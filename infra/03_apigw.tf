resource "aws_api_gateway_rest_api" "api_gw"{
    name = "Products API"
    put_rest_api_mode = "overwrite"

    endpoint_configuration {
      types = [ "REGIONAL" ]
    }

    body =  templatefile("./api2.yml", {
        apigw_name="Products API"
    })
}

resource "aws_api_gateway_deployment" "this" {
    rest_api_id = aws_api_gateway_rest_api.api_gw.id

    triggers = {
        redeployment = sha1(aws_api_gateway_rest_api.api_gw.body)
    }

    lifecycle {
      create_before_destroy = true
    }
}

# Stage do APIGW
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name = "dev"

    variables = {
        "app_client_id" = "ecommerce"
    }
}

# Usage Plan

resource "aws_api_gateway_usage_plan" "example" {
  name         = "usage-plan-1"
  description  = "Usage Plan para a API Key do Front-end"

  api_stages {
    api_id = aws_api_gateway_rest_api.api_gw.id
    stage  = aws_api_gateway_stage.this.stage_name
  }

#   quota_settings {
#     limit  = 20
#     offset = 2
#     period = "WEEK"
#   }

#   throttle_settings {
#     burst_limit = 5
#     rate_limit  = 10
#   }
}

# Permissões para chamar a lambda
