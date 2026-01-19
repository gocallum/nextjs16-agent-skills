# Resend MCP Integration Examples

This file contains practical examples of using Resend via MCP with AI agents.

## Testing Pattern: email.md

Before diving into complex examples, learn the official test pattern:

**Create `email.md`:**
```markdown
to: your-email@example.com
subject: Test Email
content: This is a test

Hello! Testing Resend MCP.

# Optional sections:
# cc: colleague@example.com
# bcc: manager@example.com
```

**To test (Cursor):**
1. Open email.md
2. Select all text (Cmd+A / Ctrl+A)
3. Press Cmd+L / Ctrl+L
4. Say: "send this as an email" (in Agent mode)

This simple pattern confirms your MCP setup works before building complex workflows.

## Simple Email Sending

### Example 1: Basic Email

**Prompt to AI Agent:**
```
Send an email to john@example.com with subject "Hello from Resend" and body "This is a test email using Resend MCP."
```

**What the Agent Will Do:**
1. Identify the `resend` MCP tool is available
2. Extract email details: recipient, subject, body
3. Call the Resend MCP tool with formatted parameters
4. Confirm the email was sent

### Example 2: Email with HTML Content

**Prompt:**
```
Send an HTML email to customer@example.com with:
- Subject: "Welcome to Our Platform"
- Body: An HTML formatted welcome message including a button that links to https://example.com/onboarding
```

**Expected Result:**
The agent generates HTML, calls the Resend tool, and sends the formatted email.

## Personalized Batch Emails

### Example 3: CSV to Email Workflow

**Prompt:**
```
Read the file "customers.csv" which contains columns: name, email, company.

For each row, send a personalized email using Resend MCP:
- To: [email]
- Subject: "Special offer for [company]"
- Body: "Hi [name], we have an exclusive offer for [company]..."

Send all emails.
```

**Workflow:**
1. Agent reads CSV file
2. Iterates through rows
3. Personalizes email content
4. Sends via Resend MCP for each row
5. Reports success/failure for each email

## Transactional Emails

### Example 4: Order Confirmation Email

**Prompt:**
```
I have an order object:
{
  "orderId": "ORD-12345",
  "customerEmail": "buyer@example.com",
  "customerName": "John Doe",
  "items": [
    {"name": "Widget", "qty": 2, "price": 29.99}
  ],
  "total": 59.98,
  "estimatedDelivery": "2026-01-25"
}

Generate an attractive HTML order confirmation email and send it using Resend MCP with:
- Subject: "Order Confirmation: ORD-12345"
- Include all order details in a formatted table
- Add a "Track Order" button
```

**What the Agent Does:**
1. Parses the order object
2. Generates professional HTML email
3. Includes formatted table of items
4. Adds call-to-action button
5. Sends via Resend MCP

## Email Templates

### Example 5: Using Template Variables

**Prompt:**
```
Create an email template for password reset notifications:

Subject: "Reset your password"
Body template with variables: {email}, {resetLink}, {expiryHours}

Then send it to john@example.com with:
- resetLink: https://app.example.com/reset/abc123
- expiryHours: 24

Use the Resend MCP tool.
```

## Multi-Recipient Emails

### Example 6: Email with CC and BCC

**Prompt:**
```
Send an email using Resend MCP:
- To: client@example.com
- CC: manager@company.com
- BCC: audit@company.com
- Subject: "Project Completion Report"
- Body: "Project ABC has been completed on schedule..."
```

## Scheduled Emails

### Example 7: Schedule Future Email

**Prompt:**
```
Schedule an email to be sent tomorrow at 9:00 AM using Resend MCP:
- To: team@company.com
- Subject: "Daily Standup Reminder"
- Body: "Don't forget about our standup meeting at 10 AM"
```

## Error Handling

### Example 8: Handling Email Failures

**Prompt:**
```
Attempt to send an email to invalid@invalid to test error handling.
If the send fails, report the error and suggest valid alternatives.
Use the Resend MCP tool.
```

**Expected Behavior:**
1. Agent attempts to send via Resend MCP
2. Receives error response
3. Handles error gracefully
4. Reports what went wrong
5. Suggests solutions

## Advanced Workflows

### Example 9: Newsletter Distribution

**Prompt:**
```
I have a newsletter template and a subscriber list in "subscribers.json" with email addresses.

For each subscriber:
1. Generate personalized content based on their preferences
2. Send using Resend MCP
3. Track which emails were successfully sent

Show me a summary of:
- Total emails sent
- Any failed deliveries
- Delivery rate percentage
```

### Example 10: Notification System

**Prompt:**
```
Create a notification email system:

When I have a message like:
{
  "type": "user_signup",
  "email": "newuser@example.com",
  "name": "Jane Smith"
}

Use Resend MCP to send an appropriate email:
- If type is "user_signup": Send welcome email with setup instructions
- Format: Professional HTML with company branding
- Include call-to-action button
```

### Example 11: Broadcast to Audience Segment

**Prompt:**
```
Use Resend MCP to:
1. List all audiences in my Resend account
2. Send a broadcast email to the 'premium_customers' audience
3. Subject: "Exclusive Feature Access"
4. Content: HTML email with feature details and activation link

Generate professional email content and send the broadcast.
```

### Example 12: Audience Management Integration

**Prompt:**
```
Using Resend MCP:
1. Get all audiences from my Resend account
2. For the 'inactive_users' audience, send a re-engagement email
3. Include special 30% discount code
4. Track which audience segments this was sent to
```

## Integration Patterns

### Example 11: Form Submission to Email

**Prompt:**
```
I have a contact form submission:
{
  "name": "John Doe",
  "email": "john@example.com",
  "subject": "Inquiry about pricing",
  "message": "What are your enterprise plans?"
}

Use Resend MCP to:
1. Send a confirmation email to the submitter
2. Send the submission details to support@company.com
3. Include submission timestamp and reference ID
```

### Example 12: Report Generation and Distribution

**Prompt:**
```
Generate a monthly analytics report and distribute it:

1. Analyze data from the past 30 days
2. Create an HTML report with charts and statistics
3. Use Resend MCP to send the report to:
   - CEO: ceo@company.com
   - Marketing Lead: marketing@company.com
   - CC: finance@company.com

Include:
- Executive summary
- Key metrics table
- Year-over-year comparison
- Recommendations
```

## Testing Patterns

### Example 13: Development vs Production

**Prompt:**
```
I'm setting up email sending in development.

For development mode:
- Use Resend MCP with test API key
- Send all emails to my test email: dev@example.com
- Log email details instead of actually sending

For production:
- Use full Resend API key
- Send to actual recipient emails
- Track delivery status

Set this up so I can toggle between modes easily.
```

### Example 14: Email Preview and Review

**Prompt:**
```
Before sending batch emails:

1. Generate the first email as a preview
2. Show me the HTML rendering and content
3. Wait for my approval
4. Only then send the full batch using Resend MCP

This helps me review before sending to real customers.
```

## Prompt Engineering Tips

### Use Explicit MCP References

Instead of:
```
Send an email to john@example.com
```

Use:
```
Use the Resend MCP tool to send an email to john@example.com
```

This helps the agent prioritize the correct tool.

### Provide Clear Structure

Instead of vague instructions, give structured input:

```
Send an email with these details:
- Recipient: john@example.com
- Sender: noreply@company.com (if different)
- Subject: Welcome to our service
- Content Type: HTML
- Body: [HTML content here]
```

### Include Context

Provide business context to help AI generate better content:

```
Send a customer retention email. The customer:
- Name: Jane Smith
- Account age: 2 years
- Has purchased 5 times
- Last purchase: 30 days ago
- Interests: Enterprise features

Generate appropriate, personalized HTML content.
```

### Specify Quality Requirements

```
Send a professional email with:
- Correct spelling and grammar
- Responsive HTML design (works on mobile)
- Professional tone (B2B)
- Clear call-to-action
- Footer with unsubscribe link
```
