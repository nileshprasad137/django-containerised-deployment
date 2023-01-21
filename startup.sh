#!/bin/bash

python wait_for_db.py
cd todo_project/
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
