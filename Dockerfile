# Use an image base con Eclipse Temurin JDK 17 en Ubuntu Jammy
FROM eclipse-temurin:17-jdk-jammy

# Setup metadata
LABEL maintainer="martin.salvachua1@gmail.com"
LABEL description="Local validation environment for EDAAnOWL ontology using Python and ROBOT."

# Install Python 3.11 and other dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Config Python alternatives
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Install Python packages
RUN pip install --upgrade pip
RUN pip install rdflib pyshacl requests

# Set working directory
WORKDIR /app

# Download ROBOT
RUN wget -q -O robot.jar https://github.com/ontodev/robot/releases/download/v1.9.4/robot.jar
ENV ROBOT_JAR=/app/robot.jar

# Copy validation files into the container
COPY scripts/ /app/scripts/
COPY shapes/ /app/shapes/
COPY tests/ /app/tests/
COPY docs/ /app/docs/

# Entry point by default (runs the master validation script)
ENTRYPOINT ["python3", "scripts/check_rdf.py"]
# Optionally, you can use a master script
# ENTRYPOINT ["bash", "scripts/validate.sh"]