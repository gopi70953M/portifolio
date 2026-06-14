# GitHub Actions Workflow Documentation

## Overview

This repository uses GitHub Actions to automatically validate pull requests across three environments: **dev**, **test**, and **prod**. The workflow runs on every PR and posts results as a comment on the PR.

---

## Workflow: `pr-validation.yml`

**File Location:** `.github/workflows/pr-validation.yml`

**Triggers:** 
- Pull requests to `dev`, `test`, or `prod` branches
- Runs on: `opened`, `synchronize`, `reopened`

**Status:** ✅ Free tier compatible (no paid actions required)

---

## Validation Checks

### 1. PR Description Validation

**Checks:**
- PR description is not empty
- PR description contains at least 50 characters

**Outcomes:**
- ✅ **PASS**: Description is valid
- ⚠️ **WARN**: Description exists but is less than 50 characters
- ❌ **FAIL**: Description is empty (blocks merge if branch protection enabled)

**Example Output:**
```
✅ PR Description: PASSED
⚠️ PR Description: WARNING - PR description is less than 50 characters (35 chars)
❌ PR Description: FAILED - PR description is empty
```

---

### 2. HTML Validation

**Checks:**
- ✅ HTML5 DOCTYPE declaration present
- ✅ `<html>` tag has `lang` attribute
- ✅ Charset meta tag present
- ✅ Viewport meta tag present
- ✅ Description meta tag present
- ✅ Title tag present
- ✅ All images have `alt` attributes
- ✅ All HTML tags are properly closed/matched
- ✅ No deprecated HTML tags (font, center, marquee, blink, u, strike)

**Validates:**
- All `.html` files in the repository
- Scans all subdirectories

**Example Issues Found:**
```
❌ HTML validation failed:
- Missing viewport meta tag
- Image #1 missing alt attribute: <img src="hero.jpg">
- Deprecated HTML tag found: <font>
```

---

### 3. Code Quality Check

**Checks:**
- ✅ No inline `style` attributes (styles should be in CSS files)
- ✅ No `console.log()` statements left in code
- ✅ No deprecated HTML tags

**Validates:**
- All `.html` and `.js` files in the repository

**Example Output:**
```
⚠️ Code quality issues found:

**index.html:**
  - 5 inline style attribute(s) found
  - 2 console.log statement(s) found
```

**Why These Matter:**
- **Inline Styles**: Mixed presentation with HTML makes code harder to maintain. Use CSS files instead.
- **console.log**: Debug statements left in production code can leak information and impact performance.

---

### 4. Link Validation

**Checks:**
- ✅ All internal links point to existing files
- ✅ External links are valid (non-404)
- ✅ Anchor links (#) are skipped (assumed valid)

**Validates:**
- All `href` and `src` attributes in HTML files
- Internal file paths are resolved relative to the HTML file location

**Example Issues:**
```
⚠️ Link validation issues found:

**index.html:**
  - Broken internal link: images/missing-photo.jpg
  - Broken internal link: styles/theme.css
```

---

### 5. File Size Check

**Limits:**
- ⚠️ Individual files larger than 500KB → Warning
- ⚠️ Total repository larger than 5MB → Warning

**Note:** These are warnings, not failures. Large files are flagged for review.

**Example Output:**
```
⚠️ Files exceed 500KB:
  - assets/video.mp4: 650.50KB

⚠️ Repository size (5.2MB) exceeds 5MB limit
```

---

## PR Comment Template

The workflow automatically posts a comment on your PR with results. Example:

```markdown
# 🔍 PR Validation Report

**Branch Target:** `prod`
**Triggered by:** @username

## Check Results

✅ **PR Description**: PASSED

✅ **HTML Validation**: PASSED

✅ **Code Quality**: PASSED

⚠️ **Link Validation**: ISSUES FOUND
   - Check for broken internal links

✅ **File Size Check**: PASSED

---

### Next Steps

- This PR targets **prod**. Ensure:
  - ✅ All checks pass
  - ✅ Code has been tested on **test** branch
  - ✅ At least one approval is obtained

**Run #:** 12345678
**Timestamp:** 2024-06-14T10:30:00.000Z
```

---

## Workflow Execution Flow

```
PR opened/updated
       ↓
[Checkout code]
       ↓
[Setup Node.js]
       ↓
[Install dependencies]
       ↓
┌─────────────────────────┐
│ Run checks in parallel: │
├─────────────────────────┤
│ • PR Description        │
│ • HTML Validation       │
│ • Code Quality          │
│ • Link Validation       │
│ • File Size Check       │
└─────────────────────────┘
       ↓
[Create Summary]
       ↓
[Post Comment to PR]
       ↓
Workflow Complete ✅
```

---

## How to Fix Issues

### PR Description

**Issue:** PR description is empty or too short

**Fix:**
1. Go to your PR
2. Click **Edit** (pencil icon) on the PR description
3. Add a meaningful description (minimum 50 characters recommended)
4. Save

The check will run again on your next commit.

### HTML Validation

**Issue:** Missing `alt` attribute on image

**Fix:**
```html
<!-- Before -->
<img src="photo.jpg">

<!-- After -->
<img src="photo.jpg" alt="Profile photo of John Doe">
```

**Issue:** Missing meta tags

**Fix:**
```html
<!-- Add to <head> -->
<meta name="description" content="Brief description of your portfolio">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Portfolio Title</title>
```

### Code Quality

**Issue:** Inline styles detected

**Fix:**
```html
<!-- Before -->
<div style="color: red; font-size: 16px;">Text</div>

<!-- After (in CSS file) -->
<div class="highlight">Text</div>
```

```css
/* styles.css */
.highlight {
  color: red;
  font-size: 16px;
}
```

**Issue:** console.log statements

**Fix:**
```javascript
// Before
function handleClick() {
  console.log('Button clicked');
  doSomething();
}

// After (use comments if needed for debugging)
function handleClick() {
  // Debug: Button was clicked
  doSomething();
}
```

### Link Validation

**Issue:** Broken internal link

**Fix:**
```html
<!-- Before (file doesn't exist) -->
<a href="pages/about.html">About</a>

<!-- After (correct path) -->
<a href="./about.html">About</a>
```

Or create the missing file that the link points to.

### File Size

**Issue:** Repository exceeds 5MB

**Fix:**
1. Identify large files: Check GitHub Actions workflow logs
2. Move large media files to:
   - GitHub LFS (Git Large File Storage)
   - CDN or external hosting
   - Remove unnecessary files

---

## GitHub Actions Syntax Explanation

### Workflow Triggers

```yaml
on:
  pull_request:
    branches: [dev, test, prod]    # Runs on PRs to these branches
    types: [opened, synchronize, reopened]  # Runs on these PR events
```

### Job Structure

```yaml
jobs:
  validate:                    # Job name
    runs-on: ubuntu-latest     # Runs on latest Ubuntu runner
    steps:                     # List of steps
      - name: Step name        # Display name
        run: command           # Shell command to run
```

### Continue on Error

```yaml
continue-on-error: true        # Workflow continues even if step fails
                               # (warnings don't block merge)
```

### Conditionals

```yaml
if: always()                   # Run regardless of previous steps
if: failure()                  # Run only if previous steps failed
if: success()                  # Run only if previous steps succeeded
```

---

## Customizing the Workflow

### Change File Size Limits

Edit `.github/workflows/pr-validation.yml`:

```javascript
const SIZE_LIMIT = 500 * 1024; // Change to 1MB: 1024 * 1024
const REPO_LIMIT = 5 * 1024 * 1024; // Change to 10MB: 10 * 1024 * 1024
```

### Add New Validation Check

Add a new step in the workflow:

```yaml
- name: Run Custom Check
  id: custom_check
  run: |
    # Your validation script here
    echo "Running custom validation..."
```

### Change PR Approval Requirements

Edit branch protection rules in GitHub Settings → Branches.

---

## Troubleshooting

### "No status check named 'validate' found"

**Solution:** The workflow must run at least once successfully. The status check appears after the first run.

1. Open a test PR to any branch
2. Wait for workflow to complete
3. Return to branch settings
4. The `validate` check will now appear

### Workflow Fails but PR Still Mergeable

**Reason:** If you don't have branch protection rules enabled, PRs can be merged even with failing checks.

**Fix:** Enable branch protection rules following [BRANCH_PROTECTION_SETUP.md](./BRANCH_PROTECTION_SETUP.md).

### "HTML validation failed" but file looks correct

**Solution:** The validator may be stricter than expected. Check:
- All tags are properly closed (matching open/close counts)
- All images have `alt` attributes
- Required meta tags are present

Run this command locally to test:
```bash
node validate_html.js
```

---

## Performance

- **Average execution time:** 30-45 seconds
- **Includes:** Setup, validation, and PR comment posting
- **Cost:** Free (uses GitHub-hosted runners)

---

## Files Modified/Created

```
.github/
├── workflows/
│   └── pr-validation.yml          # Main workflow file
└── BRANCH_PROTECTION_SETUP.md     # Setup documentation
```

---

## Security Considerations

1. **Secrets:** This workflow doesn't use any secrets (safe for public repos)
2. **Permissions:** Uses standard GitHub Actions permissions
3. **External Calls:** Link validation makes HTTP requests to external URLs
4. **Data:** No sensitive data is logged or stored

---

## Support & Debugging

**View workflow runs:**
1. Go to **Actions** tab in GitHub
2. Select "PR Validation Workflow"
3. Click on the run to see logs

**Check PR validation status:**
- Green checkmark ✅ = All checks passed
- Red X ❌ = Some checks failed
- Yellow dot 🟡 = Checks still running

**Re-run workflow:**
1. Go to the failed run
2. Click "Re-run failed jobs" (or "Re-run all jobs")
