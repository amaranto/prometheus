locals{
  baseName = "${var.baseName}-monitor"
  defaultPromDefinition=<<DEFINITION
[
  {
    "image": "prom/prometheus:latest",
    "cpu": 1024,
    "memory": 2048,
    "name": "prom",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 9090,
        "hostPort": 9090
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ecs-prometheus",
            "awslogs-region": "us-west-2",
            "awslogs-stream-prefix": "ecs-prometheus-els"
        }
    }    
  }
]
DEFINITION

  defaultKibanaDefinition=<<DEFINITION
[
  {
    "image": "kibana:7.14.1",
    "cpu": 512,
    "memory": 1024,
    "name": "kibana",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 5601,
        "hostPort": 5601
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ecs-prometheus",
            "awslogs-region": "us-west-2",
            "awslogs-stream-prefix": "ecs-prometheus-kibana"
        }
    },    
    "environment": [
        {
            "name": "ELASTICSEARCH_HOSTS",
            "value": "http://els:9200"
        }
    ]    
  },
  {
    "image": "elasticsearch:7.14.1",
    "cpu": 512,
    "memory": 1024,
    "name": "els",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 9200,
        "hostPort": 9200
      },
      {
        "containerPort": 9300,
        "hostPort": 9300
      }      
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "ecs-prometheus",
            "awslogs-region": "us-west-2",
            "awslogs-stream-prefix": "ecs-prometheus-els"
        }
    },
    "environment": [
        {
            "name": "discovery.type",
            "value": "single-node"
        }
    ]    
  }  
]  
DEFINITION
}