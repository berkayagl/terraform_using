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

- `backend`: Terraform'ın durumunu nereye ve nasıl saklayacağını belirtmek için kullanılan bir yapılandırmadır. Backend, Terraform'ın durum dosyasını güvenli bir şekilde saklamasını ve paylaşmasını sağlar.

- `bucket`: Durum dosyasının saklanacağı bulut depolama alanının adını belirtir. Örnekte, `my-terraform-bucket` olarak yerleştirilmiştir. Bir AWS S3 Bucket adı veya başka bir desteklenen bulut sağlayıcısının depolama alanı adı olabilir.

- `key`: Durum dosyasının adını belirtir veya anahtarını oluşturur. `terraform.state` olarak belirlenmiştir. Anahtar, durum dosyasının bir adıdır ve tercih ettiğiniz şekilde değiştirilebilir.

- `region`: Durum dosyasının depolanacağı AWS bölgesini belirtir. Örnekte, `us-east-1` (Kuzey Virginia) olarak ayarlanmıştır. Kendi bulut sağlayıcınıza ve tercih ettiğiniz bölgeye göre bu değeri değiştirebilirsiniz.

## Provider

```hlc
provider "aws" {
 region = "us-east-1"
}
```

- `provider`: Terraform, altyapı kaynaklarını yönetmek için kullanılan sağlayıcıları tanımlamak için bu bloğu kullanır. `aws` sağlayıcısı, AWS hizmetlerini yönetmek için Terraform tarafından sağlanan bir sağlayıcıdır.

- `region`: Bu ayar, AWS bölgesini belirtir. AWS, dünya genelinde birçok coğrafi bölgede hizmet veren bir bulut sağlayıcısıdır. Her bölge, farklı veri merkezlerine ve hizmetlere sahiptir. `us-east-1`, Kuzey Virginia AWS bölgesini ifade eder. Farklı bir bölgeye ayarlamanız gerektiğinde, bu değeri tercih ettiğiniz AWS bölgesine göre değiştirmeniz gerekecektir.

## Resource VPC

```hlc
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```

- `resource`: AWS veya başka bir sağlayıcıda oluşturulacak altyapı kaynaklarını belirtmek için kullanılır. Bu örnekte, AWS sağlayıcısı altında bir kaynak oluşturulacak.

- `aws_vpc`: AWS sağlayıcısı altında oluşturulacak VPC kaynağını temsil eder. `aws_vpc` öğesi, AWS sağlayıcısının VPC kaynağını oluşturmak için kullanılan kaynak türünü belirtir. `example` ise özel bir ad (etiket) olarak belirtilmiştir.

- `cidr_block`: Bu ayar, oluşturulan VPC'nin IP adres bloğunu belirtir. VPC, özel bir sanal ağdır ve bu IP adres bloğu içindeki kaynaklar bu alan içinde çalışır. Örnekte, VPC'nin IP adres bloğu `10.0.0.0/16` olarak belirtilmiştir. CIDR bloğu, VPC'nin IP adres aralığını belirler ve tercihinize göre değiştirilebilir.

- VPC, kullanıcının özel bir ağ ortamı oluşturmasını sağlar ve ağ kaynaklarını bu sanal özel ağ içinde çalıştırma yeteneği sağlar.

## Resource Subnet

```hlc
resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}
```

- `aws_subnet`: AWS sağlayıcısı altında oluşturulacak subnet kaynağını temsil eder. `aws_subnet` öğesi, AWS sağlayıcısının subnet kaynağını oluşturmak için kullanılan kaynak türünü belirtir. `example` ise özel bir ad (etiket) olarak belirtilmiştir.

- `vpc_id`: Subnet'in bağlı olacağı VPC'nin kimliğini belirtir. `aws_vpc.example.id` ifadesi, `aws_vpc` türündeki kaynağın `example` adlı VPC'sinin kimliğini referans alır. Bu şekilde, subnet oluşturulduğunda ilgili VPC'ye bağlanır.

- `cidr_block`: Subnet'in IP adres bloğunu belirtir. Subnet, VPC'nin altında yer alan ve daha küçük bir IP adres bloğuna sahip alanlardır. Örnekte, subnet'in IP adres bloğu `10.0.1.0/24` olarak belirtilmiştir. CIDR bloğu, subnet'in IP adres aralığını belirler ve tercihinize göre değiştirilebilir.

- `map_public_ip_on_launch`: Subnet'te EC2 instance'ların başlatıldığında otomatik olarak genel IP adresine atanıp atanmayacağını belirtir. `false` olarak ayarlandığında, başlatılan EC2 instance'ların sadece özel IP adreslerine atanır. İhtiyaçlarınıza göre bu ayarı değiştirebilirsiniz.

## Resource İnstance

```hlc
resource "aws_instance" "example" {
  ami             = "ami-058face4ac718403d"
  instance_type   = "t2.nano"
  subnet_id       = aws_subnet.example.id
}
```

- `aws_instance`: Bu blok, AWS sağlayıcısı altında oluşturulacak EC2 instance kaynağını temsil eder. `aws_instance` öğesi, AWS sağlayıcısının EC2 instance kaynağını oluşturmak için kullanılan kaynak türünü belirtir. `example` ise özel bir ad (etiket) olarak belirtilmiştir.

- `ami`: Bu ayar, EC2 instance'in başlatılması için kullanılacak Amazon Machine Image (AMI) kimliğini belirtir. AMI, bir önyüklenebilir işletim sistemi ve uygulama paketlerini içeren bir sanal makine görüntüsüdür. Örnekteki `ami-058face4ac718403d`, belirli bir AMI kimliğini ifade eder. Kullanmak istediğiniz AMI'yi belirli bir bölgeye göre seçmelisiniz.

- `instance_type`: EC2 instance'in kullanacağı örnekleme tipini belirtir. Örnekleme türleri, kaynakların bellek, işlemci gücü, ağ performansı vb. özelliklerine göre farklı boyutlarda sunulur. Örnekteki `t2.nano`, en küçük tür olan nano boyutunda bir örnekleme tipidir. İhtiyaçlarınıza göre farklı bir örnekleme tipi kullanabilirsiniz.

- `subnet_id`: EC2 instance'in hangi subnet'e bağlanacağını belirtir. `aws_subnet.example.id` ifadesi, `aws_subnet` türündeki kaynağın `example` adlı subnet'inin kimliğini referans alır. Bu şekilde, EC2 instance oluşturulduğunda belirtilen subnet'e bağlanır.
