# Use a lightweight R base image
FROM rocker/r-ver:4.4

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install system libraries and nginx
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libxt-dev \
    pandoc \
    nginx \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

# Set working directory inside the container
WORKDIR /app

# Copy app code, renv.lock, nginx config, and htpasswd file
COPY . /app
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/.htpasswd /etc/nginx/.htpasswd
COPY start.sh /start.sh

# Install renv and restore package environment
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org'); renv::restore(confirm = FALSE)"

RUN R -e "install.packages('markdown', repos = 'https://cloud.r-project.org')"

# Create a non-root user for security
RUN useradd -m -s /bin/bash shiny && \
    chown -R shiny:shiny /app

USER shiny

# Expose port 80 for nginx
EXPOSE 80

# Start nginx and shiny server when container launches
CMD ["/start.sh"]

