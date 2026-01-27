const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.get('/predict', (req, res) => {
  res.status(200).json({ score: 0.75 });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
