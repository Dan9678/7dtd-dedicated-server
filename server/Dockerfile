FROM cm2network/steamcmd:latest

# Install Python
USER root
RUN apt-get update && apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*
USER steam

# Set the working directory
WORKDIR /home/steam

# Copy scripts
COPY install.sh start7dtd.sh update_config.py .

# Copy mod script folders
COPY mod_scripts/ mod_scripts/

# Set the entrypoint
ENTRYPOINT ["/home/steam/install.sh"]

