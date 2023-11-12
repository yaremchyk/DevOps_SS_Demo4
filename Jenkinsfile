
pipeline {
    agent { node { label 'master' } }

    parameters {
        choice (
            choices: ['deploy', 'build', 'destroy'],
            description: '',
            name: 'action'
        )
        choice (
            choices: ['stage', 'prod'],
            description: '',
            name: 'env'
        )
    }
    stages{
        stage('Terraform init and select workspace') {
            when {
              expression { params.action == 'deploy' || params.action == 'destroy'}
            }
            steps {
                script {
                          sh 'terraform init'
               }
            }
        }

        stage('Deploy app') {
            when {
              expression { params.action == 'deploy'}
            }
            steps {
                 
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
       
            }
        }

        stage('Stop app') {
            when {
                expression { params.action == 'destroy'}
            }
            steps {
               
                        sh 'terraform destroy -auto-approve'         
            }
        }
    }

}
