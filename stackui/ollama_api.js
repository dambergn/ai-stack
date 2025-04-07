const axios = require('axios');

// Create the configuration object for the request
const config = {
  method: 'post',
  url: 'http://192.168.1.41:11434/api/generate',
  headers: {
    'Content-Type': 'application/json'
  },
  data: JSON.stringify({
    "model": "deepseek-r1:1.5b",
    "prompt": "What is the speed of light?",
    "stream": false
  })
};

// Make the request and save the response
axios(config)
.then((response) => {
  const jsonResponse = response.data;
  console.log(jsonResponse);
})
.catch((error) => {
  console.error("Error:", error);
});