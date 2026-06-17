# Enterprise Lab: Windows Server & AD DS Deployment

## Objective
To depoy a functional Windows Domain environment using Windows Server 2022.
- This project built upon my previous lab: [Linux Virtualization Host Setup](https://github.com/AllFullPower/Linux-Virtualization-Host-Setup-QEMU-KVM-)

The goal was to implement centralized identity management and autometed network configuration (DHCP/DNS) for Windows 10 workstations. This infrastructure will be used for future labs.

## Skills Learned
- **Network Virtualization:** Configured isolated Virtual Networks and vNICs within KVM simulating a physical corporate LAN.
- **Infrastructure Services:** Deployed and authorized a DHCP server to replace host-managed networking.
- **Identity Management:** Installed a Domain Controller, managing the AD DS schema, and joining workstations to the domain.
- **Powershell Scripting:** Developed interactive CLI tools to manage Active Directory user creation, group assignment and OUs management, reducing manual administration time by 90%. 
- **Data Parsing:** Automated data entry by processing external .txt files with Powershell.
- **Identity Standardization:** Enforced organizational naming conventions through Powershell.
- **Directory Services:** Created a multi-OU structure to facilitate granular GPO application.
- **Access Control & File Integrity:** Implemented Least Privilege models using NTFS and Share permissions this combining inheritance and explicit denials.
- **Configuration Management:** Designed and deployed GPOs to standardized environment settings.
<br/>



## Tools Used
- **Host OS:** Bazzite Linux (Fedora Based).
- **Hypervisor:** QEMU/KVM via Virtual Machine Manager.
- **Server OS:** Windows Server 2022
- **Client OS:** Windows 10 Pro
- **Services:** AD DS, DHCP.
- **Scripting and Automation:** Powershell Script.
- **Role-Based Access Control (RBAC):** Methodology used for folder permission.
- **Group Policy Management Console (GPMC):** For orchestration of user/computer environments.
- **NTFS Protocol:** For network file sharing.
- **Powershell ISE:** For script development and debugging.
<br/>

# Steps Taken
This section documents the process I followed to build and configure my Active Directory infrastructure.

## Step 1: Windows Server Setup

Created an isolated virtual network using the `10.0.0.0/24` subnet for internal lab communications:

<img width="799" height="629" alt="Pasted image 20260422200349" src="https://github.com/user-attachments/assets/9b3325f4-436a-4723-aeb8-95ac318f56d4" />
<br/>
<br/>
Added two network adapters: one for internal traffic and another for internet access through RAS/NAT:
<img width="1277" height="866" alt="Pasted image 20260422200520" src="https://github.com/user-attachments/assets/1b74f9c8-23a7-45ba-80d2-4ed8130c6d7b" />
<br/>
<br/>
Windows Sever VM successfully installed:

<img width="1029" height="773" alt="Pasted image 20260422211233" src="https://github.com/user-attachments/assets/4ecd52cd-75c6-4160-89e6-c3d77b6d412c" />
<br/>
<br/>

## Step 2: Windows Server Network Configuration

Used ipconfig to identify internal and external interfaces based on their assigned IP addresses:

- "Ethernet" was the **inside** interface because it had an **APIPA** address due to a failure on DHCP.
- "Ethernet 2" was using a private IPv4 Address what means that it was the **outside** interface giving me internet connection.
   
<img width="1035" height="774" alt="Pasted image 20260422212329" src="https://github.com/user-attachments/assets/0e3bea6b-aa3f-4856-a451-6e8850c054e4" />
<br/>
<br/>
Renamed both adapters to simplify future administration and reduce configuration mistakes:
<img width="1027" height="779" alt="Pasted image 20260422212429" src="https://github.com/user-attachments/assets/53df249b-c03c-4bbf-9c56-3d514fe77b07" />
<br/>
<br/>
Configured the internal adapter with a static IP address for domain services:
<img width="1032" height="776" alt="Pasted image 20260422214019" src="https://github.com/user-attachments/assets/fe8d547b-b65d-4c0b-be4b-0b3170b9d808" />
<br/>
<br/>

## Step 3: Installing Active Directory Domain Services
Installed Active Directory Domain Services and promoted the server to a Domain Controller:
<img width="1032" height="776" alt="Pasted image 20260422221421" src="https://github.com/user-attachments/assets/1843c289-1e08-4d89-a643-cb980721716a" />
<br/>
<br/>
Verified the AD DS installation completed successfully:
<img width="1032" height="776" alt="Pasted image 20260422222439" src="https://github.com/user-attachments/assets/c494991b-d222-439f-a4dc-6be40dd0906d" />
<br/>
<br/>
Created a dedicated administrative account for domain management and daily administration tasks:
<img width="1032" height="776" alt="Pasted image 20260422222742" src="https://github.com/user-attachments/assets/619a53db-51b4-44b8-a52a-7a8ab882b3c8" />
<br/>
<br/>

## Step 4: Configuring RAS/NAT
> Configured RAS/NAT to provide internet connectivity for internal virual machines:
<img width="1032" height="776" alt="Pasted image 20260422224343" src="https://github.com/user-attachments/assets/4f5fbe89-c2fc-4cf1-bef2-883186f013b5" />
<br/>
<br/>

Verified NAT translation was functioning correctly and clients could access external networks:
<img width="1032" height="776" alt="Pasted image 20260422225025" src="https://github.com/user-attachments/assets/9f8d3a3a-acb7-4a2a-897b-cde352528c6a" />
<br/>
<br/>

## Step 5: DHCP Configuration
Configured a DHCP scope to automatically assign network settings to domain-joined devices:
<br/>

**Scope Configuration:**
- **Address Pool:** 10.0.0.1 - 10.0.0.100
- **Reserved Addresses:** 10.0.0.1 - 10.0.0.10
- **Default Gateway:** 10.0.0.10
- **DNS Server:** 10.0.0.10

<br/>

<img width="891" height="671" alt="Pasted image 20260423180553" src="https://github.com/user-attachments/assets/b1e39856-8a37-4047-a3f1-5d94ed15855a" />
<br/>
<br/>
<img width="891" height="671" alt="Pasted image 20260423180609" src="https://github.com/user-attachments/assets/8a7a931a-3cc7-4d9a-9fc5-0e3480222d17" />
<br/>
<br/>

## Step 6: Creating Users with Powershell

Developed a PowerShell script to automate user creation and Organizational Unit deployment.
Used automation to create multiple users significantly faster than manual Active Directory administration:

> Script: Interactive_User_Creation_Script.ps1

<br/>

<img width="903" height="623" alt="Pasted image 20260427223012" src="https://github.com/user-attachments/assets/b1bdd871-74f4-412d-8f65-5dce88855b1b" />
<br/>
<br/>
<img width="1014" height="769" alt="Pasted image 20260427222910" src="https://github.com/user-attachments/assets/5750365e-83e4-4aa6-86b5-af314e27388f" />
<br/>
<br/>

## Step 7: Adding a Workstation and obtaining IP from DHCP Server
Added a Windows 10 workstation and joined it to the Active Directory domain

**The workstation successfully:**

- Received an IP address from DHCP.
- Resolved domain resources through DNS.
- Logged in using a domain user account.

<br/>
<br/>

> Workstation Screenshot:
<img width="938" height="592" alt="Screenshot_20260428_231628" src="https://github.com/user-attachments/assets/b23a826a-4d03-48f8-a9b6-889b81ae3d2f" />


<br/>
<br/>

> Windows Server screenshot:
<img width="940" height="770" alt="Pasted image 20260428210649" src="https://github.com/user-attachments/assets/cf9d485c-bce1-476c-a8a4-dd6ee461143b" />

<br/>
<br/>

## Step 8: Shaping the AD infrastructure

Created departmental security groups to support access control and policy assignment:

- IT Department
- HR Department
- Customer Service Agents
- Financial Department

> Developed a PowerShell script that automatically distributed users across security groups based on defined percentages. Optimizing almost a 90% of administrative time:
> Script: **Set_Random_Group_Script.ps1**
<img width="689" height="490" alt="Pasted image 20260504205458" src="https://github.com/user-attachments/assets/e938d893-6e3c-4cb9-a08d-460b32da9c0c" />

<img width="689" height="490" alt="Pasted image 20260504205520" src="https://github.com/user-attachments/assets/b5938816-326c-4be2-ade1-611b9ec570dc" />

<br/>
<br/>

All users and groups initially existed within a single Organizational Unit

- Created additional Organizational Units to improve structure and simplify future Group Policy management.

> To optimized time and automate the process, I wrote a powershell script that moved every user to their corresponding OU based on the group they were in.
> Script: **Move_Users_To_OUs.ps1**

<img width="689" height="490" alt="Pasted image 20260504205426" src="https://github.com/user-attachments/assets/35081959-9f29-48c2-a9e0-f7068bf0ebdf" />

<br/>
<br/>

Applied Group Policy Objects after organizing users, computers, and security groups into dedicated containers:
<img width="953" height="679" alt="Pasted image 20260504203009" src="https://github.com/user-attachments/assets/0baefabc-a92a-4468-8f3f-dc61e13096d7" />

<br/>
<br/>

Configured departmental shared folders and enforced RBAC access using Share and NTFS permissions:
<img width="949" height="802" alt="Pasted image 20260504203943" src="https://github.com/user-attachments/assets/9ae44049-b99d-4f50-a5a5-12baf3ff156e" />

<br/>

# More Labs
This project provided the infrastructure used for the following lab:

- <b>Enterprise Help Desk Lab with Active Directory</b>
  - [Enterprise Help Desk Lab with Active Directory](https://github.com/AllFullPower/Ticketing-System-integration-with-AD-Environment)

