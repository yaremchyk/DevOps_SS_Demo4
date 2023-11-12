
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
        stage('Terraform init') {
            when {
              expression { params.action == 'deploy' || params.action == 'destroy'}
            }
            steps {
                script {
                          sh 'terraform init'
               }
            }
        }

        stage('Jenkins module apply') {
            when {
              expression { params.action == 'deploy'}
            }

            steps {
                script {
                    try {
                        sh 'terraform plan'
                                sh 'terraform apply -target="module.jenkins"'
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
                echo currentBuild.result
            }
        }

        stage('Deploy app') {
            when {
              expression { params.action == 'deploy'}
            }
            steps {
                script {
                    try {
                        sh 'terraform plan'
                                sh 'terraform apply -auto-approve'
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
                echo currentBuild.result
            }
        }

        stage('Triggering App job') {
            when {
              expression { params.action == 'deploy' || params.action == 'destroy'}
            }
            steps {
                script {
                          build 'Demo4'
               }
            }
        }

        stage('Stop app') {
            when {
                expression { params.action == 'destroy'}
            }
            steps {
                script {
                    try {
                        sh 'terraform plan'
                                sh 'terraform destroy -auto-approve'
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
                echo currentBuild.result
    }
        }
    }

}
