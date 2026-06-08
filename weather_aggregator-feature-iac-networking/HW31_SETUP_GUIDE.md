# HW31: Multi-Stage CI/CD Assembly Line - Setup Guide

## What's Been Done

✅ **Created test file** (`tests/test_app.py`):
   - Trivial test: `assert 1 + 1 == 2`
   - Import validation tests
   - Flask app creation test
   - Ready to add real tests

✅ **Updated `.github/workflows/ci.yml`** with three-stage assembly line:
   - **Stage 1: TEST** - Runs on Python 3.11 & 3.12 with `pytest`
   - **Stage 2: BUILD** - Depends on test, builds & pushes Docker image with commit SHA tag
   - **Stage 3: DEPLOY** - Depends on build, deploys to Minikube using Helm

✅ **Enhanced `.gitignore`**:
   - Added kubeconfig files exclusion
   - Added Python cache, venv, and environment files
   - Already had Terraform state files excluded

## Required Setup Steps

### 1. Set GitHub Repository Secrets
Navigate to: **Settings → Secrets and variables → Actions**

Add these secrets:
- `DOCKERHUB_USERNAME` - Your DockerHub username
- `DOCKERHUB_TOKEN` - Your DockerHub personal access token (NOT your password)

### 2. Verify Prerequisites
- [ ] GitHub Actions self-hosted runner is active and configured
- [ ] Minikube is running
- [ ] Helm chart exists at `./weather-chart/`
- [ ] Docker and kubectl are available on the runner

### 3. Create & Push the Branch
```bash
git checkout -b hw31
git add .github/workflows/ci.yml tests/test_app.py .gitignore
git commit -m "feat: multi-stage CI/CD assembly line - test, build, deploy stages"
git push origin hw31
```

### 4. Open a Pull Request
- Go to your GitHub repo
- Open a PR from `hw31` → `main`
- Watch the pipeline run through all three stages

## Pipeline Behavior

### On Pull Requests:
1. **Test stage** runs and reports results (no deploy)
2. **Build stage** only runs if tests pass
3. **Deploy stage** is skipped (PR branches don't deploy)

### On Push to Main:
1. **Test stage** runs first (Python 3.11 & 3.12)
2. **Build stage** builds and pushes image with commit SHA tag + "latest"
3. **Deploy stage** requires manual approval (via GitHub environment settings) before deploying to Minikube

## Verify the Deployment

Once deploy completes, verify in your Minikube cluster:
```bash
kubectl get pods
kubectl describe deployment weather
kubectl get svc weather
```

The pods should show your new image tag (7-char commit SHA).

## Troubleshooting

**Test fails:** 
- Ensure `pytest` is in requirements.txt, or pip install it in the workflow (already done)
- Check test syntax in `tests/test_app.py`

**Build fails:**
- Verify `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets are set correctly
- Confirm Dockerfile exists in repo root

**Deploy fails:**
- Verify `weather-chart/` Helm chart is valid: `helm lint ./weather-chart/`
- Check Minikube is running: `minikube status`
- Verify kubectl context points to Minikube: `kubectl config current-context`

## Security Checklist

✅ No credentials hardcoded in workflow
✅ All secrets stored in GitHub repository secrets
✅ Kubeconfig files excluded from git
✅ `.tfstate` and `.tfvars` files already excluded
✅ Workflow uses `${{ secrets.* }}` pattern throughout

## Next Steps (After Approval)

Once you've verified the pipeline works:
1. Add real unit tests to `tests/test_app.py`
2. Consider adding code quality checks (flake8, black)
3. Add container image scanning
4. Add environment-specific Helm values
