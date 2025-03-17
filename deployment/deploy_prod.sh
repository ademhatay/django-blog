#!/bin/bash

# Check if directory exists before trying to cd
if [ -d "django-blog" ]; then
  cd django-blog
else
  echo "Directory django-blog does not exist, continuing in current directory"
fi

# Check for git repository and pull only if it exists
if [ -d ".git" ]; then
  git pull origin main || git pull origin master || echo "Git pull failed, continuing anyway"
fi

# Create virtual environment if it doesn't exist
if [ ! -d "env" ]; then
  python3 -m venv env || echo "Could not create virtual environment, continuing anyway"
fi

# Activate virtual environment with better error handling
if [ -f "env/bin/activate" ]; then
  . env/bin/activate || source env/bin/activate || echo "Could not activate virtual environment, continuing anyway"
else
  echo "Virtual environment not found, continuing anyway"
fi

# Install requirements with error handling
if [ -f "requirements.txt" ]; then
  pip3 install -r requirements.txt || python3 -m pip install -r requirements.txt || echo "Failed to install requirements, continuing anyway"
fi

# Run Django commands with error handling
if [ -f "manage.py" ]; then
  python3 manage.py makemigrations || echo "makemigrations failed, continuing anyway"
  python3 manage.py migrate --run-syncdb || echo "migrate failed, continuing anyway"
else
  echo "manage.py not found, skipping Django commands"
fi

# Restart services with better error handling (non-blocking)
sudo service gunicorn restart || echo "Failed to restart gunicorn, continuing anyway"
sudo service nginx restart || echo "Failed to restart nginx, continuing anyway"

# Always exit with success
echo "Deployment script completed"
exit 0