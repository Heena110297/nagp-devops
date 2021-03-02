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
					 snapshotRepo:'demoArtifactory',
					 releaseRepo: 'demoArtifactory'
					)
					rtMavenRun(
					 pom:'pom.xml',
					 goals:'clean install',
					 deployerId: 'deployer'
					)
					rtPublishBuildInfo(
					 serverId:'demoArtifactory'
					)
				}
			}
		stage('Build Docker Image'){
			steps{
				script{
					if(scmVars.GIT_BRANCH == 'origin/dev'){
						bat 'docker build --network=host --no-cache -t heenamittal11/demo-application:%BUILD_NUMBER% -f Dockerfile .'
					}
					else{
						bat 'docker build --network=host --no-cache -t heenamittal11/demo-application-feature:%BUILD_NUMBER% -f Dockerfile .'
					}
				}
			}
		}
		stage('Push to DTR'){
			steps{
			   if(scmVars.GIT_BRANCH == 'origin/dev'){
			   bat 'docker push heenamittal11/demo-application:%BUILD_NUMBER%'
			   }
			   else{
			   bat 'docker push heenamittal11/demo-application-feature:%BUILD_NUMBER%'
			   }
			}
		}
		stage('Stop Running Container'){
			steps{
			   if(scmVars.GIT_BRANCH == 'origin/dev'){
			   bat '''
				for /f %%i in ('docker ps -aqf "name=^demo-application"') set containerId=%%i
					if("%containerId% == "") (
						echo "No Running Container"
					) else (
						docker stop %containerId%
						docker rm -f %containerId%
					)
			   '''
			   }
			   else{
			   bat '''
				for /f %%i in ('docker ps -aqf "name=^demo-application-feature"') set containerId=%%i
					if("%containerId% == "") (
						echo "No Running Container"
					) else (
						docker stop %containerId%
						docker rm -f %containerId%
					)
			   '''
			   }
		    }
	    }
    }
}

