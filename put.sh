echo "----------------------- DEVELOPMENT DIRECTORY -----------------------------"
echo " Updating repository..."

NOW = $(date)
git add .
git status
git commit -m "$(date)"
git push --force-with-lease origin HEAD

clear



