const express = require('express');
const axios = require('axios');
const router = express.Router();

// Configuration for Ollama server
const ollamaConfig = {
    url: 'http://192.168.1.41:11434',
    endpoint: '/api/generate'
};

// POST route to send prompt to Ollama
router.post('/generate', async (req, res) => {
    try {
        const { model, prompt } = req.body;

        // Validate required fields
        if (!model || !prompt) {
            return res.status(400).json({ error: 'Model and prompt are required' });
        }

        // Prepare the payload
        const payload = {
            model,
            prompt,
            stream: false
        };

        // Send request to Ollama server
        const response = await axios.post(`${ollamaConfig.url}${ollamaConfig.endpoint}`, payload);

        // Return the response from Ollama
        return res.status(200).json(response.data);
    } catch (error) {
        console.error('Error:', error.message);
        return res.status(500).json({ error: 'Failed to generate response' });
    }
});

module.exports = router;