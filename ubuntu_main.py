"""
Author: Khuong Nguyen, Vu Le

"""


# system imports
import threading
import re
import visa
import os , sys
from subprocess import call
from can.interface import Bus
import relay_ft245r

from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtCore import *

# RDM class
from inv_control_demo import *
# Power Supply Class
from PS_Control import *

# Relay board relay channel
WUP_channel = 1

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



class RDMdemo(QObject):
    def __init__(self):
        QObject.__init__(self)

        # Stage duration
        self.stg1_duration = 10
        self.stg2_duration = 10
        self.stg3_duration = 3
        self.stg4_duration = 10
        self.stg5_duration = 3


        print('Demo created!')
        self.m_demoStage = 0
        self.m_leftRPM = 0
        self.m_rightRPM = 0
        self.m_leftTorque = 0
        self.m_rightTorque = 0

        # Star Stop Flag
        self.isStarted  = False
        self.demoStage = 0    # 1 to 5
        # Create RDM object
        self.rdm = RDM()

        # Relay control
        self.relay_board = init_relay()

        # Timers
        self.timers = []

        # start CAN
        initCAN()
        # self.start_CAN_thread()

    ####### GUI ############
    # signal to send to qml to update gauges
    leftRPMSignal = pyqtSignal(int)

    # function returns as a qml property
    @pyqtProperty(int, notify=leftRPMSignal)
    def leftRPM(self):
        return self.m_leftRPM

    # setter function to change/store rpm values within the class
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

    # the signal that comes from qml to python, incoming type, and slot function
    startButtonPressedSignal = pyqtSignal(bool, arguments=['startButtonPressed'])

    # slot and the connected function
    @pyqtSlot(bool)
    def startButtonPressed(self, pressed):
        if pressed:
            if self.isStarted:
                print("Start button pressed... stopping!")
                self.pause()
                self.isStarted = False
                self.startButtonPressedSignal.emit(False)
            elif self.isStarted == False:
                print("Start button pressed... starting!")
                self.start_CAN_thread()
                self.isStarted = True
                self.startButtonPressedSignal.emit(True)
            return self.isStarted



    # signal to send to qml to update gauges
    demoStageSignal = pyqtSignal(int)

    # function returns as a qml property
    @pyqtProperty(int, notify=demoStageSignal)
    def demoStage(self):
        return self.m_demoStage

    # setter function to change/store rpm values within the class
    @demoStage.setter
    def demoStage(self, v):
        if self.m_demoStage == v:
            return
        self.m_demoStage = v
        self.demoStageSignal.emit(v)


    #######################################
    ###### Control Inverter methods #######
    #######################################

    def start_btn_pressed(self):
        if self.isStarted:
            self.pause()
            self.isStarted = False
        elif self.isStarted == False:
            self.start_CAN_thread()
            self.isStarted = True
        return self.isStarted

    def enable_RDM(self):
        print("Enable RDM...")

        # Enable RDM
        self.rdm.enable()
        self.rdm.set_torque(10)

        self.isStarted = True

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

                ### Read status from INV ####
                tm1_feedback = self.rdm.get_tm1_feedback()
                tm2_feedback = self.rdm.get_tm2_feedback()


                ### Update GUI ####
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

        # Feedback for GUI
        self.isStarted = True

        # WUP HIGH
        print ("WUP On...")
        self.relay_board.switchon(WUP_channel)

        # Turn ON HV Power Supply Output
        power_supply_control(output = 'ON', voltage = 340, current = 5)


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
        nxt_stg = threading.Timer(self.stg1_duration,self.stage2,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.clear()
        self.timers = [nxt_stg]
        self.demoStage = 1


    def stage2(self):
        self.rdm.set_torque(14,'TM1')

        nxt_stg = threading.Timer(self.stg2_duration,self.stage3,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        self.demoStage = 2

    def stage3(self):
        self.rdm.set_torque(0)

        nxt_stg = threading.Timer(self.stg3_duration,self.stage4,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        self.demoStage = 3


    def stage4(self):
        self.rdm.set_torque(10)
        self.rdm.set_motor_direction('reverse')

        nxt_stg = threading.Timer(self.stg4_duration,self.stage5,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        self.demoStage = 4

    def stage5(self):
        self.rdm.set_torque(0)
        self.rdm.set_motor_direction('normal')


        nxt_stg = threading.Timer(self.stg5_duration,self.stage1,args=())
        nxt_stg.daemon = True
        nxt_stg.start()

        self.timers.append(nxt_stg)
        self.demoStage = 5

    def pause(self):
        # Feedback for GUI
        self.isStarted = False
        self.demoStage = 0

        # Stop all timers
        for t in self.timers:
            t.cancel()

        self.timers.clear()

        # reset rdm settings
        self.rdm.set_torque(0)
        self.rdm.set_motor_direction('normal')

    #######################################
    ############# Main functions ##########
    #######################################

def check_PEAK_CAN_connection():
    global PEAK_CAN_connected
    # 1 means no can0. prompt user for exit/retry and wait for input
    res = call("sudo ip link set can0 up", shell=True)
    PEAK_CAN_connected = not res # 1 is not connected

def init_relay():
    try:
        rb = relay_ft245r.FT245R()
        dev_list = rb.list_dev()

        # list of FT245R devices are returned
        if len(dev_list) == 0:
            print('No FT245R devices found')
            sys.exit()

        # Pick the first one for simplicity
        dev = dev_list[0]
        print('Using device with serial number ' + str(dev.serial_number))
        rb.connect(dev)
        return rb

    except:
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
    check_PEAK_CAN_connection()
    print('PEAK CAN connected: {}'.format(PEAK_CAN_connected))



    #######################################
    ######Power Supply methodss ##########
    #######################################

def power_supply_control(output , voltage , current):
    try:
        rm = visa.ResourceManager('@py')
        # PS number 1
        inst = rm.open_resource('USB0::2391::34823::US18M7888R::0::INSTR')

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

        while True:
            time.sleep(10)
            d.pause()
            time.sleep(5)
            d.start_CAN_thread()

    except Exception as e:
        print ('Main thread error: '+ str(e))
	
if __name__ == '__main__':
    main()
