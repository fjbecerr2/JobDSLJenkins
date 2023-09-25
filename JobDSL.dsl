job('PruebaCreadaPorDSL-GIT') {
	description('Job creado desde DSL')
  parameters{     
    stringParam('NombreProyecto','Version-', 'Nombre de la versión')
    stringParam('NumeroVersion', '0', 'Número de la versión')
    booleanParam('EJECUTAR', false, 'Lanzar tras compilar')
    choiceParam('TipoVersion', ['snapshot (default)', 'feature', 'release'], ' Tipo de versión')                
  }  
  scm{
    git('https://github.com/fjbecerr2/HelloWord', '*/main')
  }  
  triggers{
    cron('7 14 * * *')
  }
  steps {
  	batchFile('echo Hello World!')       
  }
  publishers {
  	mailer('fjbecerr@hotmail.es', true, true)
  }
  
}

job('PruebaCreadaPorDSL-Maven-GIT') {
    scm{
    	git('https://github.com/fjbecerr2/HelloWord', '*/main')
  	}  
  	steps {
      maven {
        	mavenInstallation('Maven-Jenkins')
         	goals('-B -DskipTests clean package')        
      }
   	batchFile('''
          echo '************************************************'
          echo 'Desplegando/Ejecutando aplicación creada por DSL'
          echo '************************************************'
          echo 'Aplicación : EjemploMaven1-1.0-SNAPSHOT.jar '
          echo 'en: C:/Users/francisco.becerra/.jenkins/workspace/maven-Job1\target'
          cd C:/Users/francisco.becerra/.jenkins/workspace/maven-Job1/target
          echo '**** Lanzado el jar SIN el manifest'
          java -cp EjemploMaven1-1.0-SNAPSHOT.jar  es.EjemploMaven1.EjemploMaven1
          echo '**** Lanzado el jar CON el manifest'
          java -jar EjemploMaven1-1.0-SNAPSHOT.jar 
        ''')       
 	  }
    publishers {
        archiveArtifacts('target/*.jar')
    }
}
