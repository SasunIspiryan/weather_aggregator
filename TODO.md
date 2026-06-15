# TODO

- [ ] Step 1: Inspect current CI workflow wiring in `.github/workflows/ci.yml`
- [ ] Step 2: Inspect reusable template workflow `.github/workflows/build-scan.yml` (and understand how jobs can be DRY’ed via `uses:`/`include`)
- [ ] Step 3: Refactor `.github/workflows/ci.yml` to reference a pinned template tag (planned tag v1 / v1.0.0)
- [ ] Step 4: If weather-chart bump was done earlier, ensure updated change is committed
- [ ] Step 5: Ensure security check (no tokens/keys/passwords committed; terraform/kubeconfig ignored)
- [ ] Step 6: Commit changes on branch `hw33`
- [ ] Step 7: Push weather_aggregator repo branch
- [ ] Step 8: Push/tag the `ci-templates` repo with `v1` / `v1.0.0` and pin from the weather pipeline
- [ ] Step 9: Final verification: check workflow YAML has no duplicated job bodies and references pinned tag
