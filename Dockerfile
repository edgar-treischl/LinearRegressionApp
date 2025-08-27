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

# Set working directory
WORKDIR /app

# Copy app code, renv.lock, nginx config, and htpasswd file
COPY . /app
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/.htpasswd /etc/nginx/.htpasswd
COPY start.sh /start.sh

# Ensure start.sh is executable
RUN chmod +x /start.sh

# Install renv and restore packages
RUN R -e "install.packages('renv', repos = 'https://cloud.r-project.org'); renv::restore(confirm = FALSE)"
RUN R -e "install.packages('markdown', repos = 'https://cloud.r-project.org')"

# Create non-root user and fix permissions (including /run for nginx)
RUN useradd -m -s /bin/bash shinyuser && \
    mkdir -p /var/lib/nginx/body && \
    mkdir -p /var/log/nginx && \
    mkdir -p /run && \
    chown -R shinyuser:shinyuser /app /var/lib/nginx /var/log/nginx /run

# Switch to non-root user
USER shinyuser

# Expose port 80 for nginx
EXPOSE 80

# Start both Shiny and nginx
CMD ["/start.sh"]
