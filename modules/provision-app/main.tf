# fe_nodes = module.app-infra-aws.fe-fe_nodes.value
# be_nodes =module.app-infra-aws.fe-be_nodes.value 

resource "aws_instance" "frontend_nodes"{
    for_each = toset(be-nodes-id)

    




    

}