$domainDistinguisedName = "$((Get-ADDomain).DistinguishedName)"


$usaUsers = Get-ADUser -Filter * -SearchBase "OU=Users,OU=USA,$domainDistinguisedName"
$usaGroups = Get-ADGroup -Filter * -SearchBase "OU=Groups,OU=USA,$domainDistinguisedName"


$customerServiceAmount = ($usaUsers.Count * 0.55)
$itAmount = ($usaUsers.Count * 0.20)
$hrAmount = ($usaUsers.Count * 0.10)
$financialAmount = ($usaUsers.Count * 0.15)


Write-Host ($customerServiceAmount + $itAmount + $hrAmount + $financialAmount)
Write-Host $customerServiceAmount $itAmount $hrAmount $financialAmount


function SetRandomGroup {
    param (
        $users
    )

    foreach ( $user in $users ){
        
        if ( $customerServiceAmount -gt 0){

            Add-ADGroupMember -Identity "Customer_Service_Agents" -Members $user.name
            Write-Host "$($user.name) set in Customer Service" -BackgroundColor Black -ForegroundColor Cyan
            $customerServiceAmount = $($customerServiceAmount - 1)
            Write-Host "Available spaces $customerServiceAmount" 
        }
        elseif ($itAmount -gt 0){
            Add-ADGroupMember -Identity "IT_Department" -Members $user.name
            Write-Host "$($user.name) set in IT Department" -BackgroundColor Black -ForegroundColor Cyan
            $itAmount = $($itAmount - 1)
            Write-Host "Available spaces $itAmount"        
        }
        elseif ($hrAmount -gt 0){
            Add-ADGroupMember -Identity "HR_Department" -Members $user.name
            Write-Host "$($user.name) set in HR Department" -BackgroundColor Black -ForegroundColor Cyan
            $hrAmount = $($hrAmount - 1)
            Write-Host "Available spaces $hrAmount"        
        }
        elseif ($financialAmount -gt 0){
            Add-ADGroupMember -Identity "Financial_Department" -Members $user.name
            Write-Host "$($user.name) set in Financial Department" -BackgroundColor Black -ForegroundColor Cyan
            $financialAmount = $($financialAmount - 1)
            Write-Host "Available spaces $financialAmount"        
        }
    }


}


SetRandomGroup $usaUsers $usaGroups