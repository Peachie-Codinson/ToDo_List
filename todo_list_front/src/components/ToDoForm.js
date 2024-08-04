import React, { useState, useEffect } from 'react';
import { Card, Col, Row, Button, Form } from 'react-bootstrap';
import api from "../api.js";

const ToDoForm = ({ fetchTodos }) => {
    const [description, setDescription] = useState('');
    const [dateToBeCompleted, setDateToBeCompleted] = useState('');
    const [priority, setPriority] = useState('low');

    useEffect(() => {
        setDescription('');
        setDateToBeCompleted('');
        setPriority('low');
    }, [fetchTodos]);

    const handleSubmit = async (event) => {
        event.preventDefault();
        try {
            await api.post('/', {
                description,
                date_to_be_completed: dateToBeCompleted,
                priority,
            });
            fetchTodos(); 
            setDescription('');
            setDateToBeCompleted('');
            setPriority('low');
        } catch (error) {
            console.error('Error submitting todo:', error);
        }
    };

    return (
        <Col md={8} className="mx-auto mt-4 mb-4">
            <Card className="p-4">
                <h3 className="mb-4">Add New Task</h3>
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
                            <Button type="submit" variant="primary">Add To-Do</Button>
                        </Col>
                    </Row>
                </Form>
            </Card>
        </Col>
    );
};

export default ToDoForm;
