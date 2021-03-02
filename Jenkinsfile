def scmVars
pipeline{
	agent any
	tools{
	   maven 'Maven3'
	}
	environment{
	 GIT_BRANCH = ${params.Environment}
	}
	options{
	    timestamps()
		timeout(time: 1, unit: 'HOURS')
		skipDefaultCheckout()
		buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepSTr:'10'))
		disableConcurrentBuilds()
	}
	stages{
		stage('checkout'){
			steps{
				script{
				 scmVars = checkout scm
				}
			}
		}
		stage('Build'){
			steps{
			    echo scmVars.GIT_BRANCH
				bat "mvn install"
			}
		}
		stage('Unit Testing'){
			steps{
			    echo scmVars.GIT_BRANCH
				bat "mvn test"
			}
		}
		stage('Sonar Analysis'){
			steps{
			    withSonarQubeEnv("Test_Sonar"){
					bat "mvn sonar:sonar"
				}
			}
		}
	}
}