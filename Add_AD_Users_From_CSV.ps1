# To use this script, make sure to update the path to the CSV file 
# and the column names in the CSV file to match your data.
# Also, you may need to modify the properties that are
# set on the $userObj object depending on the properties you
# want to set on your Active Directory users.

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Specify the path to the CSV file
$csvFilePath = "C:\path\to\users.csv"

# Read the CSV file
$users = Import-Csv $csvFilePath

# Loop through each user in the CSV file and create an Active Directory user
foreach ($user in $users) {
    $username = $user.Username
    $password = $user.Password
    $firstname = $user.FirstName
    $lastname = $user.LastName
    $email = $user.Email
    $ou = $user.OU

    # Create the user object
    $userObj = New-Object -TypeName Microsoft.ActiveDirectory.Management.ADUser

    # Set the user properties
    $userObj.SamAccountName = $username
    $userObj.UserPrincipalName = $username + "@yourdomain.com"
    $userObj.GivenName = $firstname
    $userObj.Surname = $lastname
    $userObj.EmailAddress = $email
    $userObj.Enabled = $true

    # Set the user's password
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $userObj.SetPassword($securePassword)

    # Get the OU to create the user in
    $ouObj = Get-ADOrganizationalUnit -Identity $ou

    # Create the user in Active Directory
    New-ADUser -Instance $userObj -Path $ouObj
}
