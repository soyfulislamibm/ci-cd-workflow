const express = require('express');
const app = express();

app.get('/', (req, res) => {
  let message = 'Works on my machine.';
  res.send(message);
});

module.exports = app;
