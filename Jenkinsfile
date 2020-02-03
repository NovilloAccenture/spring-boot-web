pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: maven
    image: maven:alpine
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Build') {
      steps {
        container('maven') {
          sh 'mvn clean package'
        }
      }
    }
    stage('Test') {
      steps {
        container('maven') {
          sh 'mvn test'
        }
      }
    }
    stage('Sonarqube') {
    steps {
        container('maven') {
          script {
            withSonarQubeEnv(installationName: 'SonarqubeServer') { // You can override the credential to be used
              sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.6.0.1398:sonar'
          }
        }
      }
    }
  }
    stage('Deploy') {
      steps {
        container('maven') {
          sh 'mvn clean deploy -Dmaven.test.skip=true'
        }
      }
    }


}
}
                
        
        
