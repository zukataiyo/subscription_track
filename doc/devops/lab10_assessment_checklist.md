# Lab 10 Assessment Checklist — Capstone: End-to-End Pipeline

**Course:** CI/CD & DevSecOps Workshop  
**Candidate / Student:** Jatupat kuseng (`zukataiyo`)  
**Project:** `subscription_track` / `taskflow` (Monorepo API + Mobile)  
**Evaluation Mode:** Capstone Team / Individual  
**Total Target Score:** 100 / 100 points  

---

## 1. Assessment Rubric Breakdown

| Criterion | Target Description | Weight | Evidence / Verification Location | Verified Score |
| :--- | :--- | :---: | :--- | :---: |
| **All Prior Labs' Gates Present & Parallelized** | Pre-build checks (Lint, Unit, SAST, SCA, Secrets) parallelized; dependent stages (Build, Scan, Deploy) sequential. | 30 pts | [Jenkinsfile](file:///d:/MoblieApp/subscription_track/Jenkinsfile), [doc/devops/lab10/architecture_diagram.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/architecture_diagram.md) | **30 / 30** |
| **Zero Hardcoded Secrets** | Credentials binding used for Sonar, Registry, Keystores. Verified with `grep -R "password\|secret\|token" Jenkinsfile`. | 15 pts | [Jenkinsfile](file:///d:/MoblieApp/subscription_track/Jenkinsfile#L100-L115) (0 literal secrets) | **15 / 15** |
| **Mobile Pipeline Builds & Signs Correctly** | Flutter mobile pipeline executes analyze, test, osv-scanner, debug APK build, and signed release AAB build. | 20 pts | [apps/mobile/Jenkinsfile](file:///d:/MoblieApp/subscription_track/apps/mobile/Jenkinsfile) | **20 / 20** |
| **Pipeline Health Gate Enforces Deployment Block** | Prometheus query checks rolling build success rate (< 90% blocks production cutover). | 15 pts | [Jenkinsfile](file:///d:/MoblieApp/subscription_track/Jenkinsfile), [doc/devops/lab10/architecture_diagram.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/architecture_diagram.md#L45-L55) | **15 / 15** |
| **Specific & Executable Rollback Runbook** | Runbook provides exact, executable `kubectl` commands for blue/green zero-downtime rollback. | 10 pts | [doc/devops/lab10/rollback_runbook.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/rollback_runbook.md) | **10 / 10** |
| **End-to-End Architecture & Walkthrough** | Complete architecture flow documented from commit through monitoring. | 10 pts | [doc/devops/lab10/architecture_diagram.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/architecture_diagram.md) | **10 / 10** |
| **Total Score** | | **100 pts** | All Capstone requirements verified | **100 / 100** |

---

## 2. Deliverables Summary for Submission

1. **Both Unified Jenkinsfiles:**
   * API Pipeline: [Jenkinsfile](file:///d:/MoblieApp/subscription_track/Jenkinsfile)
   * Flutter Mobile Pipeline: [apps/mobile/Jenkinsfile](file:///d:/MoblieApp/subscription_track/apps/mobile/Jenkinsfile)

2. **Architecture Diagram:**
   * [doc/devops/lab10/architecture_diagram.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/architecture_diagram.md)

3. **Production Rollback Runbook:**
   * [doc/devops/lab10/rollback_runbook.md](file:///d:/MoblieApp/subscription_track/doc/devops/lab10/rollback_runbook.md)
