sntp.sync('ru.pool.ntp.org',
  function(sec,usec,server)
    print('sync', sec, usec, server)
    dofile("main.lua")
  end,
  function()
   print('failed!')
  end, true
)
