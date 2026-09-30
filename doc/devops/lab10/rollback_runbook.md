# Production Rollback Runbook — Taskflow CI/CD

**Target System:** `subscription-track` / `taskflow-api`  
**Author / Lead:** Jatupat kuseng (DevOps On-Call Engineer)  
**Classification:** Operational Runbook — Severity 1 / 2 Incident  

---

## 1. Trigger Conditions
This runbook must be executed immediately when any of the following occur:
1. **Pipeline Smoke Test Failure:** Automated smoke test returns non-200 or connection refused after traffic cutover.
2. **Post-Deployment Error Spike:** Prometheus reports 5xx error rate > 1% on `/health` or core API routes within 15 minutes of release.
3. **Quality / Security Regression:** SonarQube or Trivy post-deploy alert discovers newly disclosed critical vulnerability.

---

## 2. Immediate Rollback Procedure (Step-by-Step)

### Step 1: Query Current Active Service Color
Inspect the live Kubernetes Service selector to identify the currently routing deployment:
```bash
ACTIVE_COLOR=$(kubectl get svc taskflow -o jsonpath='{.spec.selector.color}')
echo "Currently serving traffic color: ${ACTIVE_COLOR}"
```

### Step 2: Determine Previous Healthy Target
```bash
if [ "$ACTIVE_COLOR" = "green" ]; then
    TARGET_COLOR="blue"
else
    TARGET_COLOR="green"
fi
echo "Emergency rollback destination: ${TARGET_COLOR}"
```

### Step 3: Verify Target Deployment Health Before Switch
Ensure the standby deployment is ready and healthy before routing traffic:
```bash
kubectl rollout status deployment/taskflow-${TARGET_COLOR} --timeout=30s
kubectl get pods -l app=taskflow,color=${TARGET_COLOR}
```

### Step 4: Instant Zero-Downtime Traffic Repointing
Patch the Service selector to point live traffic back to the known-healthy deployment:
```bash
kubectl patch svc taskflow -p "{\"spec\":{\"selector\":{\"color\":\"${TARGET_COLOR}\"}}}"
```

### Step 5: Verify Live Traffic Health
Send probe request through the Service endpoint to confirm restoration:
```bash
curl -I http://taskflow:8080/health
# Expected Output: HTTP/1.1 200 OK
```

### Step 6: Quarantine Broken Deployment
Scale down the broken candidate deployment to prevent resource contention or background errors:
```bash
kubectl scale deployment/taskflow-${ACTIVE_COLOR} --replicas=0
```

---

## 3. Post-Incident Actions
1. **Lock Pipeline:** Place a hold on `main` branch merges until root cause analysis (RCA) is completed.
2. **Notify Team:** Send notification to Slack `#devops-incidents` channel with the incident summary, duration, and rollback timestamp.
3. **Capture Telemetry:** Export Grafana dashboard metrics snapshot and pod crash logs (`kubectl logs -l app=taskflow,color=${ACTIVE_COLOR} --tail=200`).
