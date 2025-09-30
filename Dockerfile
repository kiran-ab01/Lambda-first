# Step 1: Use a lightweight Python base image
FROM python:3.10-slim

# Step 2: Set working directory
WORKDIR /app

# Step 3: Install Flask
RUN pip install flask

# Step 4: Copy application code
COPY app.py .

# Step 5: Expose port
EXPOSE 5000

# Step 6: Run the app
CMD ["python", "app.py"]
