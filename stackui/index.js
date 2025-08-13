const express = require('express');
require('dotenv').config();

const app = express();
const port = process.env.PORT | 3000;
const OLLAMA_SERVER = process.env.OLLAMA_SERVER;

// Serve static files from the public folder
app.use(express.static('public'));

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});