# ================= BASE IMAGE =================
FROM python:3.11-slim

# ================= WORKDIR ====================
WORKDIR /app

# ================= SYSTEM DEPS ================
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ================= PYTHON DEPS ================
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ================= APP FILES ==================
COPY . .

# ================= START SCRIPT ===============
RUN chmod +x start.sh

# ================= EXPOSE (if dashboard) ======
EXPOSE 8000

# ================= START ======================
CMD ["bash", "start.sh"]
