// DeleteBookButton.js

import React from 'react';
import axios from 'axios';

const DeleteBookButton = ({ bookId }) => {
  const handleDelete = async () => {
    try {
      await axios.delete(`http://34.57.166.227/api/books/${bookId}`);
      alert('Book deleted successfully!');
    } catch (error) {
      console.error('Error deleting book:', error);
    }
  };

  return (
    <button onClick={handleDelete}>Delete Book</button>
  );
};

export default DeleteBookButton;
