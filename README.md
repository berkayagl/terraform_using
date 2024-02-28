# Terraform

--> main.tf Terraform konfigürasyon dosyasıdır ve AWS (Amazon Web Services) sağlayıcısı üzerinde bir VPC (Virtual Private Cloud), bir subnet ve bir instance oluşturmayı hedeflemektedir. 

## Terraform bloğu

```hcl
terraform {
  backend {
    bucket         = "my-terraform-bucket"
    key            = "terraform.state"
    region         = "us-east-1"
  }
}
```

