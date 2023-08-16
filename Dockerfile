# Use a slim version of Python 3.10 as the base image
FROM python:3.10-slim

# Set the working directory within the container
WORKDIR /python-docker

# Copy the requirements file into the container
COPY requirements.txt requirements.txt

# Update package list and install git
RUN apt-get update && apt-get install git -y

# Install Python dependencies from requirements.txt
RUN pip3 install virtualenv
RUN virtualenv venv
RUN . venv/bin/activate && pip install -r requirements.txt

# Install Whisper from GitHub repository
RUN . venv/bin/activate && pip install "git+https://github.com/openai/whisper.git"

# Install FFmpeg
RUN apt-get install -y ffmpeg

# Copy the rest of the application code into the container
COPY . .

# Expose the port that the Flask app will run on
EXPOSE 5000

# Run the Flask app when the container starts
CMD [ "venv/bin/python", "-m", "flask", "run", "--host=0.0.0.0"]
