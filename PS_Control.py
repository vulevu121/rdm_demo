#Bring in the VISA library
#import pyvisa
import visa
#Create a resource manager

# depend on PS
current_limit = 5.1 # for 220V PS
current_limit = 2.0 # for 110 PS

#creates a write function (This is for commanding the PS to do something)
def PSwrite(inst, mode, value =-9999):
    mode = mode.upper()
    if mode == 'OFF':
        inst.write("OUTP OFF")
    elif mode == 'ON':
        inst.write("OUTP ON")
    elif mode == 'VSET':
        if value > 0 and value < 625:
            value = round(value,1)
            inst.write("VOLT " + str(value))
        else:
            print('Voltage value is not an applicable number')
            return "ERROR"
    elif mode == 'CSET':
        if value > 0 and value < current_limit:
            value = round(value,3)
            inst.write("CURR:LEV " + str(value))
        else:
            print('Current value is not an applicable number')
            return "ERROR"
    elif mode == 'OVP':
        if value > 0 and value < 625:
            inst.write("VOLT:PROT:LEV " + str(value))
        else:
            print('Voltage value is not an applicable number')
            return "ERROR"
    elif mode == 'OCP':
        if value == 0:
            inst.write("CURR:PROT:STAT OFF")
        elif value == 1:
            inst.write("CURR:PROT:STAT ON")
        else:
            print('OCP Value not applicable: Must be 0 or 1')
            return 'ERROR'
    elif mode == 'VLim':
        if value > 0 and value <625:
            value = round(value, 1)
            inst.write("VOLT:LIM:LOW " + str(value))
        else:
            print('Voltage Limit Value is not an applicable number')
            return 'ERROR'
    else:
        print('Write Mode not found')
        return "ERROR"


#creates a write & read function (This is for gathering information)
def PSquery(inst, mode):
    mode = mode.upper()
    if mode == 'MCURR':
        return inst.query("MEAS:CURR?")
    elif mode == 'MVOLT':
        return inst.query("MEAS:VOLT?")
    elif mode == 'OUTP':
        return inst.query("OUTP?")
    elif mode == 'VSET':
        return inst.query("VOLT?")
    elif mode == 'CSET':
        return inst.query("CURR?")
    elif mode == 'OCP':
        return inst.query("CURR:PROT:STAT?")
    elif mode == 'VLOWLIM':
        return inst.query("VOLT:LIM:LOW?")
    elif mode == 'VPROTLEV':
        return inst.query("VOLT:PROT:LEV?")
    else:
        print ('Query Mode not Found')
        return 'ERROR'

    
if __name__ == '__main__':
###Finds the different resources connected to computer
    rm = visa.ResourceManager()
    print(rm.list_resources())
##    #Value here may change depending upon raspberry pi's resource identification
##    inst = rm.open_resource('USB0::0x0957::0xA907::US17M5344R::INSTR')
##
##
##    print(inst.query("*IDN?"))
##    PSwrite(inst,'VSET', 400)
##    PSwrite(inst,'CSET', 2.5)
##
##    print(PSquery(inst, 'OUTP'))
##    print(PSquery(inst, 'VSET'))
##
##    PSwrite(inst, 'ON')



##    rm = visa.ResourceManager('@py')
##    print(rm.list_resources())
    # ps NUMBER 1 
##    inst = rm.open_resource('USB0::2391::43271::US17M5344R::0::INSTR')
    # ps NUMBER 2 ON rdm CART
##    inst = rm.open_resource('USB0::2391::43271::US17N6729R::0::INSTR')
##    print(inst.query("*IDN?"))      
##    PSwrite(inst,'VSET', 400)
##    PSwrite(inst,'CSET', 2.5)
