pipeline {
  agent {
    label 'slave'
  }

  options {
    ansiColor('xterm')
    timeout(time: 1, unit: 'HOURS')
  }

  stages {
    stage('check-gh-trust') {
      steps {
        checkGitHubAccess()
      }
    }

    stage('build-package') {
      steps {
        sh 'make build-package'
        archiveArtifacts artifacts: 'marathon/target/*.deb,marathon/target/*.changes'
      }
    }

    stage('upload-stretch') {
      when {
        branch 'master'
      }
      agent {
        label 'deploy'
      }
      steps {
        uploadChanges('stretch', 'marathon/target/*.changes')
      }
    }
  }

  post {
    failure {
      emailNotification()
    }
    always {
      node(label: 'slave') {
        ircNotification()
      }
    }
  }
}

// vim: ft=groovy
