const express = require('express');
const app = express();

app.use(express.json());

// Simple health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Basic AI endpoint for n8n webhooks
app.post('/ai/chat', (req, res) => {
  // Simple echo for now - you can enhance this later
  res.json({ 
    message: "AI service ready", 
    input: req.body 
  });
});

app.listen(4000, () => console.log('AI service running on port 4000'));
