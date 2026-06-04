Self-hosted Runner registration and GitHub Secrets checklist

1) Register a GitHub Actions self-hosted runner (Linux)

- On GitHub: Settings → Actions → Runners → New self-hosted runner → Linux
- Follow the generated instructions. Typical commands (example):

```bash
mkdir actions-runner && cd actions-runner
# download the Linux x64 runner archive from the page
tar xzf actions-runner-linux-x64-*.tar.gz
./config.sh --url https://github.com/YOUR_USER/YOUR_REPO --token <RUNNER_TOKEN>
# test run in foreground for debugging
./run.sh
# OR install as a service
sudo ./svc.sh install
sudo ./svc.sh start
```

Notes:
- Keep the `<RUNNER_TOKEN>` private — it's single-use and short-lived.
- If you install as a service, the runner will start automatically at boot.

2) Verify runner

- On GitHub: Settings → Actions → Runners — your runner should show "Idle" and green.
- Trigger a workflow (push to `main`) and check the Actions run logs.

3) Required repository secrets (GitHub → Settings → Secrets & variables → Actions)

- `AWS_REGION` — e.g., `us-east-1`
- `ECR_REGISTRY` — e.g., `<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com` (optional; if not set, push is skipped)
- `AWS_ACCESS_KEY_ID` — for ECR push
- `AWS_SECRET_ACCESS_KEY` — for ECR push
- `IMAGE_NAME` — optional; defaults to `weather`

Security best practices
- Do NOT put any credentials in your workflow files. Use repository secrets only.
- Use short-lived IAM credentials or fine-grained IAM user with minimal permissions (ECR push + STS if needed).
- Limit runner machine network access and keep the runner OS/packages up to date.

4) Troubleshooting tips

- If VS Code flags YAML errors, install the `YAML` extension and assign the GitHub Actions schema.
- If the runner fails to start, run `./svc.sh status` (or check `./run.sh` output) and inspect `runner/_diag` logs.

5) Example IAM policy for ECR push (minimal)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:CreateRepository"
      ],
      "Resource": "*"
    }
  ]
}
```

6) After setup

- Merge `hw30` PR to `main` and push a commit to trigger the workflow once the runner is registered and secrets are configured.
