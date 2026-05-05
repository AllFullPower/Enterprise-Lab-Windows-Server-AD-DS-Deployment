# Creating the mappings of Group name to Gruop's DistinguishedName
$groupsToOUsMapping = @{
    "IT_Department" = (Get-ADOrganizationalUnit -Filter * | Where-Object -Property "Name" -EQ "IT Department").DistinguishedName
    "HR_Department" = (Get-ADOrganizationalUnit -Filter * | Where-Object -Property "Name" -EQ "HR Department").DistinguishedName
    "Financial_Department" = (Get-ADOrganizationalUnit -Filter * | Where-Object -Property "Name" -EQ "Financial Department").DistinguishedName
    "Customer_Service_Agents" = (Get-ADOrganizationalUnit -Filter * | Where-Object -Property "Name" -EQ "Customer Service Agents").DistinguishedName
}


# Entering into the first loop that would iterate through the 4 groups
foreach ($group in $groupsToOUsMapping.Keys){
    Write-Host "Getting members from group: $group"
    
    # Getting an array with the groups members of the selected group
    $groupMemebers = Get-ADGroupMember -Identity $group

    # Getting the user object on the and then using it to get its 
    # DistinguishedName in order to use it and move the user from OU

    foreach ($member in ($groupMemebers | Where-Object {$_.objectClass -eq "user"})){
        
        $memberPath = $member.distinguishedName
        Move-ADObject $memberPath -TargetPath $groupsToOUsMapping[$group] # Moving the user

        Write-Host "$member.name correctly moved to: $($groupsToOUsMapping[$group])"
    }

}