
# Terraform Generate AWS S3 Bucket

Generating AWS S3 Bucket with using Terraform.


## Install Terraform

You need to install terraform to your device for using this.

[@microsoft-terraform-get -started](https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash ) You can follow the link to install the terraform to your device.

![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform1.png)

### You need to open the "CreatingBucket" folder which includes ".tf" files
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform2.png)

### Open "CreateBucket.tf" and change the AWS secret and access keys.
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform3.png)

### Check the "terraform.tfstate" files
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform4.png)

If there is "terraform.tfstate" fiels in the "CreatingBucket" folder, it holds the s3 bucket info which has been generated before. If you want to create a new one, you need to delete these files from the folder.
#### There are 2 options to delete them;
#### 1) Right click and delete.
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform5.png)

#### 2) Use the command to delete files
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform6.png)

```bash
  del terraform.tfstate terraform.tfstate.backup
```
### Need to set new variables that you want to create S3 Bucket, Cloudfront Distribution and Route53 Record. 
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform7.png)

### Now you can apply the code
#### First you need to open terminal in the "CreatingBucket" folder
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform8.png)

![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform9.png)

#### You need to run “terraform init” for initializing terraform.
```bash
  terraform init
```
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform10.png)

#### Now you can run "terraform plan" for the testing the code for checking errors
```bash
  terraform plan
```
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform11.png)

#### If there are not any errors, you can run "terraform apply" to generate it
```bash
  terraform apply
```
#### It asks you that you want to perform the actions. You can write "yes" and continue.
![Screen shot for installing terraform](https://meta-assets.atlas.space/Text/terraform/terraform12.png)

The perfoming takes 4-5 minutes. And all of that should be done.

## NOTE: 
#### If anythings went wrong when creating them or If anythings was generated that you didn't want, "terraform-state" files are important and need to revert the generated files.If you want to delete the generated things that you also have in "terraform-state" files, you can run "terraform-destroy" to revert them. After run the command, the generated files will be destroyed automatically.
```bash
  terraform destroy
```


  
## Support

#### If you have any issue in any steps, you can contact with "Ümit ÇELİK (DevOps Engineer)"
- Developed by [@umitceeelik](https://www.github.com/umitceeelik)
