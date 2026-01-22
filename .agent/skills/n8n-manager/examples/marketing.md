# Marketing & Growth Workflows

This file contains common patterns for marketing automation, social media management, and lead generation.

## 📱 Social Media Automation

### 1. Cross-Platform Content Publisher
**Description:** Post content to Twitter, LinkedIn, and Facebook simultaneously from a single form or trigger.
**Nodes:**
- **Trigger:** Webhook / Airtable Trigger
- **Logic:** Switch (by platform check)
- **Action:** `n8n-nodes-base.twitter`, `n8n-nodes-base.linkedin`, `n8n-nodes-base.facebookGraphApi`

### 2. Tweet from RSS Feed with AI
**Description:** Watch an RSS feed/blog, summarize the new post with AI, and tweet it.
**Nodes:**
- **Trigger:** RSS Read (poll)
- **Processing:** OpenAI (Summarize content + generate hashtags)
- **Action:** Twitter (Post)

### 3. Instagram Auto-Responder (DM)
**Description:** Reply to DMs containing specific keywords (e.g., "price", "catalog").
**Nodes:**
- **Trigger:** Instagram Trigger (message created)
- **Logic:** IF (contains "price")
- **Action:** Instagram (Send Message)

### 4. YouTube to Blog Post
**Description:** When a new video is posted, transcribe it and create a WordPress draft.
**Nodes:**
- **Trigger:** YouTube Trigger
- **Processing:** OpenAI (Whisper Transcribe + Summarize)
- **Action:** WordPress (Create Post)

### 5. Social Media Listening (Brand Mentions)
**Description:** Monitor Twitter/Reddit for brand mentions and alert Slack.
**Nodes:**
- **Trigger:** Twitter/Reddit Trigger
- **Processing:** Sentiment Analysis (AWS Comprehend or n8n-native)
- **Action:** Slack (Notify if positive/negative)

## 📧 Email Marketing & Lead Gen

### 6. Typeform to HubSpot Lead
**Description:** Capture Typeform submissions and create/update contacts in CRM.
**Nodes:**
- **Trigger:** Typeform Trigger
- **Logic:** IF (email exists?) -> HubSpot (Get)
- **Action:** HubSpot (Create/Update Contact)

### 7. Automated Webinar Follow-up
**Description:** Send different emails based on whether a user attended the webinar.
**Nodes:**
- **Trigger:** Zoom Trigger (Webinar Ended)
- **Processing:** Loop over attendees/absentees
- **Action:** Gmail/SendGrid (Send specific template)

### 8. Cold Outreach Sequence
**Description:** Send a sequence of emails with delays if no reply.
**Nodes:**
- **Trigger:** Manual/Webhook (Start sequence)
- **Action:** Send Email 1
- **Logic:** Wait (3 days) -> Gmail (Get Threads) -> IF (Replied?)
- **Action:** Send Follow-up

### 9. Newsletter Aggregator
**Description:** Collect weekly top links from HackerNews/ProductHunt and email them.
**Nodes:**
- **Trigger:** Schedule (Weekly)
- **Processing:** HackerNews (Get Top Stories) -> Code (Filter/Format HTML)
- **Action:** SendGrid (Send Newsletter)

### 10. Lead Scoring System
**Description:** Calculate lead score based on interactions (email opens, site visits).
**Nodes:**
- **Trigger:** Multiple (Email Open, Page Visit)
- **Processing:** Code (Calculate Score += 10)
- **Action:** Salesforce/HubSpot (Update Field)

## 🛍️ E-commerce Marketing

### 11. Abandoned Cart Recovery
**Description:** Send notification if checkout initiated but not completed.
**Nodes:**
- **Trigger:** Shopify Trigger (Checkout Created)
- **Logic:** Wait (1 hour) -> Shopify (Get Order by Checkout ID) -> IF (Order doesn't exist)
- **Action:** Email/SMS (Twilio)

### 12. Post-Purchase Review Request
**Description:** Ask for a review 7 days after delivery.
**Nodes:**
- **Trigger:** Shopify/WooCommerce (Order Delivered)
- **Logic:** Wait (7 days)
- **Action:** Email (Request Review)

### 13. VIP Customer Tagger
**Description:** Tag customers who spend over $1000.
**Nodes:**
- **Trigger:** Stripe/Shopify (Order Paid)
- **Logic:** IF (Total Spent > 1000)
- **Action:** Update Customer (Add Tag: VIP)

### 14. Sync Facebook Leads to Google Sheets
**Description:** Backup Facebook Lead Ads data in realtime.
**Nodes:**
- **Trigger:** Facebook Lead Ads Trigger
- **Action:** Google Sheets (Append Row)

### 15. Coupon Code Generator
**Description:** Generate unique coupon for birthdays.
**Nodes:**
- **Trigger:** Schedule (Daily check for birthdays)
- **Action:** WooCommerce (Create Coupon) -> Email (Send Code)

## 📝 Content Marketing

### 16. WordPress to Medium Cross-Post
**Description:** Republish blog posts to Medium with canonical link.
**Nodes:**
- **Trigger:** WordPress (Post Published)
- **Action:** Medium (Create Post)

### 17. Image Generation for Blog Headers
**Description:** Generate DALL-E image based on blog title.
**Nodes:**
- **Trigger:** Webhook (New Draft)
- **Processing:** OpenAI (Generate Image)
- **Action:** Upload Image -> Update Post

### 18. Community Welcome Bot (Discord/Slack)
**Description:** Send personalized DM and assign roles to new members.
**Nodes:**
- **Trigger:** Discord/Slack (User Joined)
- **Action:** Send DM + Add Role

### 19. Survey Analysis Report
**Description:** Aggregate survey results and email summary to team.
**Nodes:**
- **Trigger:** Google Forms (On Submit)
- **Processing:** Code (Calculate stats)
- **Action:** Slack (Send Report)

### 20. Eventbrite to CRM
**Description:** Sync event attendees to marketing lists.
**Nodes:**
- **Trigger:** Eventbrite Trigger
- **Action:** Mailchimp/ActiveCampaign (Add to list)

---
*Note: This file contains patterns. For full JSON implementation, ask the agent to "Generate the [Name] workflow".*
