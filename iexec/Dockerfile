# Use a lightweight Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install required system dependencies (if any) and Python libraries
# We need 'web3' for the keccak256 hashing
RUN pip install --no-cache-dir web3

# Copy your application source code
COPY app.py /app/app.py

# Copy your Aleo policy file (the "Policy Artifact")
# This file is hashed by the script to prove which logic was used
COPY main.aleo /app/main.aleo

# Create the input/output directories that iExec expects
# (These are often mounted at runtime, but good to have)
RUN mkdir -p /iexec_in /iexec_out

# Define the command to run your app
ENTRYPOINT ["python", "/app/app.py"]