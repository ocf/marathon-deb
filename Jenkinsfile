try {
    node('slave') {
        step([$class: 'WsCleanup'])

        stage('check-out-code') {
            checkout scm
        }

        stage('build-package') {
            sh 'make build-package'
            archiveArtifacts artifacts: "marathon/target/*.deb,marathon/target/*.changes"
        }

        stash 'build'
    }

    if (env.BRANCH_NAME == 'master') {
        stage("upload-stretch") {
            build job: 'upload-changes', parameters: [
                [$class: 'StringParameterValue', name: 'path_to_changes', value: "marathon/target/*.changes"],
                [$class: 'StringParameterValue', name: 'dist', value: 'stretch'],
                [$class: 'StringParameterValue', name: 'job', value: env.JOB_NAME.replace('/', '/job/')],
                [$class: 'StringParameterValue', name: 'job_build_number', value: env.BUILD_NUMBER],
            ]
        }
    }

} catch (err) {
    def subject = "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - Failure!"
    def message = "${env.JOB_NAME} (#${env.BUILD_NUMBER}) failed: ${env.BUILD_URL}"

    if (env.BRANCH_NAME == 'master') {
        slackSend color: '#FF0000', message: message
        mail to: 'root@ocf.berkeley.edu', subject: subject, body: message
    } else {
        mail to: emailextrecipients([
            [$class: 'CulpritsRecipientProvider'],
            [$class: 'DevelopersRecipientProvider']
        ]), subject: subject, body: message
    }

    throw err
}

// vim: ft=groovy
