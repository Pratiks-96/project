const express = require('express');
const client = require('prom-client');

const app = express();
const port = process.env.PORT || 3000;

// Collect default metrics
client.collectDefaultMetrics();

app.get('/health', (req, res) => {
res.status(200).json({ status: 'ok' });
});

app.get('/predict', (req, res) => {
res.status(200).json({ score: 0.75 });
});

app.get('/metrics', async (req, res) => {
res.set('Content-Type', client.register.contentType);
res.end(await client.register.metrics());
});

app.listen(port, () => {
console.log(`Server running on port ${port}`);
});
