## README

A sample project to showcase how to use Django, Django REST framework and PostgreSQL in a Docker container.

## Prerequisites
 - Docker
 - Docker Compose
 - Python 3.11.0


## Installation and Setup
1. Clone the repository:
2. Create a new file in the project root directory called `.env`, and set the following environment variables:
```
DATABASE_NAME='todo_project'
DATABASE_USER='todo_project_admin'
DATABASE_PASSWORD='todo_project_pass'
DATABASE_HOST='db'
DATABASE_PORT=5432
ENV="dev"
```
3. Build the Docker images and start the containers:
```
docker-compose build
docker-compose up
```

Once the containers are running, you should be able to access the application at http://localhost:8000/

To stop the containers, use `docker-compose down`



## Additional Info
 - The Dockerfile is used to build the image for the backend service. It installs the required dependencies, sets environment variables and starts the server.
 - The `docker-compose.yml` file defines the services, networks and volumes for the project.
 - The `startup.sh` file run migrations and run the server
 - The `.env` file contains the environment variables for the project.
 - The `requirements` folder contains the requirements-dev.txt file which lists the dependencies for the project.
 - The `settings` module contains the settings for different environments.
 - The todo_project is the main django project.
 - The todo_app is the django app for the todo functionality.
 - The `wait_for_db.py` file is used to wait for the database container to be ready before starting the backend service.

## Deployment
You can deploy this application to any platform that supports Docker and Docker Compose.
