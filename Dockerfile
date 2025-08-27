# Use your custom base image with R, Shiny Server, renv, and NGINX
FROM ghcr.io/edgar-treischl/shinyserver:latest

# Copy app code and renv files
COPY . /srv/shiny-server/app

WORKDIR /srv/shiny-server/app

# Restore packages from renv.lock
RUN R -e "renv::restore(prompt = FALSE)"

# You can optionally override Basic Auth or NGINX config if needed
# COPY custom-nginx.conf /etc/nginx/nginx.conf
# COPY .htpasswd /etc/nginx/.htpasswd

# Expose default port used by NGINX (which proxies to Shiny Server)
EXPOSE 80

# Start both nginx and shiny-server
CMD service nginx start && exec shiny-server
