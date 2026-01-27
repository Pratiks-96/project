const request = require('supertest');
const express = require('express');
const app = express();

app.get('/health', (req, res) => res.status(200).json({ status: 'ok' }));
app.get('/predict', (req, res) => res.status(200).json({ score: 0.75 }));

describe('API Tests', () => {
  it('GET /health should return 200', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
  });

  it('GET /predict should return score', async () => {
    const res = await request(app).get('/predict');
    expect(res.body.score).toBe(0.75);
  });
});
