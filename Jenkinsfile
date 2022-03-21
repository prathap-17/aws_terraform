pipeline {
    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Workspace/environment file to use for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')

    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent  any   
    stages {
        stage('checkout') {
            steps {
                 script{
                        echo "inside checkout"
                        dir("terraform")
                        {
                            git "https://github.com/prathap-17/aws_terraform.git"
                        }
                 }
            }
        }
  
        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage('Plan') {
            steps {
                sh 'terraform workspace new ${environment}'
                sh 'terraform workspace select ${environment}'
                sh "terraform plan -input=false -out tfplan "
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

        stage('Apply') {
            steps {
                sh "pwd;terraform apply -input=false tfplan"
                }
            }
    }
}
