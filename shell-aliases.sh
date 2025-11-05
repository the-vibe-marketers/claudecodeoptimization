# Claude Code Efficiency Aliases
# Add these to your ~/.zshrc or ~/.bashrc
# Source this file or copy the aliases manually

# Quick budget check
alias cc-budget="claude-code /budget"

# Reset session and start fresh
alias cc-reset="claude-code /reset"

# Get optimization suggestions for current task
alias cc-optimize="claude-code /optimize"

# Switch to Sonnet model (for complex tasks)
alias cc-sonnet="claude-code --model claude-sonnet-4-5-20250929"

# Request planning phase before implementation
alias cc-plan="claude-code --ask-for-plan"

# Show token usage context
alias cc-context="claude-code /context-check"

# Done - show cost summary and savings
alias cc-done="claude-code /done"

# View your Claude Code documentation
alias cc-docs="open https://docs.claude.com/en/docs/claude-code/"

# Quick help
alias cc-help="echo 'Available commands: cc-budget, cc-reset, cc-optimize, cc-sonnet, cc-plan, cc-context, cc-done'"
