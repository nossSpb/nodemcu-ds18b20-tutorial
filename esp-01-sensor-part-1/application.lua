ds18b20 = require('ds18b20', 'zzz')
ds18b20.read()

port = 80

-- ESP-01 GPIO Mapping
gpio0, gpio2 = 3, 4

ds18b20.setup(gpio0)
-- Just read temperature

srv=net.createServer(net.TCP)
srv:listen(port,
     function(conn)
          conn:send("HTTP/1.1 200 OK\nContent-Type: application/json\n\n" ..
              "{\n" ..
              "\"sensor-name\": \"balcony\",\n" ..
              "\"temperature\": "..ds18b20.read()..",\n" ..
              "\"chipID\": "..node.chipid()..",\n" ..
              "\"espMac\": \""..wifi.sta.getmac().."\",\n" ..
              "\"espIp\": \""..wifi.sta.getip().."\",\n" ..
              "\"heap\": "..node.heap()..",\n" ..
              "\"timerTicks\": "..tmr.now().."\n" ..
              "}")          
          conn:on("sent",function(conn) conn:close() end)
     end
)


function sendData()
t=ds18b20.read()
print("Temp:"..t.." C\n")
-- conection to thingspeak.com
print("Sending data to thingspeak.com")

http.get("http://api.thingspeak.com/update?api_key=YOUR_API_KEY&field1="..t, nil, function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
      print("Closing connection")
    end
  end)
  
end

-- send data every 60000 ms to thing speak
tmr.alarm(0, 60000, 1, function() sendData() end )