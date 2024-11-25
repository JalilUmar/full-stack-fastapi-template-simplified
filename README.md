# Template AI-Powered Document Manager 

Welcome to **Template AI-Powered Document Manager**, an advanced solution to streamline document management processes using AI. This guide provides detailed instructions to run the project locally, with or without Docker, and deploy it to production environments like DigitalOcean.

---

## **How to Run This Project Locally with Docker**

### Step 1:
```bash
Ensure Docker is installed and the Docker daemon is running on your computer.
```

### Step 2:
```bash
Open a terminal in the project's root folder.
```

### Step 3:
```bash
Run `docker compose up --build`.
```

### Step 4:
```bash
Access the application:
- Frontend: `http://localhost/`
- Backend API: `http://localhost/health`
```

---

## **How to Run This Project Locally Without Docker**

### Step 1: Run the Backend
1. Navigate to the backend directory:
   ```bash
   cd ./backend
   ```
2. Activate the virtual environment:
   ```bash
   poetry shell
   ```
3. Install dependencies:
   ```bash
   poetry install
   ```
4. Run the FastAPI server:
   ```bash
   uvicorn src.main:app --reload
   ```

### Step 2: Run the Frontend
1. Open a new terminal and navigate to the frontend directory:
   ```bash
   cd ./frontend
   ```
2. Install dependencies:
   ```bash
   pnpm i
   ```
3. Start the development server:
   ```bash
   pnpm run dev
   ```

### Step 3:
```bash
Access the application:
- Frontend: `http://localhost:3000/`
- Backend API: `http://localhost:8000/api/health`
```

---

## **How to Deploy This Project**

### Deployment Guides:
1. **Deploying Locally or to Production**:
   - Use the [Deployment Guide](docs/deployment.md) for detailed instructions on deploying the application, including Docker Compose configurations, environment variables, and more.

2. **Deploying to DigitalOcean**:
   - Refer to the [DigitalOcean Deployment Guide](docs/digital-ocean.md) for step-by-step instructions to set up a Droplet and deploy your application using Docker.

---

## **Environment Variables**

Ensure the following environment variables are configured in a `.env` file in the root directory:

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
NEXT_PUBLIC_API_LINK=http://localhost/api
```

---

## **Key Features**

- **Frontend**:
  Built using **Next.js** for a modern, fast, and scalable user interface.

- **Backend**:
  Developed with **FastAPI**, leveraging Python for high-performance API services.

- **Database**:
  Powered by **PostgreSQL** for reliable and scalable data storage.

- **Containerization**:
  Dockerized architecture for seamless deployment and scalability.

---

## **Useful Resources**

- [Deployment Guide](./deployment.md)
- [DigitalOcean Deployment Guide](./digital-ocean.md)
- Additional tips for setting up local web servers:
  [How to Deploy a Website on DigitalOcean Droplet](https://anirudhdaya.hashnode.dev/how-to-deploy-a-website-on-digitalocean-droplet)

---

## **Support**

If you encounter any issues or need assistance, please feel free to open an issue in the repository or contact the maintainer.

