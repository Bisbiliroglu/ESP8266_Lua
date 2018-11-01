 -- TCP dinler ve gelen mesajı ekrana yazıdırır
 -- tcpSendString fonksiyonu ile TCP den gelen mesajı gönderir.

port = 3456 --portun bir özelliği yoktur rastgele seçilmiştir.
 sv=net.createServer(net.TCP)
 sv:listen(port,function(c)
  c:on("receive", function(c, pl)
     print(pl) --pl gelen mesaj
  end)
 end)

function tcpSendString(string,ip,port)
srvtcp = net.createConnection(net.TCP, 0)
srvtcp:on("receive", function(sck, c) print(c) end)
srvtcp:connect(port,ip)
srvtcp:on("connection", function(sck, c)
  sck:send(string)
  srvtcp:close()
end)
end

--tcpSendString('hello world','192.168.0.19','3456')
