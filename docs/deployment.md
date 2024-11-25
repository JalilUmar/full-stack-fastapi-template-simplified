## Deployment Instructions

This document provides step-by-step instructions for deploying your application using Docker and Docker Compose. The setup includes a **PostgreSQL database**, a **FastAPI backend**, a **Next.js frontend**, and an **Nginx reverse proxy**.

---

### **1. Prerequisites**

Ensure the following are installed on your deployment server:
- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/)

---

### **2. Environment Variables**

Create a `.env` file in the root directory of your project. Use the following template:

```env
# OpenAI API Key
OPENAI_API_KEY=sk-proj-

# JWT Configuration
SECRET_KEY=XXXXX
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=10

# PostgreSQL Configuration
POSTGRES_PASSWORD=password
POSTGRES_USER=user
POSTGRES_DB=mydb
PG_DB_URL=postgresql://user:password@db:5432/mydb

# Domain Configuration
NEXT_PUBLIC_API_LINK=http://<your-domain-or-ip>/api
```

- Replace placeholders (`XXXXX`, `<your-domain-or-ip>`, etc.) with actual values.
- `NEXT_PUBLIC_API_LINK` should point to the public endpoint for your backend API, e.g., `http://your-domain.com/api`.

---

### **3. File Structure**

Ensure the following file structure:
```
/project-root
│
├── backend/
│   ├── Dockerfile
│   ├── app/  # Backend application code
│   ├── requirements.txt
│   └── ...
│
├── frontend/
│   ├── Dockerfile
│   ├── next.config.js
│   ├── pages/
│   └── ...
│
├── proxy.conf
├── docker-compose.yml
├── .env
└── ...
```

---

### **4. Docker Compose Services**

The `docker-compose.yml` file defines the following services:

- **`db`**: PostgreSQL database
- **`adminer`**: A web-based database management tool (optional for debugging)
- **`backend`**: FastAPI backend
- **`frontend`**: Next.js frontend
- **`proxy`**: Nginx reverse proxy for routing requests

Refer to the full `docker-compose.yml` included above.

---

### **5. Build and Run the Application**

1. **Build and Start Services**
   Run the following command in the root directory of your project:
   ```bash
   docker-compose up --build -d
   ```

   This will:
   - Build the backend and frontend images.
   - Start all services in detached mode.

2. **Check Running Containers**
   Verify that all services are running:
   ```bash
   docker ps
   ```

3. **Access the Application**
   - **Frontend**: Open your browser and go to `http://<your-domain-or-ip>/`.
   - **API**: The backend API is accessible at `http://<your-domain-or-ip>/api`.
   - **Database (Adminer)**: Access the database UI at `http://<your-domain-or-ip>:8080`.

---

### **6. Nginx Reverse Proxy**

The `proxy` service uses Nginx to route requests:
- `/api` → Backend (`http://backend:8000`)
- `/` → Frontend (`http://frontend:3000`)

#### `proxy.conf`:
```nginx
server {
    listen 80;
    server_name _;

    location /api/ {
        proxy_pass http://backend:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location / {
        proxy_pass http://frontend:3000;
    }
}
```

---

### **7. Debugging**

#### Check Logs
To view logs for a specific service:
```bash
docker logs <service-name>
```

Examples:
```bash
docker logs backend
docker logs frontend
docker logs web-proxy
```

#### Test Connectivity
- Test backend API:
  ```bash
  curl -X GET http://<your-domain-or-ip>/api/health
  ```
- Test frontend:
  Open `http://<your-domain-or-ip>/` in a browser.

---

### **8. Stopping Services**
To stop all running services:
```bash
docker-compose down
```

This will stop and remove all containers, networks, and volumes created by `docker-compose`.

---

### **9. Optional: Persistent Data**

The PostgreSQL database stores data in a Docker volume named `app-db-data`. This volume is persistent even after stopping or removing containers.

- To remove the volume (and all data):
  ```bash
  docker volume rm app-db-data
  ```

---

### **10. Updating the Application**

1. Pull the latest changes:
   ```bash
   git pull origin main
   ```

2. Rebuild and restart services:
   ```bash
   docker-compose up --build -d
   ```

---

### **11. Notes**

- Ensure the `.env` file is updated with production-ready secrets and configurations before deployment.
- For enhanced security, use HTTPS with a valid SSL certificate.

Follow [this](digital-ocean.md) guide to deploy project to DigitalOcean