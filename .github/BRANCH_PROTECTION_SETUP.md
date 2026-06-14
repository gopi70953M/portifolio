# Branch Protection Rules Setup

This document outlines the branch protection rules for your portfolio repository to ensure code quality and control merge workflows across dev, test, and prod environments.

## Prerequisites

- You must be a repository administrator
- Navigate to **Settings → Branches** in your GitHub repository

---

## General Branch Protection Rules

### For All Branches (dev, test, prod)

1. **Block Direct Pushes**
   - [ ] Enable "Require a pull request before merging"
   - [ ] Set "Required number of approvals" to `1`
   - [ ] Enable "Dismiss stale pull request approvals when new commits are pushed"

2. **Require Status Checks**
   - [ ] Enable "Require status checks to pass before merging"
   - [ ] Enable "Require branches to be up to date before merging"
   - [ ] Add required status check: `validate` (from your GitHub Actions workflow)

3. **Code Review Requirements**
   - [ ] Enable "Require approvals"
   - [ ] Set number of required approvals: `1`

---

## Development Branch (`dev`)

### Create/Edit Rule: `dev`

**Basic Settings:**
- Pattern: `dev`
- [ ] Require a pull request before merging (Approvals: `1`)
- [ ] Allow force pushes: ❌ (Disabled - required for data protection)
- [ ] Allow deletions: ❌ (Disabled - prevents accidental deletion)

**Status Checks:**
- [ ] Require status checks to pass before merging
- [ ] Require branches to be up to date before merging
- Select status check: `validate`

**Rules Summary:**
```
✅ Only PRs allowed (no direct pushes)
✅ 1 approval required
✅ All GitHub Actions checks must pass
✅ Branch must be up to date
❌ Force pushes disabled
❌ Deletion disabled
```

---

## Test Branch (`test`)

### Create/Edit Rule: `test`

**Basic Settings:**
- Pattern: `test`
- [ ] Require a pull request before merging (Approvals: `1`)
- [ ] Allow force pushes: ❌ (Disabled)
- [ ] Allow deletions: ❌ (Disabled)

**Status Checks:**
- [ ] Require status checks to pass before merging
- [ ] Require branches to be up to date before merging
- Select status check: `validate`

**Require Branches:**
- [ ] Require branches to be up to date before merging
- [ ] Restrict who can push to matching branches

**Rules Summary:**
```
✅ Only PRs allowed (blocks direct pushes)
✅ 1 approval required
✅ All checks must pass
✅ Branch must be current before merge
⚠️ Consider requiring dismissal of outdated reviews
```

---

## Production Branch (`prod`)

### Create/Edit Rule: `prod`

**Basic Settings:**
- Pattern: `prod`
- [ ] Require a pull request before merging
  - Required number of approvals: `1`
  - [ ] Require review from Code Owners: (Optional - set up if using CODEOWNERS file)
  - [ ] Dismiss stale pull request approvals when new commits are pushed: ✅ (Enabled)
  - [ ] Require approval of the most recent reviewable push: ✅ (Enabled - strict)
- [ ] Allow force pushes: ❌ (Disabled - never allow on prod)
- [ ] Allow deletions: ❌ (Disabled - never allow on prod)

**Status Checks:**
- [ ] Require status checks to pass before merging
- [ ] Require branches to be up to date before merging
- Select status checks:
  - `validate` (from GitHub Actions workflow)

**Additional Requirements:**
- [ ] Require approval of the most recent reviewable push
- [ ] Require status checks to pass before merging
- [ ] Require branches to be up to date before merging

**Restrict Who Can Push:**
- [ ] Allow force pushes (select "Restrict who can force push"): ❌ (No one)
- [ ] Allow deletions: ❌ (No one)

**Rules Summary:**
```
✅ Only PRs allowed (ZERO direct pushes)
✅ 1 approval required (from any user)
✅ All checks must pass
✅ Approvals require latest push to be reviewed
✅ Branch must be up to date before merge
❌ Force pushes completely disabled
❌ Deletion completely disabled
❌ No dismissal of reviews without new approval
```

---

## Step-by-Step Setup Instructions

### Step 1: Navigate to Branch Settings

1. Go to your GitHub repository
2. Click on **Settings** (top navigation bar)
3. Select **Branches** from the left sidebar

### Step 2: Create Protection Rule for `dev`

1. Click **Add rule**
2. **Branch name pattern:** Enter `dev`
3. Check the following boxes:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Require a pull request before merging → Set to `1` approval
4. Under "Status checks that are required":
   - Search for and select `validate`
5. Click **Create** or **Save**

### Step 3: Create Protection Rule for `test`

Repeat Step 2, but use `test` as the branch name pattern.

### Step 4: Create Protection Rule for `prod`

1. Click **Add rule**
2. **Branch name pattern:** Enter `prod`
3. Check the following boxes:
   - ✅ Require a pull request before merging
   - ✅ Require approval of the most recent reviewable push
   - ✅ Dismiss stale pull request approvals when new commits are pushed
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
4. Set **Required approvals** to `1`
5. Under "Status checks that are required":
   - Select `validate`
6. Under "Restrict who can push to matching branches":
   - Leave as default (prevents force pushes for all)
7. Click **Create** or **Save**

---

## Testing Your Configuration

### Verify Rules Are Working

1. **Test Direct Push (Should Fail):**
   ```bash
   git checkout prod
   git commit --allow-empty -m "Test direct push"
   git push origin prod
   # Expected: ❌ ERROR - Requires PR
   ```

2. **Create PR to Prod (Should Succeed):**
   - Create a branch from `test`
   - Make a change
   - Push to branch: `git push origin feature/test`
   - Open PR against `prod`
   - Verify all checks pass
   - Review and approve your own PR
   - Merge should succeed

3. **Verify Status Checks Run:**
   - Open a PR to any branch
   - Verify the `validate` check appears in PR checks section
   - Workflow should run automatically

---

## Rule Configuration Reference

| Rule | dev | test | prod |
|------|-----|------|------|
| **Require PR** | ✅ | ✅ | ✅ |
| **Required Approvals** | 1 | 1 | 1 |
| **Status Checks** | validate | validate | validate |
| **Latest Push Approval** | ❌ | ❌ | ✅ |
| **Stale Review Dismissal** | ❌ | ❌ | ✅ |
| **Direct Push Allowed** | ❌ | ❌ | ❌ |
| **Force Push Allowed** | ❌ | ❌ | ❌ |
| **Deletion Allowed** | ❌ | ❌ | ❌ |

---

## Important Notes

1. **Admin Bypass**: Repository admins can bypass branch protection rules (this cannot be changed). Be careful with admin access.

2. **Status Checks**: The `validate` job must complete successfully before merging. If it fails, GitHub will prevent the merge.

3. **Rebase and Force Push**: The rule "Require branches to be up to date" means developers must pull the latest commits before pushing. This prevents accidentally overwriting others' work.

4. **Code Review Dismissal**: 
   - On `prod`: Reviews are dismissed when new commits are pushed, so each push must be re-approved
   - On `dev`/`test`: Reviews are not automatically dismissed

5. **Approval Authority**: Currently set to allow any user to approve. To restrict to specific code owners, set up a `CODEOWNERS` file in your repository root.

---

## Troubleshooting

### "Status checks required, but no status checks are available"

**Solution**: Ensure the GitHub Actions workflow has completed at least once. The status check `validate` will appear after the first workflow run.

### Cannot Merge PR Even After Approval

**Possible causes:**
1. Status checks still running - wait for completion
2. Branch is out of date with base branch - use "Update branch" button
3. Review was dismissed due to new commits - request new review

### Cannot Push to Protected Branch

**Expected behavior** - Direct pushes are blocked. Create a PR instead:
```bash
git checkout -b feature/my-feature
git push origin feature/my-feature
# Then open a PR from feature/my-feature to the protected branch
```

---

## Environment-Specific Workflow

### Recommended Merge Flow

```
1. Create feature branch from: dev
   ↓
2. Open PR → dev (requires 1 approval)
   ↓
3. After approval + passing checks → Merge to dev
   ↓
4. Create PR → test (testing environment)
   ↓
5. After testing + approval + passing checks → Merge to test
   ↓
6. Create PR → prod (production)
   ↓
7. After approval + passing checks → Merge to prod
```

Each merge is validated by:
- ✅ GitHub Actions workflow checks
- ✅ Required code reviews
- ✅ Branch protection rules
- ✅ Status checks passing
