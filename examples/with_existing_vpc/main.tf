module "ecs_cluster" {
    source = "../../modules/ecs_cluster"
    capacity_providers = [ "FARGATE" ]
    cluster_name = "prometheus"
    cw_group_name = "ecs-prometheus"
    vpc_id = "vpc-0ea050a5c49266479"
}

module "prom" {
    source = "../../modules/prometheus"
    clusterId = module.ecs_cluster.cluster_id
    vpcId = "vpc-0ea050a5c49266479"
    elbSubnets = ["subnet-02425acfee64cbd76", "subnet-0d0b9f01ce5bc07f3"]
    serviceSubnets = ["subnet-0e195449f0de28392"]
    enableKibana = true
    kibanaSvcSubnets = ["subnet-0e195449f0de28392"]
    efsToken = "prom-mon"
}