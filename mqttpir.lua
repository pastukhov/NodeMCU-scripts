

broker = "192.168.1.1"
pir = 3
status = "CLEAR"
oldstatus = "CLEAR"

chipid = node.chipid()

gpio.mode(pir,gpio.INPUT,gpio.FLOAT)

function sendalarm(SensorID,status)
m:publish("events/esp8266/".. chipid .. "/pir" ,("{\"Type\":\"PIR\",\"SensorID\":\"".. chipid .. "\", \"Status\":\"".. status .."\"}"),0,0, function(conn) print("Status sent") end)
end





m = mqtt.Client(chipid, 120, "Login", "Password")

m:lwt("lwt/".. chipid, chipid .." gone offline", 0, 0)

m:on("offline", function(con)
     print ("reconnecting...")
     tmr.alarm(1, 10000, 0, function()
          m:connect("broker", 1883, 0)
     end)
end)

-- on publish message receive event
m:on("message", function(conn, topic, data)
  if data ~= nil then
   print(data)
  end
  
end)

tmr.alarm(2, 1000, 1, function() -- Set alarm to one second
     if gpio.read(pir)==1 then status="ALARM" else status="CLEAR" end
     if status ~= oldstatus then sendalarm (SensorID,status) end
     oldstatus = status
end)


tmr.alarm(0, 1000, 1, function()
 if wifi.sta.status() == 5 then
     tmr.stop(0)
     m:connect("broker", 1883, 0, function(conn)
--          print("connected")
          m:subscribe("actions/esp8266/#",0, function(conn)
          m:publish("events/esp8266/".. chipid ,chipid .. " become online",0,0, function(conn) print("connected") end)
          end)
     end)
 end
end)


