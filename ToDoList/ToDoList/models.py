from django.db import models

class ToDoItem(models.Model):
    LOW = 'low'
    MEDIUM = 'medium'
    HIGH = 'high'
    PRIORITY_CHOICES = [
        (LOW, 'Low'),
        (MEDIUM, 'Medium'),
        (HIGH, 'High'),
    ]

    description = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    date_to_be_completed = models.DateTimeField()
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default=LOW)

    def __str__(self):
        return self.description
