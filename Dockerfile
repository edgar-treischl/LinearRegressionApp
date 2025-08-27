# Use rocker image with R and Shiny Server preinstalled
FROM rocker/shiny:4.4.0

ENV DEBIAN_FRONTEND=noninteractive

# Install system libraries, nginx, create user, and prepare nginx dirs
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev libssl-dev libxml2-dev libpng-dev libjpeg-dev libxt-dev pandoc nginx apache2-utils && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash shinyuser && \
    mkdir -p /var/lib/nginx/body /var/log/nginx /run && \
    chown -R shinyuser:shinyuser /var/lib/nginx /var/log/nginx /run

WORKDIR /app

COPY . /app
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/.htpasswd /etc/nginx/.htpasswd
COPY start.sh /start.sh

# Fix permissions for /app after copying files
RUN chown -R shinyuser:shinyuser /app && \
    chmod +x /start.sh && \
    R -e "install.packages('renv', repos='https://cloud.r-project.org'); renv::restore(confirm = FALSE)" && \
    R -e "install.packages('markdown', repos='https://cloud.r-project.org')"

USER shinyuser

EXPOSE 80

CMD ["/start.sh"]
