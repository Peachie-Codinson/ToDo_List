import axios from 'axios';

const api = axios.create({
    baseURL: 'https://13.48.141.41:8080/api/todos/',
    // baseURL: 'http://localhost:8080/api/todos/',
});

export default api;
