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

# Taken Steps
This is the process that I followed in order to built my own AD infrastructure.

## Step 1: Windows Server Setup

I Created an isolated virtual network for the VMs:
- I used the network 10.0.0.0/24
<img width="799" height="629" alt="Pasted image 20260422200349" src="https://github.com/user-attachments/assets/9b3325f4-436a-4723-aeb8-95ac318f56d4" />
<br/>
<br/>
I added both NICs, one for internal communications and the other one for internet access through RAS/NAT.
<img width="1277" height="866" alt="Pasted image 20260422200520" src="https://github.com/user-attachments/assets/1b74f9c8-23a7-45ba-80d2-4ed8130c6d7b" />
<br/>
<br/>
Windows Sever VM successfully installed:

<img width="1029" height="773" alt="Pasted image 20260422211233" src="https://github.com/user-attachments/assets/4ecd52cd-75c6-4160-89e6-c3d77b6d412c" />
<br/>
<br/>

## Step 2: Windows Server Network Configuration

With the `ipconfig` command I identified the interfaces:
- Ethernet was the inside interface because it had an APIPA address due to a failure on DHCP.
- Ethernet 2 was using a private IPv4 Address which means it was the outside interface giving me internet connection. 
<img width="1035" height="774" alt="Pasted image 20260422212329" src="https://github.com/user-attachments/assets/0e3bea6b-aa3f-4856-a451-6e8850c054e4" />
<br/>
<br/>
I changed their name to identify them easily:
<img width="1027" height="779" alt="Pasted image 20260422212429" src="https://github.com/user-attachments/assets/53df249b-c03c-4bbf-9c56-3d514fe77b07" />
<br/>
<br/>
Applying the right network configurations to the internal network adapter:
<img width="1032" height="776" alt="Pasted image 20260422214019" src="https://github.com/user-attachments/assets/fe8d547b-b65d-4c0b-be4b-0b3170b9d808" />
<br/>
<br/>

## Step 3: Installing Active Directory Domain Services
Configured this server as the Domain Controller:
<img width="1032" height="776" alt="Pasted image 20260422221421" src="https://github.com/user-attachments/assets/1843c289-1e08-4d89-a643-cb980721716a" />
<br/>
<br/>
AD DS correctly installed:
<img width="1032" height="776" alt="Pasted image 20260422222439" src="https://github.com/user-attachments/assets/c494991b-d222-439f-a4dc-6be40dd0906d" />
<br/>
<br/>
Created an Admin Account:
<img width="1032" height="776" alt="Pasted image 20260422222742" src="https://github.com/user-attachments/assets/619a53db-51b4-44b8-a52a-7a8ab882b3c8" />
<br/>
<br/>

## Step 4: Configuring RAS/NAT
> I wanted the internal VMs to use this server in order to get access to the internet, so I configured RAS/NAT:
<img width="1032" height="776" alt="Pasted image 20260422224343" src="https://github.com/user-attachments/assets/4f5fbe89-c2fc-4cf1-bef2-883186f013b5" />
<br/>
<br/>

Configuration completed:
<img width="1032" height="776" alt="Pasted image 20260422225025" src="https://github.com/user-attachments/assets/9f8d3a3a-acb7-4a2a-897b-cde352528c6a" />
<br/>
<br/>

## Step 5: DHCP Configuration
Here are the configurations for the DHCP Server:
- Address Pool: 10.0.0.1 - 10.0.0.100
- Reserved Addresses: 10.0.0.1 - 10.0.0.10
- Default Gateway: 10.0.0.10
- DNS Server: 10.0.0.10
<br/>

<img width="891" height="671" alt="Pasted image 20260423180553" src="https://github.com/user-attachments/assets/b1e39856-8a37-4047-a3f1-5d94ed15855a" />
<br/>
<br/>
<img width="891" height="671" alt="Pasted image 20260423180609" src="https://github.com/user-attachments/assets/8a7a931a-3cc7-4d9a-9fc5-0e3480222d17" />
<br/>
<br/>

## Step 6: Creating Users with Powershell
Created a Powershell Sript that helps with:
- Single user creation
- OU creation
- Automation of multiple user creation.
Improved the user creation time and automate large processes like onboarding a lot of users at once by using my previous programming knowledge.
> Script: **Interactive_user_creation_scirpt.ps1**

<br/>

<img width="903" height="623" alt="Pasted image 20260427223012" src="https://github.com/user-attachments/assets/b1bdd871-74f4-412d-8f65-5dce88855b1b" />
<br/>
<br/>
<img width="1014" height="769" alt="Pasted image 20260427222910" src="https://github.com/user-attachments/assets/5750365e-83e4-4aa6-86b5-af314e27388f" />
<br/>
<br/>

## Step 7: Adding a Workstation and obtaining IP from DHCP Server
Added a new workstation (A Windows 10 VM) and I was able to:
- Login into an account made from the powershell script.
- Get an IP address through DCHP.
- Confirm the DNS configurations.
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

Group assignment 

First, I created 4 new Security Groups:
- IT Department
- HR Department
- Customer Service Agents
- Financial Department

> I made a Powershell script that added a certain percentage of users to each group, it helped me optimizing almost a 90% percent of the time that it would have taken me to do it manually.
> Script: **Set_Random_Group_Script.ps1**
<img width="689" height="490" alt="Pasted image 20260504205458" src="https://github.com/user-attachments/assets/e938d893-6e3c-4cb9-a08d-460b32da9c0c" />

<img width="689" height="490" alt="Pasted image 20260504205520" src="https://github.com/user-attachments/assets/b5938816-326c-4be2-ade1-611b9ec570dc" />

<br/>
<br/>

All the security groups and users were under the same OU, so I created more OUs to reorder the structure and apply GPOs properly:

> To optimized time and automate the process, I wrote a powershell script that moved every user to their corresponding OU based on the group they are in.
> Script: **Move_Users_To_OUs.ps1**
<img width="689" height="490" alt="Pasted image 20260504205426" src="https://github.com/user-attachments/assets/35081959-9f29-48c2-a9e0-f7068bf0ebdf" />

<br/>
<br/>

After an effective distribution of the Users, Security Groups, and Computers, I started assigning the GPOs:
<img width="953" height="679" alt="Pasted image 20260504203009" src="https://github.com/user-attachments/assets/0baefabc-a92a-4468-8f3f-dc61e13096d7" />

<br/>
<br/>

Finally, I configured a shared folder for each group and limited their access based on the user role (RBAC) using SHARED and NTFS permissions:
<img width="949" height="802" alt="Pasted image 20260504203943" src="https://github.com/user-attachments/assets/9ae44049-b99d-4f50-a5a5-12baf3ff156e" />

<br/>

# More Labs
This lab was used as infrastructure for this project:

- <b>Enterprise Help Desk Lab with Active Directory</b>
  - [Enterprise Help Desk Lab with Active Directory](https://github.com/AllFullPower/Ticketing-System-integration-with-AD-Environment)

