variable vpcId {
    type = string
}
variable serviceSubnets {
    type = list(string)
}
variable elbSubnets {
    type = list(string)
}
variable clusterId {
    type = string
}
variable baseName {
    type = string
    default = "prom"
}
variable promPort {
    type = number
    default = 9090
}
variable elbPromPort {
  type = string
  default = null
}
variable elbName {
    type = string
    default = null
}
variable serviceName{
    type = string
    default = "prom"
}
variable promContainerName {
    type = string
    default = "prom"
}
variable promContainerPort {
    type = number
    default = null
}
variable serviceDesideredAccount{
    type = number
    default = 1
}

variable serviceLaunchType{
    type = string
    default = "FARGATE"
}
variable sgProtocol{
    type = string
    default = "tcp"
}

variable sgPromCidr{
    type = list(string)
    default = null
}
variable sgPromCidr6 {
    type = list(string)
    default = null
}
variable sgPromSgIds {
    type = list(string)
    default = []
}

variable sgPromEgressProtocol {
    type = string
    default = "-1"
}

variable sgPromEgressFrom {
    type = number
    default = 0
}
variable sgPromEgressTo {
    type = number
    default = 0
}
variable sgPromEgressCidr {
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable sgPromEgressCidr6 {
    type = list(string)
    default = null
}
variable sgPromEgressSgIds {
    type = list(string)
    default = null
}
variable promDefinition {
    type = string
    default = null
}

variable family {
    type = string
    default = "monitoring"
}

variable compatibilities {
    type = list(string)
    default = ["FARGATE"]
}
variable networkMode {
    type = string
    default = "awsvpc"
}

variable cpu {
    type = string
    default = "1024"
}

variable memory {
    type = string
    default = "2048"
}

variable lbSgName {
  type = string
  default = "${"prom"}-sg-elb"
}

variable lbSgProtocol {
  type = string
  default = "tcp"
}
variable lbSgFromPort {
  type = number
  default = null
}

variable lbSgToPort {
  type = number
  default = null
}

variable lbSgCidr {
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable lbSgCidr6 {
  type = list(string)
  default = null
}
variable lbSgAllowedIds {
  type = list(string)
  default = null
}

variable lbSgEgressProtocol {
  type = string
  default = "-1"
}

variable lbSgEgressFromPort {
  type = number
  default = 0
}

variable lbSgEgressToPort {
  type = number
  default = 0
}

variable lbSgEgressCidr {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable promHelthThreshold {
    type = number
    default = 3
}

variable promHelthInterval {
    type = number
    default = 30
}
variable promHelthMatcher {
    type = string
    default = "200"
}
variable promHelthPath {
    type = string
    default = "/-/healthy"
}
variable promHelthPort{
    type = string
    default = "traffic-port"
}
variable promHelthProtocol {
    type = string
    default = "HTTP"
}
variable promHelthTimeOut {
    type = number
    default = 3
}
variable promHelthUnhealtyThreshold {
    type = number
    default = 3    
}
variable enableKibana {
    type = bool
    default = true
}
variable kibanaCpu {
    type = string
    default = "1024"
}

variable kibanaMemory {
    type = string
    default = "2048"
}

variable kibanaDefinition{
    type = string
    default = null
}

variable sgNetworkIngress {
  type = list
  default = null 
}
variable kibanaPort {
    type = string
    default = 5601
}
variable kibanaSgProtocol{
    type = string
    default = "tcp"
}
variable elbKibanaPort {
    type = number
    default = null
}
variable kibanaSgCidr{
    type = list(string)
    default = null
}
variable kibanaSgCidr6 {
    type = list(string)
    default = null
}
variable kibanaSgSgIds {
    type = list(string)
    default = []
}

variable kibanaSgEgressProtocol {
    type = string
    default = "-1"
}

variable kibanaSgEgressFrom {
    type = number
    default = 0
}
variable kibanaSgEgressTo {
    type = number
    default = 0
}
variable kibanaSgEgressCidr {
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable kibanaSgEgressCidr6 {
    type = list(string)
    default = null
}

variable kibanaSgEgressSgIds {
    type = list(string)
    default = null
}

variable kibanaHelthThreshold {
    type = number
    default = 3
}

variable kibanaHelthInterval {
    type = number
    default = 30
}
variable kibanaHelthMatcher {
    type = string
    default = "200"
}
variable kibanaHelthPath {
    type = string
    default = "/"
}
variable kibanaHelthPort{
    type = string
    default = "traffic-port"
}
variable kibanaHelthProtocol {
    type = string
    default = "HTTP"
}
variable kibanaHelthTimeOut {
    type = number
    default = 3
}
variable kibanaHelthUnhealtyThreshold {
    type = number
    default = 3    
}

variable kibanaServiceName {
    type = string
    default = "kibana"
}

variable kibanaSvcLaunchType {
    type = string
    default = "FARGATE"
}

variable kibanaSvcSubnets {
    type = list(string)
    default = [ ]
}

variable kibanaContainerName {
    type = string
    default = "kibana"
}

variable kibanaContainerPort {
    type = number
    default = null
}

variable efsToken {
    type = string
    default = null
}

variable efsAz {
    type = string
    default = null
}

variable efsEncrypted {
    type = bool
    default = false
}
variable efsKmsKeyId {
    type = string
    default = null
}

variable fsLifeCycle {
    type = string
    default = "AFTER_30_DAYS"
}

variable efsPerformanceMode {
    type = string
    default = "generalPurpose"
}