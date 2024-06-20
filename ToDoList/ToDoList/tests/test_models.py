from django.test import TestCase
from models import ToDoItem

class ToDoItemModelTest(TestCase):
    def setUp(self):
        self.todo = ToDoItem.objects.create(
            description='Test ToDo',
            date_to_be_completed='2024-12-31T23:59:59Z',
            priority='medium',
        )

    def test_todo_creation(self):
        self.assertEqual(self.todo.description, 'Test ToDo')
        self.assertEqual(self.todo.priority, 'medium')
        self.assertEqual(str(self.todo), self.todo.description)
