# Project1 (with real EC2 resources):
terraform plan -out=plan.tfplan > /dev/null && terraform show -json plan.tfplan > plan.json

# Project2 (terraform-aws-pricing module):
TF_VAR_file_path=plan.json terraform apply
HOURLY_PRICE=$(terraform output -raw total_price_per_hour)


echo "HOURLY PRICE FOR THE PLAN IS $HOURLY_PRICE"

if HOURLY_PRICE < 10 then
  terraform apply plan.json # (from Project1)
else
  echo "Crash! Boom! Bang!"
end