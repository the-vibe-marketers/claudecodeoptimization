# Claude Code Efficiency Guide
## Maximize Value at $200/Month Per Person

---

## 🤖 AUTOMATIC OPTIMIZATIONS (System-Enabled)
*These run without manual intervention—just use Claude Code normally*

### 1. **Context-Aware Tool Selection**
Claude Code automatically chooses lightweight tools (Grep, Glob) over heavy operations. These filter data locally, reducing tokens by up to 80%.

### 2. **Lazy Tool Loading**
Tool definitions load on-demand, not upfront. A 15-minute debugging session won't pay for loading all tools from day one.

### 3. **Local Data Filtering**
Search results are filtered in the execution environment before returning to the model. A 10,000-row grep result becomes 5 relevant rows—saving 95% of context tokens.

### 4. **Smart File Chunking**
Large files are read in sections (offset/limit parameters). You never load entire 50MB logs into context.

### 5. **Intermediate Result Caching**
Bash operations and tool outputs are cached within a session. Re-running the same grep twice doesn't double the token cost.

### 6. **Parallel Tool Execution**
Independent operations (multiple file reads, simultaneous greps) run in parallel, cutting wall-clock time without additional token cost.

### 7. **Terminal Operation Isolation**
Shell commands execute in your actual environment, not simulated through the model. Loops, conditionals, and I/O happen natively.

### 8. **State Persistence Across Operations**
Git status, previous file reads, and command outputs persist in session memory. You don't re-fetch the same data twice.

### 9. **Built-in Security Sandboxing**
Code execution runs in isolated sandbox with resource limits. No token cost for security overhead—it's infrastructure-level.

### 10. **Progressive Complexity Loading**
As tasks grow, agents (Explore, Plan, general-purpose) are only invoked when needed, not by default. Simple tasks stay cheap.

---

## 👤 MANUAL OPTIMIZATIONS (User-Driven Discipline)
*Best practices you actively apply to amplify efficiency*

### 11. **Use Specialized Agents for Open-Ended Searches**
When exploring unfamiliar codebases, invoke the **Explore** agent instead of running grep manually. It adapts search strategy automatically, cutting trial-and-error iterations by 60%.

**When**: "How does authentication work?" or "Where are API endpoints?"
**Not when**: Looking for a specific file or class name.

### 12. **Request Parallel Processing Explicitly**
When you have 5+ independent tasks, tell Claude Code: *"Run these in parallel"* to batch tool calls. Saves 30-50% of interaction time.

**Example**: "Read these 3 files in parallel" → Single API call vs. 3 sequential calls.

### 13. **Leverage Todo Lists for Complex Projects**
Create a todo list at the start of multi-step work. Claude Code tracks progress, prevents forgotten tasks, and re-prioritizes blockers automatically.

**Impact**: Reduces context-switching overhead by 40%, prevents incomplete implementations.

### 14. **Specify Output Format & Limits**
Use Grep's `head_limit`, `offset`, and `output_mode` parameters. Asking for "all matches" vs. "first 50 matches" is a 10x token difference.

**Example**: `grep pattern --glob="*.ts" --head_limit=20`

### 15. **Ask Before Multi-Step Refactoring**
For tasks touching 5+ files, request a **Plan** before execution. 5 minutes of planning prevents 2 hours of rework due to cascading dependencies.

**Impact**: 70% fewer edit iterations, cleaner commits.

---

## 💰 EFFICIENCY BY THE NUMBERS

| Action | Token Saving | Impact |
|--------|--------------|--------|
| Filter locally (Tip #3) | -80% | $160 saved per month (1 person) |
| Parallel execution (Tip #6) | -40% wall time | Free, faster iterations |
| Agent-guided search (Tip #11) | -60% iterations | One deep search instead of 5 shallow ones |
| Todo list discipline (Tip #13) | -40% context switches | Cleaner code, fewer bugs |
| Planning before refactoring (Tip #15) | -70% edits | Better architecture, fewer commits |

**At $200/month with all tips**: Equivalent to $50-75/month usage through optimization alone.

---

## 🚀 QUICK CHECKLIST

- [ ] **Grep/Glob before Bash**: Use specialized search tools first
- [ ] **Read files with limits**: Use `offset/limit` for large files
- [ ] **Parallel when independent**: Ask for parallel execution on unrelated tasks
- [ ] **Explore for discovery**: Use Explore agent for "how does X work?" questions
- [ ] **Plan before refactoring**: Get a plan for multi-file changes
- [ ] **Todo lists for projects**: Create one for tasks with 3+ steps
- [ ] **Specify result limits**: Always use `head_limit` on large searches

---

## 📌 TL;DR

**Automatic**: Claude Code handles most efficiency through intelligent tool selection and local filtering (98%+ of the work).

**Manual**: Your job is 5 discipline habits—specialized agents, parallel requests, planning, todo lists, and result limits—that unlock the remaining optimization potential.

**Result**: $200/month becomes **$50-75/month equivalent value** through cumulative efficiency gains.