# Bootstrap

Creates the S3 bucket every other environment uses as its remote backend.
Applied manually, once per AWS account, by someone with direct AWS
credentials — never via CI/CD, since the pipeline's own role depends on
this bucket already existing.

    cd bootstrap
    terraform init
    terraform apply

`terraform.tfstate` here is gitignored on purpose: it's the only state file
in this repo not stored in S3.
