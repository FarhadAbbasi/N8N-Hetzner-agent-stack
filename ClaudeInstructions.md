










6. Access URLs
After deployment, your services will be available at:

N8N Webhook: http://proxpire.com:5678/webhook/legal-query
Qdrant Dashboard: http://proxpire.com:6333/dashboard
Ollama API: http://proxpire.com:11434
Ollama Internal(localhost): http://ollama:11434/

7. Update N8N Workflow URLs
In your N8N workflow, update the URLs to use your VPS IP:

Ollama Embedding: http://ollama:11434/api/embeddings
Qdrant Search: http://qdrant:6333/collections/legal_documents/points/search
Ollama Generate: http://ollama:11434/api/generate


# Pull the model: You can pull the nomic-embed-text model directly from Ollama’s system in your Ollama container.
docker exec -it agent-stack-ollama-1 bash   # Access Ollama Container
ollama pull nomic-embed-text    # Pull embedding model
ollama list                     # View installed models


#  Correct Qdrant API Endpoints:

Insert/Update Points: PUT /collections/{collection_name}/points
Search Points: POST /collections/{collection_name}/points/search
Delete Points: POST /collections/{collection_name}/points/delete
Get Points: POST /collections/{collection_name}/points


# Create the collection in Qdrant
curl -X PUT "http://your-vps-ip:6333/collections/legal_documents" \
  -H "Content-Type: application/json" \
  -d '{
    "vectors": {
      "size": 768,
      "distance": "Cosine"
    }
  }'

# Verify collection was created in Qdrant
curl "http://your-vps-ip:6333/collections/legal_documents"




#### >>--------------------------------  FILES ------------------------------------------------------>>




  # Claude's Docker-compose File. NOT used exactly but ONLY as reference. 

version: '3.8'

services:
  # N8N Workflow Automation
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=your_secure_password_here
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://your-vps-ip:5678
      - GENERIC_TIMEZONE=UTC
      - N8N_LOG_LEVEL=info
    volumes:
      - n8n_data:/home/node/.n8n
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - legal_ai_network
    depends_on:
      - qdrant
      - ollama

  # Qdrant Vector Database
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    restart: unless-stopped
    ports:
      - "6333:6333"
      - "6334:6334"
    volumes:
      - qdrant_storage:/qdrant/storage
    environment:
      - QDRANT__SERVICE__HTTP_PORT=6333
      - QDRANT__SERVICE__GRPC_PORT=6334
      - QDRANT__LOG_LEVEL=INFO
    networks:
      - legal_ai_network

  # Ollama LLM Server
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0
      - OLLAMA_ORIGINS=*
    networks:
      - legal_ai_network
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    # Remove the deploy section above if you don't have GPU support

  # Nginx Reverse Proxy (Optional - for SSL and domain routing)
  nginx:
    image: nginx:alpine
    container_name: nginx_proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    networks:
      - legal_ai_network
    depends_on:
      - n8n
      - qdrant
      - ollama

  # Redis (Optional - for N8N queue management)
  redis:
    image: redis:7-alpine
    container_name: redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - legal_ai_network

  # Tika Server for PDF/DOCX text extraction
  tika:
    image: apache/tika:latest
    container_name: tika_server
    restart: unless-stopped
    ports:
      - "9998:9998"
    networks:
      - legal_ai_network

  # PostgreSQL (Optional - for N8N database instead of SQLite)
  postgres:
    image: postgres:15-alpine
    container_name: postgres
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=n8n
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=your_db_password_here
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - legal_ai_network

networks:
  legal_ai_network:
    driver: bridge

volumes:
  n8n_data:
  qdrant_storage:
  ollama_data:
  redis_data:
  postgres_data:

---
# Additional Configuration Files

# Create nginx.conf file in the same directory:
# events {
#     worker_connections 1024;
# }
# 
# http {
#     upstream n8n {
#         server n8n:5678;
#     }
#     
#     upstream qdrant {
#         server qdrant:6333;
#     }
#     
#     upstream ollama {
#         server ollama:11434;
#     }
#     
#     server {
#         listen 80;
#         server_name your-domain.com;
#         
#         location /webhook/ {
#             proxy_pass http://n8n/webhook/;
#             proxy_set_header Host $host;
#             proxy_set_header X-Real-IP $remote_addr;
#             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#             proxy_set_header X-Forwarded-Proto $scheme;
#         }
#         
#         location /n8n/ {
#             proxy_pass http://n8n/;
#             proxy_set_header Host $host;
#             proxy_set_header X-Real-IP $remote_addr;
#             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#             proxy_set_header X-Forwarded-Proto $scheme;
#         }
#         
#         location /qdrant/ {
#             proxy_pass http://qdrant/;
#             proxy_set_header Host $host;
#             proxy_set_header X-Real-IP $remote_addr;
#         }
#         
#         location /ollama/ {
#             proxy_pass http://ollama/;
#             proxy_set_header Host $host;
#             proxy_set_header X-Real-IP $remote_addr;
#         }
#     }
# }