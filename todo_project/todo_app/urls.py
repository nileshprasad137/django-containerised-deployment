from django.urls import path
from .views import TodoList, TodoDetail

urlpatterns = [
    path('todos/', TodoList.as_view(), name='todo_list'),
    path('todos/<int:pk>/', TodoDetail.as_view(), name='todo_detail'),
]
