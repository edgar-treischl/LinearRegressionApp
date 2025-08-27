# Use rocker image with R and Shiny Server preinstalled
FROM rocker/shiny:4.4.0

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

# Make sure start.sh is executable
RUN chmod +x /start.sh

# Install renv and restore package environment
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org'); renv::restore(confirm = FALSE)"

# Install markdown package explicitly (required by your app)
RUN R -e "install.packages('markdown', repos = 'https://cloud.r-project.org')"

# Create a non-root user for security and fix permissions
RUN useradd -m -s /bin/bash shinyuser && \
    chown -R shinyuser:shinyuser /app && \
    mkdir -p /var/lib/nginx/body && \
    mkdir -p /var/log/nginx && \
    chown -R shinyuser:shinyuser /var/lib/nginx /var/log/nginx

# Switch to non-root user
USER shinyuser

# Expose port 80
EXPOSE 80

# Start script (should start both shiny-server and nginx)
CMD ["/start.sh"]
