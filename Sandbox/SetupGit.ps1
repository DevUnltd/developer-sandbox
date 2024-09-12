$username = git config user.name
if(!$username){
    $username = Read-Host 'What is your Git username?'
    git config --global user.name $username
}

$email = git config user.email
if(!$email){
    $email = Read-Host 'What is your Git email?'
    git config --global user.email $email
}