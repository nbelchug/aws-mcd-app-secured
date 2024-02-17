echo "----------------------- DEVELOPMENT DIRECTORY -----------------------------"
echo " Updating repository..."

NOW = date
git add .
git status
git commit -m" CODE UPDATE AT  $NOW"
git push --force-with-lease origin HEAD
clear



