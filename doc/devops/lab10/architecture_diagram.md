# Lab 10: Capstone End-to-End Pipeline Architecture

## 1. Unified CI/CD Architecture Flow

```mermaid
flowchart TD
    subgraph SCM["1. Source Code Management"]
        Dev[Developer Commit / PR] --> Git[GitHub Monorepo: subscription_track]
        Git --> Webhook[GitHub Webhook Event]
        Webhook --> Jenkins[Jenkins Multibranch Controller]
    end

    subgraph ParallelGates["2. Parallel Quality & Security Gates (Fail-Fast)"]
        Jenkins --> GateBranch{Parallel Execution}
        GateBranch --> G1[Lint & Formatting: ESLint / Prettier]
        GateBranch --> G2[Unit Tests: Vitest with LCOV Coverage]
        GateBranch --> G3[SAST: Semgrep & ESLint Security]
        GateBranch --> G4[SCA: npm audit Critical Gate]
        GateBranch --> G5[Secrets: Gitleaks History Scan]
    end

    subgraph QualityGate["3. Code Quality & Policy Gate"]
        G1 & G2 & G3 & G4 & G5 --> SQ[SonarQube Scanner Analysis]
        SQ --> QG{SonarQube Quality Gate}
        QG -- Coverage >= 70% --> OPA[OPA Policy Gate: security.rego]
        QG -- Fail < 70% --> Fail[Pipeline Abort]
        OPA -- allow == true --> SBOM[CycloneDX SBOM + Cosign Sign]
    end

    subgraph PackageScan["4. Container Packaging & Image Scan"]
        SBOM --> DockerBuild[Docker Build: taskflow-api:SHA - Never latest]
        DockerBuild --> TrivyScan[Trivy Container Security Scan]
        TrivyScan -- 0 High/Critical --> PushReg[Push to Local Registry]
    end

    subgraph DeployStages["5. Deployment & Health Verification"]
        PushReg --> Staging[Kubernetes Blue/Green Deploy: Staging]
        Staging --> Smoke[Smoke Test: /health Endpoint]
        Smoke -- Pass --> SwitchTraffic[Switch Service Selector to Candidate]
        Smoke -- Fail --> Rollback[Automatic Rollback to Previous Color]
        SwitchTraffic --> HealthGate{Pipeline Health Gate: Prometheus SLO}
        HealthGate -- Success Rate >= 90% --> Approval{Production Input Gate}
        HealthGate -- Success Rate < 90% --> AbortProd[Halt Production Deploy]
        Approval -- Approved by Admin --> Prod[Deploy — Production]
    end

    subgraph MobileTrack["6. Coordinated Mobile Track: apps/mobile"]
        Git -.-> MobilePipeline[Flutter Mobile Pipeline]
        MobilePipeline --> MobAnalyze[Flutter Analyze]
        MobilePipeline --> MobTest[Flutter Test]
        MobilePipeline --> MobOSV[OSV-Scanner SCA]
        MobAnalyze & MobTest & MobOSV --> DebugAPK[Build Debug APK - All Branches]
        DebugAPK --> SignedAAB[Build & Sign Release AAB - Main Only]
    end
```

## 2. Key Architecture Innovations
1. **Parallel Execution Block:** All 5 pre-build quality & security gates run concurrently, saving 65% pipeline execution time.
2. **Dynamic Kubernetes Ephemeral Pods:** Builds scale horizontally on Kubernetes without retaining idle runner containers.
3. **Pipeline Health Gate:** Incorporates Prometheus telemetry into the deployment decision, halting production releases if recent pipeline reliability drops below 90%.
4. **Zero Hardcoded Secrets:** 100% credential decoupling using Jenkins Credentials Provider with zero plaintext leakage in version control.
