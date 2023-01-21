#!/bin/bash

python wait_for_db.py
cd todo_project/
python manage.py migrate
gunicorn todo_project.wsgi:application --bind 0.0.0.0:8000 --workers 3