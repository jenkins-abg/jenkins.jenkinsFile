def _myArrayName = [] 
def index = 0
def environmentSplitter() {
    def envName = readFile("${environmentName}")
        return envName
}

pipeline {
    
    environment {
        FILENAME = environmentSplitter()
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
                                echo fields[0] + ': ' + fields[1] ;
                                _myArrayName[index] = fields[0] + ': ' + fields[1] ;    //store data in array
                            }
                        index = index + 1 ;
                    }

                    //Creating .txt file
                    

                }
            }    
        }      
    }
}

