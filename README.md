# AWS MCD APP DEMO

# AWS MCD APP SECURED

Terraform configuration to secure pre-deployed tea-shop app using Cisco Multicloud Defense (MCD)

# Instructions

1. Apply Tea-shop app https://github.com/jpianigiani-cisco/aws-mcd-app
2. Onboard CSP account in MCD
3. Update *.auto.tfvars file for the following parameter(s):

```
# CSP account name found in multicloud defense ui
csp_account_name_mcd_reg = ""
```

4. Apply current tf configuration with input from task 1 terraform output:

```bash
terraform apply -var-file ../aws-mcd-app/mcd_inputs.tfvars
```