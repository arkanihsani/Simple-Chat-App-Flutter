const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

wss.on('connection', (ws) => {
  let username = null;

  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data);

      if (msg.type === "join") {
        username = msg.sender;

        ws.send(JSON.stringify({
          type: "welcome",
          sender: "Server",
          message: `Welcome, ${username}!`,
        }));

        const joinMsg = JSON.stringify({
          type: "system",
          sender: "System",
          message: `${username} joined the chat`,
        });
        broadcast(joinMsg);
      } 
      else if (msg.type === "chat" || msg.type === "image") {
        const forwardMsg = JSON.stringify({
          type: msg.type,
          sender: username,
          message: msg.message,
        });
        broadcast(forwardMsg);
      }
    } catch (err) {
      console.error("Invalid message received:", data);
    }
  });

  ws.on('close', () => {
    if (username) {
      const leaveMsg = JSON.stringify({
        type: "system",
        sender: "System",
        message: `${username} left the chat`,
      });
      broadcast(leaveMsg);
    }
  });
});

function broadcast(message) {
  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

console.log("✅ WebSocket server running on ws://0.0.0.0:8080");
