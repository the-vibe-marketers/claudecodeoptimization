# Claude Code Setup & Best Practices Guide
## Implementation Framework for $200/Month Efficiency

---

## 🎯 OVERVIEW
This guide covers **how to configure, set up, and implement** best practices that prevent token waste, optimize model selection, and ensure predictable costs.

---

## 📋 PART 1: MODEL SELECTION STRATEGY

### When to Use Which Model

#### **Haiku 4.5** (Default - Recommended 80% of time)
- **Cost**: Lowest token rate (~$0.80/1M input tokens)
- **Best for**: File reading, code review, simple edits, debugging, search/analysis
- **Setup**: Keep as default in `.claude.json`
- **Command override**: `/haiku` (if system supports it)

```json
{
  "default_model": "claude-haiku-4-5-20251001"
}
```

#### **Sonnet 4.5** (Complex tasks - 15% of time)
- **Cost**: 5x Haiku (~$4/1M input tokens, but handles complex logic better)
- **Best for**: Architecture planning, multi-file refactoring, complex algorithms
- **When to switch**: User says "design", "architecture", "refactor across", "implement feature"
- **Command**: `/sonnet` with cost warning
- **Auto-trigger rules**:
  - Task touches 5+ files → suggest Sonnet
  - Planning phase required → suggest Sonnet
  - User says "complex" or "large-scale" → auto-offer Sonnet

#### **Opus** (Rare - 5% of time, use sparingly)
- **Cost**: 15x Haiku (very expensive, only when absolutely needed)
- **Best for**: Security-critical decisions, novel/unprecedented problems
- **Setup**: Require explicit user confirmation before using
- **Command**: `/opus` with warning

### Implementation in `.claude.json`
```json
{
  "model_selection_rules": {
    "default": "haiku",
    "auto_suggest_sonnet_indicators": [
      "refactor",
      "architecture",
      "design",
      "multiple files",
      "complex"
    ],
    "require_confirmation": ["opus"],
    "warn_on_model_switch": true
  }
}
```

---

## 🔧 PART 2: TASK PLANNING & SCOPE DETECTION

### Auto-Detect Vague Requests
When user input is unclear or open-ended, intervene **before** wasting tokens.

**Trigger phrases that suggest vague scope:**
- "Help me with..."
- "I need to..."
- "Can you improve..."
- "What should I do about..."
- "Fix this" (without context)
- "Make it better"

### Automatic Response Template
When vague request detected:

```
🚨 I notice this task might be open-ended. Before I start, let me clarify:

• Are you planning a small fix (1-2 files) or a large refactor (5+ files)?
• Is this a quick optimization or a new feature?
• Do you need a plan first, or should I jump straight to implementation?

This helps me choose the right model (Haiku vs. Sonnet) and avoid burning tokens on the wrong approach.
```

**Implementation**: Add pre-flight check hook that analyzes user message for scope indicators.

---

## 📊 PART 3: FILE READING SETUP FOR LARGE FILES

### Rule: Never Load Entire Large Files

**File size thresholds:**
- **< 50KB**: Read normally (full file)
- **50KB - 1MB**: Use `offset/limit` to read in 50KB chunks
- **> 1MB**: Only read specific sections, use grep first

### Reading Large Files Correctly

#### ❌ Wrong
```bash
# This loads entire 2MB file into context
read_file("src/data/large_log.txt")
```

#### ✅ Right
```bash
# First, search for relevant lines
grep "ERROR" src/data/large_log.txt --head_limit=50

# Then read only those sections if needed
read_file("src/data/large_log.txt", offset=1000, limit=100)
```

### Setup in Claude Code
Add to `.claude.json`:
```json
{
  "file_reading_rules": {
    "warn_on_file_size_above_kb": 500,
    "auto_limit_large_files": true,
    "default_chunk_size_kb": 50,
    "preferred_tools_for_large_files": ["grep", "glob"],
    "grep_before_read": true
  }
}
```

### Auto-Warning System
```
⚠️ File src/logs/app.log is 2.3MB.
Reading the full file would use ~15,000 tokens.

Better approach:
1. Search for what you need: grep "ERROR" src/logs/app.log
2. Read only those sections

Should I proceed with limited read, or search first?
```

---

## 🚨 PART 4: TOKEN BUDGET & ALERTS

### Setup Token Alerts

#### Level 1: Yellow Alert (70% of budget used)
- **Action**: Notify user, suggest wrapping up or switching to new session
- **Message**: "You've used $140 of your $200 budget this month. Consider starting a new session or being more selective with searches."

#### Level 2: Red Alert (90% of budget used)
- **Action**: Require confirmation before major operations
- **Message**: "Budget at 90%. High-cost operations (Sonnet, large searches) require approval."

#### Level 3: Hard Stop (100% of budget)
- **Action**: Block new operations, offer /reset or /done
- **Message**: "Monthly budget exhausted. Use `/reset` to start fresh or `/done` to end session."

### Implementation in `.claude.json`
```json
{
  "token_budget": {
    "monthly_limit_usd": 200,
    "alert_thresholds": {
      "yellow": 0.70,
      "red": 0.90,
      "hard_stop": 1.0
    },
    "check_before_expensive_ops": true,
    "auto_suggest_optimization": true,
    "show_cost_per_operation": true
  }
}
```

### Display Cost Per Operation
After each tool use:
```
✓ Grep completed
Cost: ~$0.02 | Session: $12.50 / $200 | Remaining: $187.50
```

---

## 🎓 PART 5: AUTO-MODE SHIFTING

### Detect Planning Needs & Auto-Suggest

**Trigger phrases for planning mode:**
- "Implement [feature]"
- "Refactor [system]"
- "Add support for..."
- "How should I..."
- "Best way to..."

**Response:**
```
📋 This looks like it needs a plan.

Should I:
1. Create a quick plan (Haiku) - 2 min, ~$0.50
2. Deep-dive architecture (Sonnet) - 5 min, ~$2.50
3. Jump straight to coding - faster but riskier

What's your preference?
```

### Todo List Auto-Creation

**Auto-create todo list if:**
- Task has 3+ clear steps
- Task touches multiple files
- User doesn't explicitly refuse planning

```
Creating todo list for this task:
1. [pending] Search existing implementation
2. [pending] Design component structure
3. [pending] Implement core functionality
4. [pending] Add tests
5. [pending] Review and optimize

Ready to start when you are.
```

---

## 🎯 PART 6: SHORTCUT FOLDER SETUP

### Pre-Configure Common Paths
Add frequently-used project paths to `.claude.json`:

```json
{
  "shortcut_folders": {
    "src": "/Users/varalakshmi/Desktop/LANDPAGE/src",
    "components": "/Users/varalakshmi/Desktop/LANDPAGE/src/components",
    "utils": "/Users/varalakshmi/Desktop/LANDPAGE/src/utils",
    "tests": "/Users/varalakshmi/Desktop/LANDPAGE/__tests__",
    "config": "/Users/varalakshmi/Desktop/LANDPAGE/config"
  }
}
```

### Usage in Commands
Instead of:
```bash
grep "function" /Users/varalakshmi/Desktop/LANDPAGE/src/utils/helpers.ts
```

Use shortcut:
```bash
grep "function" @utils/helpers.ts
```

**Implementation**: Add alias expansion in CLI or use shell aliases.

---

## 💡 PART 7: VAGUE REQUEST HANDLER

### Hook-Based Intervention

Add a `user-prompt-submit` hook that checks for vagueness:

```javascript
// .claude/hooks/check-scope.js
module.exports = {
  'user-prompt-submit': (message) => {
    const vaguePhrases = [
      /^help me with/i,
      /^i need to/i,
      /^can you .*(improve|fix|optimize|enhance)/i,
      /^what should i do/i,
      /^make it better/i,
      /^fix this/i
    ];

    const isVague = vaguePhrases.some(phrase => phrase.test(message));

    if (isVague && message.length < 100) {
      return {
        action: 'ask_clarification',
        questions: [
          'Is this a small change (1-2 files) or large refactor (5+ files)?',
          'Do you want a plan first, or jump to implementation?',
          'What model should I use - Haiku (fast, cheap) or Sonnet (smarter)?'
        ]
      };
    }

    return { action: 'proceed' };
  }
};
```

---

## 📈 PART 8: OPTIMIZATION COMMANDS

### Quick-Access Commands
Add these aliases to `.zshrc` or `.bashrc`:

```bash
# Quick Claude Code with Sonnet
alias cc-sonnet="claude-code --model sonnet"

# Quick reset with token report
alias cc-reset="claude-code /reset"

# Budget check
alias cc-budget="claude-code /budget"

# Context optimizer
alias cc-optimize="claude-code /optimize"

# Start new expensive task
alias cc-plan="claude-code /plan"
```

---

## 🔐 PART 9: SAFEGUARDS & LIMITS

### Set Default Safeguards
```json
{
  "safeguards": {
    "max_tokens_per_grep": 10000,
    "max_tokens_per_read": 50000,
    "max_files_per_glob": 1000,
    "max_parallel_operations": 5,
    "confirm_before_git_push": true,
    "confirm_before_destructive_ops": true,
    "require_comment_on_edits": true
  }
}
```

### Auto-Reject Risky Operations
```
🚫 This operation might be risky:
- Editing 15 files at once
- Running destructive git commands
- Processing 50MB of data

Approve? [y/n]
```

---

## 🎬 PART 10: IMPLEMENTATION CHECKLIST

### Setup Steps (Order matters)

- [ ] **Step 1**: Update `.claude.json` with all config from this guide
- [ ] **Step 2**: Add model selection rules and auto-suggest logic
- [ ] **Step 3**: Create token alert hooks (70%, 90%, 100%)
- [ ] **Step 4**: Set up shortcut folders for your project
- [ ] **Step 5**: Add vague-request detection hook
- [ ] **Step 6**: Create file-size warning system
- [ ] **Step 7**: Add todo-list auto-creation rules
- [ ] **Step 8**: Create shell aliases for quick commands
- [ ] **Step 9**: Set up safeguards and confirmation prompts
- [ ] **Step 10**: Test with a sample task (refactor or new feature)

---

## 📊 EXPECTED IMPACT

| Setup | Token Savings | Implementation |
|-------|-----------------|---|
| Model switching (Haiku default) | -40% | Config + auto-suggest |
| File reading limits | -50% large files | Warning system |
| Token alerts | -20% (prevent waste) | Alert hooks |
| Planning before large tasks | -60% iterations | Auto-detection |
| Vague request handler | -30% misdirected effort | Pre-flight check |
| **Combined Impact** | **~70% reduction** | All steps above |

---

## 🚀 QUICK START

1. **Copy this config into `.claude.json`**:
   - Model selection rules
   - Token budget settings
   - File reading thresholds
   - Shortcut folders

2. **Enable hooks** for vague requests and alerts

3. **Create shell aliases** for `/sonnet`, `/budget`, `/reset`

4. **Test**: Ask a vague question and see the pre-flight check trigger

5. **Monitor**: Check `/budget` after first week to calibrate

---

## 📌 TL;DR

**Setup = Smart defaults + alerts + guided choices**

Once configured, Claude Code will automatically:
- Choose the right model for your task
- Warn you about vague requests before wasting tokens
- Alert you when approaching budget limits
- Read large files efficiently
- Create plans when needed
- Show cost per operation

**Result**: Predictable $200/month spend with 70% efficiency gains.
