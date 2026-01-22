# n8n Cheat Sheet

## JavaScript Snippets (Code Node)

### 1. Filtering Items
```javascript
const items = $input.all();
return items.filter(item => item.json.amount > 100);
```

### 2. Aggregating Data
```javascript
const items = $input.all();
const total = items.reduce((sum, item) => sum + item.json.amount, 0);
return [{ json: { total, count: items.length } }];
```

### 3. Flattening Arrays
```javascript
const items = $input.all();
return items.flatMap(item => 
  item.json.orders.map(order => ({
    json: { userId: item.json.id, ...order }
  }))
);
```

### 4. Accessing Static Data (Persistence)
```javascript
const staticData = getWorkflowStaticData('global');
staticData.counter = (staticData.counter || 0) + 1;
return [{ json: { count: staticData.counter } }];
```

## Expression Patterns

### 1. Basic Mapping
- `={{ $json.fieldName }}`: Access field from current item.
- `={{ $('Node Name').item.json.field }}`: Access field from another node.

### 2. Date/Time
- `={{ $now.toISO() }}`: Current timestamp.
- `={{ $today.format('yyyy-MM-dd') }}`: Current date.
- `={{ $json.date.plus({days: 7}) }}`: Date arithmetic.

### 3. String Manipulation
- `={{ $json.name.toLowerCase() }}`: Lowercase.
- `={{ $json.text.split(',').map(i => i.trim()) }}`: Split and trim.

## AI Agent Pattern ($fromAI)
Use this in tool parameters so the agent can control them:
`={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('ParamName', 'Description', 'string') }}`

---
name: n8n-workflow-builder
description: Build production-ready n8n automation workflows with AI agents, data transformations, integrations, and best practices. Use when creating n8n workflows, configuring nodes, writing JavaScript for transformations, building AI agents with tools and memory, or troubleshooting n8n automations.
license: MIT
metadata:
  author: n8n-automation-expert
  version: "2.0"
  n8n_version: "2.3.6+"
---

# n8n Workflow Builder - Complete Agent Skill

Build professional n8n workflows using native nodes, AI agents, and proven patterns.

### 1. TRIGGERS - Starting Workflows

#### Webhook Trigger (API Endpoints)
```json
{
  "parameters": {
    "httpMethod": "POST",
    "path": "my-endpoint",
    "authentication": "headerAuth",
    "responseMode": "lastNode",
    "options": {}
  },
  "name": "Webhook",
  "type": "n8n-nodes-base.webhook",
  "typeVersion": 2,
  "credentials": {
    "httpHeaderAuth": {
      "id": "credential-id",
      "name": "API Key Auth"
    }
  }
}
```

**When to use:** REST API endpoints, external integrations, form submissions
**Authentication options:** None, Basic Auth, Header Auth, JWT
**Response modes:** onReceived (immediate), lastNode (wait for completion), responseNode (custom)

#### Schedule Trigger (Cron Jobs)
```json
{
  "parameters": {
    "rule": {
      "interval": [
        {
          "triggerAtHour": 9,
          "triggerAtMinute": 0,
          "weekdaysType": "weekdays"
        }
      ]
    }
  },
  "name": "Schedule Trigger",
  "type": "n8n-nodes-base.scheduleTrigger",
  "typeVersion": 1.2
}
```

**Cron syntax:**
```
0 9 * * 1    = Every Monday at 9:00 AM
0 */6 * * *  = Every 6 hours
0 0 1 * *    = First day of every month
```

**CRITICAL:** Workflow MUST be published (active) for schedules to work

#### Chat Trigger (AI Chatbots)
```json
{
  "parameters": {
    "options": {}
  },
  "name": "When chat message received",
  "type": "@n8n/n8n-nodes-langchain.chatTrigger",
  "typeVersion": 1.4,
  "webhookId": "auto-generated-id"
}
```

**Use for:** Web chat interfaces, testing AI agents
**Connects to:** AI Agent nodes

#### Telegram Trigger (Bot Messages)
```json
{
  "parameters": {
    "updates": ["message"]
  },
  "name": "Telegram Trigger",
  "type": "n8n-nodes-base.telegramTrigger",
  "typeVersion": 1.1,
  "credentials": {
    "telegramApi": {
      "id": "credential-id",
      "name": "Telegram Bot"
    }
  }
}
```

**Message types:** message, edited_message, channel_post, callback_query
**Access chat ID:** `{{ $json.message.chat.id }}`
**Access user ID:** `{{ $json.message.from.id }}`

---

### 2. DATA TRANSFORMATION - Processing Data

#### Edit Fields (Set) - Simple Mapping
```json
{
  "parameters": {
    "mode": "manual",
    "duplicateItem": false,
    "assignments": {
      "assignments": [
        {
          "id": "field-1",
          "name": "fullName",
          "value": "={{ $json.firstName }} {{ $json.lastName }}",
          "type": "string"
        },
        {
          "id": "field-2",
          "name": "email",
          "value": "={{ $json.email.toLowerCase() }}",
          "type": "string"
        },
        {
          "id": "field-3",
          "name": "total",
          "value": "={{ $json.amount * 1.16 }}",
          "type": "number"
        },
        {
          "id": "field-4",
          "name": "timestamp",
          "value": "={{ $now.toISO() }}",
          "type": "string"
        }
      ]
    },
    "options": {}
  },
  "name": "Transform Data",
  "type": "n8n-nodes-base.set",
  "typeVersion": 3.4
}
```

**When to use Edit Fields:**
- Renaming fields
- Simple calculations
- String concatenation
- Date formatting
- Creating nested objects with dot notation (`user.name`)

**JSON Output Mode (for complex objects):**
```json
{
  "parameters": {
    "mode": "raw",
    "jsonOutput": "={\n  \"customer\": {\n    \"name\": \"{{ $json.firstName }} {{ $json.lastName }}\",\n    \"email\": \"{{ $json.email }}\"\n  },\n  \"order\": {\n    \"total\": {{ $json.amount }},\n    \"tax\": {{ $json.amount * 0.16 }}\n  },\n  \"meta\": {\n    \"processedAt\": \"{{ $now.toISO() }}\"\n  }\n}"
  }
}
```

#### Code Node - Advanced Transformations
```json
{
  "parameters": {
    "mode": "runOnceForAllItems",
    "jsCode": "// Process all items\nconst items = $input.all();\n\nreturn items\n  .filter(item => item.json.amount > 100)\n  .map(item => ({\n    json: {\n      ...item.json,\n      total: item.json.amount * 1.16,\n      processedAt: new Date().toISOString()\n    }\n  }));"
  },
  "name": "Code",
  "type": "n8n-nodes-base.code",
  "typeVersion": 2
}
```

**Mode options:**
- `runOnceForAllItems`: Process all items together (use for filtering, aggregating)
- `runOnceForEachItem`: Process each item individually

**Common Patterns:**

**Filter items:**
```javascript
const items = $input.all();
return items.filter(item => 
  item.json.status === 'active' && 
  item.json.amount > 100
);
```

**Aggregate/Sum:**
```javascript
const items = $input.all();
const total = items.reduce((sum, item) => sum + item.json.amount, 0);

return [{
  json: {
    totalAmount: total,
    itemCount: items.length,
    average: total / items.length
  }
}];
```

**Flatten nested arrays:**
```javascript
const items = $input.all();
return items.flatMap(item => 
  item.json.orders.map(order => ({
    json: {
      userId: item.json.id,
      userName: item.json.name,
      orderId: order.id,
      orderTotal: order.total
    }
  }))
);
```

**Access multiple nodes:**
```javascript
const webhookData = $('Webhook').first().json;
const apiData = $('HTTP Request').all();

return [{
  json: {
    requestId: webhookData.id,
    results: apiData.map(i => i.json),
    processedAt: $now.toISO()
  }
}];
```

**Error handling:**
```javascript
const items = $input.all();
const results = [];

for (const item of items) {
  try {
    // Validate
    if (!item.json.email || !item.json.name) {
      throw new Error('Missing required fields');
    }
    
    results.push({
      json: {
        ...item.json,
        status: 'valid',
        validatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    results.push({
      json: {
        ...item.json,
        status: 'error',
        error: error.message
      }
    });
  }
}

return results;
```

**Persistent data across executions:**
```javascript
const staticData = getWorkflowStaticData('global');

if (!staticData.counter) {
  staticData.counter = 0;
}

staticData.counter += 1;
staticData.lastRun = new Date().toISOString();

return [{
  json: {
    executionNumber: staticData.counter,
    lastRun: staticData.lastRun
  }
}];
```

---

### 3. CONTROL FLOW - Logic & Routing

#### IF Node - Binary Decisions
```json
{
  "parameters": {
    "conditions": {
      "options": {
        "caseSensitive": true,
        "typeValidation": "strict"
      },
      "conditions": [
        {
          "id": "condition-1",
          "leftValue": "={{ $json.amount }}",
          "rightValue": 100,
          "operator": {
            "type": "number",
            "operation": "gt"
          }
        }
      ],
      "combinator": "and"
    }
  },
  "name": "Check Amount",
  "type": "n8n-nodes-base.if",
  "typeVersion": 2
}
```

**Operators by type:**
- **Number:** equals, notEquals, gt, gte, lt, lte
- **String:** equals, notEquals, contains, notContains, startsWith, endsWith, regex
- **Boolean:** true, false
- **DateTime:** after, before

**Multiple conditions (AND):**
```json
{
  "conditions": [
    {"leftValue": "={{ $json.status }}", "rightValue": "active", "operator": {"type": "string", "operation": "equals"}},
    {"leftValue": "={{ $json.amount }}", "rightValue": 100, "operator": {"type": "number", "operation": "gte"}},
    {"leftValue": "={{ $json.verified }}", "rightValue": true, "operator": {"type": "boolean", "operation": "true"}}
  ],
  "combinator": "and"
}
```

**Multiple conditions (OR):**
```json
{
  "conditions": [
    {"leftValue": "={{ $json.priority }}", "rightValue": "high", "operator": {"type": "string", "operation": "equals"}},
    {"leftValue": "={{ $json.amount }}", "rightValue": 1000, "operator": {"type": "number", "operation": "gt"}},
    {"leftValue": "={{ $json.isVip }}", "rightValue": true, "operator": {"type": "boolean", "operation": "true"}}
  ],
  "combinator": "or"
}
```

#### Switch Node - Multiple Routes
```json
{
  "parameters": {
    "mode": "rules",
    "rules": {
      "rules": [
        {
          "outputKey": "low",
          "renameOutput": true,
          "conditions": {
            "conditions": [
              {
                "leftValue": "={{ $json.amount }}",
                "rightValue": 100,
                "operator": {"type": "number", "operation": "lt"}
              }
            ]
          }
        },
        {
          "outputKey": "medium",
          "renameOutput": true,
          "conditions": {
            "conditions": [
              {
                "leftValue": "={{ $json.amount }}",
                "rightValue": 100,
                "operator": {"type": "number", "operation": "gte"}
              },
              {
                "leftValue": "={{ $json.amount }}",
                "rightValue": 1000,
                "operator": {"type": "number", "operation": "lt"}
              }
            ]
          }
        },
        {
          "outputKey": "high",
          "renameOutput": true,
          "conditions": {
            "conditions": [
              {
                "leftValue": "={{ $json.amount }}",
                "rightValue": 1000,
                "operator": {"type": "number", "operation": "gte"}
              }
            ]
          }
        }
      ]
    },
    "options": {
      "fallbackOutput": 3
    }
  },
  "name": "Route by Amount",
  "type": "n8n-nodes-base.switch",
  "typeVersion": 3
}
```

**Expression Mode (simpler for lookups):**
```json
{
  "parameters": {
    "mode": "expression",
    "output": "={{ {\"low\": 0, \"medium\": 1, \"high\": 2}[$json.priority] ?? 3 }}"
  }
}
```

#### Loop Over Items - Batching with Rate Limiting
```json
{
  "parameters": {
    "batchSize": 5,
    "options": {}
  },
  "name": "Loop Over Items",
  "type": "n8n-nodes-base.splitInBatches",
  "typeVersion": 3
}
```

**Use with Wait node for rate limiting:**
```
[Get Items] → [Loop] → [Wait 2s] → [HTTP Request] → [Loop]
```

**Access loop context:**
```javascript
const currentBatch = $node["Loop Over Items"].context["currentRunIndex"];
const isLastBatch = $node["Loop Over Items"].context["noItemsLeft"];
```

#### Merge Node - Combine Data Streams
```json
{
  "parameters": {
    "mode": "combine",
    "combinationMode": "matchingFields",
    "matchingFields": [
      {
        "field1": "id",
        "field2": "userId"
      }
    ],
    "options": {
      "includeUnpaired": false
    }
  },
  "name": "Join by User ID",
  "type": "n8n-nodes-base.merge",
  "typeVersion": 3
}
```

**Modes:**
- **append:** Concatenate all items from both inputs
- **combine:** SQL-style joins
  - matchingFields: JOIN ON field1 = field2
  - byPosition: Merge item[0] with item[0], etc.
  - multiplex: Cartesian product (all combinations)

---

### 4. AI AGENTS - Building Intelligent Assistants

#### Complete AI Agent Structure

**Minimal agent (Chat Model + Tool):**
```json
{
  "nodes": [
    {
      "parameters": {
        "options": {}
      },
      "name": "Chat Trigger",
      "type": "@n8n/n8n-nodes-langchain.chatTrigger",
      "typeVersion": 1.4
    },
    {
      "parameters": {
        "promptType": "define",
        "text": "={{ $json.input }}",
        "options": {
          "systemMessage": "You are a helpful assistant."
        }
      },
      "name": "AI Agent",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "typeVersion": 3.1
    },
    {
      "parameters": {
        "model": "claude-3-5-sonnet-20241022",
        "options": {}
      },
      "name": "Claude Model",
      "type": "@n8n/n8n-nodes-langchain.lmChatAnthropic",
      "typeVersion": 1.8
    }
  ],
  "connections": {
    "Chat Trigger": {
      "main": [[{"node": "AI Agent", "type": "main", "index": 0}]]
    },
    "Claude Model": {
      "ai_languageModel": [[{"node": "AI Agent", "type": "ai_languageModel", "index": 0}]]
    }
  }
}
```

#### AI Agent with Memory
```json
{
  "nodes": [
    {
      "parameters": {
        "sessionKey": "={{ $json.userId }}",
        "contextWindowLength": 10
      },
      "name": "Simple Memory",
      "type": "@n8n/n8n-nodes-langchain.memoryBufferWindow",
      "typeVersion": 1.3
    }
  ],
  "connections": {
    "Simple Memory": {
      "ai_memory": [[{"node": "AI Agent", "type": "ai_memory", "index": 0}]]
    }
  }
}
```

**Memory types:**
- **Simple Memory:** In-RAM, lost on restart, use `sessionKey` for per-user memory
- **Postgres Chat Memory:** Persistent, production-ready
- **Redis Chat Memory:** Persistent, high-performance

**Session Key patterns:**
```javascript
// Per user
"={{ $json.userId }}"
// Per Telegram user
"={{ $('Telegram Trigger').first().json.message.from.id }}"
// Per conversation
"={{ $json.conversationId }}"
```

#### AI Tools - Giving Agents Capabilities

**Google Sheets Tool:**
```json
{
  "parameters": {
    "documentId": {
      "__rl": true,
      "mode": "list",
      "value": "spreadsheet-id"
    },
    "sheetName": {
      "__rl": true,
      "mode": "list",
      "value": "Sheet1"
    },
    "options": {}
  },
  "name": "Analyze Data",
  "type": "n8n-nodes-base.googleSheetsTool",
  "typeVersion": 4.7
}
```

**Gmail Tool (Read):**
```json
{
  "parameters": {
    "operation": "getAll",
    "limit": 20,
    "filters": {
      "labelIds": ["INBOX"],
      "readStatus": "unread",
      "receivedAfter": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Received_After', ``, 'string') }}",
      "receivedBefore": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Received_Before', ``, 'string') }}"
    }
  },
  "name": "Get Email",
  "type": "n8n-nodes-base.gmailTool",
  "typeVersion": 2.1
}
```

**Gmail Tool (Send):**
```json
{
  "parameters": {
    "sendTo": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('To', ``, 'string') }}",
    "subject": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Subject', ``, 'string') }}",
    "message": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Message', ``, 'string') }}",
    "options": {
      "appendAttribution": false
    }
  },
  "name": "Send Email",
  "type": "n8n-nodes-base.gmailTool",
  "typeVersion": 2.1
}
```

**Google Calendar Tool:**
```json
{
  "parameters": {
    "operation": "getAll",
    "calendar": {
      "__rl": true,
      "mode": "id",
      "value": "user-email@gmail.com"
    },
    "options": {
      "timeMin": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('After', ``, 'string') }}",
      "timeMax": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Before', ``, 'string') }}",
      "fields": "items(summary, start(dateTime))"
    }
  },
  "name": "Google Calendar",
  "type": "n8n-nodes-base.googleCalendarTool",
  "typeVersion": 1.1
}
```

**Google Tasks Tool (Create):**
```json
{
  "parameters": {
    "task": "task-list-id",
    "title": "={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('Title', ``, 'string') }}",
    "additionalFields": {}
  },
  "name": "Create Task",
  "type": "n8n-nodes-base.googleTasksTool",
  "typeVersion": 1
}
```

**Google Tasks Tool (Get Many):**
```json
{
  "parameters": {
    "operation": "getAll",
    "task": "task-list-id",
    "additionalFields": {}
  },
  "name": "Get Tasks",
  "type": "n8n-nodes-base.googleTasksTool",
  "typeVersion": 1
}
```

**CRITICAL `$fromAI()` Pattern:**
Tools use `$fromAI()` to let the AI agent populate parameters dynamically:
```javascript
"={{ /*n8n-auto-generated-fromAI-override*/ $fromAI('ParameterName', `default or prompt`, 'string') }}"
```

**System Message Best Practices:**
```
You are a helpful assistant called [Name].

Today's date is {{ $today.format('yyyy-MM-dd') }}.

Guidelines:
- When summarizing emails, include Sender, Date, Subject, and brief summary
- If user doesn't specify a date, assume today
- When answering about calendar events, filter irrelevant events
- Be concise and accurate
- Use tools before answering questions about data
```

#### Voice Support with OpenAI Transcription
```json
{
  "nodes": [
    {
      "parameters": {
        "resource": "file",
        "fileId": "={{ $('Telegram Trigger').item.json.message.voice.file_id }}"
      },
      "name": "Get Voice File",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.1
    },
    {
      "parameters": {
        "resource": "audio",
        "operation": "transcribe",
        "options": {}
      },
      "name": "Transcribe",
      "type": "@n8n/n8n-nodes-langchain.openAi",
      "typeVersion": 1.8
    }
  ],
  "connections": {
    "Get Voice File": {
      "main": [[{"node": "Transcribe", "type": "main", "index": 0}]]
    },
    "Transcribe": {
      "main": [[{"node": "AI Agent", "type": "main", "index": 0}]]
    }
  }
}
```

**Pattern for voice or text:**
```json
{
  "nodes": [
    {
      "parameters": {
        "fields": {
          "values": [
            {
              "name": "text",
              "stringValue": "={{ $json?.message?.text || \"\" }}"
            }
          ]
        }
      },
      "name": "Extract Text or Voice",
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.2
    },
    {
      "parameters": {
        "conditions": {
          "conditions": [
            {
              "leftValue": "={{ $json.message.text }}",
              "operator": {"type": "string", "operation": "empty"}
            }
          ]
        }
      },
      "name": "Is Voice?",
      "type": "n8n-nodes-base.if",
      "typeVersion": 2
    }
  ]
}
```

---

### 5. HTTP & API INTEGRATION

#### HTTP Request Node
```json
{
  "parameters": {
    "method": "POST",
    "url": "https://api.example.com/users",
    "authentication": "headerAuth",
    "sendBody": true,
    "bodyParameters": {
      "parameters": [
        {
          "name": "name",
          "value": "={{ $json.fullName }}"
        },
        {
          "name": "email",
          "value": "={{ $json.email }}"
        }
      ]
    },
    "options": {
      "response": {
        "response": {
          "responseFormat": "json"
        }
      }
    }
  },
  "name": "HTTP Request",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2
}
```

**Authentication types:**
- **None:** Public APIs
- **Header Auth:** API keys in headers
- **Basic Auth:** Username/password
- **OAuth1/OAuth2:** Complex auth flows
- **Predefined Credential Type:** Reuse credentials from native nodes

**Pagination (automatic):**
```json
{
  "options": {
    "pagination": {
      "pagination": {
        "paginationMode": "updateAParameterInEachRequest",
        "parameterName": "page",
        "parameterValue": "={{ $pageCount }}",
        "paginationCompleteWhen": "responseIsEmpty"
      }
    }
  }
}
```

**Response Contains Next URL:**
```json
{
  "options": {
    "pagination": {
      "pagination": {
        "paginationMode": "responseContainsNextUrl",
        "nextUrlPath": "paging.next"
      }
    }
  }
}
```

---

### 6. DATABASE OPERATIONS

#### PostgreSQL
```json
{
  "parameters": {
    "operation": "executeQuery",
    "query": "SELECT * FROM users WHERE created_at > $1 ORDER BY created_at DESC LIMIT $2",
    "options": {
      "queryParameters": "={{ $json.startDate }},100"
    }
  },
  "name": "PostgreSQL",
  "type": "n8n-nodes-base.postgres",
  "typeVersion": 2.5
}
```

**Insert with mapping:**
```json
{
  "parameters": {
    "operation": "insert",
    "schema": {"__rl": true, "value": "public", "mode": "list"},
    "table": {"__rl": true, "value": "orders", "mode": "list"},
    "columns": {
      "mappingMode": "defineBelow",
      "value": {
        "full_name": "={{ $json.name }}",
        "email": "={{ $json.email }}",
        "total": "={{ $json.amount }}",
        "created_at": "={{ $now.toSQL() }}"
      }
    }
  }
}
```

**CRITICAL:** Always use query parameters (`$1`, `$2`) to prevent SQL injection

---

### 7. MESSAGING & NOTIFICATIONS

#### Telegram Send Message
```json
{
  "parameters": {
    "resource": "message",
    "operation": "sendMessage",
    "chatId": "={{ $json.chatId }}",
    "text": "={{ $json.message }}",
    "additionalFields": {
      "parse_mode": "Markdown",
      "disable_notification": false
    }
  },
  "name": "Send Message",
  "type": "n8n-nodes-base.telegram",
  "typeVersion": 1.2
}
```

**Parse modes:** Markdown, HTML, None

**Markdown formatting:**
```
*bold text*
_italic text_
[link](https://example.com)
`code`
```
```
multi-line code
```
```

#### Gmail Send
```json
{
  "parameters": {
    "sendTo": "user@example.com",
    "subject": "Daily Report",
    "emailType": "text",
    "message": "=Hey,\n\nYour report is ready:\n\n{{ $json.summary }}",
    "options": {}
  },
  "name": "Send Email",
  "type": "n8n-nodes-base.gmail",
  "typeVersion": 2.1
}
```

**HTML email:**
```json
{
  "parameters": {
    "emailType": "html",
    "message": "=<html><body><h1>Report</h1><p>{{ $json.content }}</p></body></html>"
  }
}
```

---

## 🔧 JavaScript Reference

### Global Variables
```javascript
// Workflow context
$workflow.id
$workflow.name
$workflow.active

// Execution context
$execution.id
$execution.mode  // 'test' or 'production'

// Current item
$json.fieldName
$json["field-with-dashes"]
$json.nested?.optional?.field

// Input methods
$input.all()     // Array of all items
$input.first()   // First item
$input.last()    // Last item
$input.item      // Current item (forEach mode)

// Access other nodes
$('Node Name').all()
$('Node Name').first().json.fieldName
$('Node Name').item(2).json

// Date/time (Luxon)
$now.toISO()                    // "2026-01-19T10:30:00.000Z"
$now.toFormat('yyyy-MM-dd')     // "2026-01-19"
$now.toSQL()                    // SQL-compatible format
$now.plus({ days: 7 })
$now.minus({ hours: 2 })
$today.toFormat('yyyy-MM-dd')   // Today at midnight

// Variables
$vars.myVariable
$env.MY_ENV_VAR  // Self-hosted only

// Static data (persistent)
const data = getWorkflowStaticData('global');
data.counter = (data.counter || 0) + 1;
```

### Common Patterns
```javascript
// Map/transform
items.map(item => ({
  json: {
    ...item.json,
    fullName: `${item.json.first} ${item.json.last}`
  }
}))

// Filter
items.filter(item => item.json.amount > 100)

// Find
items.find(item => item.json.id === targetId)

// Reduce/aggregate
items.reduce((sum, item) => sum + item.json.amount, 0)

// Group by
const grouped = items.reduce((acc, item) => {
  const key = item.json.category;
  if (!acc[key]) acc[key] = [];
  acc[key].push(item.json);
  return acc;
}, {});

// Flatten
items.flatMap(item => item.json.children)

// Sort
items.sort((a, b) => b.json.amount - a.json.amount)

// Unique values
[...new Set(items.map(i => i.json.category))]

// Check if exists
items.some(item => item.json.status === 'error')

// All match condition
items.every(item => item.json.verified === true)
```

---

## 📋 Complete Workflow Templates

### Template 1: Telegram AI Bot with Memory
```json
{
  "name": "Telegram AI Bot",
  "nodes": [
    {
      "parameters": {
        "updates": ["message"]
      },
      "name": "Telegram Trigger",
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.1,
      "position": [250, 300]
    },
    {
      "parameters": {
        "resource": "message",
        "operation": "sendChatAction",
        "chatId": "={{ $json.message.chat.id }}",
        "action": "typing"
      },
      "name": "Send Typing",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [450, 300]
    },
    {
      "parameters": {
        "promptType": "define",
        "text": "={{ $json.message.text }}",
        "options": {
          "systemMessage": "Eres un asistente útil que responde en español de manera clara y concisa."
        }
      },
      "name": "AI Agent",
      "type": "@n8n/n8n-nodes-langchain.agent",
      "typeVersion": 3.1,
      "position": [650, 300]
    },
    {
      "parameters": {
        "resource": "message",
        "operation": "sendMessage",
        "chatId": "={{ $('Telegram Trigger').item.json.message.chat.id }}",
        "text": "={{ $json.output }}",
        "additionalFields": {
          "parse_mode": "Markdown"
        }
      },
      "name": "Send Response",
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [850, 300]
    },
    {
      "parameters": {
        "sessionKey": "={{ $('Telegram Trigger').item.json.message.from.id }}",
        "contextWindowLength": 10
      },
      "name": "Memory",
      "type": "@n8n/n8n-nodes-langchain.memoryBufferWindow",
      "typeVersion": 1.3,
      "position": [650, 480]
    },
    {
      "parameters": {
        "model": "claude-3-5-sonnet-20241022"
      },
      "name": "Claude",
      "type": "@n8n/n8n-nodes-langchain.lmChatAnthropic",
      "typeVersion": 1.8,
      "position": [650, 120]
    }
  ],
  "connections": {
    "Telegram Trigger": {
      "main": [[{"node": "Send Typing", "type": "main", "index": 0}]]
    },
    "Send Typing": {
      "main": [[{"node": "AI Agent", "type": "main", "index": 0}]]
    },
    "AI Agent": {
      "main": [[{"node": "Send Response", "type": "main", "index": 0}]]
    },
    "Memory": {
      "ai_memory": [[{"node": "AI Agent", "type": "ai_memory", "index": 0}]]
    },
    "Claude": {
      "ai_languageModel": [[{"node": "AI Agent", "type": "ai_languageModel", "index": 0}]]
    }
  }
}
```

### Template 2: Data Processing Pipeline
```json
{
  "name": "Data Processing with Validation",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "process-data",
        "responseMode": "lastNode"
      },
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 2,
      "position": [250, 300]
    },
    {
      "parameters": {
        "mode": "runOnceForAllItems",
        "jsCode": "const items = $input.all();\n\nreturn items.filter(item => {\n  const d = item.json;\n  return d.email && d.name && (!d.amount || d.amount >= 10);\n});"
      },
      "name": "Validate",
      "type": "n8n-nodes-base.code",
      "typeVersion": 2,
      "position": [450, 300]
    },
    {
      "parameters": {
        "mode": "manual",
        "assignments": {
          "assignments": [
            {
              "id": "1",
              "name": "full_name",
              "value": "={{ $json.name }}",
              "type": "string"
            },
            {
              "id": "2",
              "name": "email_address",
              "value": "={{ $json.email.toLowerCase() }}",
              "type": "string"
            },
            {
              "id": "3",
              "name": "total_amount",
              "value": "={{ $json.amount * 1.16 }}",
              "type": "number"
            },
            {
              "id": "4",
              "name": "created_at",
              "value": "={{ $now.toSQL() }}",
              "type": "string"
            }
          ]
        }
      },
      "name": "Transform",
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [650, 300]
    },
    {
      "parameters": {
        "operation": "insert",
        "schema": {"__rl": true, "value": "public", "mode": "list"},
        "table": {"__rl": true, "value": "orders", "mode": "list"},
        "columns": {
          "mappingMode": "defineBelow",
          "value": {
            "full_name": "={{ $json.full_name }}",
            "email_address": "={{ $json.email_address }}",
            "total_amount": "={{ $json.total_amount }}",
            "created_at": "={{ $json.created_at }}"
          }
        }
      },
      "name": "Insert to DB",
      "type": "n8n-nodes-base.postgres",
      "typeVersion": 2.5,
      "position": [850, 300]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": "={{ { \"success\": true, \"inserted\": $json.rowCount } }}"
      },
      "name": "Respond",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1.1,
      "position": [1050, 300]
    }
  ],
  "connections": {
    "Webhook": {
      "main": [[{"node": "Validate", "type": "main", "index": 0}]]
    },
    "Validate": {
      "main": [[{"node": "Transform", "type": "main", "index": 0}]]
    },
    "Transform": {
      "main": [[{"node": "Insert to DB", "type": "main", "index": 0}]]
    },
    "Insert to DB": {
      "main": [[{"node": "Respond", "type": "main", "index": 0}]]
    }
  }
}
```

### Template 3: API Scraper with Rate Limiting
```json
{
  "name": "API Scraper with Batching",
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [{"field": "cronExpression", "expression": "0 */6 * * *"}]
        }
      },
      "name": "Schedule",
      "type": "n8n-nodes-base.scheduleTrigger",
      "typeVersion": 1.2,
      "position": [250, 300]
    },
    {
      "parameters": {
        "method": "GET",
        "url": "https://api.example.com/items"
      },
      "name": "Get List",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.2,
      "position": [450, 300]
    },
    {
      "parameters": {
        "batchSize": 5
      },
      "name": "Loop",
      "type": "n8n-nodes-base.splitInBatches",
      "typeVersion": 3,
      "position": [650, 300]
    },
    {
      "parameters": {
        "amount": 2,
        "unit": "seconds"
      },
      "name": "Wait",
      "type": "n8n-nodes-base.wait",
      "typeVersion": 1.1,
      "position": [850, 300]
    },
    {
      "parameters": {
        "method": "GET",
        "url": "=https://api.example.com/items/{{ $json.id }}/details"
      },
      "name": "Get Details",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.2,
      "position": [1050, 300]
    }
  ],
  "connections": {
    "Schedule": {
      "main": [[{"node": "Get List", "type": "main", "index": 0}]]
    },
    "Get List": {
      "main": [[{"node": "Loop", "type": "main", "index": 0}]]
    },
    "Loop": {
      "main": [[{"node": "Wait", "type": "main", "index": 0}]]
    },
    "Wait": {
      "main": [[{"node": "Get Details", "type": "main", "index": 0}]]
    },
    "Get Details": {
      "main": [[{"node": "Loop", "type": "main", "index": 0}]]
    }
  }
}
```
