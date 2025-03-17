#!groovy

node {
    try {
        stage('Checkout') {
            checkout scm

            sh 'git log HEAD^..HEAD --pretty="%h %an - %s" > GIT_CHANGES'
            def lastChanges = readFile('GIT_CHANGES')
            echo "Recent changes: ${lastChanges}"
        }

        stage('Test') {
            // Install virtualenv if it's not available
            sh 'pip install virtualenv || pip3 install virtualenv'
            
            // Create and activate virtual environment
            sh 'python3.10 -m virtualenv env || python3 -m virtualenv env'
            
            // Use the full path to pip and python from the virtual environment
            sh '''
                . env/bin/activate
                pip install -r requirements.txt
                python manage.py test --testrunner=blog.tests.test_runners.NoDbTestRunner
                deactivate
            '''
        }

        stage('Deploy') {
            sh './deployment/deploy_prod.sh'
        }

        stage('Publish results') {
            echo "Deployment completed successfully!"
        }
    }
    catch (err) {
        // Improved error handling
        currentBuild.result = 'FAILURE'
        
        // Send detailed error notification
        echo "BUILD FAILED: ${err.message}"
        
        // Optional: You can add notifications here
        // mail to: 'team@example.com', subject: 'Build Failed', body: "${err.message}\n\nCheck console output at ${BUILD_URL}"
        
        throw err
    }
    finally {
        // This section always runs, regardless of success or failure
        echo "Build finished with result: ${currentBuild.result ?: 'SUCCESS'}"
        
        // Archive artifacts if needed
        archiveArtifacts artifacts: 'GIT_CHANGES', allowEmptyArchive: true
    }
}
