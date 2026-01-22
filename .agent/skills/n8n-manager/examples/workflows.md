# n8n Workflow Examples

These workflows are ready to be imported into n8n. Copy the JSON and use "Import from JSON" in your workflow editor.

---

## 1. Personal AI Assistant (Jackie)
**Description:** Telegram-based assistant with access to Gmail, Google Calendar, and Google Tasks.
**Features:** Text & Voice support, conversational memory, email/calendar management.

```json
{
  "name": "Personal AI Assistant - Jackie",
  "nodes": [
    {
      "parameters": {
        "updates": ["message"],
        "additionalFields": {}
      },
      "id": "telegram-trigger",
      "name": "Telegram Trigger",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.1,
      "position": [880, 480]
    },
    // ... (rest of the JSON from WORKFLOWS.md)
  ]
}
```
*(Refer to full JSON in WORKFLOWS.md if needed during execution)*

## 2. Google Sheets Data Analyst
**Description:** Web-chat assistant that analyzes data in Google Sheets.
**Features:** Natural language queries, total/average calculations, trend identification.

```json
{
  "name": "Google Sheets Data Analyst",
  "nodes": [
    {
      "parameters": {
        "options": {}
      },
      "id": "chat-trigger",
      "name": "Chat Trigger",
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "typeVersion": 1.4,
      "position": [1152, 672]
    }
    // ...
  ]
}
```

## 3. Daily Quote Email
**Description:** Sends an inspirational quote daily at 7 AM.
**Nodes:** Schedule -> HTTP Request -> Set -> Gmail.

## 4. Multi-Destination Event Router
**Description:** Routes incoming webhooks to Slack, Email, or Database based on severity levels.
**Nodes:** Webhook -> Switch -> Slack/Gmail/PostgreSQL.
