# Active-Directory-and-Windows-Server-Setup



# Taken Steps
Next, I will show the steps I took to setup this AD and Windows server enviroment for future labs.

## Step 1: Windows Server Setup

I Created an isolated virtual network for the VMs:
- I used the network 10.0.0.0/24
<img width="799" height="629" alt="Pasted image 20260422200349" src="https://github.com/user-attachments/assets/9b3325f4-436a-4723-aeb8-95ac318f56d4" />
<br/>
<br/>
I added the two NICs, one for internal communications and the other for internet access through NAT.
<img width="1277" height="866" alt="Pasted image 20260422200520" src="https://github.com/user-attachments/assets/1b74f9c8-23a7-45ba-80d2-4ed8130c6d7b" />
<br/>
<br/>
Windows Sever VM successfully installed:

<img width="1029" height="773" alt="Pasted image 20260422211233" src="https://github.com/user-attachments/assets/4ecd52cd-75c6-4160-89e6-c3d77b6d412c" />
<br/>
<br/>

## Step 2: Windows Server Network Configuration
I identified the adapters: 
- Outside adapter with NAT (Connected to internet).
- Inside adapter (Internal Communications).

With the `ipconfig` command I identified the adapters:
- Ethernet was the inside because it had an APIPA address due to a fail on DHCP.
- Ethernet 2 was using a private IPv4 Address which means it was giving me internet connection. 
<img width="1035" height="774" alt="Pasted image 20260422212329" src="https://github.com/user-attachments/assets/0e3bea6b-aa3f-4856-a451-6e8850c054e4" />
<br/>
<br/>
I changed their named to identify them easily:
<img width="1027" height="779" alt="Pasted image 20260422212429" src="https://github.com/user-attachments/assets/53df249b-c03c-4bbf-9c56-3d514fe77b07" />
<br/>
<br/>
Applying the Right Network configurations to the internal network adapter:
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

Installation completed:
<img width="1032" height="776" alt="Pasted image 20260422225025" src="https://github.com/user-attachments/assets/9f8d3a3a-acb7-4a2a-897b-cde352528c6a" />
<br/>
<br/>

## Step 5: DHCP Configuration
Here are the configurations for the DHCP Server Scope:
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

<br/>

<img width="903" height="623" alt="Pasted image 20260427223012" src="https://github.com/user-attachments/assets/b1bdd871-74f4-412d-8f65-5dce88855b1b" />
<br/>
<br/>
<img width="1014" height="769" alt="Pasted image 20260427222910" src="https://github.com/user-attachments/assets/5750365e-83e4-4aa6-86b5-af314e27388f" />
<br/>
<br/>

## Step 7: Adding a Workstation and obtaining IP from DHCP Server
Obtained an IP address and checking DNS configurations. I was able to:
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



