up:
	docker-compose up --build

up-backend:
	docker-compose up --build backend

up-frontend:
	docker-compose up --build frontend

# Stop all containers
down:
	docker-compose down

# Remove all containers, volumes, and images
clean:
	docker-compose down -v --rmi all


#DIGITAL_OCEAN

# Variables
DROPLET_NAME=my-droplet
REGION=nyc3
IMAGE=docker-20-04
SIZE=s-1vcpu-1gb
SSH_KEY=<your-ssh-key-id>  # Replace with your DigitalOcean SSH Key ID
PROJECT_DIR=daniel-ai-manager  # Local directory for the project
DROPLET_IP=$(shell doctl compute droplet list --format PublicIPv4 --no-header | head -n 1)  # Fetch Droplet IP
DOCKER_IMAGE=myusername/myapp:latest  # Replace with your Docker image name

# Create a DigitalOcean Droplet
create-droplet:
	@echo "Creating a DigitalOcean Droplet..."
	doctl compute droplet create $(DROPLET_NAME) \
		--region $(REGION) \
		--size $(SIZE) \
		--image $(IMAGE) \
		--ssh-keys $(SSH_KEY) \
		--wait
	@echo "Droplet created successfully. IP: $(DROPLET_IP)"

# Update Droplet and Install Prerequisites
setup-droplet:
	@echo "Setting up the Droplet..."
	ssh root@$(DROPLET_IP) "apt update && apt upgrade -y && apt install -y docker.io docker-compose git"

# Upload Project to Droplet
upload-project:
	@echo "Uploading project files to the Droplet..."
	scp -r ./$(PROJECT_DIR) root@$(DROPLET_IP):/root/

# Deploy the Project Using Docker Compose
deploy-project:
	@echo "Deploying the project on the Droplet..."
	ssh root@$(DROPLET_IP) "cd /root/$(PROJECT_DIR) && docker-compose up --build -d"

# View Deployed Services
check-services:
	@echo "Checking running services on the Droplet..."
	ssh root@$(DROPLET_IP) "docker ps"

# Clean Up the Droplet (Optional)
destroy-droplet:
	@echo "Destroying the DigitalOcean Droplet..."
	doctl compute droplet delete $(DROPLET_NAME) --force
	@echo "Droplet destroyed successfully."

# Full Deployment Workflow
deploy: create-droplet setup-droplet upload-project deploy-project check-services
