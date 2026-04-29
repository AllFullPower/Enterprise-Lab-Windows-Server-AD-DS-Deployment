##--- PowerShell Quick User Creation Menu
Import-Module ActiveDirectory

##-------------------- Script Variables -------------------------

$running = 0 # Controls if the loop of the menu stops or continues


$domainDistinguishedName = (Get-ADDomain).DistinguishedName #Getting the AD Domain


# Variable that stores the prompt the user will see
$selectionPrompt = "Please Select and Option:`n 
1.Load Users From A File `n 
2.Create a User `n
3.Change OU `n 
0.Exit `n

Your Selection: "


## ------------------------- Script Functions -------------------------

#==Generating the User IDs==
function GenerateUserID{
    Write-Host "Generating userID...."

    $newID = ""
    $idLength = 0

    While ($idLength -le 5){
        $randomNumber = Get-Random -Minimum 0 -Maximum 9
        $newID += $randomNumber.ToString()
        $idLength += 1 
    }

    
    Write-Host "ID Sucessfully Generated!!!"
    return $newID

}



#==Selecting the OU we will work with==
function SelectOU{
    
    # This will be used for the OU menu
    $creatingOU = 1

    while ($creatingOU -eq 1){
        
        ## Getting the avialable OUs and saving them on a variable for later use
        $availableOUsList = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Select-Object -Property Name
        Write-Host "======"
        Write-Host "AVAILABLE OUs"

        $i = 1

        # Listing available OUs
        foreach ($ou in $availableOUsList){
            Write-Host "[$i]  $(($ou).Name)"
            $i += 1
        }


        Write-Host "[C] Create new OU"
        Write-Host "======"

        $userOUSelection = Read-Host "Select an OU "
        

        # Selecting an already existing OU
        if($userOUSelection -le $i){
            $ouSelected = $availableOUsList[$userOUSelection - 1].Name
            Write-Host "You selected: $ouSelected"
            Return $ouSelected
            $creatingOU = 0
        }

        # Creating the new OU
        elseif ($userOUSelection -ieq "c"){
            Write-Host "`n Creating a new OU..."
            $ouName = Read-Host "OU Name: "


            New-ADOrganizationalUnit -Name $ouName `
            -Path "$domainDistinguishedName" `
            -ProtectedFromAccidentalDeletion $False
            # We disble this option for lab propurses, we want to manipulate
            # OUs easily.

            Write-Host "New OU: $ouName, Successfully Created!!!" -BackgroundColor Black -ForegroundColor Cyan

        }

    
    }


}


# Generating the username automatically, so you won't have to write them
function GenerateUsernameAlias{

    param(
        $userFirstName,
        $userLastName
    )

    $username = "$($userFirstName.toLower().Substring(0,1))$($userLastName.ToLower())"

    return $username
}






# This function will be used to generate the user on the AD and the selected OU
# It will received the selected OU and the newUser as an object and then add it

function GenerateUser{
    param (
        $newUser,
        $userOU
    )
        

        $password = ConvertTo-SecureString $newUser.Password -AsPlainText -Force


        New-AdUser -AccountPassword $password `
                -GivenName $newUser.Name `
                -Surname $newUser.LastName `
                -DisplayName $newUser.DisplayName `
                -Name $newUser.DisplayName `
                -SamAccountName $newUser.DisplayName `
                -EmployeeID $newUser.ID `
                -PasswordNeverExpires $true `
                -Path "OU=$userOU,$domainDistinguishedName" `
                -Enabled $true
               
        Write-Host "New User Created: $($newUser.DisplayName)" -BackgroundColor Black -ForegroundColor Cyan


}


# This function will take the users from the file and extract their first and lastanme
# Besides that it will create a username for them.


# Here resides the variable $userpassword, it can be change for any password you want
# The password is simple for lab purposes, but it must be more secure and change after the first login

function CreateUserFromFileTxt{

    param (
        $usersFromFile,
        $userOU
    )

    foreach ($user in $usersFromFile){
     
        $name = $user.Split("")[0]
        $lastName = $user.Split("")[1]

        $newUserName = GenerateUsernameAlias -userFirstName $name -userLastName $lastName
        $defaultPassword = '$P4ssw0rd1'
        # Must change the users password after creation
        # For the lab we will leave it like that.

        $userGenerated = [PSCustomObject]@{
            Name = $name
            Lastname = $lastName
            DisplayName = $newUserName
            ID = GenerateUserID
            Password = $defaultPassword

        }
  
        GenerateUser -newUser $userGenerated -userOU $userOU
    }

}




# Creating users with a while cycle until the user verified the information is rigth
function CreateNewUser{

    param (
        $userOU
    )


    $creatingUser = 1

    while ($creatingUser -eq 1){

            Write-Host "Set the new user values: "


            # Saving the user data on an object to handle it easier and
            # Reduce the amount of code.

            $newUser = [PSCustomObject]@{
                Name = Read-Host "FisrtName "
                Lastname = Read-Host "LastName "
                DisplayName = Read-Host "DisplayName "
                ID = GenerateUserID
                Password = Read-Host "Password "

    
            }


            $userConfirmation = Read-Host "Is the user information Right?`n
User First Name: $($newUser.Name) `n
User Last Name: $($newUser.Lastname) `n
User Display Name: $($newUser.DisplayName) `n
User ID: $($newUser.ID) `n
User Password: $($newUser.Password)

Select [Y/n]"

            if (($userConfirmation -eq "n") -or  ($userConfirmation -eq "N")){
                Write-Host "Deleting Information..."
                $creatingUser = 0
            }

            # Adding the user to AD.
            elseif (($userConfirmation -eq "Y") -or ($userConfirmation -eq "y") -or ($userConfirmation -eq "")){
                Write-Host "Creating User..."

                # Actually generating the user.
                GenerateUser -newUser $newUser -userOU $userOU


                
                

            }
        
    }


}






#=============================================================#
#----------------- MENU EXECUTION -----------------------------
# Here is from where the script initiates.

$currentOU = SelectOU # Selecting an OU before the loop men

## -- Menu where the user will select to either createa a user or load them
## From a .txt file with a specific format.

while ($running -eq 0){



Write-Host "`n`nWorking on OU: $currentOU" -ForegroundColor Cyan
$userSelection = Read-Host $selectionPrompt
    

    # In case user select 0 we will close the script
    if ($userSelection -eq 0){
        $running = 1
    }


    # User can load a file with names formated properly to create the users automatically
    elseif ($userSelection -eq 1){
        
       # Getting the filepath from the user
       $filePath = Read-Host "Please provide the route of the TXT file" 
       $usersFromFile = Get-Content -Path $filePath # Getting the content of the file

       CreateUserFromFileTxt -usersFromFile $usersFromFile -userOU $currentOU

       Write-Host "Users from $filePath succesfully created!!!" -BackgroundColor Black -ForegroundColor Cyan
        
    
    }

    ## Creating a new user
    elseif($userSelection -eq 2){
        CreateNewUser -userOU $currentOU


    }

    # Can go back to the OU selection menu in case user wants to select a different OU or create one
    elseif ($userSelection -eq 3){
        $currentOU = SelectOU
    }
}


##---- Recomendation ----

# In case you are loading the users from a .txt file I recommend to 
# have the file with the names in the same directory as the script
# This way you just prove the next path: ./names.txt