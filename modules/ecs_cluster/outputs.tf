output cluster_id {
    value = aws_ecs_cluster.cluster.id 
}

output vpc_id {
    value =  var.vpc_id == null ? aws_vpc.default.0.id : var.vpc_id
}

output pub_subnet_ids {
    value = var.vpc_id == null ? aws_subnet.public.*.id : []
}

output priv_subnet_ids {
    value = var.vpc_id == null ? aws_subnet.private.*.id : []
}
/*
output cluster_arn {
    value = var.create_cluster ? aws_ecs_cluster.cluster.0.arn : data.aws_ecs_cluster.cluster.0.arn
}

output cluster_tags {
    value = var.create_cluster ? aws_ecs_cluster.cluster.0.tags_all : data.aws_ecs_cluster.cluster.0.tags_all
}

output cluster_name {
    value = var.create_cluster ? aws_ecs_cluster.cluster.0.name : data.aws_ecs_cluster.cluster.0.name
}

output cluster_providers {
    value = var.create_cluster ?  aws_ecs_cluster.cluster.0.capacity_providers : data.aws_ecs_cluster.cluster.0.capacity_providers
}*/