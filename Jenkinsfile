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

    agent any

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
                        index = index + 1 ;
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
    }
}

