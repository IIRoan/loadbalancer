FROM nginx:alpine

# Install troubleshooting tools
RUN apk add --no-cache curl bind-tools iputils

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom config
COPY nginx.conf /etc/nginx/nginx.conf

# Create a startup script
RUN echo '#!/bin/sh\n\
echo "==== TESTING CONNECTION ===="\n\
echo "Resolving laravel-example.railway.internal..."\n\
nslookup laravel-example.railway.internal || echo "DNS resolution failed"\n\
echo "Attempting connection to backend..."\n\
curl -v --connect-timeout 5 http://laravel-example.railway.internal:8080/ || echo "Connection failed"\n\
echo "==== STARTING NGINX ===="\n\
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

# Expose port 80
EXPOSE 80

# Start with our script
CMD ["/start.sh"]