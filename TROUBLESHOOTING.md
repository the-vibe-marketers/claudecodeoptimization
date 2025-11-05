# Troubleshooting Guide
## Common Issues & Solutions

---

## 🔴 Setup Issues

### **Problem: "Permission denied" when running setup.sh**

**Solution:**
```bash
chmod +x setup.sh
./setup.sh
```

The file needs execute permissions. The `chmod +x` command grants them.

---

### **Problem: .claude.json not found after setup**

**Solution:**

Check if it was created:
```bash
cat ~/.claude.json
```

If not found, manually copy the template:
```bash
cp .claude.json.template ~/.claude.json
```

Then edit your budget:
```bash
# Edit in your favorite editor
nano ~/.claude.json
```

Find the line `"monthly_limit_usd": 200` and change `200` to your budget.

---

### **Problem: Shell aliases not working (cc-budget, cc-sonnet, etc.)**

**Solution:**

1. **Reload shell config:**
   ```bash
   source ~/.zshrc  # for zsh
   # OR
   source ~/.bashrc # for bash
   ```

2. **Check aliases were added:**
   ```bash
   grep "cc-budget" ~/.zshrc
   ```

3. **If still not working**, manually add to your shell config:
   ```bash
   # For zsh, edit ~/.zshrc
   # For bash, edit ~/.bashrc
   nano ~/.zshrc
   ```

   Add at the end:
   ```bash
   alias cc-budget="claude-code /budget"
   alias cc-reset="claude-code /reset"
   ```

   Save (Ctrl+O, Enter, Ctrl+X in nano), then reload:
   ```bash
   source ~/.zshrc
   ```

---

### **Problem: Setup asks for budget but doesn't accept my input**

**Solution:**

The script expects a number. Make sure you enter:
- **Valid**: `50`, `200`, `1000`, `50.50`
- **Invalid**: `$200`, `two hundred`, `200usd`

Enter **just the number** without currency symbol.

---

## 🟡 Configuration Issues

### **Problem: "Cannot read file .claude.json"**

**Solution:**

Check if `.claude` directory exists:
```bash
ls -la ~/.claude
```

If not:
```bash
mkdir -p ~/.claude
mkdir -p ~/.claude/hooks
```

Then copy your `.claude.json`:
```bash
cp .claude.json.template ~/.claude.json
```

---

### **Problem: Hooks aren't triggering**

**Solution:**

1. Check hooks are in right location:
   ```bash
   ls -la ~/.claude/hooks/
   ```

   Should show:
   - `check-scope.js`
   - `token-alerts.js`
   - `file-size-warning.js`

2. Verify `.claude.json` points to hooks:
   ```bash
   grep "hooks_path" ~/.claude.json
   ```

3. If hooks missing, copy them manually:
   ```bash
   cp config/hooks/* ~/.claude/hooks/
   ```

---

### **Problem: Token alerts not showing**

**Solution:**

1. Check budget is set in `.claude.json`:
   ```bash
   grep "monthly_limit_usd" ~/.claude.json
   ```

   Should show a number like `200`.

2. Run a command to trigger alerts:
   ```bash
   cc-budget
   ```

3. If still not showing, check hook file syntax:
   ```bash
   cat ~/.claude/hooks/token-alerts.js
   ```

---

## 🔴 Runtime Issues

### **Problem: "Unknown command: cc-budget"**

**Solution:**

The alias isn't loaded. Try:

```bash
# Reload shell
source ~/.zshrc

# Test again
cc-budget
```

If still doesn't work, run directly:
```bash
claude-code /budget
```

---

### **Problem: "File too large" warning but I need it**

**Solution:**

1. **Search first** - Use grep to find what you need:
   ```bash
   grep "ERROR" large_file.log | head -50
   ```

2. **Read in chunks** - If you really need the whole file:
   ```bash
   head -1000 large_file.log | claude-code
   ```

3. **Override warning** - In `.claude.json`, increase threshold:
   ```json
   "warn_on_file_size_above_kb": 2000
   ```

---

### **Problem: Getting "vague request" warning but request is specific**

**Solution:**

The check looks for phrases like "help me with", "fix this", "make it better".

To avoid false positives, be more specific:

❌ **Bad**: "Help me fix the bug"
✅ **Good**: "Fix the authentication bug in src/auth.ts"

Or disable the hook by editing:
```bash
nano ~/.claude/hooks/check-scope.js
```

Comment out the warning section if you don't want it.

---

### **Problem: Budget limit stopping my work**

**Solution:**

Three options:

1. **Increase budget** in `.claude.json`:
   ```json
   "monthly_limit_usd": 500
   ```

2. **Start new session** with `/reset`:
   ```bash
   cc-reset
   ```

3. **Use cheaper model** (Haiku instead of Sonnet):
   ```bash
   # Default already set to Haiku, but if switched:
   claude-code --model haiku
   ```

---

## 🟢 Windows-Specific Issues

### **Problem: Running setup.sh on Windows**

**Solution:**

Option 1: **Use WSL (Recommended)**
```bash
# Install WSL if not already
wsl --install

# Then run setup.sh inside WSL
chmod +x setup.sh
./setup.sh
```

Option 2: **Manual Setup**

Since `setup.sh` is a bash script, manually create files:

1. Create `.claude.json` in your home directory:
   ```
   C:\Users\YourName\.claude.json
   ```

   Copy contents from `.claude.json.template`

2. Create hooks directory:
   ```
   C:\Users\YourName\.claude\hooks\
   ```

3. Copy hook files there

4. Add aliases to PowerShell profile:
   ```
   $PROFILE
   ```

---

### **Problem: Shell aliases don't work on Windows**

**Solution:**

Windows PowerShell uses different syntax. Create aliases in your PowerShell profile:

```powershell
# Open profile
notepad $PROFILE

# Add these aliases
Set-Alias -Name cc-budget -Value 'claude-code /budget'
Set-Alias -Name cc-reset -Value 'claude-code /reset'
```

Or use `doskey` for CMD:
```cmd
doskey cc-budget=claude-code /budget
doskey cc-reset=claude-code /reset
```

---

## 🟣 Advanced Issues

### **Problem: Multiple projects with different budgets**

**Solution:**

Create separate `.claude.json` for each project:

```bash
# Project A
cp .claude.json.template project-a/.claude.json

# Project B
cp .claude.json.template project-b/.claude.json
```

Edit each with their own budget, then when in that directory, it'll use local config.

---

### **Problem: Team setup - shared configuration**

**Solution:**

Create a shared config in your team's repo:

```bash
# Team repo root
.claude.json (shared config)
.claude/hooks/ (shared hooks)
```

Team members clone repo and run `setup.sh` once. Their personal budget overrides during setup.

---

### **Problem: Hooks conflicting with other tools**

**Solution:**

Rename hook files to be more specific:

```bash
mv ~/.claude/hooks/check-scope.js \
   ~/.claude/hooks/claude-check-scope.js
```

Or disable individual hooks by removing the export statement:

```javascript
// Disable this hook
// module.exports = { 'user-prompt-submit': ... }
```

---

## 🔧 Debug Mode

### **Enable detailed logging:**

Edit `.claude.json`:
```json
"debug": {
  "log_level": "verbose",
  "log_file": "~/.claude/debug.log"
}
```

Then check logs:
```bash
tail -f ~/.claude/debug.log
```

---

### **Test individual hooks:**

```bash
# Test vague request detection
node ~/.claude/hooks/check-scope.js

# Test token alerts
node ~/.claude/hooks/token-alerts.js
```

---

## 📞 Still Having Issues?

### **Check these first:**

1. ✅ Did you run `chmod +x setup.sh`?
2. ✅ Did you reload your shell (`source ~/.zshrc`)?
3. ✅ Does `~/.claude.json` exist? (`ls ~/.claude.json`)
4. ✅ Is your budget a number, not text?

### **Get help:**

- 📖 Re-read [README.md](README.md) - Quick Start section
- 📋 Check [Setup Guide](CLAUDE_CODE_SETUP_BEST_PRACTICES.md)
- 💬 Open a GitHub issue with:
  - What you were trying to do
  - What error you got
  - Output of: `echo $SHELL` and `ls ~/.claude.json`

---

## 🚀 Quick Fixes Checklist

- [ ] Run `chmod +x setup.sh` before executing
- [ ] Reload shell: `source ~/.zshrc`
- [ ] Check `.claude.json` exists: `cat ~/.claude.json`
- [ ] Verify hooks directory: `ls ~/.claude/hooks/`
- [ ] Test simple command: `cc-budget`
- [ ] Check hook syntax: `cat ~/.claude/hooks/check-scope.js`
- [ ] Increase log level for debugging
- [ ] Check file paths use `~` not absolute paths
- [ ] Ensure budget is a number, not text
- [ ] On Windows? Try WSL

---

**Still stuck?** Open an issue at:
https://github.com/the-vibe-marketers/claudecodeoptimization/issues
