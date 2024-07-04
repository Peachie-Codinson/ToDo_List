import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Card, Button, Form, Row, Col } from 'react-bootstrap';

const EditToDo = ({ todo, updateTodo, onCancel }) => {
    const [description, setDescription] = useState('');
    const [dateToBeCompleted, setDateToBeCompleted] = useState('');
    const [priority, setPriority] = useState('low');

    useEffect(() => {
        if (todo) {
            setDescription(todo.description);
            setDateToBeCompleted(todo.date_to_be_completed);
            setPriority(todo.priority);
        }
    }, [todo]);

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            const updatedTodo = {
                ...todo,
                description,
                date_to_be_completed: dateToBeCompleted,
                priority,
            };
            await axios.put(`http://localhost:8080/api/todos/${todo.id}/`, updatedTodo);
            updateTodo(updatedTodo);
            onCancel();
        } catch (error) {
            console.error('Error updating todo:', error);
        }
    };

    return (
        <Col className="mx-auto mt-4 mb-4">
            <Card className="p-4">
                <h3 className="mb-4">Edit Task</h3>
                <Form onSubmit={handleSubmit}>
                    <Row className="mb-3">
                        <Col>
                            <Form.Group controlId="description">
                                <Form.Label>Description:</Form.Label>
                                <Form.Control
                                    type="text"
                                    value={description}
                                    onChange={(e) => setDescription(e.target.value)}
                                />
                            </Form.Group>
                        </Col>
                        <Col>
                            <Form.Group controlId="dateToBeCompleted">
                                <Form.Label>Date to be completed:</Form.Label>
                                <Form.Control
                                    type="datetime-local"
                                    value={dateToBeCompleted}
                                    onChange={(e) => setDateToBeCompleted(e.target.value)}
                                />
                            </Form.Group>
                        </Col>
                        <Col>
                            <Form.Group controlId="priority">
                                <Form.Label>Priority:</Form.Label>
                                <Form.Control
                                    as="select"
                                    value={priority}
                                    onChange={(e) => setPriority(e.target.value)}
                                >
                                    <option value="low">Low</option>
                                    <option value="medium">Medium</option>
                                    <option value="high">High</option>
                                </Form.Control>
                            </Form.Group>
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <Button type="submit" variant="primary" className="me-2">Update To-Do</Button>
                            <Button variant="secondary" onClick={onCancel}>Cancel</Button>
                        </Col>
                    </Row>
                </Form>
            </Card>
        </Col>
    );
};

export default EditToDo;
