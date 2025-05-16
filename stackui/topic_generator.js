const fs = require('fs');
require('dotenv').config();

// .env storred variables
const OLLAMA_SERVER = process.env.OLLAMA_SERVER;

// Topics
let topic_list = [];

// Ollama API request
async function ollama_request(model, prompt) {
    // Create the configuration object for the request
    const config = {
      method: 'post',
      url: `${OLLAMA_SERVER}/api/generate`,
      headers: {
        'Content-Type': 'application/json'
      },
      data: JSON.stringify({
        "model": model,
        "prompt": prompt,
        "stream": false
      })
    };
}

async function main(){
    let model = "qwen3:0.6b"
    let prompt = "Please generate a list of all the elements on the periodic table and return them in json format."
    let ollama_response = await ollama_request(model, prompt);
    console.log(ollama_response);
    
};

main();