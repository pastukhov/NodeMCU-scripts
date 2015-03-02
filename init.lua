--_PROMPT=""
uart.setup( 0, 9600, 8, 0, 1, 0 )
tmr.delay(100000)
print("")
print("OK")
print("set up wifi mode")
wifi.setmode(wifi.STATION)
wifi.sta.config("WiFi","Password")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function() 
    if wifi.sta.getip()== nil then 
    	print("Waiting...") 
    else 
    	tmr.stop(1)
    	print("Config done, IP is "..wifi.sta.getip())
     dofile("mqttpir.lua")
    end 
 end)

