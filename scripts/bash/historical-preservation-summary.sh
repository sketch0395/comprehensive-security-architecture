#!/bin/bash

# Historical Preservation Summary
# Shows the changes made to preserve scan history with timestamps

echo "🔄 SCAN HISTORY PRESERVATION IMPLEMENTED"
echo "========================================"
echo
echo "📊 Changes Applied to Security Scan Scripts:"
echo

echo "✅ TruffleHog (run-trufflehog-scan.sh):"
echo "   • Results: trufflehog-{type}-results-YYYY-MM-DD_HH-MM-SS.json"
echo "   • Logs: trufflehog-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: trufflehog-{type}-results.json → latest"
echo

echo "✅ Grype (run-grype-scan.sh):"
echo "   • Results: grype-{type}-results-YYYY-MM-DD_HH-MM-SS.json"
echo "   • SBOMs: sbom-{type}-YYYY-MM-DD_HH-MM-SS.json"
echo "   • Logs: grype-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: grype-{type}-results.json → latest"
echo

echo "✅ Trivy (run-trivy-scan.sh):"
echo "   • Results: trivy-{type}-results-YYYY-MM-DD_HH-MM-SS.json"
echo "   • Logs: trivy-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: trivy-{type}-results.json → latest"
echo

echo "✅ Checkov (run-checkov-scan.sh):"
echo "   • Results: checkov-results-YYYY-MM-DD_HH-MM-SS.json"
echo "   • Logs: checkov-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: checkov-results.json → latest"
echo

echo "✅ ClamAV (run-clamav-scan.sh):"
echo "   • Results: clamav-detailed-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Logs: clamav-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: clamav-detailed.log → latest"
echo

echo "✅ Xeol (run-xeol-scan.sh):"
echo "   • Results: xeol-{type}-results-YYYY-MM-DD_HH-MM-SS.json"
echo "   • Logs: xeol-scan-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: xeol-{type}-results.json → latest"
echo

echo "✅ Helm Build (run-helm-build.sh):"
echo "   • Logs: helm-build-YYYY-MM-DD_HH-MM-SS.log"
echo "   • Current symlinks: helm-build.log → latest"
echo

echo "🎯 BENEFITS OF HISTORICAL PRESERVATION:"
echo "======================================="
echo "• 📈 Trend Analysis: Compare security findings over time"
echo "• 🔄 Rollback Capability: Access previous scan results"
echo "• 📊 Audit Trail: Complete history of security scans"
echo "• 🎯 Current Access: Symlinks always point to latest results"
echo "• 🗂️  Organized Storage: Timestamped files prevent overwrites"
echo

echo "💡 USAGE EXAMPLES:"
echo "=================="
echo "# View latest results (unchanged)"
echo "cat reports/trivy-reports/trivy-filesystem-results.json"
echo
echo "# View historical results"
echo "ls reports/trivy-reports/trivy-filesystem-results-*.json"
echo
echo "# Compare two scans"
echo "diff reports/grype-reports/grype-filesystem-results-2025-11-15_19-00-00.json \\"
echo "     reports/grype-reports/grype-filesystem-results-2025-11-15_20-00-00.json"
echo

echo "🧹 CLEANUP RECOMMENDATIONS:"
echo "==========================="
echo "• Consider periodic cleanup of old files (keep last 10-30 scans)"
echo "• Use log rotation for long-term storage management"
echo "• Archive critical scan results for compliance purposes"
echo

echo "✅ All security scan scripts now preserve historical data!"
echo "   Your analysis tools will continue to work with current symlinks."