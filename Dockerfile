FROM python:3.12.0a6-alpine3.16

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Create a directory for the application
RUN mkdir /backend

WORKDIR /backend

COPY ["./requirements/requirements-dev.txt", "/tmp/"]

# Install build dependencies
# postgresql-dev installs the PostgreSQL development libraries, which are needed by the psycopg2 package, a PostgreSQL adapter for Python.
# gcc, musl-dev, libc-dev are used to compile and build native extensions for python packages.
# jpeg-dev, zlib-dev are required to install python packages that have C extensions.
RUN apk update \
    && apk add postgresql-dev \
    gcc \
    musl-dev \
    libc-dev \
    jpeg-dev \
    zlib-dev \ 
    && pip install --no-cache-dir --extra-index-url https://alpine-wheels.github.io/index -r /tmp/requirements-dev.txt

# Collect static files
# Django uses the collectstatic management command to gather all of the static files from all of the installed apps and any other static files that are located in the STATIC_ROOT directory specified in the settings file, and copy them to a single directory that can be served by a web server.
# RUN python manage.py collectstatic --noinput

# Expose the port 8000
EXPOSE 8000

# Run the server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]