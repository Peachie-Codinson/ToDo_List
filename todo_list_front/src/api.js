import axios from 'axios';

const api = axios.create({
    baseURL: 'http://13.48.141.41:8080/api/todos/',
});

export default api;
