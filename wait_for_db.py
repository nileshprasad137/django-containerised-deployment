import os
import sys
import psycopg2
import time
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Wait for DB
while True:
    try:
        conn = psycopg2.connect(
            host=os.environ.get('DATABASE_HOST', 'db'),
            port=os.environ.get('DATABASE_PORT', '5432'),
            user=os.environ.get('DATABASE_USER', 'postgres'),
            password=os.environ.get('DATABASE_PASSWORD', 'password'),
            dbname=os.environ.get('DATABASE_NAME', 'postgres')
        )
        conn.close()
        break
    except psycopg2.OperationalError:
        print("Waiting for DB...")
        time.sleep(1)

# Run the command
print("Database has connected.")
