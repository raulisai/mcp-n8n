# n8n MCP Integration Walkthrough

This guide provides the steps to set up a complete end-to-end integration between **Google Antigravity** and your **n8n** instance using the Model Context Protocol (MCP).

## Prerequisites
- An active n8n instance (v1.60+ recommended for best MCP support).
- An n8n API Key.
- Antigravity installed and configured.

---

## 🚀 Step 1: Import the n8n MCP Server Workflow

1. Open your n8n instance.
2. Create a new workflow.
3. Import the `n8n_mcp_server_workflow.json` file provided in the `n8n_integration` folder.
4. **Configuration**:
   - Double-click the **MCP Server Trigger** node.
   - The **Production URL** is: `https://n8n.neobyte.space/mcp-server/http`
   - Authentication is set to **Bearer Auth** with the provided token.
5. **Credentials**:
   - Ensure the workflow nodes use the **n8n API** credential with key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
6. **Activate** the workflow.

---

## 🛠 Step 2: Configure Antigravity

Your configuration is already applied to `~/.gemini/antigravity/mcp_config.json`:

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "supergateway",
        "--streamableHttp",
        "https://n8n.neobyte.space/mcp-server/http",
        "--header",
        "authorization:Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlMDk3ZmVjOC1hOTI2LTQ0YjEtYWVjNi1lNDA5Y2U3MTAwMjIiLCJpc3MiOiJuOG4iLCJhdWQiOiJtY3Atc2VydmVyLWFwaSIsImp0aSI6ImQxODQ3YjIzLTJmY2YtNGUxMi1iMWViLWEyMGFlMmMyZjAwMSIsImlhdCI6MTc2ODg1MzEyM30.2JU7QfwVEoeQ_nGPcHW-iH7pe2pGxOy0z8uxlkYidgE"
      ]
    }
  }
}
```

---

## 🐍 Step 3: Use the n8n Manager CLI

### Setup
The CLI manager is located in the root folder via the global `n8n` command.

1. **Configure environment** (Automated):
   ```bash
   # Windows:
   deploy.bat

   # Linux / macOS:
   chmod +x deploy.sh && ./deploy.sh
   ```

2. **Add to PATH** (for global access):
   - **Windows**: The `setup.bat` (called by `deploy.bat`) attempts to do this automatically. Restart CMD to see changes.
   - **Linux/macOS**: Add `export PATH="$PATH:$(pwd)"` to your `~/.bashrc` or `~/.zshrc`.

3. **Edit Credentials**:
   Open the `.env` file in the root directory and add your `N8N_API_KEY` and `N8N_URL`.

### Examples
Once configured, you can run from anywhere:

- **List workflows**:
  ```bash
  n8n list
  ```
- **Activate a workflow**:
  ```bash
  n8n activate <workflow_id>
  ```
- **Run a workflow**:
  ```bash
  n8n run <workflow_id> --data '{"key": "value"}'
  ```
  
See **[README.md](README.md)** for complete installation and usage instructions.

---

## 🤖 Step 4: Example Prompts for Antigravity

Once the integration is active, you can ask Antigravity to perform complex n8n tasks:

- *"List my n8n workflows and tell me which ones are inactive."*
- *"Get the definition of workflow 'Ab12Cd34' and audit it for security best practices."*
- *"Generate a new n8n workflow that triggers on a webhook and sends a Slack message, then create it in my n8n instance."*
- *"Auto-document all inactive workflows in my n8n instance."*

---

## 🔍 Validation Checklist
- [ ] **Workflow Active**: The MCP Server Trigger workflow is on and "Active" in n8n.
- [ ] **URL Reachable**: You can reach the `/mcp/antigravity-mcp` URL from your local machine.
- [ ] **MCP Tools Loaded**: When starting Antigravity, check logs/tools to see if `list_workflows`, `get_workflow`, etc. are available.
- [ ] **CLI Auth**: `python n8n_manager.py list` returns your workflow list without errors.

---

## ⚠️ Known Issues & Tips
- **SSE Buffering**: If using Nginx, ensure `proxy_buffering off;` is set for the n8n path.
- **Queue Mode**: If n8n is in queue mode, route MCP traffic to a single instance.
- **Node Versions**: The JSON uses `httpRequest` v4 and `code` v2. If your n8n version is older, you might need to manually update these nodes.
