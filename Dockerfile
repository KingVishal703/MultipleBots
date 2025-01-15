# Use the latest official Python image from Docker Hub
FROM python:latest

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . .

# Run the initial setup script
RUN bash run.sh

# Copy the start script and make it executable
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Set the default command to run when the container starts
CMD ["/usr/local/bin/start.sh"]
