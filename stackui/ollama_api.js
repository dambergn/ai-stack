const fs = require('fs');
const path = require('path');
const axios = require('axios');
require('dotenv').config();

// .env storred variables
const OLLAMA_SERVER = process.env.OLLAMA_SERVER;

// Topics
let topic_queue = [];
let topic_complete = [];

// Save to Json File
async function saveToJsonFile(incidents, filename) {
  try {
      const dirPath = path.dirname(filename);

      // Check if directory exists; if not, create it
      if (!fs.existsSync(dirPath)) {
          fs.mkdirSync(dirPath, { recursive: true });
      }

      const jsonString = JSON.stringify(incidents, null, 2); // Pretty print the JSON
      fs.writeFileSync(filename, jsonString);
      console.log(`Successfully saved to: ${filename}`);
  } catch (error) {
      console.error('Error saving:', error.message);
      throw error;
  }
}

// Append to text file
function appendToFile(textToAdd, filePath) {
  // Extract directory from file path
  const dir = path.dirname(filePath);
  
  // Check if directory exists
  if (!fs.existsSync(dir)) {
      // Create the directory if it doesn't exist (recursive)
      fs.mkdirSync(dir, { recursive: true });
  }

  // Append text to file
  try {
      fs.appendFile(filePath, textToAdd + '\n', (err) => {
          if (err) throw err;
          console.log('Text appended successfully');
      });
  } catch (error) {
      console.error('Error appending text:', error);
  }
}

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
  
  // Make the request and return the promise
  try {
    const response = await axios(config);
    return response.data;
  } catch (error) {
    console.error("Error:", error);
    throw error;
  }
};

function formatResponse(data){
  
}

async function main(){
  let model = "deepseek-r1:1.5b"
  let prompt = "You are an expert on Computer Science, Give me a comprehensive explenation for computer science and its sub-fields. please give me a list of related topics."
  let response = {};
  try {
    const ollamaResponse = await ollama_request(model, prompt);
    response = ollamaResponse
  } catch (error) {
    console.error("Error in main:", error);
  }
  console.log(response);
}

main();