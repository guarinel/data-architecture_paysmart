
ecs_key_name = "kafka_deployment" 

ecs_image_id = "ami-0a12a5bec44aa9f2b"          

#ECS
ecs_cluster_name               = "kad-ecs"
ecs_instance_type              = "t3.xlarge"
ecs_desired_capacity           = 2
ecs_min_size                   = 1
ecs_max_size                   = 2
image_kafka_schema_registry    = "confluentinc/cp-schema-registry:latest"
image_kafka_schema_registry_ui = "landoop/schema-registry-ui:latest"
image_kafka_connect            = "debezium/connect:latest"
image_kafka_connect_ui         = "landoop/kafka-connect-ui"
image_kafka_ksql               = "confluentinc/cp-ksql-server:5.4.2"
image_kafka_rest_api           = "confluentinc/cp-kafka-rest:latest"

ecs_container_kafka_schema_registry_port = 8081
ecs_host_kafka_schema_registry_port      = 8081

ecs_container_kafka_connect_port = 8083
ecs_host_kafka_connect_port      = 8083

ecs_alb_kafka_schema_registry_ui_port       = 9000
ecs_container_kafka_schema_registry_ui_port = 8000
ecs_host_kafka_schema_registry_ui_port      = 8001

ecs_alb_kafka_connect_ui_port       = 9001
ecs_container_kafka_connect_ui_port = 8000
ecs_host_kafka_connect_ui_port      = 8002

ecs_alb_kafka_rest_api_port       = 9002
ecs_container_kafka_rest_api_port = 8082
ecs_host_kafka_rest_api_port      = 8082

ecs_container_kafka_ksql_port = 8088
ecs_host_kafka_ksql_port      = 8088
