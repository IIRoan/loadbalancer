FROM nginx:alpine

# Install troubleshooting tools
RUN apk add --no-cache curl bind-tools iputils

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom config
COPY nginx.conf /etc/nginx/nginx.conf

# Create a startup script directly in the container
RUN echo '#!/bin/sh' > /docker-entrypoint.d/99-test-connection.sh && \
    echo 'echo "==== TESTING CONNECTION ====" >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    echo 'echo "Resolving laravel-example.railway.internal..." >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    echo 'nslookup laravel-example.railway.internal || echo "DNS resolution failed" >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    echo 'echo "Attempting connection to backend..." >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    echo 'curl -v --connect-timeout 5 http://laravel-example.railway.internal:8080/ || echo "Connection failed" >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    echo 'echo "==== CONNECTION TEST COMPLETED ====" >> /proc/1/fd/1' >> /docker-entrypoint.d/99-test-connection.sh && \
    chmod +x /docker-entrypoint.d/99-test-connection.sh

# Expose port 80
EXPOSE 80

# Use the default command from the nginx image
CMD ["nginx", "-g", "daemon off;"]