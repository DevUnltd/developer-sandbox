$fork = Read-Host 'What is the repository to clone?'

$FolderName = "..\Code"
if (Test-Path $FolderName) {
    Remove-Item $FolderName -Recurse -Force -Confirm:$false
}

.\SetupGit.ps1

git clone $fork $FolderName
cd $FolderName

if(Test-Path -path $FolderName\package.json){
    npm install
}

code .