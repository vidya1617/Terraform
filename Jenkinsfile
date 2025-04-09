pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/vidya1617/Terraform'
            }
        }
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -target="aws_s3_bucket"."my_bucket" -target="aws_iam_role"."new_role" -out=tfplan'
            }
        }
        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
