# Use a lightweight R base image
FROM rocker/r-ver:4.4

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install system libraries required by common R packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libxt-dev \
    pandoc \
    pandoc-citeproc \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /app

# Copy everything into the container (app.R, renv.lock, etc.)
COPY . /app

# Install renv and restore package environment
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org'); renv::restore(confirm = FALSE)"

# Optional: create a non-root user (for security best practice)
RUN useradd -m -s /bin/bash shiny && \
    chown -R shiny:shiny /app
USER shiny

# Expose the default Shiny port
EXPOSE 3838

# Run the app directly using shiny::runApp
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]
