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

Below mentioned steps are for AWS ECS (with fargate)

#### Steps for Deploying Application on Production (with ECS Fargate and Postgres Aurora Serverless)
  - Go To RDS and choose Aurora Serverless Postgres. Create a EC2 instance to login to the Postgres host and create your project specific database).
    Inside EC2 ->
     - `sudo yum install -y postgresql`
     - Create your project db : `psql "postgres://<username>:<password>@<cluster-endpoint>:5432/postgres" -c "CREATE DATABASE todo_project"`
  - Create an ECR repository to store your Docker image which can be done from CLI / Console.
  - Build a production-specific Docker image using a Dockerfile.prod file with necessary dependencies and the gunicorn server.
 `docker buildx build --platform=linux/amd64 -f Dockerfile.prod -t todo_project .` (This will ensure that the image is built for the linux/amd64 architecture)
  - Push the image to the ECR repository.
    - Login to aws ecr
         `aws ecr get-login-password --region ap-south-1 --profile personal | docker login --username AWS --password-stdin <account_id>.dkr.ecr.ap-south-1.amazonaws.com`
    - Tag your docker image
        `docker tag todo_project:latest <account_id>.dkr.ecr.ap-south-1.amazonaws.com/todo_project:latest`
    - Push to ECR
        `docker push <account_id>.dkr.ecr.ap-south-1.amazonaws.com/todo_project:latest`
  - Create an ECS task definition for your task and specify the necessary environment variables and container settings. Make sure you choose right ports (8000 in this project's case) and ecs has the required permissions / policies attached. Choose Fargate launch type if you don't want to have the headcahe of maintaing EC2 instances.
  - Create ECS Cluster and choose the right VPC with appropriate n/w settings.
  - Create an ECS service and configure it to use the desired task definition and image.
Configure a load balancer to route traffic to the ECS service. This step must be done carefully. You would need to ensure you Load Balancer is able to access ECS containers on the spcified port or Health checks would keep failing.
 - Modifying the security group or network ACL associated with the ECS task or the associated load balancer to allow traffic on the desired port.
  - If the service is created successfully, ECS tasks would be in  `Running` state. 
 

#### Challenges that you can run into:
 1. One of the challenges you may face during production deployment is ensuring that the container image is compatible with the architecture and operating system of the container you are trying to run it on. This can be resolved by building the image on the same architecture and operating system as the container, or by using a multi-architecture builder like buildx.
 2. If task does not connect to RDS, provide necessary permission to ecs using Policies.
 3. Another challenge may be configuring security groups or network ACLs to allow inbound traffic to the task on the specified port. This can be resolved by adding the necessary rules to the security group or network ACL.
 4. Another challenge may be configuring ELB to route to the ECS task. This can be resolved by allowing the hosts. (in `settings.py`)

