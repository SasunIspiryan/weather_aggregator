# Weather Aggregator SLO

Our primary user-facing SLO is: **99.5% of HTTP requests should return a non-5xx response over a rolling 30-day window**.

I chose an availability SLO because users care first about whether the API responds successfully at all, and this app depends on multiple external systems (weather provider + database), so a strict but realistic target is better than an aspirational one that pages constantly. The SLI behind this is the 5xx error-ratio query:

```promql
sum(rate(http_requests_total{code=~"5.."}[5m]))
/
sum(rate(http_requests_total[5m]))
```

For a 30-day window, the error budget is `1 - 0.995 = 0.005` (0.5%). That corresponds to about `30 days * 24 hours * 60 minutes * 0.005 = 216 minutes`, or roughly **3.6 hours** of total bad time if failures were continuous. The alert in this repo is symptom-based (elevated 5xx ratio), not cause-based, so it detects real user pain regardless of root cause. The `for: 5m` clause reduces alert fatigue by requiring sustained failure before notifying, which filters out short blips and prevents flapping.
