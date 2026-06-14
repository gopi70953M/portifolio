# PR Validation System - Quick Start Guide

## What This Does

This repository has a **GitHub Actions workflow** that automatically validates every pull request with:

✅ PR description validation  
✅ HTML5 structure validation  
✅ Code quality checks  
✅ Link validation  
✅ File size warnings  

**Results are posted as a comment on every PR.**

---

## For Developers: How to Work With This

### 1. Create a Feature Branch

```bash
git checkout dev
git pull origin dev
git checkout -b feature/my-new-feature
```

### 2. Make Your Changes

Edit files, then commit:

```bash
git add .
git commit -m "Add new portfolio section"
```

### 3. Push and Create a PR

```bash
git push origin feature/my-new-feature
```

Then on GitHub:
1. Click **"Create Pull Request"**
2. Write a clear description (50+ characters recommended)
3. Set target branch to `dev`, `test`, or `prod`
4. Click **"Create Pull Request"**

### 4. Check Validation Results

Wait 30-45 seconds. The workflow will:
- Run all validations
- Post results as a comment on your PR
- Show pass/fail for each check

All checks must pass before you can merge (based on branch protection rules).

### 5. Fix Any Issues

If checks fail:
1. Read the PR comment for details
2. Fix the issues locally
3. Commit and push: `git commit -am "Fix validation issues" && git push`
4. Checks run again automatically

### 6. Get Approval and Merge

1. Request a reviewer (if not automatically assigned)
2. Once approved + all checks pass → Merge button becomes available
3. Click **"Merge Pull Request"**

---

## Merging Between Environments

### Recommended Flow

```
feature branch
    ↓ PR to dev (runs checks)
    ↓ merge to dev
    ↓
branch to test (or PR dev→test)
    ↓ PR to test (runs checks)
    ↓ merge to test
    ↓
branch to prod (or PR test→prod)
    ↓ PR to prod (runs checks + 1 approval required)
    ↓ merge to prod
```

---

## Understanding PR Comments

### Example Comment

```markdown
# 🔍 PR Validation Report

**Branch Target:** dev
**Triggered by:** @you

## Check Results

✅ **PR Description**: PASSED
✅ **HTML Validation**: PASSED
✅ **Code Quality**: PASSED
✅ **Link Validation**: PASSED
✅ **File Size Check**: PASSED
```

### Meanings

- ✅ **PASSED** - No issues found
- ⚠️ **WARNING** - Issues found but not blocking  
- ❌ **FAILED** - Must be fixed before merge

---

## Common Issues & Fixes

### "HTML Validation FAILED"

**Likely issue:** Missing `alt` attribute on image

**Fix:**
```html
<!-- Change this -->
<img src="photo.jpg">

<!-- To this -->
<img src="photo.jpg" alt="Description of image">
```

### "PR Description is less than 50 characters"

**Fix:** Edit your PR description to be longer and more descriptive.

### "Code Quality: Inline styles found"

**Issue:** Styles are in HTML instead of CSS files

**Fix:**
```html
<!-- Remove this from HTML -->
<div style="color: red;">Text</div>

<!-- Add this to a CSS file instead -->
.text { color: red; }

<!-- Then use class -->
<div class="text">Text</div>
```

### "console.log statements found"

**Fix:** Remove `console.log()` statements before committing:
```javascript
// Remove this
console.log('Debug info');

// Or replace with comments
// Debug: This needs investigation
```

### "Link Validation: Broken link"

**Fix:** Either:
1. Create the file the link points to, OR
2. Fix the link path to point to the correct file

---

## Documentation Files

| File | Purpose |
|------|---------|
| [.github/BRANCH_PROTECTION_SETUP.md](.github/BRANCH_PROTECTION_SETUP.md) | How to configure GitHub branch protection rules |
| [.github/WORKFLOWS.md](.github/WORKFLOWS.md) | Detailed explanation of what each check does |
| [.github/workflows/pr-validation.yml](.github/workflows/pr-validation.yml) | The actual workflow file |

---

## For Administrators: Setup Checklist

- [ ] **Read:** [BRANCH_PROTECTION_SETUP.md](.github/BRANCH_PROTECTION_SETUP.md)
- [ ] **Configure:** Branch protection rules for `dev`, `test`, `prod`
- [ ] **Enable:** Status checks in branch protection (require `validate` to pass)
- [ ] **Test:** Create a test PR and verify workflow runs
- [ ] **Share:** Send developers to this [Quick Start Guide](#for-developers-how-to-work-with-this)

---

## Quick Reference

### Commands

```bash
# Create feature branch from dev
git checkout -b feature/name

# Make changes and commit
git commit -am "Description"

# Push to GitHub
git push origin feature/name

# Then create PR on GitHub.com
# ↑ Workflow runs automatically

# After merge, update local dev
git checkout dev
git pull origin dev
```

### Branch Protection Rules Summary

| Branch | Direct Push | PR Required | Approvals | Checks Required |
|--------|-------------|-------------|-----------|-----------------|
| dev | ❌ Blocked | ✅ Required | 1 | ✅ validate |
| test | ❌ Blocked | ✅ Required | 1 | ✅ validate |
| prod | ❌ Blocked | ✅ Required | 1 | ✅ validate |

---

## What Gets Validated

### PR Description ✍️
- Not empty
- At least 50 characters

### HTML Structure 📄
- Valid HTML5 DOCTYPE
- Required meta tags (charset, viewport, description)
- Title tag present
- All images have alt attributes
- No mismatched tags
- No deprecated tags

### Code Quality 🧹
- No inline styles (use CSS)
- No console.log statements
- No deprecated HTML tags

### Links 🔗
- All internal links point to existing files
- References match actual file paths

### File Sizes 📦
- Individual files under 500KB
- Total repository under 5MB

---

## Performance

- **Check Duration:** ~30-45 seconds
- **Free:** Uses GitHub's free tier (no paid actions)
- **When:** Runs on every PR to dev/test/prod

---

## Need Help?

1. **Workflow failing?** → Check [WORKFLOWS.md](.github/WORKFLOWS.md)
2. **Setup issues?** → Check [BRANCH_PROTECTION_SETUP.md](.github/BRANCH_PROTECTION_SETUP.md)
3. **How do I PR?** → You're reading it!
4. **Fixing validation errors?** → See [Common Issues section](#common-issues--fixes)

---

## Environment Details

| Environment | Purpose | Branch | Approval Required |
|-------------|---------|--------|-------------------|
| **dev** | Development | `dev` | 1 |
| **test** | Testing/Staging | `test` | 1 |
| **prod** | Production | `prod` | 1 |

**Best Practice Flow:**
```
feature → dev (test locally)
dev → test (test staging)
test → prod (go live)
```

---

**Last Updated:** June 2024  
**Status:** ✅ Ready to use
