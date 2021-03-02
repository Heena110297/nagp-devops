def scmVars
pipeline{
	agent any
	tools{
	   maven 'Maven3'
	}
	environment{
	 GIT_BRANCH = "${params.Environment}"
	}
	options{
	    timestamps()
		timeout(time: 1, unit: 'HOURS')
		skipDefaultCheckout()
		buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr:'10'))
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
		stage('Upload to Artifactory'){
			steps{
					rtMavenDeployer(
					 id: 'deployer',
					 serverId:'demoArtifactory',
					 snapshotRepo:'demoArtifactory'
					 releaseRepo: 'demoArtifactory'
					)
					rtMavenRepo(
					 pom:'pom.xml',
					 goals:'clean install',
					 deployerId: 'deployer'
					)
					rtPublishBuildInfo(
					 serverId:'demoArtifactory'
					)
				}
			}
		}
	}
}