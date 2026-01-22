# AI Agents & Automation Workflows

This file contains advanced patterns using LangChain, OpenAI, and other AI nodes in n8n.

## 🤖 Chatbots & Assistants

### 1. Telegram AI Chatbot with Memory
**Description:** A conversational bot on Telegram that remembers user context.
**Nodes:**
- **Trigger:** `@n8n/n8n-nodes-langchain.chatTrigger` (connected to Telegram)
- **Agent:** AI Agent (Conversational Agent)
- **Memory:** Window Buffer Memory
- **Model:** OpenAI GPT-4o / Claude 3.5 Sonnet
**Full Workflow code:** [jackie_ai_assistant.json](file:///c:/Users/raul_/.gemini/antigravity/skills/n8n-skill/examples/json/jackie_ai_assistant.json)

### 2. Customer Support Triage Bot
**Description:** Classify incoming support tickets and suggest answers.
**Nodes:**
- **Trigger:** Zendesk / Freshdesk Trigger
- **Processing:** OpenAI (Classify: "Billing", "Tech", "Feature")
- **Action:** Add Tag -> Draft Reply

### 3. Internal Knowledge Base Q&A (RAG)
**Description:** Answer employee questions based on a Notion doc or PDF.
**Nodes:**
- **Trigger:** Slack / Microsoft Teams
- **Agent:** AI Agent
- **Tool:** Vector Store Tool (Pinecone/Qdrant)
- **Embedding:** OpenAI Embeddings

### 4. Voice Note Transcriber & Action Taker
**Description:** Transcribe voice notes from WhatsApp/Telegram and create tasks/calendar events.
**Nodes:**
- **Trigger:** WhatsApp/Telegram (Media)
- **Processing:** OpenAI Whisper (Transcribe) -> OpenAI (Extract Action Items)
- **Action:** Google Tasks / Notion

### 5. Website Chat Widget with Function Calling
**Description:** Web chat that can look up order status via API.
**Nodes:**
- **Trigger:** Chat Trigger
- **Agent:** AI Agent (Tools Agent)
- **Tool:** HTTP Verification Tool (calling internal API)

## 📄 Document Processing & RAG

### 6. PDF Invoice Parser
**Description:** Extract structured data (Date, Amount, Vendor) from PDF invoices.
**Nodes:**
- **Trigger:** Email Attachment / Drive Upload
- **Processing:** Read PDF -> OpenAI (JSON Output Mode)
- **Action:** Google Sheets / QuickBooks

### 7. Contract Clause Analyzer
**Description:** Review legal contracts and highlight risky clauses.
**Nodes:**
- **Trigger:** Dropbox File Upload
- **Processing:** LangChain Recursive Character Text Splitter -> OpenAI (Analyze)
- **Action:** Generate Report (PDF/Doc)

### 8. Resume/CV Screening
**Description:** Score resumes against a job description.
**Nodes:**
- **Trigger:** Form Submission (with file)
- **Processing:** PDF Reader -> OpenAI (Compare Resume vs Job Desc)
- **Action:** Airtable (Update Status)

### 9. Meeting Minutes Generator
**Description:** Take a transcript and generate summary, action items, and sentiment.
**Nodes:**
- **Trigger:** Webhook (Receive Transcript)
- **Processing:** OpenAI (Summarize)
- **Action:** Email Team / Notion Page

### 10. Researcher Agent
**Description:** Scrape top 5 Google results for a topic and write a report.
**Nodes:**
- **Trigger:** Manual / Chat
- **Agent:** AI Agent
- **Tool:** SerpAPI / Google Search Tool -> Web Scraper Tool
- **Action:** Save to Doc

## 🎨 Creative & Content AI

### 11. Social Media Image Generator
**Description:** Create Instagram images based on quotes.
**Nodes:**
- **Trigger:** Schedule
- **Processing:** OpenAI (Generate Prompt) -> DALL-E 3 / Stable Diffusion
- **Action:** Instagram/Pinterest

### 12. SEO Article Writer
**Description:** Write a full blog post optimized for keywords.
**Nodes:**
- **Trigger:** Keyword List (Google Sheets)
- **Processing:** OpenAI (Outline) -> Loop (Write Section)
- **Action:** WordPress (Draft)

### 13. Personalized Sales Video Script
**Description:** Generate a video script for a prospect based on their LinkedIn profile.
**Nodes:**
- **Trigger:** CRM New Lead
- **Processing:** LinkedIn Scraper -> OpenAI (Personalize Script)
- **Action:** Save to CRM

### 14. YouTube Thumbnail Tester
**Description:** Analyze thumbnail CTR potential (using Vision).
**Nodes:**
- **Trigger:** New Video Upload
- **Processing:** GPT-4 Vision (Analyze Image appeal)
- **Action:** Email Report

### 15. Product Description Generator
**Description:** Generate descriptions from supplier specs.
**Nodes:**
- **Trigger:** Shopify New Product (Title only)
- **Processing:** OpenAI (Write Description)
- **Action:** Shopify Update Product

## 🛠️ Utility & Integration Agents

### 16. SQL Query Generator
**Description:** Allow non-tech users to ask "How many users today?" and run SQL.
**Nodes:**
- **Trigger:** Slack Command
- **Processing:** OpenAI (Text-to-SQL)
- **Action:** Postgres (Execute) -> Table/Chart Output

### 17. API Connector Agent
**Description:** "Smart" HTTP request builder that fixes its own 400 errors.
**Nodes:**
- **Trigger:** Webhook
- **Agent:** AI Agent (with HTTP tool)
- **Loop:** Retry logic with AI analyzing error message

### 18. Emotion/Sentiment Tagger
**Description:** Tag support tickets by emotion (Angry, Happy, Frustrated).
**Nodes:**
- **Trigger:** New Ticket
- **Processing:** OpenAI (Sentiment)
- **Action:** Update Ticket Priority

### 19. Audio Translation Pipeline
**Description:** Translate a podcast audio file into another language (Text).
**Nodes:**
- **Trigger:** File Upload
- **Processing:** Whisper (Transcribe) -> OpenAI (Translate)
- **Action:** Save Text

### 20. Code Assistant for n8n
**Description:** An agent that writes JavaScript for n8n Code Nodes.
**Nodes:**
- **Trigger:** Chat
- **System Prompt:** Specialized in n8n data structures (`$input.all()`).
- **Action:** Output Code Block

---
*Note: AI workflows often require model credentials (OpenAI, Anthropic, etc.). Use `@n8n/n8n-nodes-langchain` nodes for best results.*
