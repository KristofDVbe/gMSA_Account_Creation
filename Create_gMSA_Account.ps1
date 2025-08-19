# Configurable Parameters
$domainDN = "DC=X,DC=XXX,DC=com" # DN
$domain2 = "<subdomain>.<domain>.com" # FQDN
$group = "gMSA_Group_<Function/Name>_<ENV>" # gMSA_Group_<Function/Name>_<ENV>
$gmsa = "gmsa_<function>" #gmsa_<function>
$gmsa_description = "Group Managed Service Account for ..." # Group Managed Service Account for ...
$servers = @("<servername>","<servername>") # Servers that will need to use the gMSA account. Format: "<server>","<server>","..."
$JIRA = "TICKET-XXXX" # JIRA or SNOW ticket number

# New Group Creation
New-ADGroup -Name $group -Path "OU=Services,OU=Groups,OU=Administration,OU=ROOT,$domainDN" -Description "Security group granting access to retrieve the password of $gmsa - $JIRA" -GroupScope Global -Server $domain2

# Adding servers to the group that need to access the gMSA account
foreach($server in $servers) {
 Add-ADGroupMember -Identity $group -Members "$server$" -Server $domain2
}

# gMSA creation
New-ADServiceAccount $gmsa -DNSHostName $gmsa+"."+$domain2 -Description $gmsa_description -PrincipalsAllowedToRetrieveManagedPassword $group -Enabled $True -Server $domain2 -SamAccountName $gmsa

# Allow the gMSA to register its SPN (service principal name) for Authentication in certain Services. A lot of output will be generated.
dsacls (Get-ADServiceAccount -Identity $gmsa).DistinguishedName /G "SELF:RPWP;servicePrincipalName"

# Confirm creation of gMSA account
Write-Host "gMSA Account Details:"
# Get-ADServiceAccount -Identity $gmsa | Select Name, Enabled, SamAccountName, DistinguishedName

# Reboot the servers
Write-Host "All done! Reboot the following servers: $servers"
