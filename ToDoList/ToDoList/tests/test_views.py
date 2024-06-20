from django.test import TestCase
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIClient
from models import ToDoItem

class ToDoItemViewTest(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.todo = ToDoItem.objects.create(
            description='Test ToDo',
            date_to_be_completed='2024-12-31T23:59:59Z',
            priority='medium',
        )

    def test_get_todo_list(self):
        response = self.client.get(reverse('todo-list'))
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_todo(self):
        data = {
            'description': 'New ToDo',
            'date_to_be_completed': '2024-12-31T23:59:59Z',
            'priority': 'low'
        }
        response = self.client.post(reverse('todo-list'), data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_update_todo(self):
        data = {
            'description': 'Updated ToDo',
            'priority': 'high'
        }
        response = self.client.patch(reverse('todo-detail', kwargs={'pk': self.todo.pk}), data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_todo(self):
        response = self.client.delete(reverse('todo-detail', kwargs={'pk': self.todo.pk}))
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
