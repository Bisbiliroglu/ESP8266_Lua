-- SNTP Servera bağlanır ve Unix EPOCH formatta sn cinsinden zaman bilgisi alır.
--alınan zamanı human date değerine çevirir ve ekrana yazdırır
sntp.sync("0.tr.pool.ntp.org",
  function(sec, usec, server, info)
    print('sync', sec, usec, server)
    epoch2human(sec,3)
  end,
  function()
   print('failed!')
  end
)

-- bir yıldaki saniye sayısı 31557600
-- bir gündeki saniye sayısı 86400
-- bir saatteki saniye sayısı 3600
function epoch2human (sec, gmt)

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
    
    print(string.format("%02d:%02d:%02d %02d %s %d",hour,minute,second,day,months_str[month],year))
end