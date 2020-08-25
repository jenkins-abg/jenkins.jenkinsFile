
def environmentSplitter() {
    //def envName = "${env.FILENAME}".split(" : ")
    def envName = readFile("${environmentName}")
    //if (branchName == "master") {
        //echo envName
        return envName.split(":")[1]
    //}
    //else {
    //   return 'test'
    //}
}

pipeline {
    
    environment {
        FILENAME = environmentSplitter()
    }

    agent any

    stages{
        stage ('Example') {
            steps {
                echo "Hello JENKINS"
                echo "Opening: ${env.FILENAME} "
                
                
                //echo  "${env.SECONDS}.split(":")"
            }    
        }      
    }
}

