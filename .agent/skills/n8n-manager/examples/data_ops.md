# Data Ops & Integration Workflows

This file contains patterns for ETL (Extract, Transform, Load), database synchronization, and reporting.

## 🔄 Data Synchronization

### 1. Google Sheets to PostgreSQL Sync
**Description:** Mirror a Google Sheet into a Database table.
**Nodes:**
- **Trigger:** Schedule (Hourly) / Google Sheets Trigger
- **Extract:** Google Sheets (Read All)
- **Transform:** Code Node (Map columns)
- **Load:** Postgres (Upsert by ID)

### 2. Airtable to Webflow CMS
**Description:** Publish Airtable records as Webflow CMS items.
**Nodes:**
- **Trigger:** Airtable Trigger (Record Created/Updated)
- **Load:** Webflow (Create/Update Item)

### 3. CRM Contact Deduplication
**Description:** Merge duplicate contacts in HubSpot based on email.
**Nodes:**
- **Trigger:** Schedule (Weekly)
- **Extract:** HubSpot (Get All Contacts)
- **Transform:** Code (Group by Email, find duplicates)
- **Action:** HubSpot (Merge Contacts)

### 4. Shopify Orders to Xero/QuickBooks
**Description:** Create an invoice in accounting software for each new order.
**Nodes:**
- **Trigger:** Shopify (Order Paid)
- **Load:** Xero (Create Invoice)

### 5. Multi-Source Lead Aggregator
**Description:** Combine leads from FB, LinkedIn, and Typeform into one CSV.
**Nodes:**
- **Trigger:** Schedule (Daily)
- **Extract:** Parallel (FB Ads, LinkedIn Ads, Typeform)
- **Transform:** Merge Node (Append)
- **Load:** Spreadsheet File (Write CSV) -> Email/S3

## 📊 Reporting & Analytics

### 6. Daily Sales Dashboard (Slack)
**Description:** Send a summary of yesterday's sales to Slack.
**Nodes:**
- **Trigger:** Schedule (Morning)
- **Extract:** Stripe/Shopify (Get Sales)
- **Transform:** Code (Calculate Total, Avg Order Value)
- **Action:** Slack (Post Message with blocks)

### 7. Google Analytics to BigQuery
**Description:** Archive raw GA4 event data to BigQuery.
**Nodes:**
- **Trigger:** Cron
- **Extract:** Google Analytics Data API
- **Load:** BigQuery (Insert Rows)

### 8. SEO Ranking Report (Weekly)
**Description:** Email a PDF report of keyword positions.
**Nodes:**
- **Trigger:** Schedule (Weekly)
- **Extract:** SEMRush / Ahrefs API
- **Action:** HTML to PDF (APITemplate.io or binary)
- **Action:** Gmail (Send Attachment)

### 9. Employee Time Tracking Report
**Description:** Aggregate Harvest/Toggl hours for payroll.
**Nodes:**
- **Trigger:** Schedule (Monthly)
- **Extract:** Harvest API
- **Transform:** Code (Sum hours per user)
- **Load:** Google Sheets (Payroll tab)

### 10. Error Log Aggregation
**Description:** Consolidate error logs from multiple apps into a daily digest.
**Nodes:**
- **Trigger:** Webhook (Receive Error) -> PostgreSQL (Buffer)
- **Trigger 2:** Schedule (Daily) -> PostgreSQL (Read IDs)
- **Action:** Email (Digest)

## 🛠️ ETL & Transformation Utilities

### 11. JSON to CSV Converter
**Description:** Convert a complex JSON API response to a flat CSV file.
**Nodes:**
- **Trigger:** Webhook
- **Transform:** Spreadsheet File (JSON to CSV)
- **Action:** Response (Download) or Upload to S3

### 12. Image Resizer & Watermark Pipeline
**Description:** Process uploaded images for web.
**Nodes:**
- **Trigger:** S3 / Drive (File Created)
- **Transform:** Edit Image (Resize, Composite specific watermark)
- **Action:** Upload to "Processed" Bucket

### 13. Data Anonymizer (GDPR)
**Description:** Remove PII (Personally Identifiable Information) before dumping to warehouse.
**Nodes:**
- **Extract:** Production DB
- **Transform:** Code (Hash emails, mask phones)
- **Load:** Analytics DB

### 14. Currency Converter Pipeline
**Description:** Standardize all monetary values to USD.
**Nodes:**
- **Trigger:** New Transaction
- **Extract:** Exchange Rate API (Get rate for date)
- **Transform:** Edit Fields (Amount * Rate)
- **Load:** ERP System

### 15. Address Validator & Normalizer
**Description:** Clean up address data using Google Maps API.
**Nodes:**
- **Trigger:** New Order
- **Extract:** Google Maps Geocoding
- **Transform:** Set standard fields (State code, standard street)
- **Action:** Update Order Address

## 💾 File & Storage Ops

### 16. Email Attachment Saver
**Description:** Save invoices received via email to specific Drive folders.
**Nodes:**
- **Trigger:** Gmail (Trigger on Label 'Invoice')
- **Action:** Google Drive (Upload File)

### 17. FTP to S3 Migration
**Description:** Move files from legacy FTP to S3.
**Nodes:**
- **Trigger:** FTP (List files)
- **Reading:** FTP (Download)
- **Writing:** S3 (Upload)

### 18. Daily Database Dump to S3
**Description:** Stream pg_dump to S3.
**Nodes:**
- **Trigger:** Schedule
- **Action:** Execute Command (`pg_dump ... | aws s3 cp ...`)
   - *Note: Often better done via shell script, but triggerable via n8n.*

### 19. Bulk Web Scraper (product prices)
**Description:** Scrape a list of URLs for prices.
**Nodes:**
- **Extract:** HTML Extract (CSS Selectors)
- **Flow:** Loop Over Items
- **Load:** Database

### 20. XML Feed Internalizer
**Description:** Parse an XML product feed and sync to internal API.
**Nodes:**
- **Extract:** HTTP Request (Get XML)
- **Transform:** XML to JSON
- **Load:** Internal API

---
*Note: Data Ops requires careful handling of data types and batching for performance.*
