module "ecs_cluster" {
    source = "../../modules/ecs_cluster"
    capacity_providers = [ "FARGATE" ]
    cluster_name = "prometheus"
    cw_group_name = "ecs-prometheus"
}

module "prom" {
    source = "../../modules/prometheus"
    clusterId = module.ecs_cluster.cluster_id
    vpcId = module.ecs_cluster.vpc_id
    elbSubnets = module.ecs_cluster.pub_subnet_ids
    serviceSubnets = module.ecs_cluster.priv_subnet_ids
    enableKibana = true
    kibanaSvcSubnets = module.ecs_cluster.priv_subnet_ids
    efsToken = "prom-mon"
}