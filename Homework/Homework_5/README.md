**Python "Fail2Ban" Script** **  
 **  
 **Description**  
   
 The Scenario: Imagine you are working as a Security Engineer. Your Linux server is under attack. Bots are trying to guess your passwords.  
   
 We have a list of recent login attempts. Your job is to write a Python script (fail2ban.py) that reads this data, finds the bad IP addresses (bots), and "blocks" them.  
   
 **How the script works** **  
 ** **  
 Sample login data:**  
   
 A list of dictionaries represents login attempts, each containing an IP address, username, and login status (success or failed).  
**Firewall blocking function:**  
   
 block_ip(ip_address) simulates blocking an IP across three firewalls by printing a message for each firewall.  
**Log analysis function:**  
   
 analyze_logs(logs) counts failed login attempts per IP address.  
**Threshold check:**  
   
 If an IP has 3 or more failed attempts, it is flagged as suspicious and added to the banned list.  
**Blocking action:** **  
 **  
 Each banned IP is passed to block_ip() to simulate blocking across all firewalls.  
**Program execution:**  
   
 When run, the script prints out the banned IPs and shows the simulated firewall blocking messages.  
