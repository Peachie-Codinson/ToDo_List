from django.db import models
from django.utils import timezone 

class ToDoItem(models.Model):
    LOW = 'low'
    MEDIUM = 'medium'
    HIGH = 'high'
    PRIORITY_CHOICES = [
        (LOW, 'Low'),
        (MEDIUM, 'Medium'),
        (HIGH, 'High'),
    ]

    IN_PROGRESS = 'in-progress'
    COMPLETED = 'completed'
    STATUS_CHOICES = [
        (IN_PROGRESS, 'In Progress'),
        (COMPLETED, 'Completed'),
    ]

    description = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    date_to_be_completed = models.DateTimeField()
    date_completed = models.DateTimeField(null=True, blank=True)  # New field
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default=LOW)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=IN_PROGRESS)

    def save(self, *args, **kwargs):
        if self.status == self.COMPLETED and not self.date_completed:
            self.date_completed = timezone.now() 
        super().save(*args, **kwargs)

    def __str__(self):
        return self.description
