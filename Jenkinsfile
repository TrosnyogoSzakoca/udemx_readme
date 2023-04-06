pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git branch:'main',
                    url:'https://github.com/TrosnyogoSzakoca/helloworld_http_server/'

                sh "docker build -t hello-world-http:latest ."
                sh "docker tag hello-world-http:latest localhost:5000/hello-world-http"
                sh "docker push localhost:5000/hello-world-http"
            }
        }
        stage('Deploy') {
            steps {
                sh "docker run -d hello-world-http"
            }
        }
    }
}
