import React, { useState } from 'react';
import ToDoList from './components/ToDoList';

const App = () => {
    const [fetchTodos, setFetchTodos] = useState(() => () => {});
    const [, setEditingTodo] = useState(null);

    return (
        <div>
            <ToDoList setFetchTodos={setFetchTodos} setEditingTodo={setEditingTodo} />
        </div>
    );
};

export default App;
