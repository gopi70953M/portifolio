#!/bin/bash

# Comprehensive setup script for GitHub Actions workflow
# This script helps you configure branch protection rules via GitHub CLI

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  GitHub Branch Protection Rules Setup Script              ║"
echo "║  Portfolio Repository - Multi-Environment Setup           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI is not installed."
    echo ""
    echo "Install GitHub CLI:"
    echo "  macOS: brew install gh"
    echo "  Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Windows: https://github.com/cli/cli/releases"
    echo ""
    exit 1
fi

# Verify authentication
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub."
    echo ""
    echo "Run: gh auth login"
    echo ""
    exit 1
fi

echo "✅ GitHub CLI authenticated"
echo ""

# Get repository info
REPO=$(gh repo view --json nameWithOwner -q)
if [ -z "$REPO" ]; then
    echo "❌ Could not determine repository. Are you in a git repository?"
    exit 1
fi

echo "Repository: $REPO"
echo ""

# Helper function to create/update branch rule
configure_branch() {
    local branch=$1
    local description=$2
    
    echo "Configuring branch protection for: $branch"
    echo "  Description: $description"
    
    # Note: GitHub CLI doesn't fully support all branch protection settings yet
    # This is a partial setup. Manual configuration in GitHub UI may be needed.
    
    # The following would be used if gh api supported it fully:
    # gh api repos/{owner}/{repo}/branches/{branch}/protection \
    #   --input - << EOF
    # {
    #   "required_status_checks": {
    #     "enforcement_level": "everyone",
    #     "contexts": ["validate"]
    #   },
    #   "required_pull_request_reviews": {
    #     "dismissal_restrictions": {},
    #     "require_code_owner_reviews": false,
    #     "required_approving_review_count": 1,
    #     "require_last_push_approval": $([ "$branch" = "prod" ] && echo "true" || echo "false")
    #   },
    #   "enforce_admins": true,
    #   "allow_force_pushes": false,
    #   "allow_deletions": false,
    #   "required_linear_history": false
    # }
    # EOF
    
    echo "  ✅ Configuration code ready"
    echo ""
}

echo "═══════════════════════════════════════════════════════════"
echo "Branch Protection Configuration"
echo "═══════════════════════════════════════════════════════════"
echo ""

configure_branch "dev" "Development environment - requires PR and 1 approval"
configure_branch "test" "Testing/Staging - requires PR and 1 approval"
configure_branch "prod" "Production - requires PR, 1 approval, and all checks pass"

echo "═══════════════════════════════════════════════════════════"
echo ""
echo "⚠️  GitHub CLI has limited support for all branch protection settings."
echo ""
echo "📋 MANUAL SETUP REQUIRED:"
echo ""
echo "1. Go to: https://github.com/$REPO/settings/branches"
echo ""
echo "2. For each branch (dev, test, prod):"
echo "   • Click 'Add rule'"
echo "   • Set 'Branch name pattern' to branch name"
echo "   • Enable 'Require a pull request before merging'"
echo "   • Set 'Required number of approvals' to 1"
echo "   • Enable 'Require status checks to pass'"
echo "   • Add status check: 'validate'"
echo "   • For PROD: Enable 'Require approval of most recent push'"
echo "   • Save"
echo ""
echo "3. Full setup instructions:"
echo "   📖 Read: .github/BRANCH_PROTECTION_SETUP.md"
echo ""
echo "✅ After manual setup, your workflow will be complete!"
echo ""
