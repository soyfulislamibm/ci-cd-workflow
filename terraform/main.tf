module "app" {
  source = "./modules/app"

  environment   = "development"
  instance_type = var.instance_type
  key_name      = "cicd-dev-key"
  ami_id        = "ami-01c952cfc86b7870d"
}