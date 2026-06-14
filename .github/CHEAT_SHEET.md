# 📋 PR Validation Cheat Sheet

## Quick Reference for Developers

---

## ⚡ TL;DR - One Page Summary

### What Happens
1. You create PR → Workflow runs automatically → Comment appears with results

### How to Create PR
```bash
git checkout -b feature/name
# Make changes
git commit -am "Clear message"
git push origin feature/name
# Open PR on GitHub.com (wait 30-45 seconds for validation)
```

### What Gets Checked
✅ PR description (50+ chars)  
✅ HTML5 structure  
✅ Code quality  
✅ Links  
✅ File sizes

### If Validation Fails
1. Read the PR comment for what failed
2. Fix the issue locally
3. `git commit -am "Fix: [issue]" && git push`
4. Workflow runs again automatically

### Merge When
- ✅ All checks PASS (green)
- ✅ Have 1 approval
- ✅ Branch is up to date

---

## 🐛 Common Issues & Fixes

### ❌ "PR Description is less than 50 characters"
**Fix:** Edit PR description to be longer

### ❌ "Image missing alt attribute"
**Fix:** 
```html
<img src="image.jpg" alt="Description">
```

### ❌ "Inline styles found"
**Fix:** Move to CSS file
```html
<!-- Before -->
<div style="color: red;">Text</div>

<!-- After (in CSS) -->
.text { color: red; }
<div class="text">Text</div>
```

### ❌ "console.log found"
**Fix:** Remove debug statements
```javascript
// Remove this:
console.log('Debug');

// Before submitting
```

### ❌ "Broken internal link"
**Fix:** Check file path matches actual location
```html
<a href="./correct-path/file.html">Link</a>
```

---

## 📝 Git Commands

```bash
# Create branch
git checkout -b feature/description

# Make changes and commit
git add .
git commit -m "Clear description"

# Push to GitHub
git push origin feature/description

# Update if behind
git pull origin dev
git push origin feature/description
```

---

## 🔄 Branch Strategy

```
feature branch
    ↓ PR
   dev ← approved
    ↓ PR
   test ← approved  
    ↓ PR
   prod ← approved ✅
```

**Rule:** Never push directly to dev/test/prod - always use PR!

---

## ✅ Merge Checklist

Before clicking merge:
- [ ] All checks pass (✅ green)
- [ ] Have approval (at least 1)
- [ ] Branch is current
- [ ] No conflicts

---

## 📊 PR Comment Results

### ✅ PASS
Can merge (if approved + all checks pass)

### ⚠️ WARN  
Optional fix (warnings don't block merge)

### ❌ FAIL
**MUST FIX** (blocks merge)

---

## 🚫 Don'ts

❌ Direct push to dev/test/prod  
❌ Empty PR descriptions  
❌ Merge without approval  
❌ Leave console.log in code  
❌ Inline styles in HTML  
❌ Missing image alt attributes  
❌ Broken links  

---

## ✅ Do's

✅ Create feature branch  
✅ Write clear PR description  
✅ Wait for validation (30-45 sec)  
✅ Fix any issues  
✅ Request approval  
✅ Merge when ready  

---

## 🔗 Documentation

- **How to PR:** QUICK_START.md
- **Technical:** WORKFLOWS.md  
- **Setup:** BRANCH_PROTECTION_SETUP.md
- **Team rules:** TEAM_GUIDELINES.md

---

## ❓ Common Questions

**Q: Workflow not running?**  
A: Check Actions tab, or create new PR

**Q: Can't merge?**  
A: Wait for checks, get approval, update branch

**Q: How to see workflow logs?**  
A: GitHub → Actions → click run

**Q: What if validation is wrong?**  
A: Report it, update workflow

---

## 📱 Emergency: Need to Hotfix Production?

```bash
git checkout prod
git pull origin prod
git checkout -b hotfix/emergency-fix
# Fix the issue
git commit -am "Hotfix: Emergency fix"
git push origin hotfix/emergency-fix
# Create PR to prod
# After merge, backport to test and dev
```

---

## 🎯 Target Audience

| Branch | Use Case | Approval |
|--------|----------|----------|
| dev | Development | 1 |
| test | Testing | 1 |
| prod | Live | 1 |

---

## 📞 Help

- Something not working? → Check WORKFLOWS.md
- How do I...? → Check QUICK_START.md
- Team practices? → Check TEAM_GUIDELINES.md
- Setup issue? → Check BRANCH_PROTECTION_SETUP.md

---

## ⏱️ Typical Workflow Time

```
Create PR:         5 min
Wait for checks:   1 min
Get approval:      5-30 min  
Merge:             1 min
─────────────────────────
Total:             15-45 min
```

---

## 💡 Pro Tips

✅ Review your own code first  
✅ Write good commit messages  
✅ Keep PRs small and focused  
✅ Fix issues immediately  
✅ Request review early  
✅ Test locally before pushing  

---

**Bookmark this!** Print or save for quick reference.

Last updated: June 2024
