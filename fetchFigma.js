const axios = require('axios');
const fs = require('fs');
require('dotenv').config();

const figmaApiToken = process.env.FIGMA_API_TOKEN;
const fileId = 'cgxyu538MRm5yObOmv1G0b'; 	// Figma file ID

async function fetchFigmaFile() {
  try {
    const response = await axios.get(`https://api.figma.com/v1/files/${fileId}`, {
      headers: {
        'X-Figma-Token': figmaApiToken
      }
    });
    fs.writeFileSync('figmaData.json', JSON.stringify(response.data, null, 2));
    console.log('Figma data saved successfully!');
  } catch (error) {
    console.error('Error fetching Figma file:', error);
  }
}

fetchFigmaFile();
