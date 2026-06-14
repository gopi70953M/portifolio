# 🚀 GitHub Actions PR Validation System

Complete automated validation system for portfolio repository across dev, test, and prod environments.

## 📋 Quick Links

| Document | Purpose |
|----------|---------|
| [QUICK_START.md](QUICK_START.md) | **START HERE** - For developers using this system |
| [WORKFLOWS.md](WORKFLOWS.md) | Detailed explanation of each validation check |
| [BRANCH_PROTECTION_SETUP.md](BRANCH_PROTECTION_SETUP.md) | How to configure GitHub branch protection rules |
| [validation-config.env](validation-config.env) | Configuration reference (future customization) |

## 🎯 What This System Does

Automatically validates every pull request to `dev`, `test`, or `prod` branches with:

```
PR Created
    ↓
Workflow Triggers (30-45 seconds)
    ├─ PR Description Validation
    ├─ HTML5 Structure Validation
    ├─ Code Quality Checks
    ├─ Link Validation  
    └─ File Size Checks
    ↓
Results Posted as PR Comment
    ↓
Merge Allowed/Blocked Based on Results
```

## ✨ Features

- ✅ **Free** - Uses only GitHub's free tier (no paid actions)
- ✅ **Automatic** - Runs on every PR without manual triggers
- ✅ **Non-blocking Warnings** - Warnings don't prevent merges
- ✅ **Blocking Failures** - Critical failures require fixes
- ✅ **Environment-Aware** - Different rules for dev/test/prod
- ✅ **Clear Feedback** - Detailed PR comments with actionable advice

## 📊 Validation Checks

### 1. PR Description Validation ✍️

**Checks:**
- PR description is not empty
- PR description is at least 50 characters

**Status:**
- ✅ PASS if valid
- ⚠️ WARN if too short (< 50 chars)
- ❌ FAIL if empty

**Why:** Good PR descriptions help with code review and history.

### 2. HTML Validation 📄

**Checks:**
- HTML5 DOCTYPE present
- Required meta tags (charset, viewport, description)
- Title tag exists
- All images have alt attributes
- Tags properly matched/closed
- No deprecated HTML tags

**Why:** Ensures accessibility, SEO, and proper rendering.

### 3. Code Quality 🧹

**Checks:**
- No inline styles (should be in CSS)
- No console.log statements
- No deprecated HTML tags

**Why:** Maintains code quality and prevents debug code in production.

### 4. Link Validation 🔗

**Checks:**
- All internal links point to existing files
- File paths are correct

**Why:** Prevents broken links that hurt user experience.

### 5. File Size Check 📦

**Checks:**
- Individual files < 500KB
- Total repository < 5MB

**Why:** Large files slow down repository cloning and CI/CD.

## 🔧 File Structure

```
.github/
├── workflows/
│   └── pr-validation.yml                 # Main workflow file
├── QUICK_START.md                        # Developer guide
├── WORKFLOWS.md                          # Detailed documentation
├── BRANCH_PROTECTION_SETUP.md            # Setup instructions
├── setup-branch-protection.sh            # Helper script
├── validation-config.env                 # Configuration reference
└── README.md                             # This file
```

## 🚀 Getting Started

### For Administrators (Setup)

1. **Ensure you have:**
   - Repository access on GitHub
   - Admin rights to configure branch protection

2. **Configure branch protection:**
   - Read: [BRANCH_PROTECTION_SETUP.md](BRANCH_PROTECTION_SETUP.md)
   - Follow the step-by-step setup instructions
   - Configure for `dev`, `test`, and `prod` branches

3. **Verify workflow:**
   - Go to **Actions** tab in GitHub
   - Create a test PR
   - Verify workflow runs and posts comments

### For Developers (Using It)

1. **First time setup:**
   - Read: [QUICK_START.md](QUICK_START.md)
   - Understand the merge flow

2. **Create a PR:**
   - Create feature branch from `dev`
   - Make changes and commit
   - Push and create PR
   - Wait for validation results

3. **Fix any issues:**
   - Read the PR comment
   - Fix issues in your branch
   - Commit and push (workflow runs again automatically)

4. **Merge when ready:**
   - Get approval
   - All checks must pass
   - Click merge button

## 📈 Branch Strategy

```
                feature/new-feature
                        ↓ PR
                    ← dev ←
                       ↓ PR
                    ← test ←  
                       ↓ PR
                    ← prod
```

**Flow:**
1. Create features from `dev`
2. PR to `dev` (dev environment)
3. PR from `dev` to `test` (testing/staging)
4. PR from `test` to `prod` (production)

Each PR must pass all validations.

## 🛡️ Branch Protection Rules

| Aspect | dev | test | prod |
|--------|-----|------|------|
| Direct Push | ❌ | ❌ | ❌ |
| PR Required | ✅ | ✅ | ✅ |
| Approvals | 1 | 1 | 1 |
| Status Checks | ✅ | ✅ | ✅ |
| Latest Push Approval | ❌ | ❌ | ✅ |

## 💬 PR Comment Example

```markdown
# 🔍 PR Validation Report

**Branch Target:** `prod`
**Triggered by:** @username

## Check Results

✅ **PR Description**: PASSED

✅ **HTML Validation**: PASSED

✅ **Code Quality**: PASSED

✅ **Link Validation**: PASSED

✅ **File Size Check**: PASSED

---

### Next Steps

- This PR targets **prod**. Ensure:
  - ✅ All checks pass
  - ✅ Code has been tested on **test** branch
  - ✅ At least one approval is obtained
```

## 🐛 Troubleshooting

### Workflow Not Running

**Problem:** PR created but workflow doesn't start

**Solution:**
1. Check workflow file exists: `.github/workflows/pr-validation.yml`
2. Verify branches `dev`, `test`, or `prod` exist
3. Check **Actions** tab for any errors
4. Manually trigger by creating/updating PR

### Status Check Not Showing

**Problem:** Branch protection requires status check, but it doesn't appear

**Solution:**
1. Workflow must run at least once successfully
2. Create a test PR to trigger the workflow
3. Wait 5-10 minutes after first run
4. Return to branch protection settings
5. Select `validate` from available checks

### Cannot Merge Even Though All Checks Pass

**Possible causes:**
1. Branch is out of date with base branch
   - **Fix:** Click "Update branch" in PR
2. Review is required but not provided
   - **Fix:** Request review from someone
3. New commits pushed but not re-reviewed
   - **Fix:** Request new review for new commits
4. Status check showing as skipped
   - **Fix:** Close and reopen PR to re-trigger

## ⚙️ Customization

### Change File Size Limits

Edit `.github/workflows/pr-validation.yml`:

```javascript
// Find these lines (~line 380):
const SIZE_LIMIT = 500 * 1024; // 500KB
const REPO_LIMIT = 5 * 1024 * 1024; // 5MB

// Change to your desired limits:
const SIZE_LIMIT = 1 * 1024 * 1024; // 1MB
const REPO_LIMIT = 10 * 1024 * 1024; // 10MB
```

### Add New Validation Check

1. Open `.github/workflows/pr-validation.yml`
2. Add a new step with a name and run command
3. Use `continue-on-error: true` for warnings
4. Update summary step to include your check
5. Update PR comment posting step

See [WORKFLOWS.md](WORKFLOWS.md#customizing-the-workflow) for examples.

## 🔐 Security

- **No secrets used** - Safe for public repositories
- **No external authentication** - Uses GitHub Actions default permissions
- **No data storage** - Validation runs on each PR, nothing persisted
- **No sensitive data logged** - Safe repository data only

## 📊 Performance

- **Execution time:** 30-45 seconds
- **Cost:** Free (GitHub-hosted runners)
- **Frequency:** Every PR to dev/test/prod
- **Timeout:** 10 minutes (GitHub default)

## 🤝 Contributing

This workflow is designed to be self-service:

1. **Need to customize?**
   - Edit `.github/workflows/pr-validation.yml`
   - See [WORKFLOWS.md](WORKFLOWS.md) for details

2. **Found a bug?**
   - Check workflow logs in **Actions** tab
   - Update the workflow file
   - Test with a new PR

3. **Want to add a check?**
   - Add a new JavaScript validation block
   - Update PR comment step to show results
   - Test and commit

## 📚 Documentation

| Document | For | Key Topics |
|----------|-----|-----------|
| QUICK_START.md | Developers | How to use, common issues, fixes |
| WORKFLOWS.md | Technical staff | Detailed check explanations, customization |
| BRANCH_PROTECTION_SETUP.md | Administrators | Step-by-step GitHub configuration |
| validation-config.env | Future use | Configuration reference |

## 🎓 Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub REST API](https://docs.github.com/en/rest)

## ✅ Verification Checklist

Before going live, verify:

- [ ] Workflow file created: `.github/workflows/pr-validation.yml`
- [ ] Branch protection configured for `dev`, `test`, `prod`
- [ ] Test PR created and workflow runs successfully
- [ ] Validation comment appears on PR
- [ ] Merge button respects branch protection rules
- [ ] Developers have access to QUICK_START.md
- [ ] Administrators have access to BRANCH_PROTECTION_SETUP.md

## 🚢 Release Notes

**Version 1.0** - Initial Release
- ✅ PR description validation
- ✅ HTML5 structure validation
- ✅ Code quality checks
- ✅ Link validation
- ✅ File size checks
- ✅ Branch protection setup
- ✅ Complete documentation

## 📞 Support

**For questions:**
1. Check [QUICK_START.md](QUICK_START.md) or [WORKFLOWS.md](WORKFLOWS.md)
2. Review troubleshooting section above
3. Check **Actions** tab for workflow logs
4. Review GitHub Actions documentation

**For bugs/improvements:**
- Edit `.github/workflows/pr-validation.yml`
- Test changes with a new PR
- Document changes in relevant markdown files

---

**Last Updated:** June 2024  
**Status:** ✅ Production Ready  
**Maintenance:** Minimal - Runs automatically
