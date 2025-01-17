from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtCore import *
import random

guiTesting = False

if not guiTesting:
	#from ubuntu_main import *
	from ubuntu_main_w_PS_shutdown import *


class RDM(QObject):
	def __init__(self):
		QObject.__init__(self)
		self.m_leftRPM = 0
		self.m_rightRPM = 0
		self.m_leftTorque = 0
		self.m_rightTorque = 0
		self.m_demoStage = 0
		self.isStarted = False

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
				# self.pause()
				self.isStarted = False
				self.startButtonPressedSignal.emit(False)
			elif not self.isStarted:
				print("Start button pressed... starting!")
				# self.start_CAN_thread()
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

	def updateStatus(self):
		self.leftRPM += 100
		self.leftRPM %= 500
		self.rightRPM -= 50
		self.rightRPM %= -500
		self.leftTorque += 1
		self.leftTorque %= 30
		self.rightTorque -= 1
		self.rightTorque %= -30

		# self.leftRPM = random.randrange(-500, 500)
		# self.rightRPM = random.randrange(-500, 500)
		# self.leftTorque = int(self.leftRPM / 25)
		# self.rightTorque = int(self.rightRPM / 25)

		if self.leftRPM < 100:
			self.demoStage = 0
		elif self.leftRPM < 150:
			self.demoStage = 1
		elif self.leftRPM < 200:
			self.demoStage = 2
		elif self.leftRPM < 350:
			self.demoStage = 3
		elif self.leftRPM < 400:
			self.demoStage = 4
		elif self.leftRPM < 500:
			self.demoStage = 5


if __name__ == "__main__":
	import sys
	# Create an instance of the application
	app = QGuiApplication(sys.argv)
	# app.setAttribute(Qt.AA_EnableHighDpiScaling)
	# app.setAttribute(Qt.AA_DisableHighDpiScaling)
	# Create QML engine
	engine = QQmlApplicationEngine()

	if guiTesting:
		# Instantiate the class
		RDMBench = RDM()
		# And register it in the context of QML
		engine.rootContext().setContextProperty("RDMBench", RDMBench)
		# Load the qml file into the engine
		engine.load("qml/dashboard.qml")

		timer = QTimer()
		timer.timeout.connect(RDMBench.updateStatus)
		timer.start(10000)
	else:
		# Instantiate the class
		RDMBench = RDMdemo()
		# And register it in the context of QML
		engine.rootContext().setContextProperty("RDMBench", RDMBench)
		# Load the qml file into the engine
		engine.load("qml/dashboard.qml")

	
	engine.quit.connect(app.quit)
	sys.exit(app.exec_())


