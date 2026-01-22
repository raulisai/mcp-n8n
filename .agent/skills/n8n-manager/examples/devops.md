# DevOps & IT Operations Workflows

This file contains patterns for deployment automation, server monitoring, error alerting, and incident management.

## 🚀 Deployment & CI/CD

### 1. Notify Slack on GitHub PR Merge
**Description:** Send a notification to #engineering when a PR is merged into main.
**Nodes:**
- **Trigger:** GitHub Trigger (PR merged)
- **Logic:** IF (base branch == main)
- **Action:** Slack (Send Message with PR link & author)

### 2. Auto-Deploy to DigitalOcean
**Description:** Trigger a deployment via SSH when a tag is pushed.
**Nodes:**
- **Trigger:** GitHub/GitLab Trigger (Tag Push)
- **Action:** SSH (Execute command `docker-compose up -d`)
- **Action:** Telegram/Slack (Notify "Deployment Started")

### 3. Sync Secrets to Repositories
**Description:** Update a secret (e.g., API key) across multiple GitHub repositories.
**Nodes:**
- **Trigger:** Manual / Webhook.
- **Processing:** List of Repos (Code Node / HTTP Request) -> Loop Over Items
- **Action:** GitHub API (Update Secret)

### 4. Jira Ticket on Sentry Error
**Description:** Create a Jira ticket when a new issue arises in Sentry.
**Nodes:**
- **Trigger:** Sentry Trigger (New Issue)
- **Action:** Jira (Create Issue)
- **Action:** Slack (Post Jira Link)

### 5. Docker Container Restart Bot
**Description:** Allow devs to restart containers via Slack command.
**Nodes:**
- **Trigger:** Slack Trigger (Slash Command `/restart`)
- **Processing:** Logic to validate user
- **Action:** SSH (Execute `docker restart container_name`)

## 🛡️ Monitoring & Security

### 6. SSL Certificate Expiry Monitor
**Description:** Check SSL expiry date and alert if < 7 days.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Action:** Execute Command (`openssl s_client ...`) OR HTTP Request
- **Logic:** IF (Days remaining < 7)
- **Action:** Email/Slack (Alert)

### 7. Uptime Monitor (Health Check)
**Description:** Ping an endpoint every 5 mins; alert on failure.
**Nodes:**
- **Trigger:** Schedule (5 mins)
- **Action:** HTTP Request (GET status endpoint)
- **Logic:** IF (Status != 200)
- **Action:** PagerDuty/Opsgenie (Create Alert)

### 8. AWS Cost Spike Alert
**Description:** Check daily AWS spend; alert if it exceeds threshold.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Action:** AWS Cost Explorer API
- **Logic:** IF (Cost > Budget)
- **Action:** Slack (Send Alert with graph image)

### 9. New Admin User Alert
**Description:** Monitor IAM/Auth0 logs for new admin role assignments.
**Nodes:**
- **Trigger:** CloudTrail / Auth0 Log Stream (Webhook)
- **Logic:** IF (Role == Admin)
- **Action:** Slack (Security Alert)

### 10. Database Backup Verification
**Description:** Check if the daily backup file exists on S3.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Action:** AWS S3 (List Objects)
- **Logic:** IF (Backup file not found today)
- **Action:** PagerDuty (Trigger Incident)

## 🔧 IT Support & Incident Management

### 11. Slack to Notion Ticket System
**Description:** Turn a Slack message into a Notion ticket with an emoji reaction.
**Nodes:**
- **Trigger:** Slack Trigger (Reaction Added: 🎫)
- **Action:** Notion (Create Page)
- **Action:** Slack (Reply to thread with Ticket Link)

### 12. On-Call Shift Rotation Notification
**Description:** Notify the team who is on call this week.
**Nodes:**
- **Trigger:** Schedule (Weekly)
- **Action:** PagerDuty (Get Schedule)
- **Action:** Slack (Post "@user is on call this week")

### 13. Auto-Close Stale Jira Tickets
**Description:** Close tickets that haven't been updated in 30 days.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Action:** Jira (JQL search: `updated < -30d AND status != Done`)
- **Processing:** Loop Over Items
- **Action:** Jira (Transition Issue to Closed)

### 14. WiFi Password Rotator (Guest Network)
**Description:** Generate new guest WiFi password and update Unifi controller.
**Nodes:**
- **Trigger:** Schedule (Monthly)
- **Processing:** Code (Generate Password)
- **Action:** Unifi Controller API (Update WLAN)
- **Action:** Slack/Email (Post new password)

### 15. Employee Onboarding (Account Creation)
**Description:** Create Google Workspace, Slack, and Jira accounts for new hire.
**Nodes:**
- **Trigger:** HR System (BambooHR/Workday Webhook)
- **Action:** Google Admin (Create User)
- **Action:** Slack (Create User)
- **Action:** Email (Send Credentials to personal email)

## ☁️ Cloud & Infrastructure

### 16. Terminate Idle EC2 Instances
**Description:** Stop dev instances at 8 PM everyday to save costs.
**Nodes:**
- **Trigger:** Schedule (Daily 20:00)
- **Action:** AWS EC2 (Describe Instances tag:env=dev) -> Loop
- **Action:** AWS EC2 (Stop Instance)

### 17. S3 Bucket Cleaner
**Description:** Delete files older than 30 days in temp bucket.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Action:** AWS S3 (List Objects) -> Filter (Date < 30 days) -> Loop
- **Action:** AWS S3 (Delete Object)

### 18. Domain Name Expiry Watcher
**Description:** Check implementation of domain expiry.
**Nodes:**
- **Trigger:** Schedule (Weekly)
- **Action:** Whois API / Namecheap API
- **Logic:** IF (Expiry < 30 days)
- **Action:** Email (Renew Reminder)

### 19. Kubernetes Pod Restarter
**Description:** Restart pods that are in CrashLoopBackOff.
**Nodes:**
- **Trigger:** Schedule (Hourly) / Prometheus Alert
- **Action:** Kubernetes API (Get Pods)
- **Logic:** IF (Status == CrashLoopBackOff)
- **Action:** Kubernetes (Delete Pod)

### 20. Log Aggregation to ElasticSearch
**Description:** Forward webhook logs to ELK stack.
**Nodes:**
- **Trigger:** Webhook (Log reciever)
- **Action:** ElasticSearch (Index Document)

---
*Note: Devops workflows often require secure handling of API keys. Use n8n Credentials securely.*
