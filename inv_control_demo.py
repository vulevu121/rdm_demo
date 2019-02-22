#!/usr/bin/python3

import time
import datetime                                                                                                                                                               
import threading
import can
import numpy as np    

######## CAN ID ################
TM1_TORQUE_CMD_ID     = 0x47
TM1_TORQUE_PROTECT_ID = 0x41
TM1_STATUS_ID         = 0x153
TM1_FEEDBACK_ID       = 0xCA
TM1_DIAG_OBD_ID       = 0x386

TM2_TORQUE_CMD_ID     = 0x48
TM2_TORQUE_PROTECT_ID = 0x42
TM2_STATUS_ID         = 0x154
TM2_FEEDBACK_ID       = 0xCB
TM2_DIAG_OBD_ID       = 0x387

# This is for motor thermal open circuit detection
HCU_OBD2_ID           = 0x535

##################################### RDM Class definition ############################################
class RDM:
    def __init__(self):
        
        # Initilize signals
        self.legacy_enable_cmd   = 0x5
        self.legacy_shutdown_cmd = 0x0
        self.enable_cmd          = 0x0
        self.shutdown_cmd        = 0x0
        self.torque_cmd          = 0x0
        
        self.TM1_torque_cmd      = 0x0
        self.TM2_torque_cmd      = 0x0
        self.TM1_direction       = 0x0A
        self.TM2_direction       = 0x05

        self.torque_protect_val  = 0x0
        self.AccPedalPos         = 0x0
        self.arc                 = 0
        self.crc                 = 0

        ######## Inverter Status  ######
        self.TM1_inv_temp_sens   = 9999
        self.TM1_motor_temp_sens = 9999
        self.TM1_pcm_test_fail   = 9999
        self.TM1_status_sig      = 'None'
        self.TM1_diag_obd2_fault = False
        # rememeber the Diag Index of the Fault
        self.TM1_diag_obd2_code  = set()

        
        self.TM2_inv_temp_sens   = 9999
        self.TM2_motor_temp_sens = 9999
        self.TM2_pcm_test_fail   = 9999
        self.TM2_status_sig      = 'None'
        self.TM2_diag_obd2_fault = False
        # rememeber the Diag Index of the Fault
        self.TM2_diag_obd2_code  = set()

        ######## Inverter Feedback #####
        self.TM1_current_sens    = 9999
        self.TM1_speed_sens      = 9999
        self.TM1_torque_sens     = 9999
        self.TM1_voltage_sens    = 9999
        self.TM2_current_sens    = 9999
        self.TM2_speed_sens      = 9999
        self.TM2_torque_sens     = 9999
        self.TM2_voltage_sens    = 9999

        ######## HV Off Time signal #####
        self.HVoffTime           = 10   # Must be greater than 6 hours

        #### Single/Double Run Mode (0: both TMs, 1: TM1 Only, 2: TM2 Only ####
        self.run_mode = 0    
        # Initialize message
        self.msg_list =[]
        self.update_CAN_msg()

    #################################   RDM methods ################################
    def set_torque(self,target_torque, target = 'Both'):                            
        if target == 'Both':
            self.TM1_torque_cmd = target_torque
            self.TM2_torque_cmd = target_torque
        elif target == 'TM1':
            self.TM1_torque_cmd = target_torque
        elif target == 'TM2':
            self.TM2_torque_cmd = target_torque
            
    def enable(self):
        # no commmand
        self.legacy_shutdown_cmd = 0x0
        self.shutdown_cmd = 0x0
        # enable command
        self.legacy_enable_cmd = 0xA
        # torque command set to 0 is required to enable
        self.torque_cmd = 0
        # Must enable in the following sequence
        
        seq = [0x0, 0x1, 0x2, 0x3]
        for step in seq:
            enable_thread = threading.Timer(1,self.enable_seq,args=[step,])
            enable_thread.daemon = True
            enable_thread.start()
            time.sleep(1)

    def enable_seq(self,step):
        self.enable_cmd = step                  


    def isEnabled(self):
        if self.enable_cmd == 0x3:
            return True
        return False
    
    def disable(self):
        # set torque command to zero
        self.set_torque(0)
        # disable with the following sequence
        self.enable_cmd = 0x0
        # After enable_cmd becomes zero, send shutdown request for abit more time (2 seconds)
        # shutdown requested
        time.sleep(0.1)
        self.legacy_shutdown_cmd = 0x1
        # shutdown w/ active discharge
        self.shutdown_cmd = 0x2
        # not enabled
        self.legacy_enable_cmd = 0x5
        time.sleep(0.5)
        # Finally, reset all shutdown command to default value
        self.legacy_shutdown_cmd = 0x0
        self.shutdown_cmd = 0x0 

    def set_motor_direction(self,direction = 'normal'):
        if direction == 'normal':
            self.TM1_direction       = 0xA
            self.TM2_direction       = 0x5
        elif direction == 'reverse':
            self.TM1_direction       = 0xA
            self.TM2_direction       = 0xA


    def set_tm_diag_status(self,msg):
        if msg.arbitration_id == TM1_DIAG_OBD_ID:
            self.set_tm1_diag_status(msg)
        elif msg.arbitration_id == TM2_DIAG_OBD_ID:
            self.set_tm2_diag_status(msg)

    def set_inverters_status(self,msg):
        if msg.arbitration_id == TM1_STATUS_ID:
            self.set_tm1_status(msg)    
        elif msg.arbitration_id == TM1_FEEDBACK_ID:
            self.set_tm1_feedback(msg)
        elif msg.arbitration_id == TM2_STATUS_ID:
            self.set_tm2_status(msg)              
        elif msg.arbitration_id == TM2_FEEDBACK_ID:
            self.set_tm2_feedback(msg)

        
    def set_tm1_status(self,msg):
        self.TM1_inv_temp_sens   = msg.data[0] - 40
        self.TM1_motor_temp_sens = msg.data[1] - 40
        self.TM1_pcm_test_fail   = msg.data[2] >> 6
        self.TM1_status_sig      = self.decode_inv_status((msg.data[2] & 0x3F << 8) | msg.data[3])

    def get_tm1_status(self):
        return {'inv temp sens': self.TM1_inv_temp_sens, 'motor temp sens': self.TM1_motor_temp_sens,
                'pcm test fail': self.TM1_pcm_test_fail , 'status sig': self.TM1_status_sig}
    
    def set_tm1_feedback(self,msg):
        self.TM1_current_sens    =  (((msg.data[6] & 0x1F) << 8 | msg.data[7]) * 0.25) - 1024
        self.TM1_speed_sens      =   ((msg.data[2]         << 8 | msg.data[3]) * 0.5 ) - 16384
        self.TM1_torque_sens     =   ((msg.data[0] & 0x7)  << 8 | msg.data[1])         - 1024

    def get_tm1_feedback(self):
        return {'current sens': self.TM1_current_sens , 'speed sens': self.TM1_speed_sens ,
                'torque sens': self.TM1_torque_sens}

    
    def set_tm2_status(self,msg):
        self.TM2_inv_temp_sens   = msg.data[0] - 40
        self.TM2_motor_temp_sens = msg.data[1] - 40
        self.TM2_pcm_test_fail   = msg.data[2] >> 6
        self.TM2_status_sig      = self.decode_inv_status((msg.data[2] & 0x3F << 8) | msg.data[3])

    def get_tm2_status(self):
        return {'inv temp sens': self.TM2_inv_temp_sens, 'motor temp sens': self.TM2_motor_temp_sens,
                'pcm test fail': self.TM2_pcm_test_fail , 'status sig': self.TM2_status_sig}
    
    def set_tm2_feedback(self,msg):
        self.TM2_current_sens    =  (((msg.data[6] & 0x1F) << 8 | msg.data[7]) * 0.25) - 1024
        self.TM2_speed_sens      =   ((msg.data[2]         << 8 | msg.data[3]) * 0.5 ) - 16384
        self.TM2_torque_sens     =   ((msg.data[0] & 0x7)  << 8 | msg.data[1])         - 1024
        self.TM2_voltage_sens    =   ((msg.data[4] & 0xF)  << 8 | msg.data[5]) * 0.25

    def get_tm2_feedback(self):
        return {'current sens': self.TM2_current_sens , 'speed sens': self.TM2_speed_sens ,
                'torque sens': self.TM2_torque_sens}

    def set_tm1_diag_status(self,msg):
        # if any of the diagnostic failed, set fault to True
        DiagStat1 = msg.data[0] & 0x7
        DiagStat2 = msg.data[1] & 0x7
        DiagStat3 = msg.data[2] & 0x7
        # record the code of just 1 fault of diagstat2 
        IndexCode =   msg.data[1] >> 3

        if (DiagStat1 == 4 or DiagStat2 == 4 or DiagStat3 == 4) and (IndexCode != 26):
            self.TM1_diag_obd2_fault = True
            self.TM1_diag_obd2_code.add(IndexCode)
            print('TM1 FAULT CODEs: {}'.format(self.TM1_diag_obd2_code))  

    def get_tm1_diag_status(self):
        return self.TM1_diag_obd2_fault

    def set_tm2_diag_status(self,msg):
        # if any of the diagnostic failed, set fault to True
        DiagStat1 = msg.data[0] & 0x7
        DiagStat2 = msg.data[1] & 0x7
        DiagStat3 = msg.data[2] & 0x7
        # record the code of any of the stat is fine
        IndexCode= msg.data[1] >> 3

        # Code 26 is related to CAN communication, not a major issue for the test bench, can be ignored
        if (DiagStat1 == 4 or DiagStat2 == 4 or DiagStat3 == 4) and IndexCode != 26:
            self.TM2_diag_obd2_fault = True
            self.TM2_diag_obd2_code.add(IndexCode)
            print('TM2 FAULT CODEs: {}'.format(self.TM2_diag_obd2_code))    


    def get_tm2_diag_status(self):
        return self.TM2_diag_obd2_fault

    def reset_tm1_diag_status(self):
        self.TM1_diag_obd2_fault = False
        self.TM1_diag_obd2_code.clear()

    def reset_tm2_diag_status(self):
        self.TM2_diag_obd2_fault = False
        self.TM2_diag_obd2_code.clear()

    def reset_tm_diag_status(self):
        self.reset_tm2_diag_status()
        self.reset_tm1_diag_status()
        

    def decode_inv_status(self,status):                                     
        status2str = {0x1: 'INIT_ECU',
                      0x2: 'INIT_SYS',
                      0x3: 'NORMAL_ENABLE',
                      0x4: 'NORMAL_DISABLE',
                      0x5: 'SHUTDWN',
                      0x6: 'SHUTDWN_ACTIVE_CAP_DISCHARGE',
                      0x7: 'PWR_DWN',
                      0x8: 'FAULT',
                      0x9: 'PCM_ENABLE_TEST',
                      }
        try:
            return status2str[status]
        except:
            return 'Not Available'
            

        # same functionality as the other update function, only more human readable
##    def update_CAN_msg(self):
##     
##        # Convert input to hex
##        if self.direction == 'R':
##            self.TM1_direction_hex =  0x5             # CCW
##            self.TM2_direction_hex =  0xA             # CW
##        elif self.direction == 'D':
##            self.TM1_direction_hex =  0x0A            # CW
##            self.TM2_direction_hex =  0x05            # CCW
##
##        # legacy commands
##        self.legacy_enable_cmd_hex = self.legacy_enable_cmd
##        self.legacy_shutdown_cmd_hex = self.legacy_shutdown_cmd
##
##        
##        # 2.0 commands
##        self.enable_cmd_hex = self.enable_cmd
##        self.shutdown_cmd_hex = self.shutdown_cmd
##        
##
##        self.arc                    = (self.arc + 1) % 4                                   # rolling counter 0 - 3
##        self.torque_cmd_hex         = limit(self.torque_cmd + 1024,0x0,0x7FF)              # torque command
##        self.torque_protect_val_hex = self.torque_protect_val                              # torque protect = torque command
##        self.torque_env_high_hex    = limit((self.torque_cmd_hex + 0xfa),0x0,0x7FF)
##        self.torque_env_low_hex     = limit((self.torque_cmd_hex - 0xfa),0x0,0x7FF)
##
##
##	############## TM Torque Command bytes ###############
##        # Update all messages. Only CRC and Direction signals are different between TM torque_cmd messages. The rest of the signals are exactly the same for both
##        # a0: ARC (bit 6-7), shutdown_legacy (bit 3), torque_cmd (MSB bit 0-2)
##        TM1_torque_cmd_bytes = [0] * 7
##        TM1_torque_cmd_bytes[0] = getByte(self.arc, [0,1], TM1_torque_cmd_bytes[0], [6,7])
##        TM1_torque_cmd_bytes[0] = getByte(self.legacy_shutdown_cmd_hex, [0], TM1_torque_cmd_bytes[0], [3])
##        TM1_torque_cmd_bytes[0] = getByte(self.torque_cmd_hex, [8,9,10], TM1_torque_cmd_bytes[0], [0,1,2])
##
##        # a1: Torque_cmd
##        TM1_torque_cmd_bytes[1] = getByte(self.torque_cmd_hex, [0,1,2,3,4,5,6,7], TM1_torque_cmd_bytes[1], [0,1,2,3,4,5,6,7])
##        
##        # a2: Shutdown command (bit 6-7), Enable command (bit 3-5), Torque_protect_val (MSB bit 0-2)
##        TM1_torque_cmd_bytes[2] = getByte(self.shutdown_cmd_hex, [0,1], TM1_torque_cmd_bytes[2], [6,7])
##        TM1_torque_cmd_bytes[2] = getByte(self.enable_cmd_hex, [0,1,2], TM1_torque_cmd_bytes[2], [3,4,5])
##        TM1_torque_cmd_bytes[2] = getByte(self.torque_protect_val_hex, [8,9,10], TM1_torque_cmd_bytes[2], [0,1,2])
##
##        # a3: Torque_protect_val
##        TM1_torque_cmd_bytes[3] = getByte(self.torque_protect_val_hex, [0,1,2,3,4,5,6,7], TM1_torque_cmd_bytes[3], [0,1,2,3,4,5,6,7])
##        
##        # a4: Accel Pedal Pos
##        TM1_torque_cmd_bytes[4] = self.AccPedalPos
##
##        # a5: Enable_legacy (bit 4-7), direction (bit 0-3)   
##        TM1_torque_cmd_bytes[5] = getByte(self.legacy_enable_cmd_hex, [0,1,2,3], TM1_torque_cmd_bytes[5], [4,5,6,7])
##        TM1_torque_cmd_bytes[5] = getByte(self.TM1_direction_hex, [0,1,2,3], TM1_torque_cmd_bytes[5], [0,1,2,3])
##        TM2_torque_cmd_bytes = TM1_torque_cmd_bytes.copy()
##        TM2_torque_cmd_bytes[5] = getByte(self.legacy_enable_cmd_hex, [0,1,2,3], TM2_torque_cmd_bytes[5], [4,5,6,7])
##        TM2_torque_cmd_bytes[5] = getByte(self.TM2_direction_hex, [0,1,2,3], TM2_torque_cmd_bytes[5], [0,1,2,3])
##
##        # a6: CRC
##        TM1_torque_cmd_bytes[6] = crc8(TM1_torque_cmd_bytes[0:-1])
##        TM2_torque_cmd_bytes[6] = crc8(TM2_torque_cmd_bytes[0:-1])
##    
##        ############## TM Torque Command Message ###############   
##        self.TM1_torque_cmd_msg = can.Message(arbitration_id=TM1_TORQUE_CMD_ID, extended_id=False, data=TM1_torque_cmd_bytes)
##        self.TM2_torque_cmd_msg = can.Message(arbitration_id=TM2_TORQUE_CMD_ID, extended_id=False, data=TM2_torque_cmd_bytes)
##
##    
##        # HV Off time message
##        temp = [0] * 4
##        temp[0] = self.HVoffTime
##        self.HV_off_time_msg =  can.Message(arbitration_id = HCU_OBD2_ID, extended_id = False, data=temp)
##
##        # Compile to a list to use on GUI code
##        if self.run_mode == 0:
##            self.msg_list = [self.TM1_torque_cmd_msg,
##                             self.TM2_torque_cmd_msg]
##        elif self.run_mode == 1:
##            self.msg_list = [self.TM1_torque_cmd_msg]
##        elif self.run_mode == 2:
##            self.msg_list = [self.TM2_torque_cmd_msg]
##        else:
##            print ('Invalid run mode')
##            

    def update_CAN_msg(self):
     
        # Convert input to hex
##        if self.direction == 'R':
##            self.TM1_direction_hex =  0x5             # CCW
##            self.TM2_direction_hex =  0xA             # CW
##        elif self.direction == 'D':
##            self.TM1_direction_hex =  0x0A            # CW
##            self.TM2_direction_hex =  0x05            # CCW


        # legacy commands
        self.legacy_enable_cmd_hex = self.legacy_enable_cmd
        self.legacy_shutdown_cmd_hex = self.legacy_shutdown_cmd
        
        # 2.0 commands
        self.enable_cmd_hex = self.enable_cmd
        self.shutdown_cmd_hex = self.shutdown_cmd
        
        self.arc                    = (self.arc + 1) % 4                                   # rolling counter 0 - 3
        self.torque_cmd_hex         = limit(self.torque_cmd + 1024,0x0,0x7FF)              # torque command
        self.torque_protect_val_hex = self.torque_protect_val                              # torque protect = torque command

        # UPDATE #
        self.TM1_torque_cmd_hex = limit(self.TM1_torque_cmd + 1024,0x0,0x7FF)  
        self.TM2_torque_cmd_hex = limit(self.TM2_torque_cmd + 1024,0x0,0x7FF)  
        self.TM1_torque_protect_val_hex =  self.TM1_torque_cmd_hex                          # torque protect = torque command
        self.TM2_torque_protect_val_hex =  self.TM2_torque_cmd_hex                          # torque protect = torque command


	############## TM Torque Command bytes ###############
        # Update all messages. Only CRC and Direction signals are different between TM torque_cmd messages. The rest of the signals are exactly the same for both
        # a0: ARC (bit 6-7), shutdown_legacy (bit 3), torque_cmd (MSB bit 0-2)
        a0_TM1 =  (self.arc << 6) | (self.legacy_shutdown_cmd_hex << 3) | ((self.TM1_torque_cmd_hex & 0x700) >> 8)
        a0_TM2 =  (self.arc << 6) | (self.legacy_shutdown_cmd_hex << 3) | ((self.TM2_torque_cmd_hex & 0x700) >> 8)

        # a1: Torque_cmd
        a1_TM1 =  (self.TM1_torque_cmd_hex & 0x0FF)
        a1_TM2 =  (self.TM2_torque_cmd_hex & 0x0FF)
        # a2: Shutdown command (bit 6-7), Enable command (bit 3-5), Torque_protect_val (MSB bit 0-2)
        a2_TM1 = ( (self.TM1_torque_protect_val_hex & 0x700) >> 8) | self.shutdown_cmd_hex << 6 | self.enable_cmd_hex << 3
        a2_TM2 = ( (self.TM2_torque_protect_val_hex & 0x700) >> 8) | self.shutdown_cmd_hex << 6 | self.enable_cmd_hex << 3

        # a3: Torque_protect_val
        a3_TM1 =  (self.TM1_torque_protect_val_hex & 0x0FF)
        a3_TM2 =  (self.TM2_torque_protect_val_hex & 0x0FF)

        # a4: Accel Pedal Pos
        a4 =  self.AccPedalPos

        # a5: Enable_legacy (bit 4-7), direction (bit 0-3)
        a5_TM1 =  (self.legacy_enable_cmd_hex << 4) |  self.TM1_direction     #TM1 direction
        a5_TM2 =  (self.legacy_enable_cmd_hex << 4) |  self.TM2_direction    #TM2 direction

        # a6: CRC
        a6_TM1 = crc8([a0_TM1, a1_TM1, a2_TM1,  a3_TM1, a4, a5_TM1])
        a6_TM2 = crc8([a0_TM2, a1_TM2, a2_TM2, a3_TM2, a4, a5_TM2])
        
        ############## TM Torque Command Message ###############      
        old_data1 = [a0_TM1, a1_TM1,a2_TM1, a3_TM1,a4,a5_TM1,a6_TM1]
        old_data2 = [a0_TM2, a1_TM2,a2_TM2, a3_TM2,a4,a5_TM2,a6_TM2]

        self.TM1_torque_cmd_msg = can.Message(arbitration_id=TM1_TORQUE_CMD_ID, extended_id=False, data=old_data1)
        self.TM2_torque_cmd_msg = can.Message(arbitration_id=TM2_TORQUE_CMD_ID, extended_id=False, data=old_data2)
            

        # HV Off time message
        temp = [0] * 4
        temp[0] = self.HVoffTime
        self.HV_off_time_msg =  can.Message(arbitration_id = HCU_OBD2_ID, extended_id = False, data=temp)

        # Compile to a list to use on GUI code
        if self.run_mode == 0:
            self.msg_list = [self.TM1_torque_cmd_msg,
                             self.TM2_torque_cmd_msg]
        elif self.run_mode == 1:
            self.msg_list = [self.TM1_torque_cmd_msg]
        elif self.run_mode == 2:
            self.msg_list = [self.TM2_torque_cmd_msg]
        else:
            print ('Invalid run mode')

    def get_cmd_msg(self):
        return self.msg_list

    def assign_id(self,bus,goal_ID = 'GEN'):
        # Use this ID to enable Programming Mode 
        Inv_Diag_Msg_ID = {'TM1'    : 0x781,
                           'TM2'    : 0x782,
                           'GEN'    : 0x780,
                           'DEFAULT': 0x783}
        
        ID_to_name = {1921 :'TM1',
                      1922 :'TM2',
                      1920 :'GEN',
                      1923 :'BOOT'}
        
        # Use this to assign new ID
        B100_Values = {'TM1': 0x1,
                       'TM2': 0x2,
                       'GEN': 0x0}
        
        if not goal_ID in Inv_Diag_Msg_ID.keys():
            print('Invalid ID\n Exiting...')
            return
        else:
            print('Assigning ' + goal_ID)

        curr_ID = None
        b100_resp = []
        prog_pos_resp = False
        b100_pos_resp = False

        # Compile message to enable programming mode regardless of the current ID
        diag_msg_TM1     = can.Message(arbitration_id = Inv_Diag_Msg_ID['TM1'],     extended_id = False, dlc = 8, data=[0x2,0x10,0x2])
        diag_msg_TM2     = can.Message(arbitration_id = Inv_Diag_Msg_ID['TM2'],     extended_id = False, dlc = 8, data=[0x2,0x10,0x2])
        diag_msg_GEN     = can.Message(arbitration_id = Inv_Diag_Msg_ID['GEN'],     extended_id = False, dlc = 8, data=[0x2,0x10,0x2])
        diag_msg_DEFAULT = can.Message(arbitration_id = Inv_Diag_Msg_ID['DEFAULT'], extended_id = False, dlc = 8, data=[0x2,0x10,0x2])
        diag_msg_list = [diag_msg_TM1,diag_msg_TM2,diag_msg_GEN,diag_msg_DEFAULT]
        
        # Enable programming mode on inverter. IMPORTANT: expect only 1 response from the inverter even if 4 msg are sent
        print('Enabling programming mode...')
        for diag_msg in diag_msg_list:
            bus.send(diag_msg)
            response = bus.recv(timeout = 0.1)
            if response != None:
                curr_ID = diag_msg.arbitration_id
                break
        # Confirm positive response, then send programming command
        print('Waiting for programing mode response...')
        if response != None:
            if response.data[0] == 0x6 and response.data[1] == 0x50 and response.data[2] == 0x2:
                prog_pos_resp = True
                
            if prog_pos_resp:
                
                #print('{} confirmed Programming Mode. New ID is {}. Writing DID $B100...'.format(ID_to_name[curr_ID],goal_ID))
                diag_msg = can.Message(arbitration_id = curr_ID, extended_id = False, dlc = 8, data=[0x5,0x2E,0xB1,0x0,0x0,B100_Values[goal_ID]])
                bus.send(diag_msg)
                # Confirm positive response. The confirmation comes in the 2nd response from the inverter. Need to save all the response for processing
                print('Waiting for $B100 response...')
                startTime = time.time()
                while(time.time() - startTime < 1):
                    data = bus.recv(0.5)
                    if data != None:
                        b100_resp.append(data)

                if len(b100_resp) != 0:
                    for resp in b100_resp:
                        if resp.data[0] == 0x3 and resp.data[1] == 0x6E and resp.data[2] == 0xB1 and resp.data[3] == 0x0:
                            b100_pos_resp = True
                            msg ='{} Responded. New ID {} Is Written Successfully.'.format(ID_to_name[curr_ID],goal_ID)
                            print(msg)
                            return msg
                else:
                    msg = 'New ID Is Not Written. Please Try Again...'
                    print(msg)
                    return msg
                
        else:
            msg = 'Programming mode no response'
            print(msg)
            return msg
            

#################################   RDM methods END ########################################################

def limit(num,min_num,max_num):                 #limit range for torque command or any other command
    if num < max_num and num > min_num:
        return num
    elif num <= min_num:
        return min_num
    elif num >= max_num:
        return max_num


def crc8(RAW_DATA):
    remainder = np.uint32(0xff)
    CRCResult = 0

    for byte_index in range(0,6):
        remainder = remainder ^ RAW_DATA[byte_index]
        

        for bit_index in range(8,0,-1):
            if remainder & 0x80:
                remainder = (remainder << 1) ^ 0x1d
            else:
                remainder = (remainder << 1)
        
        remainder = np.uint32(remainder) 
        

    CRCResult = ~remainder & 0x00FF
    return CRCResult


def getByte(sourceByte, sourceIdxRange, destByte, destIdxRange):
    
    def getBit(val, bit):
        return (int((val & (1 << bit)) != 0))

    def setBit(byte, bit, bitval):
        if bitval == 1:
            return (byte | (1 << bit))
        else:
            return (byte & ~(1 << bit))

    
    for s, d in zip(sourceIdxRange, destIdxRange):
        destByte = setBit(destByte, d, getBit(sourceByte, s))

    return destByte



