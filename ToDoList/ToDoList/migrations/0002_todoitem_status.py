# Generated by Django 5.0.6 on 2024-06-20 12:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ToDoList', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='todoitem',
            name='status',
            field=models.CharField(choices=[('in-progress', 'In Progress'), ('completed', 'Completed')], default='in-progress', max_length=20),
        ),
    ]
