udpSocket = net.createUDPSocket()
port = 3456 --rastgele seçilmiş port değiştirilebilir

--UDP Dinleme
udpSocket:listen(port)
udpSocket:on("receive", function(s, data, port, ip)
    print(string.format("received '%s' from %s:%d", data, ip, port))
    --s:send(port, wifi.sta.getbroadcast(), "echo: ")
end)

--UDP Broadcast mesaj gönderimi 
function udpSendBroadCastMessage (messages)
    udpSocket:send(port, wifi.sta.getbroadcast(), messages)
end
