from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtCore import *
# from ubuntu_2 import *

class RDM(QObject):
	def __init__(self):
		QObject.__init__(self)
		self.m_leftRPM = 0
		self.m_rightRPM = 0
		self.m_leftTorque = 0
		self.m_rightTorque = 0
		self.m_start = 0


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

	# the signal that comes from qml to python, incoming type, and slot function
	startButtonPressedSignal = pyqtSignal(bool, arguments=['startButtonPressed'])

	# slot and the connected function
	@pyqtSlot(bool)
	def startButtonPressed(self, enable):
		if enable:
			print("start is {}!".format(enable))
			self.startButtonPressedSignal.emit(True)


	def updateStatus(self):
		self.leftRPM += 100
		self.leftRPM %= 500
		self.rightRPM += 50
		self.rightRPM %= 500
		self.leftTorque += 1
		self.leftTorque %= 30
		self.rightTorque -= 1
		self.rightTorque %= -30


if __name__ == "__main__":
	import sys
	# Create an instance of the application
	app = QGuiApplication(sys.argv)
	# Create QML engine
	engine = QQmlApplicationEngine()
	# Instantiate the class
	RDMBench = RDM()
	# RDMBench = RDMdemo()
	# And register it in the context of QML
	engine.rootContext().setContextProperty("RDMBench", RDMBench)
	# Load the qml file into the engine
	engine.load("qml/dashboard.qml")

	timer = QTimer()
	timer.timeout.connect(RDMBench.updateStatus)
	timer.start(200)
 
	engine.quit.connect(app.quit)
	sys.exit(app.exec_())
