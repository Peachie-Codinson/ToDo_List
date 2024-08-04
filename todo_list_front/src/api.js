import axios from 'axios';

const api = axios.create({
    baseURL: 'http://16.16.207.89:8080/api/todos',
});

export default api;
