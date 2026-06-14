# 📋 Team Guidelines for PR Validation System

This document outlines best practices for your team when working with the GitHub Actions PR validation system.

## 🎯 Team Objectives

- **Code Quality:** Maintain consistent, high-quality code across all environments
- **Collaboration:** Clear communication through PR descriptions and reviews
- **Reliability:** Prevent broken code from reaching production
- **Efficiency:** Make the merge process smooth and predictable

## 📝 PR Description Guidelines

### What Makes a Good PR Description

✅ **Good Examples:**
```
Adds new portfolio project showcase section with:
- Responsive grid layout for project cards
- Smooth image lazy loading
- Click-to-expand project details modal
- Improved mobile navigation

Fixes broken external links to GitHub profiles
Updates meta descriptions for better SEO
```

```
Refactors CSS layout system to use CSS Grid
- Improves mobile responsiveness
- Reduces code by 200 lines
- Maintains backward compatibility
- No visual changes to users
```

❌ **Poor Examples:**
```
Update stuff
```

```
Fixed things
```

```
Work in progress
```

### PR Description Checklist

Before creating a PR, ensure your description includes:

- [ ] **What:** What changes are you making?
- [ ] **Why:** Why are these changes needed?
- [ ] **How:** How did you implement the changes?
- [ ] **Testing:** How did you test your changes?
- [ ] **Impact:** What parts of the site are affected?

### Template for PR Descriptions

```markdown
## Description
[Brief summary of changes]

## Changes Made
- [Change 1]
- [Change 2]
- [Change 3]

## Why
[Reason for these changes]

## Testing
- [How you tested these changes]
- [Browser/device tested on]
- [Any edge cases considered]

## Screenshots (if applicable)
[Screenshots or GIFs of visual changes]

## Checklist
- [ ] Code follows project style guidelines
- [ ] I have performed a self-review
- [ ] Changes are tested locally
- [ ] No new warnings or errors introduced
```

### Minimum Requirements

✅ **Your PR description MUST:**
- Be at least 50 characters
- Explain WHAT and WHY
- Be professional and clear

## 🔄 Merge Workflow

### Standard Feature Development

```
1. Create Feature Branch
   git checkout -b feature/description

2. Make Changes & Commit
   git commit -am "Clear commit messages"

3. Push to GitHub
   git push origin feature/description

4. Create PR to 'dev'
   - Clear description (50+ chars)
   - Link related issues if any
   - Request reviewer

5. Address Validation Results
   - Fix any ❌ FAILED checks
   - Review ⚠️ WARNING checks
   - Push fixes (workflow runs again)

6. Get Approval
   - At least 1 approval needed
   - Address review comments
   - Re-request review if needed

7. Merge to dev
   - All checks: ✅ PASSED
   - Has approval: ✅ YES
   - Click "Merge Pull Request"

8. Propagate to test
   Create PR: dev → test
   Repeat steps 4-7

9. Propagate to prod  
   Create PR: test → prod
   Repeat steps 4-7
```

## ✅ Validation Checks: What to Do

### When a Check FAILS ❌

**Action Required:** Fix before merge is allowed

**Process:**
1. Read the PR comment for specific issues
2. Make changes in your branch
3. Commit: `git commit -am "Fix validation issues"`
4. Push: `git push`
5. Workflow runs automatically
6. Repeat until all checks pass

### When a Check Shows WARNINGS ⚠️

**Action Optional:** Can merge but should address

**Examples:**
- Code quality issues (inline styles, console.log)
- File size warnings
- PR description too short

**Recommendation:** Fix warnings when possible for better code quality

### When All Checks PASS ✅

**Action:** Ready to request approval and merge

## 🚫 Common Mistakes to Avoid

### ❌ Empty PR Description
```
Don't do this! This will FAIL validation.
```
**Fix:** Add a meaningful description (minimum 50 characters)

### ❌ Leaving console.log in code
```javascript
function saveData() {
  console.log('Saving...'); // DON'T DO THIS
  saveToDatabase();
}
```
**Fix:** Remove debug statements before committing

### ❌ Inline styles instead of CSS
```html
<!-- Don't do this -->
<div style="color: blue; font-size: 16px;">Text</div>

<!-- Do this instead -->
<div class="text">Text</div>
<!-- Then define in CSS -->
```

### ❌ Missing alt attributes on images
```html
<!-- Don't do this -->
<img src="photo.jpg">

<!-- Do this instead -->
<img src="photo.jpg" alt="Description of image">
```

### ❌ Broken internal links
```html
<!-- Don't do this - file doesn't exist -->
<a href="./about-page.html">About</a>

<!-- Do this - file exists at this path -->
<a href="./about.html">About</a>
```

## 🎓 Best Practices

### 1. Commit Messages

Use clear, concise commit messages:

```
✅ Good:
  - "Add new project showcase section"
  - "Fix broken portfolio links"
  - "Update mobile navigation styles"

❌ Bad:
  - "stuff"
  - "fix"
  - "changes"
  - "asdf"
```

### 2. PR Size

Keep PRs focused and reasonably sized:

```
✅ Good:
  - Single feature or fix per PR
  - 200-500 lines changed
  - Solves one problem

❌ Bad:
  - Multiple unrelated features
  - 2000+ lines changed
  - Mixed refactoring and new features
```

### 3. Code Review

When reviewing others' code:

```
✅ Do:
  - Be constructive and kind
  - Ask questions if unclear
  - Suggest improvements
  - Approve when satisfied

❌ Don't:
  - Use harsh language
  - Nitpick style issues (tools do this)
  - Block on minor issues
  - Approve without reading
```

### 4. Testing

Before creating a PR:

- [ ] Test locally on your machine
- [ ] Test in multiple browsers (if front-end)
- [ ] Test on mobile (if responsive)
- [ ] Verify links work
- [ ] Check for console errors

## 🌳 Branch Naming Conventions

Use consistent branch names:

```
feature/short-description      (New features)
fix/bug-description           (Bug fixes)
refactor/change-description   (Code improvements)
docs/documentation-update     (Documentation)
chore/maintenance-task        (Maintenance)
```

Examples:
```
✅ Good:
  - feature/portfolio-projects-section
  - fix/broken-github-links
  - refactor/css-to-grid-layout
  - docs/update-readme
  - chore/upgrade-dependencies

❌ Bad:
  - my-branch
  - update
  - fix-stuff
  - changes
```

## 📊 Approval Process

### Who Should Approve?

- **For dev:** Any team member familiar with the code
- **For test:** Same person or someone else who tested
- **For prod:** Any team member (currently set to 1, can change)

### Approval Checklist

Before approving a PR, verify:

- [ ] Code changes make sense
- [ ] PR description is clear
- [ ] All validation checks pass ✅
- [ ] No security concerns
- [ ] Tested or reviewed code quality
- [ ] Branch is up to date
- [ ] Commit messages are clear

## 🔐 Production Safety (prod branch)

### Before Merging to Production

1. **All checks must pass:** ✅
2. **Code must be approved:** ✅  
3. **Code must work on test:** ✅
4. **No force pushes:** Ever!

### Emergency Hotfix Process

If production needs urgent fix:

1. Create hotfix branch from `prod`
2. Make minimal changes only
3. Create PR to `prod`
4. Get quick approval
5. Merge when checks pass
6. **Important:** Backport to `test` and `dev` after!

```bash
# Hotfix workflow
git checkout prod
git pull origin prod
git checkout -b hotfix/critical-bug-fix
# Make changes
git commit -am "Critical: Fix production issue"
git push origin hotfix/critical-bug-fix
# Create PR on GitHub
# After merge to prod:
git checkout test
git pull origin test
git merge prod
git push origin test
# Create PR: test → dev if needed
```

## 📈 Performance Tips

### Speed Up Your PR Process

1. **Write good descriptions upfront** - Reduces review time
2. **Fix issues immediately** - Don't let them accumulate
3. **Review your own code first** - Catch obvious issues early
4. **Request small PRs** - Faster to review and merge
5. **Keep branches up to date** - Avoid merge conflicts

### If Workflow is Slow

Average runtime is 30-45 seconds. If slower:
- Check if GitHub Actions is experiencing issues
- Look at workflow logs in Actions tab
- Check for external link validation timeout

## 🆘 Conflict Resolution

### If Your PR Has Conflicts

```bash
# Pull latest from base branch
git fetch origin

# Rebase on main branch
git rebase origin/dev

# Fix conflicts in editor, then:
git add .
git rebase --continue

# Force push (only to your feature branch!)
git push origin feature/name -f
```

### If Someone Blocked Your Merge

1. **Ask why** - Politely request clarification
2. **Address concerns** - Make requested changes
3. **Re-request approval** - Don't merge without!

## 🎉 Success Example

### Complete PR Workflow Example

```
Step 1: Create PR
  ✅ Branch name: feature/add-testimonials
  ✅ Description: "Add testimonials section with..."
  ✅ Targeted: dev

Step 2: Wait for validation (30-45 seconds)
  ✅ PR Description: PASS
  ✅ HTML Validation: PASS
  ✅ Code Quality: PASS (1 warning about inline style)
  ✅ Link Validation: PASS
  ✅ File Size: PASS

Step 3: Fix warning
  - Remove inline style: `<div style="...">` → CSS class
  - Commit and push
  - Workflow runs again

Step 4: All checks pass again
  ✅ All validations: PASS
  ⚠️ Code quality warning gone
  → Ready for review

Step 5: Get approval
  - Request review from teammate
  - They review and approve ✅

Step 6: Merge to dev
  - All checks: ✅
  - Has approval: ✅
  - Click "Merge Pull Request"

Step 7: Propagate to test
  - Create PR: dev → test
  - Follow same process
  - Merge to test

Step 8: Propagate to prod
  - Create PR: test → prod
  - All checks pass
  - Get approval
  - Merge to prod ✅
```

## 📚 References

- [QUICK_START.md](QUICK_START.md) - How to use the system
- [WORKFLOWS.md](WORKFLOWS.md) - Detailed check explanations
- [BRANCH_PROTECTION_SETUP.md](BRANCH_PROTECTION_SETUP.md) - Setup guide
- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## ❓ FAQ

**Q: Can I bypass validation checks?**  
A: No. Branch protection requires all checks to pass. This is intentional to maintain quality.

**Q: What if validation is wrong about my code?**  
A: Report it! Update `.github/workflows/pr-validation.yml` to fix false positives.

**Q: How do I revert a bad merge?**  
A: Use `git revert <commit-hash>` to create a new commit that undoes changes. Don't force push!

**Q: Can I merge multiple features at once?**  
A: Keep features separate for easier review and rollback if needed.

**Q: What's the best time to create PRs?**  
A: Anytime! But doing so at start of day allows time for review and fixes.

---

**Version:** 1.0  
**Last Updated:** June 2024  
**Team:** Portfolio Development
