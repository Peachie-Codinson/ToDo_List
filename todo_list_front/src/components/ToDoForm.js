import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Card, Col, Row } from 'react-bootstrap';

const ToDoForm = ({ fetchTodos, editingTodo, setEditingTodo }) => {
    const [description, setDescription] = useState('');
    const [dateToBeCompleted, setDateToBeCompleted] = useState('');
    const [priority, setPriority] = useState('low');

    useEffect(() => {
        if (editingTodo) {
            setDescription(editingTodo.description);
            setDateToBeCompleted(editingTodo.date_to_be_completed);
            setPriority(editingTodo.priority);
        } else {
            setDescription('');
            setDateToBeCompleted('');
            setPriority('low');
        }
    }, [editingTodo]);

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            if (editingTodo) {
                await axios.put(`http://localhost:8080/api/todos/${editingTodo.id}/`, {
                    description,
                    date_to_be_completed: dateToBeCompleted,
                    priority,
                });
            } else {
                await axios.post('http://localhost:8080/api/todos/', {
                    description,
                    date_to_be_completed: dateToBeCompleted,
                    priority,
                });
            }
            fetchTodos(); 
            setDescription('');
            setDateToBeCompleted('');
            setPriority('low');
            setEditingTodo(null);
        } catch (error) {
            console.error('Error submitting todo:', error);
        }
    };

    return (
        <Col md={8} className="mx-auto mt-4 mb-4">
            <Card className="p-4">
                <h3 className="mb-4">{editingTodo ? 'Edit Task' : 'Add New Task'}</h3>
                <form onSubmit={handleSubmit}>
                    <Row className="mb-3">
                        <Col>
                            <label className="form-label">
                                Description:
                                <input
                                    type="text"
                                    className="form-control"
                                    value={description}
                                    onChange={(e) => setDescription(e.target.value)}
                                />
                            </label>
                        </Col>
                        <Col>
                            <label className="form-label">
                                Date to be completed:
                                <input
                                    type="datetime-local"
                                    className="form-control"
                                    value={dateToBeCompleted}
                                    onChange={(e) => setDateToBeCompleted(e.target.value)}
                                />
                            </label>
                        </Col>
                        <Col>
                            <label className="form-label">
                                Priority:
                                <select
                                    className="form-control"
                                    value={priority}
                                    onChange={(e) => setPriority(e.target.value)}
                                >
                                    <option value="low">Low</option>
                                    <option value="medium">Medium</option>
                                    <option value="high">High</option>
                                </select>
                            </label>
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <button type="submit" className="btn btn-primary">{editingTodo ? 'Update' : 'Add'} To-Do</button>
                        </Col>
                    </Row>
                </form>
            </Card>
        </Col>
    );
};

export default ToDoForm;
