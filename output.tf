
output "fe-nodes" {
    value = module.app-infra-aws.frontend-nodes

}

output "be-nodes" {
    value = module.app-infra-aws.backend-nodes

}

output "fe-nodes-public" {
    value = module.app-infra-aws.frontend-nodes-public
}

output "be-nodes-public" {
    value = module.app-infra-aws.backend-nodes-public

}

output "fe-nodes-id" {
    value = module.app-infra-aws.frontend-nodes-id

}

output "be-nodes-id" {
    value = module.app-infra-aws.backend-nodes-id
}
