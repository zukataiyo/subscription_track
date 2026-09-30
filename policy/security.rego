package security

default allow = false

# Rule 1: No hardcoded secrets leaked
no_secrets {
    input.gitleaks.leak_count == 0
}

# Rule 2: No Critical or High vulnerabilities in dependencies
no_critical_or_high_cves {
    critical_count := count([v | v := input.vulnerabilities[_]; v.severity == "CRITICAL"])
    high_count := count([v | v := input.vulnerabilities[_]; v.severity == "HIGH"])
    critical_count == 0
    high_count == 0
}

# Rule 3: SBOM must exist and be cryptographically signed by Cosign
sbom_signed {
    input.sbom.exists == true
    input.sbom.signed == true
    input.sbom.verified == true
}

# Rule 4: SAST rules must have 0 high-severity security findings
no_sast_blockers {
    input.sast.high_count == 0
}

# Overall decision
allow {
    no_secrets
    no_critical_or_high_cves
    sbom_signed
    no_sast_blockers
}

# Detailed violation messages
violations[msg] {
    input.gitleaks.leak_count > 0
    msg := sprintf("[OPA BLOCK] Gitleaks detected %v secret(s) in repository history or working tree", [input.gitleaks.leak_count])
}

violations[msg] {
    critical_count := count([v | v := input.vulnerabilities[_]; v.severity == "CRITICAL"])
    critical_count > 0
    msg := sprintf("[OPA BLOCK] SCA dependency check failed: found %v CRITICAL CVEs", [critical_count])
}

violations[msg] {
    high_count := count([v | v := input.vulnerabilities[_]; v.severity == "HIGH"])
    high_count > 0
    msg := sprintf("[OPA BLOCK] SCA dependency check failed: found %v HIGH CVEs", [high_count])
}

violations[msg] {
    input.sbom.signed != true
    msg := "[OPA BLOCK] CycloneDX SBOM artifact is unsigned or Cosign signature verification failed"
}

violations[msg] {
    input.sast.high_count > 0
    msg := sprintf("[OPA BLOCK] SAST static code analysis found %v High severity issues", [input.sast.high_count])
}
