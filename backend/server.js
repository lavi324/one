const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors'); // Import CORS middleware
const Book = require('./models/Book');

const app = express();
app.use(express.json());

// CORS middleware
app.use(cors({
  origin: 'http://34.46.197.246' // Allow requests from this origin
}));

// MongoDB connection setup
mongoose.connect('mongodb://root:1vwLaXp8WG@104.154.135.118:27017/admin', {
  //useNewUrlParser: true,
  //useUnifiedTopology: true
})
.then(() => {
  console.log('MongoDB connected');
})
.catch(err => {
  console.error(err);
});

// Create a new book
app.post('/api/books', async (req, res) => {
  try {
    const book = await Book.create(req.body);
    res.status(201).json(book);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Get all books
app.get('/api/books', async (req, res) => {
  try {
    const books = await Book.find();
    res.json(books);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get a single book by ID
app.get('/api/books/:id', async (req, res) => {
  try {
    const book = await Book.findById(req.params.id);
    if (!book) {
      return res.status(404).json({ message: 'Book not found' });
    }
    res.json(book);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update a book
app.put('/api/books/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const book = await Book.findByIdAndUpdate(id, req.body, { new: true });
    res.json(book);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
