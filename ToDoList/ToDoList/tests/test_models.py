from django.test import TestCase
from django.utils import timezone
from ToDoList.models import ToDoItem  

class ToDoItemModelTest(TestCase):
    def setUp(self):
        self.todo = ToDoItem.objects.create(
            description='Test ToDo',
            date_to_be_completed=timezone.make_aware(timezone.datetime(2024, 12, 31, 23, 59, 59)),
            priority='medium',
        )

    def test_todo_creation(self):
        self.assertEqual(self.todo.description, 'Test ToDo')
        self.assertEqual(self.todo.priority, 'medium')
        self.assertEqual(str(self.todo), self.todo.description)
