

variable "lamda_setup" {
  type = map
   default = {
    "name" = "Lamda_func_Terra"
    "handler_name"    = "hello-python.lambda_handler"
    "timeout" = "30"
    "python" = "python3.9"
    "filename" = "./python/hello-python.zip"
    "filter_id"   = "bar-123"
    "mirror_target_id"   = "filter-123"
    "singapore" = "sg-sin1"
  }
}

variable "iam_setup" {
  type = map
   default = {
    "policy_name" = "Lamda_func_Terra_policy"
    "role_name"    = "Lamda_func_Terra_role"   
  }
}
