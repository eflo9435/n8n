const express = require('express');
const axios = require('axios');
const app = express();

app.use(express.json());

// OpenAI API proxy
app.all('/v1/*', async (req, res) => {
  try {
    const response = await axios({
      method: req.method,
      url: `https://api.openai.com${req.path}`,
      headers: {
        'Authorization': req.headers.authorization || `Bearer ${process.env.OPENAI_API_KEY}`,
        'Content-Type': 'application/json'
      },
      data: req.body
    });
    res.json(response.data);
  } catch (error) {
    console.error('Proxy error:', error.response?.data || error.message);
    res.status(error.response?.status || 500).json({ 
      error: error.response?.data || 'AI service unavailable' 
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'LiteLLM Proxy' });
});

app.listen(4000, () => console.log('LiteLLM proxy running on port 4000'));
