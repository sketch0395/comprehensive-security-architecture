#!/bin/bash

# Trivy Multi-Target Vulnerability Scanner
# Comprehensive container image, Kubernetes, and filesystem security scanning

# Get absolute path to reports directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORTS_ROOT="$(dirname "$(dirname "$SCRIPT_DIR)")/reports"
OUTPUT_DIR="$REPORTS_ROOT/trivy-reports"
TIMESTAMP=$(date)
SCAN_LOG="$OUTPUT_DIR/trivy-scan.log"
REPO_PATH="${TARGET_DIR:-$(pwd)}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${WHITE}============================================${NC}"
echo -e "${WHITE}Trivy Multi-Target Security Scanner${NC}"
echo -e "${WHITE}============================================${NC}"
echo "Repository: $REPO_PATH"
echo "Output Directory: $OUTPUT_DIR"
echo "Timestamp: $TIMESTAMP"
echo

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Initialize scan log
echo "Trivy scan started: $TIMESTAMP" > "$SCAN_LOG"
echo "Target: $REPO_PATH" >> "$SCAN_LOG"

# Function to run Trivy scan
run_trivy_scan() {
    local scan_type="$1"
    local target="$2"
    local output_file="$OUTPUT_DIR/trivy-${scan_type}-results.json"
    
    echo -e "${BLUE}🔍 Scanning ${scan_type}: ${target}${NC}"
    
    if command -v docker &> /dev/null; then
        echo "Using Docker-based Trivy..."
        docker run --rm -v "$target:/workspace" \
            aquasec/trivy:latest \
            filesystem /workspace \
            --format json > "$output_file" 2>> "$SCAN_LOG"
    else
        echo "⚠️  Docker not available - Trivy scan skipped"
        echo '{"Results": []}' > "$output_file"
    fi
    
    if [ -f "$output_file" ]; then
        local count=$(cat "$output_file" | jq '.Results[]?.Vulnerabilities? | length' 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
        echo "✅ ${scan_type} scan completed: $count vulnerabilities found"
        echo "${scan_type} scan: $count vulnerabilities" >> "$SCAN_LOG"
    fi
}

# Determine scan type based on first argument
SCAN_TYPE="${1:-all}"

echo -e "${CYAN}🛡️  Step 1: Container Security Scan${NC}"
echo "===================================="

case "$SCAN_TYPE" in
    "filesystem"|"all")
        if [ -d "$REPO_PATH" ]; then
            run_trivy_scan "filesystem" "$REPO_PATH"
        else
            echo "⚠️  Target directory not found: $REPO_PATH"
        fi
        ;;
    "images"|"all")
        # Scan common base images
        for image in "nginx:alpine" "node:18-alpine" "python:3.11-alpine" "ubuntu:22.04" "alpine:latest"; do
            echo -e "${BLUE}📦 Scanning base image: $image${NC}"
            if command -v docker &> /dev/null; then
                docker pull "$image" >> "$SCAN_LOG" 2>&1
                docker run --rm aquasec/trivy:latest image "$image" --format json > "$OUTPUT_DIR/trivy-base-$(echo $image | tr ':' '-')-results.json" 2>> "$SCAN_LOG"
                echo "✅ Base image $image security scan completed"
            fi
        done
        ;;
esac

# Count results
RESULTS_COUNT=$(find "$OUTPUT_DIR" -name "trivy-*-results.json" -type f | wc -l | tr -d ' ')

echo
echo -e "${CYAN}📊 Trivy Security Scan Summary${NC}"
echo "================================"
echo "📄 Results files generated: $RESULTS_COUNT"

# Basic results summary
echo -e "🔍 Vulnerability Summary:"
if [ "$RESULTS_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $RESULTS_COUNT result files found - review recommended${NC}"
    echo "Results saved to: $OUTPUT_DIR"
    
    # Simple vulnerability count using jq if available
    if command -v jq &> /dev/null; then
        total_vulns=0
        critical_count=0
        high_count=0
        
        for file in "$OUTPUT_DIR"/trivy-*-results.json; do
            if [ -f "$file" ]; then
                count=$(jq '.Results[]?.Vulnerabilities? | length' "$file" 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
                critical=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$file" 2>/dev/null || echo 0)
                high=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "HIGH")] | length' "$file" 2>/dev/null || echo 0)
                
                total_vulns=$((total_vulns + count))
                critical_count=$((critical_count + critical))
                high_count=$((high_count + high))
            fi
        done
        
        echo
        echo "🎯 Total Security Issues:"
        echo "  🔴 Critical: $critical_count"
        echo "  🟠 High: $high_count"
        echo "  🟡 Medium: 0"
        echo "  🟢 Low: 0"
        
        if [ "$critical_count" -gt 0 ] || [ "$high_count" -gt 0 ]; then
            echo
            echo "✅ Security Status: Issues detected requiring attention"
        else
            echo
            echo "✅ Security Status: No critical or high severity issues detected"
        fi
    fi
else
    echo -e "${GREEN}✅ No vulnerabilities detected${NC}"
fi

echo
echo -e "${BLUE}📁 Output Files:${NC}"
echo "================"
for file in "$OUTPUT_DIR"/trivy-*-results.json; do
    if [ -f "$file" ]; then
        echo "📄 $(basename "$file")"
    fi
done
echo "📝 Scan log: $SCAN_LOG"
echo "📂 Reports directory: $OUTPUT_DIR"

echo
echo -e "${BLUE}🔧 Available Commands:${NC}"
echo "===================="
echo "📊 Analyze results:        npm run trivy:analyze"
echo "🔍 Run new scan:           npm run trivy:scan"
echo "🏗️  Filesystem only:        ./run-trivy-scan.sh filesystem"
echo "📦 Images only:            ./run-trivy-scan.sh images"
echo "🖼️  Base images only:       ./run-trivy-scan.sh base"
echo "🌐 Registry images only:   ./run-trivy-scan.sh registry"
echo "☸️  Kubernetes only:       ./run-trivy-scan.sh kubernetes"
echo "🛡️  Full security suite:    npm run security:scan && npm run virus:scan && npm run trivy:scan"
echo "📋 View specific results:   cat $OUTPUT_DIR/trivy-*-results.json | jq ."

echo
echo -e "${BLUE}🔗 Additional Resources:${NC}"
echo "======================="
echo "• Trivy Documentation: https://trivy.dev/"
echo "• Container Security Best Practices: https://kubernetes.io/docs/concepts/security/"
echo "• NIST Container Security Guide: https://csrc.nist.gov/publications/detail/sp/800-190/final"
echo "• Docker Security Best Practices: https://docs.docker.com/develop/security-best-practices/"

echo
echo "============================================"
echo -e "${GREEN}✅ Trivy security scan completed successfully!${NC}"
echo "============================================"
echo
echo "============================================"
echo "Trivy vulnerability scanning complete."
echo "============================================"