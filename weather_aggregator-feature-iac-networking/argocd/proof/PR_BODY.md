Title: Add ArgoCD genesis app + automated self-heal proof

Summary:
This PR contains the ArgoCD genesis Application definition (path: `weather-chart`, branch: `hw32`) and proof artifacts demonstrating GitOps sync and automated self-heal.

What I changed:
- `argocd/genesis-app.yaml`: helm values set to `replicaCount: 4` and automated sync/selfHeal/prune enabled.

Proof artifacts (in `argocd/proof/`):
- `argocd-application.yaml` — ArgoCD Application live state
- `weather-deployment.yaml` — Deployment manifest live state
- `pods.txt` — Pod list and images
- `scale-test.txt` — Output from scaling the deployment and observing ArgoCD revert to the declared replica count

How to reproduce locally:
- Ensure `kubectl` context points to the cluster
- `kubectl apply -f argocd/genesis-app.yaml -n argocd`
- Manually scale and observe:
  - `kubectl -n weather scale deploy weather-deployment --replicas=10`
  - watch `kubectl -n weather get deploy weather-deployment -o yaml` until `.spec.replicas` returns to `4`

Notes:
- All proof files were captured from the live cluster and committed on branch `hw32`.
