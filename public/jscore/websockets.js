if('WebSocket' in window) {
	var host = "ws://localhost:12345/websocket/server.php";
	try{
		  socket = new WebSocket(host);
		  log('WebSocket - status '+socket.readyState);
		  socket.onopen    = function(msg){ log("Welcome - status "+this.readyState); };
		  socket.onmessage = function(msg){ log("Received: "+msg.data); };
		  socket.onclose   = function(msg){ log("Disconnected - status "+this.readyState); };
		}
		catch(ex){ log(ex); 
	}
		
		
} else {
  /* WebSockets не поддерживается. Попробуйте использовать старые методы связи */
}

