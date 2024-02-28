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

# Version compatibilities


| aws-mcd-app             | aws-mcd-app-secured | Notes                                                                                       |
|-------------------------|---------------------|---------------------------------------------------------------------------------------------|
| v1.4.0                  | v1.0.0              | tea-shop frontend and backend in one or separate VPCs interconnected and secured by MCD     |
| v1.7.0                  | v2.0.0              | tea-shop frontend and backend in one or separate VPCs interconnected and secured by MCD, development, validation/staging and production environment simulation     |