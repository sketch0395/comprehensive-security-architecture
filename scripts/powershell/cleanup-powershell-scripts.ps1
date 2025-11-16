# PowerShell Script Cleanup for 8-Step Security Scan
# Removes unnecessary PowerShell scripts and keeps only the essential ones

Write-Host "🧹 Cleaning up PowerShell scripts directory for 8-step security scan..." -ForegroundColor Blue
Write-Host ""

# Set up paths
$ScriptDir = $PSScriptRoot
$PowerShellDir = $ScriptDir

# Essential PowerShell scripts for 8-step security scan
$EssentialScripts = @(
    # Core orchestration
    "run-target-security-scan.ps1"
    
    # 8 Security Layers
    "run-trufflehog-scan.ps1"        # Layer 1: Secret Detection
    "run-clamav-scan.ps1"            # Layer 2: Malware Detection  
    "run-checkov-scan.ps1"           # Layer 3: Infrastructure Security
    "run-grype-scan.ps1"             # Layer 4: Vulnerability Detection
    "run-trivy-scan.ps1"             # Layer 5: Container Security
    "run-xeol-scan.ps1"              # Layer 6: End-of-Life Detection
    "run-sonar-analysis.ps1"         # Layer 7: Code Quality Analysis
    "run-helm-build.ps1"             # Layer 8: Helm Chart Building
    
    # Summary and analysis
    "consolidate-security-reports.ps1"
    
    # Essential documentation
    "README.md"
    "QUICK-START-WINDOWS.md"
)

# Scripts to remove (same as bash cleanup logic)
$RemoveScripts = @(
    # Individual analysis scripts (replaced by consolidate-security-reports.ps1)
    "analyze-checkov-results.ps1"
    "analyze-clamav-results.ps1" 
    "analyze-grype-results.ps1"
    "analyze-helm-results.ps1"
    "analyze-trivy-results.ps1"
    "analyze-trufflehog-results.ps1"
    "analyze-xeol-results.ps1"
    
    # Demo and test scripts
    "demo-portable-scanner.ps1"
    "portable-app-scanner.ps1"
    "test-desktop-default.ps1"
    
    # Specialized/niche scripts
    "nodejs-security-scanner.ps1"
    "real-nodejs-scanner.ps1"
    "real-nodejs-scanner-fixed.ps1"
    
    # Complete scan alternatives (redundant with run-target-security-scan.ps1)
    "run-complete-security-scan.ps1"
    
    # AWS/cloud specific utilities 
    "aws-ecr-helm-auth.ps1"
    "aws-ecr-helm-auth-guide.ps1"
    
    # Utility scripts that are less essential
    "compliance-logger.ps1"
    "create-stub-dependencies.ps1"
    "resolve-helm-dependencies.ps1"
    
    # Conversion utilities (no longer needed)
    "Batch-Convert-Scripts.ps1"
    "Convert-AllScripts.ps1"
    
    # Documentation files (keeping only essential ones)
    "CONVERSION-STATUS.md"
    "CONVERSION-SUMMARY.md" 
    "HYBRID-APPROACH.md"
    "PATH-FIX-NOTES.md"
    "README-PowerShell-Conversion.md"
    
    # Environment files
    ".env.sonar.example"
)

# Create backup
$BackupDir = Join-Path $PowerShellDir "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "📦 Creating backup at: $BackupDir" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

# Backup files we're about to remove
$BackedUpCount = 0
foreach ($script in $RemoveScripts) {
    $FilePath = Join-Path $PowerShellDir $script
    if (Test-Path $FilePath) {
        Copy-Item $FilePath $BackupDir -Force
        Write-Host "  📄 Backed up: $script" -ForegroundColor Gray
        $BackedUpCount++
    }
}

Write-Host "✅ Backup completed ($BackedUpCount files)" -ForegroundColor Green
Write-Host ""

# Remove unnecessary scripts
Write-Host "🗑️  Removing unnecessary PowerShell scripts..." -ForegroundColor Red
$RemovedCount = 0

foreach ($script in $RemoveScripts) {
    $FilePath = Join-Path $PowerShellDir $script
    if (Test-Path $FilePath) {
        Remove-Item $FilePath -Force
        Write-Host "  ❌ Removed: $script" -ForegroundColor Red
        $RemovedCount++
    }
}

Write-Host "✅ Removed $RemovedCount unnecessary files" -ForegroundColor Green
Write-Host ""

# List remaining essential scripts
Write-Host "📋 Essential PowerShell scripts remaining for 8-step security scan:" -ForegroundColor Blue
Write-Host ""

Write-Host "🎯 Core Orchestration:" -ForegroundColor Green
Write-Host "  • run-target-security-scan.ps1 - Main orchestration script"
Write-Host ""

Write-Host "🛡️  8 Security Layers:" -ForegroundColor Green
Write-Host "  • run-trufflehog-scan.ps1 - Layer 1: Secret Detection"
Write-Host "  • run-clamav-scan.ps1     - Layer 2: Malware Detection"
Write-Host "  • run-checkov-scan.ps1    - Layer 3: Infrastructure Security"
Write-Host "  • run-grype-scan.ps1      - Layer 4: Vulnerability Detection"
Write-Host "  • run-trivy-scan.ps1      - Layer 5: Container Security"
Write-Host "  • run-xeol-scan.ps1       - Layer 6: End-of-Life Detection"
Write-Host "  • run-sonar-analysis.ps1  - Layer 7: Code Quality Analysis"
Write-Host "  • run-helm-build.ps1      - Layer 8: Helm Chart Building"
Write-Host ""

Write-Host "📊 Analysis & Reporting:" -ForegroundColor Green
Write-Host "  • consolidate-security-reports.ps1 - Report consolidation"
Write-Host ""

Write-Host "📁 Current PowerShell scripts directory structure:" -ForegroundColor Blue
$FinalCount = (Get-ChildItem $PowerShellDir -Filter "*.ps1").Count
Write-Host "  📄 $FinalCount PowerShell scripts remaining"

Write-Host ""
Write-Host "✅ PowerShell script cleanup completed!" -ForegroundColor Green
Write-Host "💡 To run the 8-step security scan on Windows, use:" -ForegroundColor Yellow
Write-Host "   .\run-target-security-scan.ps1 <target_directory> [full|quick|images|analysis]"
Write-Host ""
Write-Host "📦 Backup location: $BackupDir" -ForegroundColor Blue

# Show final count
$OriginalCount = $FinalCount + $RemovedCount
Write-Host "📊 Final count: $FinalCount scripts (down from $OriginalCount)" -ForegroundColor Green