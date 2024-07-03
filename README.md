# To-Do List App

## Overview
The To-Do List app is a full-stack application that allows users to create, edit, delete, or mark tasks as done. It features a React frontend and a Django backend, designed for local deployment.

## Features
- Create new tasks
- Edit existing tasks
- Delete tasks
- Mark tasks as done
- View tasks sorted by date created, deadline, or priority
- Toggle between viewing in-progress and completed tasks

## Prerequisites
Before running the application, ensure you have the following installed:
- Docker
- Docker Compose

## Installation
1. Clone the repository:
    ```
    git clone https://github.com/Peachie-Codinson/ToDo_List
    ```

2. Build and start the application using Docker Compose:
    ```
    docker-compose up --build
    ```

3. Access the application in your browser:
    - Open [http://localhost:3000](http://localhost:3000) to view the React frontend.

## Folder Structure
- `ToDoList/`
  - `frontend/` - Contains the React frontend application.
  - `backend/` - Contains the Django backend application.
  - `docker-compose.yml` - Docker Compose configuration file.
  - `Dockerfile` - Dockerfile for the frontend.
  - `Dockerfile.backend` - Dockerfile for the backend.

## API Endpoints
The backend exposes the following endpoints:
- `GET /api/todos/in-progress/` - Fetches in-progress tasks
- `GET /api/todos/completed/` - Fetches completed tasks
- `POST /api/todos/` - Creates a new task
- `PUT /api/todos/{id}/` - Updates a task by ID
- `DELETE /api/todos/{id}/` - Deletes a task by ID
