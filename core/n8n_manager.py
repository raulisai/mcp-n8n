import argparse
import requests
import json
import os
import sys
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class N8NManager:
    def __init__(self, api_key, base_url):
        self.api_key = api_key
        # Ensure base_url points to the API v1 endpoint
        if not base_url.endswith('/api/v1'):
            self.base_url = base_url.rstrip('/') + '/api/v1'
        else:
            self.base_url = base_url.rstrip('/')
            
        self.headers = {
            'X-N8N-API-KEY': self.api_key,
            'Content-Type': 'application/json'
        }

    def list_workflows(self):
        response = requests.get(f"{self.base_url}/workflows", headers=self.headers, timeout=10)
        response.raise_for_status()
        return response.json()['data']

    def get_workflow(self, workflow_id):
        response = requests.get(f"{self.base_url}/workflows/{workflow_id}", headers=self.headers, timeout=10)
        response.raise_for_status()
        return response.json()

    def _clean_workflow_data(self, data):
        """Strip read-only and restricted fields from workflow data."""
        allowed_fields = {'name', 'nodes', 'connections', 'settings', 'staticData', 'meta', 'tags'}
        clean_data = {k: v for k, v in data.items() if k in allowed_fields}
        if 'settings' not in clean_data:
            clean_data['settings'] = {}
        return clean_data

    def create_workflow(self, workflow_data):
        filtered_data = self._clean_workflow_data(workflow_data)
        response = requests.post(f"{self.base_url}/workflows", headers=self.headers, json=filtered_data, timeout=10)
        response.raise_for_status()
        return response.json()

    def update_workflow(self, workflow_id, workflow_data):
        filtered_data = self._clean_workflow_data(workflow_data)
        # Note: 'active' can be sent if specifically intended, but often causes issues if sent during structure updates
        if 'active' in workflow_data:
             filtered_data['active'] = workflow_data['active']
             
        response = requests.put(f"{self.base_url}/workflows/{workflow_id}", headers=self.headers, json=filtered_data, timeout=10)
        response.raise_for_status()
        return response.json()

    def delete_workflow(self, workflow_id):
        response = requests.delete(f"{self.base_url}/workflows/{workflow_id}", headers=self.headers, timeout=10)
        response.raise_for_status()
        return response.json()

    def activate_workflow(self, workflow_id):
        # To activate, we only send {"active": True}
        response = requests.put(f"{self.base_url}/workflows/{workflow_id}", headers=self.headers, json={"active": True}, timeout=10)
        response.raise_for_status()
        return response.json()

    def deactivate_workflow(self, workflow_id):
        workflow = self.get_workflow(workflow_id)
        workflow['active'] = False
        return self.update_workflow(workflow_id, workflow)

    def execute_workflow(self, workflow_id, data=None):
        # Note: Executing via API often requires specific permissions or a webhook.
        # This implementation uses the webhook approach if a URL is provided, 
        # but here we follow the standard API if available.
        # Many n8n instances use /workflows/{id}/execute for internal calls.
        url = f"{self.base_url}/workflows/{workflow_id}/execute"
        response = requests.post(url, headers=self.headers, json=data or {}, timeout=30)
        response.raise_for_status()
        return response.json()

def main():
    parser = argparse.ArgumentParser(description="n8n Workflow Manager CLI")
    parser.add_argument('--api-key', help='n8n API Key (or set N8N_API_KEY env var)')
    parser.add_argument('--url', help='n8n Base URL (e.g., http://localhost:5678)')
    
    subparsers = parser.add_subparsers(dest='command', help='Commands')

    # List
    subparsers.add_parser('list', help='List all workflows')

    # Get
    get_parser = subparsers.add_parser('get', help='Get workflow details')
    get_parser.add_argument('id', help='Workflow ID')

    # Create
    create_parser = subparsers.add_parser('create', help='Create a workflow')
    create_parser.add_argument('file', help='JSON file containing workflow data')

    # Update
    update_parser = subparsers.add_parser('update', help='Update a workflow')
    update_parser.add_argument('id', help='Workflow ID')
    update_parser.add_argument('file', help='JSON file containing updated workflow data')

    # Activate/Deactivate
    act_parser = subparsers.add_parser('activate', help='Activate a workflow')
    act_parser.add_argument('id', help='Workflow ID')
    deact_parser = subparsers.add_parser('deactivate', help='Deactivate a workflow')
    deact_parser.add_argument('id', help='Workflow ID')

    # Run
    run_parser = subparsers.add_parser('run', help='Execute a workflow')
    run_parser.add_argument('id', help='Workflow ID')
    run_parser.add_argument('--data', help='JSON data to send as input', default='{}')

    # Config
    config_parser = subparsers.add_parser('config', help='Configure API key and URL')
    config_parser.add_argument('--api-key', help='n8n API Key')
    config_parser.add_argument('--url', help='n8n Base URL')

    args = parser.parse_args()

    api_key = args.api_key or os.environ.get('N8N_API_KEY')
    url = args.url or os.environ.get('N8N_URL') or 'http://localhost:5678'

    if not api_key:
        print("Error: N8N_API_KEY is required. Set it via --api-key or N8N_API_KEY environment variable.")
        sys.exit(1)
    
    manager = N8NManager(api_key, url)

    try:
        if args.command == 'list':
            result = manager.list_workflows()
            # Simplified output for listing
            print(f"{'ID':<10} | {'Active':<7} | {'Name'}")
            print("-" * 50)
            for wf in result:
                print(f"{wf.get('id', 'N/A'):<10} | {str(wf.get('active', False)):<7} | {wf.get('name', 'Untitled')}")
        elif args.command == 'get':
            result = manager.get_workflow(args.id)
            print(json.dumps(result, indent=2))
        elif args.command == 'create':
            with open(args.file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            result = manager.create_workflow(data)
            print(f"Created workflow with ID: {result.get('id')}")
        elif args.command == 'update':
            with open(args.file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            result = manager.update_workflow(args.id, data)
            print(f"Updated workflow {args.id}")
        elif args.command == 'activate':
            result = manager.activate_workflow(args.id)
            print(f"Activated workflow {args.id}")
        elif args.command == 'deactivate':
            result = manager.deactivate_workflow(args.id)
            print(f"Deactivated workflow {args.id}")
        elif args.command == 'run':
            data = json.loads(args.data)
            result = manager.execute_workflow(args.id, data)
            print(json.dumps(result, indent=2))
        elif args.command == 'config':
            new_api_key = args.api_key or api_key
            new_url = args.url or url
            with open('.env', 'w', encoding='utf-8') as f:
                f.write(f"N8N_API_KEY={new_api_key}\n")
                f.write(f"N8N_URL={new_url}\n")
            print(f"Configuration saved to .env")
            print(f"URL: {new_url}")
            print(f"API Key: {'*' * 10}{new_api_key[-4:] if new_api_key else ''}")
        else:
            parser.print_help()
    except requests.exceptions.HTTPError as e:
        print(f"HTTP Error: {e}")
        if e.response is not None:
            print(f"Response: {e.response.text}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
