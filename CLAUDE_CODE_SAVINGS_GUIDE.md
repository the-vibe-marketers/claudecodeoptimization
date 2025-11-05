# Save Time & Money with Claude Code
## Simple One-Pager Guide (Non-Technical)

---

## 💰 **The Big Picture**

Claude Code costs money for every API call. The smarter you use it, the less you pay.

**Real savings:** Most people save **60-70% on costs** by following these simple tips.

---

## 🚀 **Step 1: Smart Setup (5 minutes)**

### **What to do:**
1. Clone the repo
2. Run `./setup.sh`
3. Enter your monthly budget
4. Done—alerts auto-protect you

### **What it does:**
- ✅ Warns you at 70% of budget spent ("Yellow alert")
- ✅ Blocks expensive operations at 90% ("Red alert")
- ✅ Stops work at 100% (prevents overages)

**Example:** If your budget is $100/month:
- Yellow alert at $70 → "Heads up, be careful"
- Red alert at $90 → "Stop using expensive features"
- Hard stop at $100 → "No more work this month"

---

## ⚡ **Step 2: Use Cheaper Model (5% effort = 40% savings)**

### **The Models:**
- **Haiku** = Fast & cheap (use 80% of the time)
- **Sonnet** = Smarter but 5x more expensive (use 20% of the time)

### **When to use each:**
| Task | Model | Why |
|------|-------|-----|
| Fix bugs, read files, simple edits | Haiku | 5x cheaper |
| Design architecture, plan big changes | Sonnet | More intelligent |
| Never use unless critical | Opus | Super expensive |

### **Example:**
```
Bad: Use Sonnet for every task → $200/month
Good: Use Haiku for 80%, Sonnet for 20% → $60/month
Savings: $140/month (70% less!)
```

**Auto-setup:** The setup script defaults to Haiku. Done.

---

## 🎯 **Step 3: Search Smart (10% effort = 50% savings)**

### **The Rule:**
Search first, read second. Always.

### **Example:**

❌ **Costly way:**
```
"Read this 50MB log file"
→ Loads entire file = 50,000 tokens = $5
```

✅ **Smart way:**
```
"Search for ERROR in the log file"
→ Finds just the errors = 500 tokens = $0.05
Savings: 99% on this task
```

### **Real Scenario:**
You need to find a bug in your code:
- Bad: "Read all of src/auth.ts" (huge file)
- Good: "Search for 'login bug' in src/" (just what you need)

**One command:** Type your search clearly. Done.

---

## 📊 **Step 4: Set Limits (10% effort = 90% savings on large tasks)**

### **The Rule:**
Tell Claude Code "give me 50 results, not 10,000"

### **Example:**

❌ **Without limits:**
```
"Find all matches"
→ Returns 10,000 results = 10,000 tokens = huge cost
```

✅ **With limits:**
```
"Find first 50 matches"
→ Returns 50 results = 500 tokens = 1/20th the cost
```

**Setup:** The script handles this automatically.

---

## 📝 **Step 5: Be Clear (5% effort = 30% savings)**

### **The Rule:**
Specific questions = cheaper answers

### **Examples:**

❌ **Vague (costs more):**
- "Help me fix this"
- "Make this better"
- "Check this code"

✅ **Specific (costs less):**
- "Fix the authentication bug in src/auth.ts line 45"
- "Optimize the checkout flow in stripe.ts"
- "Review error handling in payment-processor.ts"

**Why:** Vague questions make Claude search longer. Specific questions get instant answers.

---

## 🔔 **Step 6: Auto-Alerts (Setup does this)**

### **What happens automatically:**

1. **You run setup.sh**
2. **System learns your budget**
3. **Alerts trigger automatically:**
   - 70% spent → Yellow warning
   - 90% spent → Red warning
   - 100% spent → Blocked

**You don't do anything. It just works.**

---

## 💡 **Quick Real-World Example**

### **Scenario:** Debug a production issue

**Old way (expensive):**
1. Read entire app.log (2MB) = $10
2. Read entire database.ts = $5
3. Read entire server.ts = $5
4. Finally find the bug
**Total: $20+**

**New way (smart):**
1. Search logs for "ERROR" = $0.10
2. Search database.ts for "connection" = $0.05
3. Search server.ts for "timeout" = $0.05
4. Found the bug!
**Total: $0.20** (100x cheaper!)

---

## ✅ **Checklist: 5 Things to Do Once**

- [ ] **Clone repo** from GitHub
- [ ] **Run setup.sh** and enter your budget
- [ ] **Reload shell** (source ~/.zshrc)
- [ ] **Test:** Type `cc-budget` in terminal
- [ ] **Remember:** Default to Haiku, search before reading

---

## 🎯 **Simple Rules to Save 60-70%**

1. **Use Haiku by default** (5x cheaper)
2. **Search first, read second** (95% savings on large files)
3. **Be specific in requests** (30% savings)
4. **Set limits on results** (90% savings when applicable)
5. **Trust the alerts** (prevents overages)

---

## 💰 **Money Saved Per Month**

| Rule | Effort | Savings |
|------|--------|---------|
| Use Haiku | 5 min setup | 40% |
| Search first | Habit | 50% on large files |
| Be specific | Always | 30% |
| Set limits | Automatic | 90% when applicable |
| **Combined** | **5 min** | **60-70% total** |

---

## 🚀 **That's It!**

Five minutes to set up. Then just code normally. The system:
- ✅ Alerts you before you overspend
- ✅ Uses cheap model by default
- ✅ Suggests smarter searches
- ✅ Blocks expensive mistakes

**Your budget goes 3-4x further. Automatically.**

---

## ❓ **FAQs**

**Q: Do I have to do anything special?**
A: No. Just run setup once. Then code normally.

**Q: Will alerts slow me down?**
A: Nope. They only pop up at 70% and 90%—plenty of warning.

**Q: Can I change my budget later?**
A: Yes. Run setup again or edit one line in your config.

**Q: What if I hit 100%?**
A: Start a new month. Or run setup to reset.

**Q: Does this work with all my projects?**
A: Yes. Setup is global for your computer.

---

## 🔗 **Quick Links**

- **GitHub:** https://github.com/the-vibe-marketers/claudecodeoptimization
- **Setup instructions:** See README.md in repo
- **Advanced guide:** See CLAUDE_CODE_SETUP_BEST_PRACTICES.md
- **Troubleshooting:** See TROUBLESHOOTING.md

---

**Save 60-70% on Claude Code costs. In 5 minutes. No complexity.** ✨
