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
  - name: docker
    image: docker:stable-dind
    command:
    - cat
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: "/var/run/docker.sock"
  - name: helm
    image: alpine/helm:3.0.0
    command:
    - cat
    tty: true
  volumes:
  - name: dockersock
    hostPath: 
      path: "/var/run/docker.sock"
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
    stage('Deploy') {
      steps {
        container('maven') {
          script {
            //Pipeline Syntax: nexusPublisher
            nexusPublisher (nexusInstanceId: 'nexus',
            nexusRepositoryId: 'mvn-private',
            packages: [[$class: 'MavenPackage',
            mavenAssetList: [[classifier: '', extension: '', filePath: 'target/spring-boot-web-0.0.1-SNAPSHOT.jar']],
            mavenCoordinate: [artifactId: 'spring-boot-web', groupId: 'guru.springframework',
            packaging: 'jar', version: '0.0.1-SNAPSHOT']]])
    }
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
  stage('Create Docker Image') {
      steps {
        container('docker') {
          script {
          app = docker.build("novilloaccenture/imagenpipeline")
          docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
          }
        }
      }
    }
  }
  stage('Deploying to Kubernetes') {
    steps { 
      container ('helm') {
        sh '''
        helm init
        helm ls
        helm upgrade -i mychartjenkins .deploy
        '''
      }
     }
    } 
   }
  }
                
        
        
