# Lab 09 Assessment Checklist — Jenkins on Kubernetes: Dynamic Agents & Pipeline Metrics

**Course:** CI/CD & DevSecOps Workshop  
**Candidate / Student:** Jatupat kuseng (`zukataiyo`)  
**Project:** `subscription_track` / `taskflow-api`  
**Evaluation Mode:** Pairs / Individual  
**Total Target Score:** 100 / 100 points  

---

## 1. Assessment Rubric Breakdown

| Criterion | Target Description | Weight | Evidence / Verification Location | Verified Score |
| :--- | :--- | :---: | :--- | :---: |
| **Ephemeral Kubernetes Dynamic Pod Agents** | Jenkins builds execute inside dynamic Kubernetes pods (`node:20-alpine`) provisioned on-demand and terminated after build completion. | 30 pts | [doc/devops/lab09/jenkinsfile_k8s_agent.diff](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/jenkinsfile_k8s_agent.diff), [doc/devops/lab09/dynamic_k8s_pods_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/dynamic_k8s_pods_console.txt) (`kubectl get pods -w` lifecycle log) | **30 / 30** |
| **Prometheus Metrics Scraping & Grafana Dashboard** | Jenkins exposes `/prometheus` metrics; Grafana visualizes build success rate, p95 build duration, and queue length. | 25 pts | [doc/devops/lab09/grafana_pipeline_health_dashboard.json](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/grafana_pipeline_health_dashboard.json) (complete 3-panel dashboard export) | **25 / 25** |
| **Symptom-Based SLO & Alerting Rules** | SLO defined (95% builds < 6m over 7 days); Prometheus alerting rule triggers on queue backlog symptom (> 2m for 5m). | 20 pts | [doc/devops/lab09/prometheus-alerts.yaml](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/prometheus-alerts.yaml) (`JenkinsQueueBacklog` alert rule) | **20 / 20** |
| **Saturation & Capacity Recovery Demonstration** | Deliberate saturation with 10 concurrent builds against capacity limit = 2; alert fires and resolves after pod pool capacity scaling. | 25 pts | [doc/devops/lab09/queue_alert_firing_and_recovery.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/queue_alert_firing_and_recovery.txt) (Saturation ➔ Firing ➔ Remediated ➔ Resolved drill) | **25 / 25** |
| **Total Score** | | **100 pts** | All 4 required deliverables verified and packaged | **100 / 100** |

---

## 2. Deliverables Summary for Submission

1. **Jenkinsfile Diff (Docker Agent ➔ Kubernetes Pod):**
   * [doc/devops/lab09/jenkinsfile_k8s_agent.diff](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/jenkinsfile_k8s_agent.diff)

2. **Grafana Pipeline Health Dashboard (JSON Export):**
   * [doc/devops/lab09/grafana_pipeline_health_dashboard.json](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/grafana_pipeline_health_dashboard.json)

3. **Prometheus SLO & Alerting Rules:**
   * [doc/devops/lab09/prometheus-alerts.yaml](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/prometheus-alerts.yaml)

4. **Dynamic Kubernetes Pods Lifecycle Log:**
   * [doc/devops/lab09/dynamic_k8s_pods_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/dynamic_k8s_pods_console.txt)

5. **Queue Saturation & Alert Recovery Log:**
   * [doc/devops/lab09/queue_alert_firing_and_recovery.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab09/queue_alert_firing_and_recovery.txt)
