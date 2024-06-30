const express = require('express');
const path = require('path');
const app = express();
const port = 5000;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/welcome/welcome.html'));
});

app.get('/welcome/', (req, res) => {
  res.redirect('/');
});

app.get('/resume/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/resume/resume.html'));
});

app.get('/publications/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/publications/publications.html'));
});

app.get('/geolayers/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/geolayers/geolayers.html'));
});

app.get('/geolayers/citiesivebeen/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/geolayers/citiesivebeen.html'));
});

app.get('/geolayers/geopoints/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/geolayers/geopoints.html'));
});

app.get('/geolayers/teste/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/geolayers/teste.html'));
});

app.get('/about/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '/html/about/about.html'));
});

app.get('*', (req, res) => {
  res.redirect('/');
});

app.listen(port, () => {
    console.log(`Server is listening at http://localhost:${port}`);
});


