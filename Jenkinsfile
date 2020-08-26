/****************************************************************/
/*    jenkins-abg = JENKINS FILE                                */
/*                                                              */
/*    (c) jenkins-abg - https://github.com/jenkins-abg          */      
/*                                                              */
/*    Copyright (c) 2020, Paul Ryan Dedumo                      */
/*    All rights reserved.                                      */           
/*                                                              */
/*    This file is coded for specific purposes only.            */
/*    Modifying this code may result to tool malfunctioning.    */
/*                                                              */
/****************************************************************/

def _myArrayName = [] 
def index = 0
def relPath = 'C:/work/Jenkins/automation-jenkins'

//Checking for settings if user selected a file
if("${environmentName}" == ""){
    echo "No environment selected..."
    currentBuild.result = 'SUCCESS'
    return
}else{
    echo "executing pipeline..."
}

def environmentSplitter() {
    def envName = readFile("${environmentName}")
    return envName        
}

pipeline {
    
    environment {
        FILENAME = environmentSplitter()
        FILELOG = fileExists (relPath + '/Log.txt')
    }

    agent {
        node {
            label "${slaveName}"
        }
    }

    stages{       
        stage ('Reading CSV') {
            steps {
                script {
                    def settings = "${env.FILENAME}"
                    settings.split('\n').each { line, count ->
                        def fields = line.split(',')
                            node {
                                //echo fields[0] + ': ' + fields[1] ;
                                //store data in array
                                _myArrayName[index] = fields[0] + ': ' + fields[1] ;    
                            }
                        index++;
                    }
                        
                    if("${env.FILELOG}" == 'true'){
                        echo "file exists"
                    }else{
                        targetFile = new File(relPath + '/Log.txt');
                        echo "no file exists..."
                        echo "creating file..."
                    }

                    writeFile file: (relPath + '/Log.txt'), text: ("""${_myArrayName[4]}\n${_myArrayName[0]}\nError_Number:\t0\nStatus:\t Starting\nSpider Version:\t\nSpider Log Text:\t\nError##_Fix:\t""")
                }
            }
        }
        stage('Initializing...'){
            steps {
                build job: '_jenkins_Main', quietPeriod: 1
                //build job: '_jenkins_Build', quietPeriod: 1
            }
        }
        stage('Setting Startup..'){
            steps {
                build job: '_jenkins_StartUpAddress', quietPeriod: 1
                //build job: '_jenkins_Build', quietPeriod: 1
            }
        }
        stage('Detecting PL..'){
            steps {
                build job: '_jenkins_PLError', quietPeriod: 1
            }
        }
        stage('Setting Comment Result..'){
            steps {
                build job: '_jenkins_CommentResultError', quietPeriod: 1
            }
        }
        // Checking and Applying Pre-run countermeasure
        stage('Pre-run countermeasure...'){
            parallel{
                stage('jenkins_CPUEmergencyError'){
                    steps {
                        build job: '_jenkins_CPUEmergencyError', quietPeriod: 1
                    }
                }
                stage('jenkins_AssemblerError'){
                    steps {
                        build job: '_jenkins_AssemblerError', quietPeriod: 1
                    }
                }
                stage('jenkins_PragmaError'){
                    steps {
                        build job: '_jenkins_PragmaError', quietPeriod: 1
                    }
                }
            }
        }
        // Building software
        stage('Run...'){
            steps {
                build job: '_jenkins_Main', quietPeriod: 1
                //build job: '_jenkins_Build', quietPeriod: 1
            }
        }
        stage('applying jnknsByteError countermeasure...'){
            steps {
                build job: '_jenkins_ByteError', quietPeriod: 100
            }
        }
        stage('applying jnknsAmbiguousError countermeasure...'){
            steps {
                build job: '_jenkins_AmbiguousError', quietPeriod: 1
            }
        }
    }
    post {
        always {
            echo "Build results: ${buildResults.toString()}"
        }
        success {
            echo "All builds completed OK"
        }
        failure {
            echo "A job failed"
        }
    }
}

