## **Guide to Deploy Your Project from a Local Repository to DigitalOcean**

### **1. Prerequisites**
Ensure you have:
- A **DigitalOcean Droplet** with Docker installed.
- Your project ready in a local repository.
- SSH access to the Droplet.

---

### **2. Set Up the Droplet**

1. **SSH into the Droplet**:
   ```bash
   ssh root@<droplet-ip>
   ```

2. **Install Required Software**:
   - Update the Droplet:
     ```bash
     apt update && apt upgrade -y
     ```
   - Install Git:
     ```bash
     apt install git -y
     ```
   - Install Docker:
     ```bash
     apt install docker.io -y
     ```
   - Install Docker Compose:
     ```bash
     apt install docker-compose -y
     ```

---

### **3. Upload Your Project to the Droplet**

#### Option 1: Clone the Repository from GitHub/GitLab
If your project is hosted on a Git platform:
1. Clone your repository directly on the Droplet:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd <repository-name>
   ```

#### Option 2: Copy the Project from Local to Droplet
If your project is only on your local machine:
1. Use `scp` to copy the project folder to the Droplet:
   ```bash
   scp -r /path/to/your/project root@<droplet-ip>:/path/on/droplet
   ```

2. SSH into the Droplet and navigate to the uploaded project directory:
   ```bash
   ssh root@<droplet-ip>
   cd /path/on/droplet/<project-folder>
   ```

---

### **4. Configure Environment Variables**

1. Ensure the `.env` file is present in the project directory. Example:
   ```env
   # Example .env
   OPENAI_API_KEY=sk-proj-
   SECRET_KEY=XXXXX
   ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=10
   POSTGRES_PASSWORD=password
   POSTGRES_USER=user
   POSTGRES_DB=mydb
   NEXT_PUBLIC_API_LINK=http://<your-droplet-ip>/api
   ```

2. Verify the `.env` file:
   ```bash
   cat .env
   ```

---

### **5. Build and Run the Application**

1. **Run Docker Compose**:
   Ensure you are in the project directory and run:
   ```bash
   docker-compose up --build -d
   ```

2. **Verify Running Containers**:
   Check that all services are running:
   ```bash
   docker ps
   ```

---

### **6. Test the Deployment**

1. Open your browser and go to:
   - Frontend: `http://<droplet-ip>/`
   - Backend API: `http://<droplet-ip>/api/health`

2. Test API endpoints using `curl`:
   ```bash
   curl -X GET http://<droplet-ip>/api/health
   ```

---

### **7. Automate Updates**

To make updating the application easier:
1. **Pull Updates from the Repository**:
   If the project is cloned from GitHub/GitLab:
   ```bash
   git pull origin main
   ```

2. **Rebuild and Restart Services**:
   After pulling changes, rebuild and restart the stack:
   ```bash
   docker-compose down
   docker-compose up --build -d
   ```

---

### **8. Enable Service on Boot**

To ensure the application starts automatically when the Droplet restarts:
1. Edit the `/etc/systemd/system/docker-compose-app.service` file:
   ```bash
   nano /etc/systemd/system/docker-compose-app.service
   ```

2. Add the following content:
   ```ini
   [Unit]
   Description=Docker Compose Application Service
   After=network.target

   [Service]
   Type=oneshot
   RemainAfterExit=true
   WorkingDirectory=/path/on/droplet/<project-folder>
   ExecStart=/usr/bin/docker-compose up -d
   ExecStop=/usr/bin/docker-compose down

   [Install]
   WantedBy=multi-user.target
   ```

3. Enable and start the service:
   ```bash
   systemctl enable docker-compose-app
   systemctl start docker-compose-app
   ```

---

### **9. Optional: Set Up a Domain and HTTPS**

If you have a domain:
1. Point your domain to the Droplet’s IP address in your DNS settings.
2. Install Certbot for SSL certificates:
   ```bash
   apt install certbot python3-certbot-nginx -y
   ```
3. Configure HTTPS with Certbot:
   ```bash
   certbot --nginx -d <your-domain>
   ```

---

### **10. Manage the Application**

#### a. View Logs
```bash
docker logs <container-name>
```

#### b. Stop the Application
```bash
docker-compose down
```

#### c. Restart the Application
```bash
docker-compose up -d
```