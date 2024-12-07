import React, { useState } from 'react';
import BookList from './BookList';
import AddBookForm from './AddBookForm';
import EditBookForm from './EditBookForm';
import DeleteBookButton from './DeleteBookButton';

const App = () => {
  const [editBookId, setEditBookId] = useState(null); // State to track book id for editing

  // Function to handle edit button click
  const handleEditClick = (id) => {
    setEditBookId(id); // Set the id of the book to be edited
  };

  // Function to handle cancel edit
  const handleCancelEdit = () => {
    setEditBookId(null); // Reset editBookId to null to cancel editing
  };

  return (
    <div>
      <h1>Book Management Applicationnnn</h1>
      <BookList handleEditClick={handleEditClick} /> {/* Pass handleEditClick as prop */}
      <AddBookForm />
      {editBookId && <EditBookForm bookId={editBookId} onCancelEdit={handleCancelEdit} />}
      <DeleteBookButton />
    </div>
  );
};

export default App;
