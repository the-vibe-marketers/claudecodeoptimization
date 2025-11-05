#!/bin/bash

# Claude Code Efficiency Setup Script
# This script configures Claude Code for optimal token usage and cost management

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║       Claude Code Efficiency Setup                         ║"
echo "║  Configure your Claude Code for optimal token usage        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to get user input with validation
get_budget() {
    while true; do
        echo -e "${YELLOW}Enter your monthly Claude Code budget in USD (e.g., 50, 200, 1000):${NC}"
        read -p "> \$" budget

        # Check if input is a number
        if ! [[ "$budget" =~ ^[0-9]+(\.[0-9]{2})?$ ]]; then
            echo -e "${RED}❌ Invalid input. Please enter a valid number (e.g., 200 or 50.50)${NC}"
            continue
        fi

        # Check if budget is reasonable
        if (( $(echo "$budget < 10" | bc -l) )); then
            echo -e "${RED}❌ Budget seems very low. Are you sure? (minimum recommended: \$10)${NC}"
            read -p "Continue anyway? (y/n): " continue_low
            if [[ "$continue_low" != "y" ]]; then
                continue
            fi
        fi

        break
    done
}

# Function to get model preference
get_default_model() {
    echo -e "${YELLOW}Which model should be your default? (recommended: haiku)${NC}"
    echo "  1. haiku (fastest, cheapest, recommended for 80% of tasks)"
    echo "  2. sonnet (smarter, 5x cost, for complex tasks)"
    read -p "Enter choice (1-2): " model_choice

    case $model_choice in
        1)
            default_model="claude-haiku-4-5-20251001"
            ;;
        2)
            default_model="claude-sonnet-4-5-20250929"
            ;;
        *)
            echo -e "${YELLOW}Using default: haiku${NC}"
            default_model="claude-haiku-4-5-20251001"
            ;;
    esac
}

# Function to check if directory exists, create if not
ensure_directory() {
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
        echo -e "${GREEN}✓ Created directory: $1${NC}"
    fi
}

# Function to backup existing config
backup_existing_config() {
    if [[ -f "$HOME/.claude.json" ]]; then
        backup_file="$HOME/.claude.json.backup.$(date +%s)"
        cp "$HOME/.claude.json" "$backup_file"
        echo -e "${YELLOW}⚠️  Backed up existing .claude.json to: $backup_file${NC}"
    fi
}

# Main setup flow
echo -e "${BLUE}Step 1: Budget Configuration${NC}"
echo "This helps set up token usage alerts and cost tracking."
echo ""
get_budget

echo -e "${BLUE}Step 2: Model Selection${NC}"
echo "Choose your default model for optimal cost/performance."
echo ""
get_default_model

echo -e "${BLUE}Step 3: Creating Configuration${NC}"
echo ""

# Calculate alert thresholds
alert_70=$(echo "scale=2; $budget * 0.70" | bc -l)
alert_90=$(echo "scale=2; $budget * 0.90" | bc -l)

# Ensure directories exist
ensure_directory "$HOME/.claude"
ensure_directory "$HOME/.claude/hooks"

# Backup existing config
backup_existing_config

# Create .claude.json
cat > "$HOME/.claude.json" << EOF
{
  "default_model": "$default_model",
  "token_budget": {
    "monthly_limit_usd": $budget,
    "alert_thresholds": {
      "yellow": 0.70,
      "red": 0.90,
      "hard_stop": 1.0
    },
    "check_before_expensive_ops": true,
    "auto_suggest_optimization": true,
    "show_cost_per_operation": true
  },
  "file_reading_rules": {
    "warn_on_file_size_above_kb": 500,
    "auto_limit_large_files": true,
    "default_chunk_size_kb": 50,
    "preferred_tools_for_large_files": ["grep", "glob"],
    "grep_before_read": true
  },
  "model_selection_rules": {
    "default": "$default_model",
    "auto_suggest_sonnet_indicators": [
      "refactor",
      "architecture",
      "design",
      "multiple files",
      "complex"
    ],
    "require_confirmation": ["opus"],
    "warn_on_model_switch": true
  },
  "safeguards": {
    "max_tokens_per_grep": 10000,
    "max_tokens_per_read": 50000,
    "max_files_per_glob": 1000,
    "max_parallel_operations": 5,
    "confirm_before_git_push": true,
    "confirm_before_destructive_ops": true
  },
  "shortcut_folders": {
    "src": "./src",
    "components": "./src/components",
    "utils": "./src/utils",
    "tests": "./__tests__",
    "config": "./config"
  }
}
EOF

echo -e "${GREEN}✓ Created .claude.json${NC}"
echo "  Budget: \$$budget/month"
echo "  Default Model: $default_model"
echo "  Yellow Alert: \$$alert_70 (70%)"
echo "  Red Alert: \$$alert_90 (90%)"

# Create hook files
echo ""
echo -e "${BLUE}Step 4: Installing Hooks${NC}"
echo ""

# Check-scope hook
cat > "$HOME/.claude/hooks/check-scope.js" << 'EOF'
/**
 * Vague Request Detection Hook
 * Triggers pre-flight checks for unclear tasks before wasting tokens
 */
module.exports = {
  'user-prompt-submit': (message) => {
    const vaguePhrases = [
      /^help me with/i,
      /^i need to/i,
      /^can you .*(improve|fix|optimize|enhance|update)/i,
      /^what should i do/i,
      /^make it better/i,
      /^fix this$/i,
      /^check this$/i
    ];

    const isVague = vaguePhrases.some(phrase => phrase.test(message));
    const isTooShort = message.length < 80;

    if (isVague && isTooShort) {
      console.warn('\n⚠️  Vague request detected. Consider clarifying:');
      console.warn('   • Is this a small fix (1-2 files) or large refactor (5+ files)?');
      console.warn('   • Do you want a plan first, or jump to implementation?');
      console.warn('   • Specific file names help avoid token waste.\n');
    }

    return { action: 'proceed' };
  }
};
EOF
echo -e "${GREEN}✓ Created check-scope hook${NC}"

# Token alerts hook
cat > "$HOME/.claude/hooks/token-alerts.js" << 'EOF'
/**
 * Token Budget Alert Hook
 * Monitors spending and warns before hitting limits
 */
module.exports = {
  'token-usage-update': (usage) => {
    const { used, limit, percentage } = usage;

    if (percentage >= 0.90) {
      console.warn('\n🚨 RED ALERT: 90% of monthly budget used');
      console.warn(`   Spent: $${used} / $${limit}`);
      console.warn('   High-cost operations (Sonnet, large searches) require approval.\n');
    } else if (percentage >= 0.70) {
      console.warn('\n⚠️  YELLOW ALERT: 70% of monthly budget used');
      console.warn(`   Spent: $${used} / $${limit}`);
      console.warn('   Consider optimizing or starting a new session.\n');
    }
  }
};
EOF
echo -e "${GREEN}✓ Created token-alerts hook${NC}"

# File size warning hook
cat > "$HOME/.claude/hooks/file-size-warning.js" << 'EOF'
/**
 * File Size Warning Hook
 * Warns when attempting to read large files
 */
module.exports = {
  'before-read-file': (filePath, fileSize) => {
    const SIZE_WARNING_KB = 500;
    const fileSizeKB = fileSize / 1024;

    if (fileSizeKB > SIZE_WARNING_KB) {
      console.warn(`\n⚠️  Large file detected: ${(fileSizeKB / 1024).toFixed(2)}MB`);
      console.warn('   Consider using grep first to find relevant sections.');
      console.warn('   Example: grep "your_search" ' + filePath + '\n');
    }
  }
};
EOF
echo -e "${GREEN}✓ Created file-size-warning hook${NC}"

# Create shell aliases
echo ""
echo -e "${BLUE}Step 5: Shell Configuration${NC}"
echo ""

# Detect shell
if [[ "$SHELL" == *"zsh"* ]]; then
    shell_config="$HOME/.zshrc"
    shell_name="zsh"
elif [[ "$SHELL" == *"bash"* ]]; then
    shell_config="$HOME/.bashrc"
    shell_name="bash"
else
    shell_config="$HOME/.bashrc"
    shell_name="bash (default)"
fi

# Add aliases if not already present
if ! grep -q "alias cc-budget" "$shell_config"; then
    cat >> "$shell_config" << 'EOF'

# Claude Code Efficiency Aliases
alias cc-budget="claude-code /budget"
alias cc-reset="claude-code /reset"
alias cc-optimize="claude-code /optimize"
alias cc-sonnet="claude-code --model claude-sonnet-4-5-20250929"
alias cc-plan="claude-code --ask-for-plan"
EOF
    echo -e "${GREEN}✓ Added aliases to $shell_name config${NC}"
    echo "  Use: cc-budget, cc-reset, cc-optimize, cc-sonnet, cc-plan"
else
    echo -e "${YELLOW}⚠️  Aliases already present in $shell_config${NC}"
fi

# Setup 6-hour token cost alerts via cron
echo ""
echo -e "${BLUE}Step 6: Setting Up 6-Hour Cost Alerts${NC}"
echo ""

# Create alert script in hooks directory
cat > "$HOME/.claude/hooks/token-6hour-alert.sh" << 'EOF'
#!/bin/bash
# Claude Code 6-Hour Token & Cost Alert
BUDGET=$(grep -o '"monthly_limit_usd"[^,]*' "$HOME/.claude.json" | grep -o '[0-9]*' | head -1)
SESSION_FILE="$HOME/.claude/.session_tokens.json"
[ ! -f "$SESSION_FILE" ] && exit 0
SESSION_DATA=$(cat "$SESSION_FILE")
TOKENS_USED=$(echo "$SESSION_DATA" | grep -o '"tokensUsed"[^,]*' | grep -o '[0-9]*' | head -1)
COST_SO_FAR=$(echo "$SESSION_DATA" | grep -o '"costSoFar"[^,]*' | grep -o '[0-9.]*' | head -1)
OPERATIONS=$(echo "$SESSION_DATA" | grep -o '"operation"' | wc -l)
PERCENT_USED=$(echo "scale=1; ($COST_SO_FAR / $BUDGET) * 100" | bc 2>/dev/null || echo "0.0")
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "   🕐 6-HOUR TOKEN & COST REPORT"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "   Tokens Used: ${TOKENS_USED:=0}"
echo "   Operations: $OPERATIONS actions"
echo "   Cost So Far: \$$COST_SO_FAR"
echo "   Budget: \$$BUDGET/month"
echo "   Used: ${PERCENT_USED}%"
echo "   Remaining: \$$(echo "scale=2; $BUDGET - $COST_SO_FAR" | bc)"
echo ""
if (( $(echo "$PERCENT_USED >= 90" | bc -l) )); then
  echo "   🔴 STATUS: CRITICAL - HIGH USAGE"
elif (( $(echo "$PERCENT_USED >= 70" | bc -l) )); then
  echo "   🟡 STATUS: WARNING - 70%+ USED"
else
  echo "   🟢 STATUS: HEALTHY - GOOD PACE"
fi
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
EOF

chmod +x "$HOME/.claude/hooks/token-6hour-alert.sh"

# Add cron job (every 6 hours: at 12am, 6am, 12pm, 6pm)
(crontab -l 2>/dev/null | grep -v "token-6hour-alert" || true; echo "0 0,6,12,18 * * * $HOME/.claude/hooks/token-6hour-alert.sh") | crontab - 2>/dev/null && \
echo -e "${GREEN}✓ 6-hour cost alerts enabled${NC}" || \
echo -e "${YELLOW}⚠️  Could not set up cron (optional - you can run alerts manually)${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Setup Complete! 🎉                                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Configuration Summary:${NC}"
echo "  • Monthly Budget: \$$budget"
echo "  • Default Model: $default_model"
echo "  • Config Location: $HOME/.claude.json"
echo "  • Hooks Location: $HOME/.claude/hooks/"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Reload your shell: source $shell_config"
echo "  2. Test it: claude-code /budget"
echo "  3. Read the guides: https://github.com/the-vibe-marketers/claudecodeoptimization"
echo ""
echo -e "${BLUE}Quick Commands:${NC}"
echo "  • cc-budget     → Check remaining budget"
echo "  • cc-reset      → Start fresh session"
echo "  • cc-optimize   → Get optimization tips"
echo "  • cc-sonnet     → Switch to Sonnet model"
echo "  • cc-plan       → Request planning phase"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
