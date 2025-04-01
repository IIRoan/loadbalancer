FROM nginx:alpine

# Install troubleshooting tools
RUN apk add --no-cache curl bind-tools iputils

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom config
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Use the default command from the nginx image
CMD ["nginx", "-g", "daemon off;"]