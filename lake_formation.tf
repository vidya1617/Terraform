# Enable Lake Formation
resource "aws_lakeformation_data_lake_settings" "lake_settings" {
  admins = ["arn:aws:iam::503561421732:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"] # Replace with your IAM Role ARN
}


# Create a Lake Formation Database
resource "aws_glue_catalog_database" "terraform_lake_db" {
  name = "terraform_lake_db"
}

# Create a Table in Lake Formation
resource "aws_glue_catalog_table" "terraform_lake_table" {
  name          = "terraform_lake_table"
  database_name = aws_glue_catalog_database.terraform_lake_db.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://your-bucket-name/lake-data/"  # Replace with your S3 bucket path
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "SerDe"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }

    columns {
      name = "id"
      type = "int"
    }

    columns {
      name = "name"
      type = "string"
    }
  }
}

# Grant Permissions to IAM Role
resource "aws_lakeformation_permissions" "lake_permissions" {
  principal = "arn:aws:iam::503561421732:role/aws-service-role/lakeformation.amazonaws.com/AWSServiceRoleForLakeFormationDataAccess"  # Replace with IAM role

  permissions = ["ALL"]

  database {
    name = aws_glue_catalog_database.terraform_lake_db.name
  }
}

# Output the Lake Formation Database Name
output "lakeformation_database_name" {
  value = aws_glue_catalog_database.terraform_lake_db.name
}