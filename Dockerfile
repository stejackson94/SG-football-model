# set base image (host OS)
FROM python:3.12-slim

# Install uv (Python package installer)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Set working directory
WORKDIR /app

# Copy project files for dependency installation
COPY ./pyproject.toml ./uv.lock ./

# Install Python Requirements using uv with CodeArtifact
RUN uv sync --frozen --no-dev

# copy the content of the local src directory to the working directory
COPY ./src ./src

# Change users
USER root

# Expose the application port
EXPOSE 8000

# Run the application
CMD ["uv", "run", "python", "src/main.py"]
