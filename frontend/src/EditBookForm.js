// EditBookForm.js

import React, { useState } from 'react';
import axios from 'axios';

const EditBookForm = ({ book }) => {
  const [title, setTitle] = useState(book.title);
  const [author, setAuthor] = useState(book.author);

  const handleSubmit = async (event) => {
    event.preventDefault();

    try {
      await axios.put(`http://34.46.49.182/api/books/${book._id}`, { title, author });
      alert('Book updated successfully!');
    } catch (error) {
      console.error('Error updating book:', error);
    }
  };

  return (
    <div>
      <h2>Edit Book</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <input
          type="text"
          value={author}
          onChange={(e) => setAuthor(e.target.value)}
        />
        <button type="submit">Update Book</button>
      </form>
    </div>
  );
};

export default EditBookForm;
