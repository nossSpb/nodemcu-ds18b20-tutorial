local lcd = require("i2clcd")


function updateLcdRow1()

tm = rtctime.epoch2cal(rtctime.get()+10800)
row1 = string.format("%04d/%02d/%02d %02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"])
lcd.lcdprint(row1, 1,0)
print(row1)
end

function updateLcdRow2()
http.get("http://api.thingspeak.com/channels/999999/fields/1.json?api_key=YOU_API_KEY&results=1", nil, function(code, data)
    if (code < 0) then
      lcd.lcdprint("HTTP request failed", 2,0)
      print("HTTP request failed")
    else
      json = cjson.decode(data)
      t = json["feeds"][1]["field1"]      
      entryId = json["feeds"][1]["entry_id"]
      lcd.lcdprint("Balcony: " .. t, 2,0)    
    end
  end)
end

function createTimers()
r1tmr = tmr.create():alarm(30000, tmr.ALARM_AUTO, updateLcdRow1)
r2tmr = tmr.create():alarm(60000, tmr.ALARM_AUTO, updateLcdRow2)
print("Timers created")
end

updateLcdRow1()
updateLcdRow2()

if _G.first_run == nil then
createTimers()
_G.first_run = true
else
print("not first call")
end