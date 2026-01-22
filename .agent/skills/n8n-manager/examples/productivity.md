# Productivity & Personal Automation

This file contains patterns for personal task management, calendar automation, and smart home integrations.

## 📅 Calendar & Meeting Automation

### 1. Daily Agenda Email
**Description:** Email a summary of today's calendar events at 7 AM.
**Nodes:**
- **Trigger:** Schedule (Daily 07:00)
- **Extract:** Google Calendar (Get Events for Today)
- **Transform:** Code (Format list of events)
- **Action:** Gmail (Send "Your Daily Agenda")

### 2. Auto-Decline Meetings on Holidays
**Description:** Automatically decline new invites if they fall on a holiday.
**Nodes:**
- **Trigger:** Google Calendar Trigger (Event Created)
- **Logic:** IF (Date matches Holiday List)
- **Action:** Google Calendar (Update Event -> status: declined)
- **Action:** Email (Reply "I'm OOO")

### 3. Focus Time Blocker
**Description:** If I have >3 meetings, block the rest of the day.
**Nodes:**
- **Trigger:** Schedule (Morning)
- **Extract:** Calendar (Count meetings)
- **Logic:** IF (Count > 3)
- **Action:** Calendar (Create 2hr "Focus Time" block)

### 4. Meeting Notes Organizer
**Description:** Create a Notion page for every calendar event.
**Nodes:**
- **Trigger:** Schedule (Daily) -> Get Calendar
- **Processing:** Loop
- **Action:** Notion (Create Page "Meeting: [Title]")

### 5. Zoom to Slack Status
**Description:** Sync Slack status to "In a Meeting" when Zoom starts.
**Nodes:**
- **Trigger:** Zoom Trigger (Meeting Started)
- **Action:** Slack (Set Status 📞)
- **Trigger 2:** Zoom (Meeting Ended)
- **Action 2:** Slack (Clear Status)

## ✅ Task Management

### 6. Email to Todoist/TickTick
**Description:** Starred emails become tasks.
**Nodes:**
- **Trigger:** Gmail Trigger (Label Added: "To Do" or "Starred")
- **Action:** Todoist (Create Task with email link)

### 7. Notion to Google Tasks Sync
**Description:** Sync "Action Items" db from Notion to Google Tasks.
**Nodes:**
- **Trigger:** Notion Trigger (Updated)
- **Action:** Google Tasks (Create/Update Trigger)

### 8. Recurring Task Generator (Flexible)
**Description:** Create "Pay Rent" task on the 1st of the month.
**Nodes:**
- **Trigger:** Schedule (Monthly)
- **Action:** Todoist (Create Task)

### 9. GitHub Issues to Personal Todo
**Description:** When assigned an issue, add it to personal todo list.
**Nodes:**
- **Trigger:** GitHub Trigger (Issue Assigned)
- **Action:** ClickUp / Asana / Todoist (Create Task)

### 10. Habit Tracker Logger
**Description:** Log completion of daily habits to a spreadsheet.
**Nodes:**
- **Trigger:** Telegram/Slack Command ("/did gym")
- **Action:** Google Sheets (Append Row: Date, Habit, Check)

## 🏠 Smart Home & Life

### 11. Sunset Lights Automation
**Description:** Turn on Philips Hue lights at sunset.
**Nodes:**
- **Trigger:** Schedule (Interval) or Weather API (Get Sunset Time)
- **Action:** Philips Hue (Turn On Scene: Relax)

### 12. Weather Warning Notification
**Description:** If rain is forecast > 80%, send Telegram alert "Take Umbrella".
**Nodes:**
- **Trigger:** Schedule (Morning)
- **Extract:** OpenWeatherMap API
- **Logic:** IF (Precipitation > 80%)
- **Action:** Telegram (Send Message)

### 13. Expense Categorizer
**Description:** Parse bank notification emails and log to Budget Sheet.
**Nodes:**
- **Trigger:** Gmail (Subject: "Transaction Alert")
- **Processing:** LLM/Regex (Extract Amount, Merchant)
- **Action:** Google Sheets / Notion (Log Expense)

### 14. Book Reading Tracker
**Description:** When I scan an ISBN barcode, add book details to Notion.
**Nodes:**
- **Trigger:** Validated Webhook (from phone shortcut) -> ISBN
- **Extract:** Google Books API (Get Details)
- **Action:** Notion (Create Book Page)

### 15. Commute Time Alert
**Description:** Check traffic and alert if commute > 45 mins.
**Nodes:**
- **Trigger:** Schedule (Morning)
- **Extract:** Google Maps Directions API
- **Logic:** IF (Duration > 45m)
- **Action:** Telegram ("Leave early! Heavy traffic")

## 🔗 Personal Knowledge Management

### 16. Save Pocket/Instapaper to Notion
**Description:** Sync read-later articles to Notion database.
**Nodes:**
- **Trigger:** Pocket Trigger
- **Action:** Notion (Create Page)

### 17. Kindle Highlights to Evernote/Notion
**Description:** Process My Clippings.txt or email export.
**Nodes:**
- **Trigger:** Email Attachment
- **Processing:** Text Parser (Split by "==")
- **Action:** Evernote (Create Note per Book)

### 18. Podcast New Episode Notifier
**Description:** Check favorite RSS feeds and notify.
**Nodes:**
- **Trigger:** RSS Trigger
- **Action:** Telegram (Send Audio Link)

### 19. Daily Journal Prompts
**Description:** Send a random journal prompt every evening.
**Nodes:**
- **Trigger:** Schedule (Evening)
- **Extract:** JSON File (List of prompts) -> Random Item
- **Action:** Day One / Notion / Email

### 20. Job Hunt Tracker
**Description:** Automatically save applied jobs from LinkedIn easy apply confirmation emails.
**Nodes:**
- **Trigger:** Gmail (Subject: "Application Sent")
- **Action:** Airtable (Create Record: Company, Date)

---
*Note: Personal automation is best when it runs silently in the background.*
