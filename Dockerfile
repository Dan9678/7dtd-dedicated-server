FROM cm2network/steamcmd:latest

# Install Python
USER root
RUN apt-get update && apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*
USER steam

# Copy install.sh to the steam user's home directory
COPY install.sh /home/steam/install.sh

# Copy start7dtd.sh to the steam user's home directory
COPY start7dtd.sh /home/steam/start7dtd.sh

# Copy update_config.py to the steam user's home directory
COPY update_config.py /home/steam/update_config.py

# Set the working directory (optional, but can be helpful)
WORKDIR /home/steam

# Set the entrypoint
ENTRYPOINT ["/home/steam/install.sh"]

