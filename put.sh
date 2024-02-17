NOW = date
git add .
git status
git commit -m" CODE UPDATE AT  $NOW"
git push --force-with-lease origin HEAD
cd ../aws-exec/
clear
echo " ---------------------- EXECUTION DIRECTORY --------------------------------"


