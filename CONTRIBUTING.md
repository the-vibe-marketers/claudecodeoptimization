# Contributing to Claude Code Optimization

We'd love your contributions! Whether it's bug fixes, improvements, or new features, let's make this better together.

---

## 🚀 How to Contribute

### **1. Found a Bug?**
- Open a GitHub issue with:
  - What went wrong
  - Your setup (OS, shell, budget)
  - Steps to reproduce
  - Error message/output

### **2. Have an Idea?**
- Suggest improvements in Discussions or Issues
- Ideas for new hooks? Share them!
- Better documentation? We'd appreciate it!

### **3. Want to Code?**
1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes
4. Test thoroughly
5. Submit a PR

---

## 📝 Guidelines

### **Code Style**
- Shell scripts: Clear comments, use meaningful variable names
- JavaScript: Use existing code as style reference
- Config files: Keep JSON valid and well-formatted

### **Documentation**
- Update README.md if adding new features
- Add troubleshooting entries for complex changes
- Include examples for new capabilities

### **Testing**
Before submitting PR:
```bash
chmod +x setup.sh
./setup.sh           # Test interactive setup
cc-budget           # Test aliases work
echo $HOME/.claude.json  # Verify config created
```

---

## 🎯 Priority Areas

We're looking for help with:
- [ ] Windows/PowerShell support improvements
- [ ] More example configs (industries, team sizes)
- [ ] Additional hooks (custom workflows)
- [ ] Integration guides (CI/CD, editor plugins)
- [ ] Translations/localization

---

## 📋 PR Checklist

- [ ] Code tested locally
- [ ] No hardcoded values (everything parameterized)
- [ ] Updated documentation if needed
- [ ] Added troubleshooting entry if applicable
- [ ] Follows existing code style
- [ ] No security issues introduced

---

## 🙋 Questions?

Open a GitHub Discussion or Issue. We're here to help!

---

**Thank you for contributing! ❤️**
