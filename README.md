7 Days to Die Dedicated Server (Dockerized)

This repository provides a Dockerized setup for running a dedicated 7 Days to Die server. It includes automation for installation, configuration updates, and an optional idle mode for manual modifications.

🚀 Features
Automated Installation & Updates via SteamCMD
Dockerized Setup for easy deployment
Customizable Settings through environment variables
Idle Mode for installing mods or making manual changes before startup
Automatic Configuration Updates via update_config.py
GitHub Actions Workflow for automated Docker image builds

📂 Project Structure
7dtd-dedicated-server/
│── .github/workflows/   # GitHub Actions for CI/CD
│── server/
│   ├── Dockerfile       # Docker setup for the server
│   ├── docker-compose.yml # Docker Compose configuration
│   ├── install.sh       # Installs/updates the server using SteamCMD
│   ├── start7dtd.sh     # Starts the dedicated server
│   ├── update_config.py # Updates serverconfig.xml based on env vars
│   ├── serverconfig.xml (optional example config)
│── README.md            # Project documentation
│── LICENSE              # Open-source license
│── .gitignore           # Ignore unnecessary files

🛠️ Installation & Setup

1️⃣ Clone the Repository
git clone https://github.com/yourusername/7dtd-dedicated-server.git
cd 7dtd-dedicated-server

2️⃣ Configure Environment Variables
Modify docker-compose.yml to set your preferred settings:

services:
  7dtd-server:
    build: .
    ports:
      - "26900-26902:26900-26902/udp"
      - "8080:8080"
    environment:
      - ServerName=DadsCrazyServer
      - ServerVisibility=0
      - GameWorld=RWG
      - WorldGenSeed=Afunseed
      - WorldGenSize=8192
      - GameName=dads_game
      - MODE=server  # Change to "idle" for manual modifications
    volumes:
      - ./server_data:/steamapps

3️⃣ Start the Server
docker-compose up -d

This will:
Install/update the server if needed
Apply environment variables to serverconfig.xml
Start the dedicated server

4️⃣ Idle Mode (For Modding & Manual Changes)
To prevent the server from auto-starting:
docker-compose up -d --env MODE=idle
Then, access the container:
docker exec -it <container_id> /bin/sh
Make changes, then manually start the server:
./start7dtd.sh

5️⃣ Stopping the Server
docker-compose down


📜 License
This project is licensed under the MIT License. See LICENSE for details.

💡 Future Enhancements
📦 Mod Support: Auto-download and apply mods
🔄 Automated Backups
🛠️ Web-based Admin Panel
Contributions & PRs are welcome! 🚀
