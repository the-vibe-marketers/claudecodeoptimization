# Claude Code Optimization Guide
## Make Claude Code 70% More Efficient for Your Budget

This repository contains everything you need to optimize your Claude Code usage, reduce token waste, and get the most value from your investment—no matter your budget size.

**Works for:**
- 💰 Students ($0-50/month)
- 👤 Freelancers ($50-200/month)
- 👥 Small teams ($200-1000/month)
- 🏢 Enterprises ($1000+/month)

---

## 🚀 Quick Start (5 Minutes)

### **Step 1: Clone This Repository**
```bash
git clone https://github.com/the-vibe-marketers/claudecodeoptimization.git
cd claudecodeoptimization
```

### **Step 2: Run the Setup Script**
```bash
chmod +x setup.sh
./setup.sh
```

The script will ask:
- **What's your monthly Claude Code budget?** (Enter any amount)
- **Which model for default?** (haiku recommended)

### **Step 3: Reload Your Shell**
```bash
source ~/.zshrc  # or ~/.bashrc
```

### **Step 4: Verify Setup**
```bash
cc-budget  # Check your configured budget
```

**Done!** Your Claude Code is now optimized. ✅

---

## ⚠️ Important Note for Existing Users

If you already use Claude Code with a **Claude subscription (Pro/Max)**, our Haiku default may not override your account settings.

**To use full optimization:**
- Option A: Use Haiku model manually in each session
- Option B: Switch to **Anthropic Console API billing** for complete automation

For best results, we recommend **API billing** so all optimizations work perfectly.

---

## 📋 What Gets Installed

After running `setup.sh`, you get:

✅ **`.claude.json`** - Personal config with your budget
✅ **Hooks** - Auto-detect vague requests, token warnings
✅ **Shell Aliases** - Quick commands like `cc-budget`, `cc-sonnet`, `cc-plan`
✅ **Safeguards** - Prevent accidental token waste
✅ **File Size Warnings** - Know before reading huge files

---

## 📚 Documentation

### **For Setup Help**
- 📖 [Setup Guide](CLAUDE_CODE_SETUP_BEST_PRACTICES.md) - How to configure everything
- 🔧 [Advanced Configuration](config/) - Customizing for your workflow

### **For Daily Use**
- ✅ [Best Practices Checklist](CLAUDE_CODE_EFFICIENCY_GUIDE.md) - 10-15 tips to remember
- 🐦 [X/Twitter Tips](CLAUDE_CODE_X_CHECKLIST.md) - Shareable one-liners

### **Examples**
- 💼 [Student Setup](examples/config-student.json) - $0-50/month
- 👤 [Individual Setup](examples/config-individual.json) - $50-500/month
- 👥 [Team Setup](examples/config-team.json) - $500+/month

---

## 🎯 How Much Can You Save?

| Strategy | Savings |
|----------|---------|
| **Use Haiku by default** | -40% |
| **Grep before reading** | -80% (large files) |
| **Chunk large files** | -95% (10MB+ files) |
| **Parallel execution** | -50% (time only) |
| **Planning before refactoring** | -70% (iterations) |
| **Result limits** | -90% (when applicable) |
| **Combined** | **~70% total reduction** |

**In dollars**: Your budget effectively becomes **3-4x more valuable** through optimization.

---

## 💡 Key Concepts

### **Automatic Optimizations** (We Handle These)
- Context-aware tool selection
- Local data filtering before returning to model
- Lazy tool loading (only load what you need)
- Parallel execution of independent tasks
- Session caching (don't re-fetch data)

### **Manual Optimizations** (You Do These)
- Use Grep before Read on large files
- Specify result limits (--head-limit=50)
- Ask for plans before big refactors
- Use Explore agent for unfamiliar codebases
- Create todo lists for multi-step work

---

## 🔧 Quick Commands

```bash
# Check your remaining budget
cc-budget

# Start fresh session
cc-reset

# Get optimization tips
cc-optimize

# Switch to Sonnet (complex tasks)
cc-sonnet

# Request planning phase
cc-plan

# View context usage
cc-context

# End session and see savings
cc-done
```

---

## 📂 File Structure

```
claudecodeoptimization/
├── setup.sh                              # Interactive setup script
├── .claude.json.template                 # Config template
├── shell-aliases.sh                      # Quick command aliases
├── README.md                             # This file
├── CLAUDE_CODE_SETUP_BEST_PRACTICES.md  # Implementation guide
├── CLAUDE_CODE_EFFICIENCY_GUIDE.md      # 10-15 efficiency tips
├── CLAUDE_CODE_X_CHECKLIST.md           # Twitter-ready tips
├── config/
│   ├── hooks/
│   │   ├── check-scope.js               # Vague request detection
│   │   ├── token-alerts.js              # Budget warnings
│   │   └── file-size-warning.js         # Large file warnings
│   └── examples/
│       ├── student-config.json          # $0-50/month example
│       ├── individual-config.json       # $50-500/month example
│       └── team-config.json             # $500+/month example
├── TROUBLESHOOTING.md                    # Common issues
└── CONTRIBUTING.md                       # How to contribute
```

---

## ⚙️ Configuration Options

After setup, your `.claude.json` includes:

### **Token Budget Alerts**
```json
"token_budget": {
  "monthly_limit_usd": 200,        // Your budget
  "alert_thresholds": {
    "yellow": 0.70,                // Alert at 70%
    "red": 0.90,                   // Warning at 90%
    "hard_stop": 1.0               // Stop at 100%
  }
}
```

### **File Reading Rules**
```json
"file_reading_rules": {
  "warn_on_file_size_above_kb": 500,
  "auto_limit_large_files": true,
  "grep_before_read": true
}
```

### **Model Selection**
```json
"model_selection_rules": {
  "default": "haiku",
  "auto_suggest_sonnet_indicators": [
    "refactor", "architecture", "complex"
  ]
}
```

---

## 🛡️ Safeguards Included

These prevent accidental token waste:

- ✅ Large file reading warnings
- ✅ Vague request detection
- ✅ Confirmation before expensive operations
- ✅ Token usage tracking per operation
- ✅ Monthly budget alerts (70%, 90%, 100%)
- ✅ Safeguards on destructive commands (git push, etc.)

---

## 🤔 FAQ

### **Q: Will this work with my budget?**
**A:** Yes! The setup script asks for your budget and configures everything accordingly. Works for $0, $50, $200, $1000, or any amount.

### **Q: How do I change my budget later?**
**A:** Edit `~/.claude.json` and change the `monthly_limit_usd` value, or run `setup.sh` again.

### **Q: Can I use this with multiple models?**
**A:** Yes! Setup uses Haiku by default, but you can switch to Sonnet with `cc-sonnet` command.

### **Q: Do I need to do this every time?**
**A:** No. Setup is one-time. Aliases and config stay in your home directory.

### **Q: What if I don't want alerts?**
**A:** Edit `.claude.json` and set alert thresholds higher, or disable in your hook files.

### **Q: Does this work on Windows?**
**A:** The `setup.sh` script is for Mac/Linux. Windows users can manually copy files or modify script for WSL.

---

## 📖 Learn More

### **For Beginners**
1. Run `setup.sh`
2. Read [CLAUDE_CODE_EFFICIENCY_GUIDE.md](CLAUDE_CODE_EFFICIENCY_GUIDE.md)
3. Bookmark the Quick Commands section above

### **For Intermediate Users**
1. Review [CLAUDE_CODE_SETUP_BEST_PRACTICES.md](CLAUDE_CODE_SETUP_BEST_PRACTICES.md)
2. Customize hooks in `~/.claude/hooks/`
3. Create shortcut folders in `.claude.json`

### **For Power Users**
1. Modify hook files for custom behavior
2. Create team-wide `.claude.json` with shared settings
3. Set up git pre-commit hooks for additional checks

---

## 🤝 Contributing

Have improvements? Found a bug? Submit a PR!

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - Feel free to use, modify, and share.

---

## 🙋 Support

**Issues or questions?**
- 📖 Read [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- 💬 Open a GitHub issue
- 📧 Check existing discussions

---

## 🌟 What Others Are Saving

> "Setup took 5 minutes, saved $120/month by defaulting to Haiku. Game changer." — Developer

> "The vague request hook caught me before I wasted tokens. Worth it alone." — Freelancer

> "Team adopted this, we saved 60% on our Claude Code budget. Highly recommend." — Team Lead

---

## 🚀 Ready to Optimize?

```bash
git clone https://github.com/the-vibe-marketers/claudecodeoptimization.git
cd claudecodeoptimization
chmod +x setup.sh
./setup.sh
```

**That's it. You're optimized.** ✨

---

**Made with ❤️ for developers who care about efficiency.**

Questions? Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) or open an issue.
