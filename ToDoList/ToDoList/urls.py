"""
URL configuration for ToDoList project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.views.generic import TemplateView
from rest_framework.routers import DefaultRouter
from .views import ToDoItemViewSet

router = DefaultRouter()
router.register(r'api/todos', ToDoItemViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/todos/', ToDoItemViewSet.as_view({
        'get': 'list',     # GET /api/todos/
        'post': 'create'   # POST /api/todos/
    }), name='todo-list'),
    path('api/todos/<int:pk>/', ToDoItemViewSet.as_view({
        'get': 'retrieve',   # GET /api/todos/<id>/
        'put': 'update',     # PUT /api/todos/<id>/
        'patch': 'partial_update',  # PATCH /api/todos/<id>/
        'delete': 'destroy'  # DELETE /api/todos/<id>/
    }), name='todo-detail'),
    path('', include(router.urls)),
]
