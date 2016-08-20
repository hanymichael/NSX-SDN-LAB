# NSX-SDN-LAB
NSX Software-defined Networking Lab - Architected and Developed by Hany Michael 

# About
NSX SDN-LAB is a fully virtualized and nested lab running on VMware’s internal cloud. This lab is architected and developed by Hany Michael – Senior Staff Architect in the Networking & Security Business Unit. If you are a VMware employee, you have an instant access to this lab as a virtual pod which could be deployed as an independent and dedicated instance from the OneCloud portal. If you are a VMware customer or a partner and would like to have an access to the lab, you can contact your account team for further guidance. This lab is vendor neutral and any of its third-party vendors listed could be replaced if required. This architecture could be used also to illustrate some of VMware’s networking and security solutions and capabilities. All the information included in this architecture reflects the exact design and configuration of the NSX SDN-LAB including but not limited to: designs, product releases, hostnames, IP addresses and so forth. The lab is also designed to be modular and could be scaled to include more sites, network, servers and/or storage resources. The future development of this lab will be based on “add-ons” to introduce other networking technologies (like MPLS), topologies (like Service-Provider models) or external clouds (like Amazon AWS, Microsoft Azure, Google CPE just to name a few).

# NSX Design & Features
NSX System:
- 2 x NSX Managers in Cross-vCenter
- 3 x Universal Controllers
- CAI: 1 x Edge Cluster + 1 x Compute
- HBE: 1 x Collapsed Edge + Compute

Multi-Rack Multi Edge Routing
- 1 x Local DLR with 1 LIF
- 4 x Edge Services Gateways
- 4 x Arista Top-of-Rack Switches
- ECMP Configuration between ESGs & Arista ToRs over 4 VLANs (50, 60, 70, 80)

Datacenter Interconnect
- 1 x Universal DLR with 3 LIFs
- 2 x ESGs in Cairo Datacenter
- 2 x ESGs in Alexandria Datacenter
- ECMP Configuration
- Local Egress

Virtual Private Networking 
- Site-to-Site VPN between CAI & HBE
- 3-Site L2-VPN in Hub (CAI) spoke (HBE + Remote) design.
- SSL-VPN Gateway in HBE for remote access 
- SSL-VPN-Clients on Remote Site

Load Balancing
- Load balancers for vCD-SP and vRA

Distributed Firewall 
- DFW with Universal FW Rules applied on the vRealize Automation Portal for end-user access.  
- DFW with Local FW Rules on the 3-Tier Web/App/DB Application.

# NSX Integrations
VMware Products
- BCDR: vCenter Site Recovery Manager
- Security: vRealize Log Insight
- Visibility: vRealize Network Insight
- Automation: vRealize Automation
- Service Provider: vCD-SP

Third-Party
- Routing: Arista vROS & Cisco CSR
- Security NI: Palo Alto Networks
- Security GI: Trend Micro 

