const WebSocket = require('ws');

const ws = new WebSocket(process.env.NJ_ADDRESS, {
  origin: 'https://websocket.org'
});

ws.on('open', function open() {
  console.log('connected');
  ws.send(1);
});

ws.on('close', function close() {
  console.log('disconnected');
});

ws.on('message', function incoming(data) {
  console.log("ping: %s", data);

  setTimeout(function timeout() {
    ws.send(1);
  }, process.env.NJ_DELAY);
});
