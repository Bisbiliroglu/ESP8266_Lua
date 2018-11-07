-- sntp ile saat verisini internetten alır
-- alınan saat verisini epoch2human fonksiyonu ile insan saatine çevirir
-- saat verisini her saniye timer ile günceller ve LCD ile seri kanala yazar
-- timer ile her saniye lm35 den sıckalık verisi alır ve LCD ye yazar




lcd = require("lcd_hd44870")
lcd.lcd(16, 2)
lcd.init()
temp = 99.99
saniye = 0

lcd.write("SNTP Veri Aliniyor")



function readlm35()
    local adcValue = adc.read(0)
      for i=1,10 do
        adcValue = ( adc.read(0) + adcValue )
      end
      adcValue = adcValue /11
    temp = (adcValue/1024)*285
end
function epoch2human (sec, gmt)
    -- bir yıldaki saniye sayısı 31557600
    -- bir gündeki saniye sayısı 86400
    -- bir saatteki saniye sayısı 3600
    sec             = gmt*3600 + sec
    months_str      = {'Ocak','Şubat','Mart','Nisan','Mayıs','Haziran','Temmuz','Ağustos','Eylül','Ekim','Kasım','Aralık'}
    year            = math.floor(sec / 31557600) + 1970
    year_decimal    = (sec / 31557600 ) - math.floor(sec / 31557600)

    if year % 4 == 0 then
    --12 saat geri
    days            = math.floor((year_decimal*31557600 + 12*3600 )/86400)
    days_decimal    = ((year_decimal*31557600  + 12*3600)/86400  ) - days
    elseif  year % 4 == 1 then
    -- 6 saat ileri
    days            = math.floor((year_decimal*31557600 - 6*3600 )/86400)
    days_decimal    = ((year_decimal*31557600  - 6*3600)/86400  ) - days
    elseif  year % 4 == 2 then
    -- aynı 
    days            = math.floor((year_decimal*31557600 + 0*3600 )/86400)
    days_decimal    = ((year_decimal*31557600  + 0*3600)/86400  ) - days
    elseif  year % 4 == 3 then
    -- 6 saat geri
    days            = math.floor((year_decimal*31557600 + 6*3600 )/86400)
    days_decimal    = ((year_decimal*31557600  + 6*3600)/86400  ) - days
    end

    if year % 4 == 0 then
    --artık yıl şubat 29 çeker
    months = {31,29,31,30,31,30,31,31,30,31,30,31}
    else
    months = {31,28,31,30,31,30,31,31,30,31,30,31}
    end
    toplam = 0
    
    for i=1,13 do
        if days >= toplam then
            toplam = toplam + months[i]
        else
            month = i-1;
             day = days - (toplam -  months[month]) + 1
            break
        end
    end

    hour            = math.floor((days_decimal*86400)/3600)
    hour_decimal    = (days_decimal*86400)/3600 - hour
    minute          = math.floor(hour_decimal*60)
    minute_decimal  = hour_decimal*60 - minute
    second          = math.floor(minute_decimal*60)

--    hour = hour + gmt
    lcd.set_xy(0, 0)
    print(string.format("%02d:%02d:%02d %02d %s %d",hour,minute,second,day,months_str[month],year))
    lcd.write(string.format(" %02d:%02d:%02d %.2fC",hour,minute,second,temp))
    lcd.set_xy(0, 1)
    lcd.write(string.format("%02d %02d %02d",day,month,year))
end

readlm35()
sntp.sync("0.tr.pool.ntp.org",
  function(sec, usec, server, info)
    print('sync', sec, usec, server)
    saniye = sec
    epoch2human(sec,3)

    lcd.set_xy(0, 0)
    lcd.write("                ")
    lcd.set_xy(0, 1)
    lcd.write("                ")
    
    tmr.create():alarm(1000, tmr.ALARM_AUTO, function()

    readlm35()
    saniye = saniye + 1
    epoch2human(saniye,3)
    end)


  end,
  function()
   print('failed!')
     lcd.set_xy(0, 0)
    lcd.write("SNTP Hatasi")
  end
)

