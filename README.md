6. Access URLs
After deployment, your services will be available at:

N8N Interface: http://your-vps-ip:5678
N8N Webhook: http://your-vps-ip:5678/webhook/legal-query
Qdrant Dashboard: http://your-vps-ip:6333/dashboard
Ollama API: http://your-vps-ip:11434

7. Update N8N Workflow URLs
In your N8N workflow, update the URLs to use your VPS IP:

Ollama Embedding: http://your-vps-ip:11434/api/embeddings
Qdrant Search: http://your-vps-ip:6333/collections/legal_documents/points/search
Ollama Generate: http://your-vps-ip:11434/api/generate