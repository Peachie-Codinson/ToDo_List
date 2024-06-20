from rest_framework import viewsets, status
from rest_framework.response import Response
from .models import ToDoItem
from .serializers import ToDoItemSerializer
from django.utils import timezone 

class ToDoItemViewSet(viewsets.ModelViewSet):
    queryset = ToDoItem.objects.all()
    serializer_class = ToDoItemSerializer

    def create(self, request, *args, **kwargs):
        request.data['status'] = 'in-progress'
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        if 'status' in request.data and request.data['status'] == 'completed':
            request.data['date_completed'] = request.data.get('date_completed', None) or timezone.now()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

    def partial_update(self, request, *args, **kwargs):
        instance = self.get_object()
        if 'status' in request.data and request.data['status'] == 'completed':
            request.data['date_completed'] = request.data.get('date_completed', None) or timezone.now()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

    def perform_update(self, serializer):
        instance = serializer.save()
        if 'status' in self.request.data and self.request.data['status'] == 'completed':
            instance.date_completed = self.request.data.get('date_completed', None) or timezone.now()
            instance.save()

    def perform_destroy(self, instance):
        instance.delete()

class InProgressToDoItemViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ToDoItem.objects.filter(status='in-progress')
    serializer_class = ToDoItemSerializer

class CompletedToDoItemViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ToDoItem.objects.filter(status='completed')
    serializer_class = ToDoItemSerializer
