HashValue = 12345
AWS_REGION ?= us-east-1
AWS_ACCOUNT_ID ?= 593242862402
ECR_REPO_NAME ?= container-application

init:
	terraform init -upgrade

ecr_repo:
	terraform apply -target=module.ecr --auto-approve

ssm_params:
	terraform apply -target=aws_ssm_parameter.rds_credentials --auto-approve

push_img:
	cd code && \
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com && \
	pwsh -ExecutionPolicy Bypass -File ./ecr_img_push.ps1 $(AWS_REGION) $(AWS_ACCOUNT_ID) $(ECR_REPO_NAME) "$(HashValue)" && \
	cd ..

plan:
	terraform plan

apply:
	terraform apply --auto-approve