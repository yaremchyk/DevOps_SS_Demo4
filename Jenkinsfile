
pipeline {
    agent any

    tools {
        terraform 'terraform'
    }

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

        stage('Terraform init and select workspace') {
            when {
              expression { params.action == 'deploy' || params.action == 'destroy'}
            }
            steps {
                script {
                    dir('terraform') {
                        withAWS(credentials:'root', region:'eu-north-1') {
                            sh 'terraform init'
                            
                        }
                    }
                }
            }
        }

        stage('Deploy app') {
            when {
              expression { params.action == 'deploy'}
            }
            steps {
                dir('terraform') {
                    withAWS(credentials:'root', region:'eu-north-1') {
                        sh 'terraform plan'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Stop app') {
            when {
                expression { params.action == 'destroy'}
            }
            steps {
                dir('terraform') {
                    withAWS(credentials:'root', region:'eu-north-1') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }


