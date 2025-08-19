# Create gMSA Account

This PowerShell script creates a Group Managed Service Account (gMSA) in Active Directory.

## Prerequisites

-   Windows Server with the Active Directory module for Windows PowerShell installed.
-   Permissions to create groups and service accounts in the specified Active Directory domain.

## Instructions

1.  Open PowerShell ISE with administrative privileges (Run as Administrator).
2.  Open the `Create_gMSA_Account.ps1` script.
3.  Modify the configurable parameters at the top of the script to match your environment.
4.  Run the script.
5.  After the script has finished, reboot the servers specified in the `$servers` variable.
