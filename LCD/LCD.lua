print ("core ready")
 
lcd = require("lcd_hd44870")
lcd.lcd(16, 2)
lcd.init()
lcd.write('Test')
lcd.set_xy(5, 1)
lcd.write('Baris')
p = lcd.get_xy()
print (p['x'].." / "..p['y'])