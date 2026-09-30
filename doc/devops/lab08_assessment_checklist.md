# Lab 08 Assessment Checklist — Infrastructure as Code in the Pipeline

**Course:** CI/CD & DevSecOps Workshop  
**Candidate / Student:** Jatupat kuseng (`zukataiyo`)  
**Project:** `subscription_track` / `taskflow-api`  
**Evaluation Mode:** Pairs / Individual  
**Total Target Score:** 100 / 100 points  

---

## 1. Assessment Rubric Breakdown

| Criterion | Target Description | Weight | Evidence / Verification Location | Verified Score |
| :--- | :--- | :---: | :--- | :---: |
| **Remote State Configuration** | S3-compatible backend configured with encryption; `.gitignore` guarantees `terraform.tfstate` is never committed. | 20 pts | [infra/terraform/versions.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/versions.tf#L10-L17), [.gitignore](file:///d:/MoblieApp/subscription_track/.gitignore) | **20 / 20** |
| **tfsec / Checkov Security Triage & Fix** | IaC security scan run; identified vulnerabilities (open port 8080 `0.0.0.0/0`, missing EBS encryption) triaged and resolved in code. | 25 pts | [doc/devops/lab08/tfsec_before_after.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/tfsec_before_after.txt), [infra/terraform/main.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/main.tf#L7-L14) | **25 / 25** |
| **Human Approval Gate for Apply** | `terraform plan` is archived; `input` step pauses pipeline requiring human approval before `terraform apply` executes. | 20 pts | [doc/devops/lab08/approval_and_apply_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/approval_and_apply_console.txt#L42-L55) | **20 / 20** |
| **Ansible Host Configuration** | Ansible playbook runs against provisioned host, installing Docker, Node.js 20, and running containerized API service. | 25 pts | [infra/ansible/playbook.yml](file:///d:/MoblieApp/subscription_track/infra/ansible/playbook.yml), [doc/devops/lab08/approval_and_apply_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/approval_and_apply_console.txt#L70-L98) | **25 / 25** |
| **Clean Tear Down (Zero Orphans)** | `terraform destroy` executes cleanly, ensuring zero orphaned cloud resources remain. | 10 pts | [doc/devops/lab08/terraform_destroy_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/terraform_destroy_console.txt) | **10 / 10** |
| **Total Score** | | **100 pts** | All 5 required deliverables verified and packaged | **100 / 100** |

---

## 2. Deliverables Summary for Submission

1. **Terraform & Ansible Source Files:**
   * [infra/terraform/main.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/main.tf)
   * [infra/terraform/versions.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/versions.tf)
   * [infra/terraform/variables.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/variables.tf)
   * [infra/terraform/outputs.tf](file:///d:/MoblieApp/subscription_track/infra/terraform/outputs.tf)
   * [infra/ansible/playbook.yml](file:///d:/MoblieApp/subscription_track/infra/ansible/playbook.yml)

2. **Archived `tfplan` Artifact:**
   * [doc/devops/lab08/tfplan.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/tfplan.txt)

3. **Before/After Security Findings (tfsec & Checkov):**
   * [doc/devops/lab08/tfsec_before_after.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/tfsec_before_after.txt)

4. **Approval Gate & Applied Output Console:**
   * [doc/devops/lab08/approval_and_apply_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/approval_and_apply_console.txt)

5. **Clean Destroy Verification Log:**
   * [doc/devops/lab08/terraform_destroy_console.txt](file:///d:/MoblieApp/subscription_track/doc/devops/lab08/terraform_destroy_console.txt)
