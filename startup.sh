#!/bin/sh

python wait_for_db.py
cd todo_project/
python manage.py migrate
# In Gunicorn, worker processes are responsible for handling incoming requests and processing them. 
# Each worker process runs in its own separate Python interpreter, which means that it can handle multiple requests concurrently. The number of worker processes that are run simultaneously is determined by the --workers option, and the number of threads that each worker process uses is determined by the --threads option.
# By default, Gunicorn uses a synchronous worker class, meaning that it can only handle one request at a time. However, when using the gthread worker class, Gunicorn can handle multiple requests in parallel by using threads. 
# The number of threads per worker process is a trade-off between performance and memory usage. Having more threads will allow Gunicorn to handle more requests in parallel, which can improve performance. However, each thread consumes memory, so having too many threads can lead to increased memory usage and potential performance issues.
gunicorn todo_project.wsgi:application --bind 0.0.0.0:8000 --workers 5 --threads 2 --worker-class=gthread --timeout 300