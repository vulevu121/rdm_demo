"""
Author: Khuong Nguyen, Vu Le

"""


from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtCore import *
import sys,os
from can.interface import Bus
#import relay_ft245r

# system imports
import threading
import re
#import visa
import os.path
from os import path
from subprocess import call

# GUI files
# RDM class
from inv_control_demo import *
# Power Supply Class
#from PS_Control import *

# Flags
TransmitFlag = True
ReadFlag     = True


# CAN objects
bus         = None
listener    = None
notifier    = None
send_thread = None
read_thread = None

PEAK_CAN_connected = 1   # 1 is not connected

# Timer
stg1_duration = 5
stg2_duration = 5
stg3_duration = 3
stg4_duration = 5
stg5_duration = 3

class RDMdemo(QObject):
    def __init__(self):
        QObject.__init__(self)

        print('Demo created!')
        self.tm1_torque_sense = 0
        self.tm1_rpm_sense = 0
        self.tm2_torque_sense = 0
        self.tm2_rpm_sense = 0

        self.m_leftRPM = 0
        self.m_rightRPM = 0
        self.m_leftTorque = 0
        self.m_rightTorque = 0

        # Create RDM object
        self.rdm = RDM()

        # Relay control
##        rb = relay_ft245r.FT245R()
##        dev_list = rb.list_dev()
##
##        # list of FT245R devices are returned
##        if len(dev_list) == 0:
##            print('No FT245R devices found')
##            sys.exit()
##
##        # Show their serial numbers
##        for dev in dev_list:
##            print(dev.serial_number)
##
##        # Pick the first one for simplicity
##        dev = dev_list[0]
##        print('Using device with serial number ' + str(dev.serial_number))

        # Timers
        self.timers = []

        # WUP Control

        # start CAN
        initCAN()
        self.start_CAN_thread()

    # signals and connections to QML
    leftRPMSignal = pyqtSignal(int)

    @pyqtProperty(int, notify=leftRPMSignal)
    def leftRPM(self):
        return self.m_leftRPM

    @leftRPM.setter
    def leftRPM(self, v):
        if self.m_leftRPM == v:
            return
        self.m_leftRPM = v
        self.leftRPMSignal.emit(v)

    rightRPMSignal = pyqtSignal(int)

    @pyqtProperty(int, notify=rightRPMSignal)
    def rightRPM(self):
        return self.m_rightRPM

    @rightRPM.setter
    def rightRPM(self, v):
        if self.m_rightRPM == v:
            return
        self.m_rightRPM = v
        self.rightRPMSignal.emit(v)

    leftTorqueSignal = pyqtSignal(int)

    @pyqtProperty(int, notify=leftTorqueSignal)
    def leftTorque(self):
        return self.m_leftTorque

    @leftTorque.setter
    def leftTorque(self, v):
        if self.m_leftTorque == v:
            return
        self.m_leftTorque = v
        self.leftTorqueSignal.emit(v)

    rightTorqueSignal = pyqtSignal(int)

    @pyqtProperty(int, notify=rightTorqueSignal)
    def rightTorque(self):
        return self.m_rightTorque

    @rightTorque.setter
    def rightTorque(self, v):
        if self.m_rightTorque == v:
            return
        self.m_rightTorque = v
        self.rightTorqueSignal.emit(v)

    def updateStatus(self):
        self.leftRPM += 100
        self.leftRPM %= 500
        self.rightRPM += 50
        self.rightRPM %= 500
        self.leftTorque += 1
        self.leftTorque %= 15
        self.rightTorque -= 1
        self.rightTorque %= -15


    #######################################        
    ###### Control Inverter methods #######           
    #######################################
        
    def enable_RDM(self):
        print("Enable RDM...")

        # Enable RDM
        self.rdm.enable()
        self.rdm.set_torque(10)


    def transmit(self):
        print("Start CAN transmit...\n")
        global send_thread


        # Start sending the HV Off Time signal, send 6 hours
        task = bus.send_periodic(self.rdm.HV_off_time_msg, period = 0.1)
        
        # Send CAN continously
        while(TransmitFlag):
            try:
                self.rdm.update_CAN_msg()
                msg_list = self.rdm.get_cmd_msg()
                for msg in msg_list:
                    bus.send(msg)
                # Time buffer for send frequency    
                time.sleep(0.005)

            except Exception as e:
                print('RDM: Unable to send on CAN bus...\nError: {}'.format(e))
                send_thread = None
                break
            
    def read(self):
        global ReadFlag
        global listener
        global read_thread

        while(ReadFlag):
            try:
                msg = listener.get_message(timeout = 0.05)
                if msg != None:
                    self.rdm.set_inverters_status(msg)
                    self.rdm.set_tm_diag_status(msg)
                    
                tm1_feedback = self.rdm.get_tm1_feedback()
                tm2_feedback = self.rdm.get_tm2_feedback()

                self.tm1_torque_sense = tm1_feedback['torque sens']
                self.tm1_rpm_sense = tm1_feedback['speed sens']
                self.tm2_torque_sense =  tm2_feedback['torque sens']
                self.tm2_rpm_sense = tm2_feedback['speed sens']

                self.leftRPM = tm1_feedback['speed sens']
                # self.leftRPM %= 500
                self.rightRPM = tm2_feedback['speed sens']
                # self.rightRPM %= 500
                self.leftTorque = tm1_feedback['torque sens']
                # self.leftTorque %= 15
                self.rightTorque = tm2_feedback['torque sens']
                # self.rightTorque %= -15
                
            except Exception as e:
                print('RDM: Unable to read on CAN bus ' + str(e) )
                read_thread = None
                break



    def start_CAN_thread(self):
        global TransmitFlag
        TransmitFlag = True

        global ReadFlag
        ReadFlag = True
        
        # WUP HIGH 
        print ("WUP On...")


        # Turn ON HV Power Supply Output
        power_supply_control(output = 'ON', voltage = 340, current = 1.5)


        # separate thread to prevent gui freezing. PASS HANDLE NOT FUNCTION CALL
        global send_thread
        global read_thread

        # If send thread already running, just need to enable RDM
        if send_thread == None:
            send_thread = threading.Thread(target=self.transmit, args=())
            send_thread.setDaemon(True)
            send_thread.start()

        if read_thread == None:
            read_thread = threading.Thread(target=self.read, args=())        
            read_thread.setDaemon(True)
            read_thread.start()

        # Set Enable in 1 seconds
        if not self.rdm.isEnabled(): 
            enable = threading.Timer(0.1,self.enable_RDM)
            enable.setDaemon(True)
            enable.start()

        nxt_stg = threading.Timer(4.5,self.stage1,args=())
        nxt_stg.daemon = True
        nxt_stg.start()


    def stage1(self):       
        self.rdm.set_torque(10)
        nxt_stg = threading.Timer(stg1_duration,self.stage2,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.clear()
        self.timers = [nxt_stg]


    def stage2(self):
        self.rdm.set_torque(14,'TM1')
        
        nxt_stg = threading.Timer(stg2_duration,self.stage3,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        
    def stage3(self):
        self.rdm.set_torque(0)

        nxt_stg = threading.Timer(stg3_duration,self.stage4,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)

    def stage4(self):
        self.rdm.set_torque(10)
        self.rdm.set_motor_direction('reverse')

        nxt_stg = threading.Timer(stg4_duration,self.stage5,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        
    def stage5(self):
        self.rdm.set_torque(0)
        self.rdm.set_motor_direction('normal')

        
        nxt_stg = threading.Timer(stg5_duration,self.stage1,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
    #    print(self.timers)
        
                                  
    #######################################        
    ############# Main functions ##########          
    #######################################

def check_PEAK_CAN_connection():
    global PEAK_CAN_connected
    # 1 means no can0. prompt user for exit/retry and wait for input
    PEAK_CAN_connected = call("sudo ip link set can0 up", shell=True)

def relay_ctrl():
    pass



def initCAN():
    # Initilize bus
    global bus
    global listener
    global notifier
    can.rc['interface'] = 'socketcan'
    can.rc['bitrate'] = 500000
    can.rc['channel'] = 'can0'
    bus = Bus()
    bus.flush_tx_buffer()
    listener = can.BufferedReader()
    notifier = can.Notifier(bus, [listener])
    connected = check_PEAK_CAN_connection()
    print('PEAK CAN connected: {}'.format(connected))



    #######################################        
    ######Power Supply methodss ##########          
    #######################################

def power_supply_control(output , voltage , current):
    try:
        rm = visa.ResourceManager('@py')
        # PS number 1
        inst = rm.open_resource('USB0::2391::43271::US17M5344R::0::INSTR')

        ## Print for debug ##
        PSwrite(inst,'VSET', voltage)
        PSwrite(inst,'CSET', current)
        PSwrite(inst,'ON')

        PSwrite(inst, output)
    except:
        print('Power Supply not found')

def main():
    try:
        d = RDMdemo()

    except Exception as e:
        print (str(e))
	
if __name__ == '__main__':
    main()
