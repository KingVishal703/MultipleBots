# Base image
FROM mysterydemon/botcluster:latest

# Set working directory
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt ./
RUN pip3 install --upgrade pip && pip3 install --root-user-action=ignore -r requirements.txt

# Copy the rest of the application code
COPY . .

# Ensure start.sh is executable
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Use the start.sh script as the entry point when the container starts
CMD ["/usr/local/bin/start.sh"]
