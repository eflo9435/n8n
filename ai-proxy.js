const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Simple proxy for OpenAI API
app.all('/v1/*', async (req, res) => {
  try {
    const response = await axios({
      method: req.method,
      url: `https://api.openai.com${req.path}`,
      headers: {
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
        'Content-Type': 'application/json'
      },
      data: req.body
    });
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: 'AI service unavailable' });
  }
});

// Models endpoint
app.get('/v1/models', (req, res) => {
  res.json({
    data: [
      { id: 'gpt-4', object: 'model' },
      { id: 'gpt-3.5-turbo', object: 'model' }
    ]
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(4000, () => console.log('AI Proxy running on port 4000'));
