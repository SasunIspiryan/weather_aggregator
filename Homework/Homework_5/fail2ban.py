#Step1 sample-data list of recent login attempts
login_logs = [
    {"ip": "192.168.1.15", "user": "admin", "status": "failed"},
    {"ip": "10.0.0.45", "user": "root", "status": "success"},
    {"ip": "192.168.1.15", "user": "root", "status": "failed"},
    {"ip": "172.16.0.5", "user": "ubuntu", "status": "success"},
    {"ip": "192.168.1.15", "user": "admin", "status": "failed"},
    {"ip": "10.0.0.45", "user": "admin", "status": "failed"},
    {"ip": "203.0.113.8", "user": "root", "status": "failed"},
    {"ip": "203.0.113.8", "user": "root", "status": "failed"},
    {"ip": "203.0.113.8", "user": "admin", "status": "failed"},
    {"ip": "10.0.0.45", "user": "root", "status": "success"}
]

# Step 2 - Function to block an IP address across multiple firewalls
def block_ip(ip_address):
    firewall_number = 1  # Start with Firewall 1
    
    # Loop until we reach Firewall 3
    while firewall_number <= 3:
        # Print a message showing which firewall is being blocked
        print(f"Blocking {ip_address} on Firewall {firewall_number}...")
        
        # Move to the next firewall
        firewall_number += 1  

# Step 3 - Function to analyze logs and count how many times each IP appears
def analyze_logs(logs):
    # Create an empty dictionary to store counts of IP addresses
    failed_counts = {}
    
    # Loop through each log entry (each entry here is just an IP string)
    for ip in logs:
        # If IP already exists in dictionary, increment its count
        if ip in failed_counts:
            failed_counts[ip] += 1
        else:
            # Otherwise, initialize count at 1 for this IP
            failed_counts[ip] = 1
    
    # Return the dictionary containing IPs and their occurrence counts
    return failed_counts

# Step 4 - Function to analyze logs and count failed login attempts per IP
def analyze_logs(logs):
    # Dictionary to track failed login counts for each IP
    failed_counts = {}
    
    # Loop through each log entry (each entry is a dictionary with IP and status)
    for log in logs:
        ip = log["ip_address"]      # Extract the IP address from the log
        status = log["status"]      # Extract the login status (success/failed)
        
        # Only count failed login attempts
        if status == "failed":
            if ip in failed_counts:
                failed_counts[ip] += 1   # Increment count if IP already exists
            else:
                failed_counts[ip] = 1    # Initialize count if first time seen
    
    # Return dictionary mapping IPs to their number of failed attempts
    return failed_counts

# Step 5 - analyze logs
def analyze_logs(logs):
    failed_counts = {}
    
    # Count failed attempts
    for log in logs:
        ip = log["ip"]   # <-- fixed key name
        status = log["status"]
        
        if status == "failed":
            failed_counts[ip] = failed_counts.get(ip, 0) + 1
    
    # Filter and block
    banned_ips = []
    for ip, count in failed_counts.items():
        if count >= 3:
            banned_ips.append(ip)
            block_ip(ip)
    return banned_ips

# Step 6 - run
if __name__ == "__main__":
    print("Banned IPs:", analyze_logs(login_logs))