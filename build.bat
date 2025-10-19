@echo off
REM Compile les servlets, crée le WAR et déploie dans Tomcat

set APP_NAME=TestFramework
set TOMCAT_HOME=C:\apache-tomcat-10.1.28
set TOMCAT_WEBAPPS=%TOMCAT_HOME%\webapps
set SRC_DIR=src\main\java
set WEB_DIR=src\main\webapps
set LIB_DIR=lib
set BUILD_DIR=build
set WAR_FILE=%APP_NAME%.war

REM Nettoyage
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%\WEB-INF\classes"

REM Compilation - Correction du wildcard
for /r "%SRC_DIR%" %%f in (*.java) do (
    echo Compilation de %%f
    javac -cp "%LIB_DIR%\servlet-api.jar;%LIB_DIR%\Framework.jar" ^
        -d "%BUILD_DIR%\WEB-INF\classes" ^
        "%%f"
    
    if errorlevel 1 (
        echo ❌ Erreur lors de la compilation de %%f
        pause
        exit /b 1
    )
)

REM Vérifier si des fichiers .class ont été créés
dir "%BUILD_DIR%\WEB-INF\classes" /b >nul 2>&1
if errorlevel 1 (
    echo ❌ Aucun fichier compilé trouvé
    echo Vérifiez le chemin des sources: %SRC_DIR%
    pause
    exit /b 1
)

REM Copier web.xml
if exist "%WEB_DIR%\WEB-INF\web.xml" (
    copy "%WEB_DIR%\WEB-INF\web.xml" "%BUILD_DIR%\WEB-INF\"
) else (
    echo ❌ Fichier web.xml introuvable
    echo Cherché dans: %WEB_DIR%\WEB-INF\web.xml
    pause
    exit /b 1
)

REM Copier toutes les pages HTML statiques
if exist "%WEB_DIR%\*.html" (
    echo 📄 Copie des fichiers HTML depuis "%WEB_DIR%" vers "%BUILD_DIR%"...
    copy "%WEB_DIR%\*.html" "%BUILD_DIR%\" >nul
    echo ✅ Copie terminée.
) else (
    echo ⚠ Aucun fichier HTML trouvé dans "%WEB_DIR%"
)

if exist "%WEB_DIR%\web" (
    xcopy "%WEB_DIR%\web" "%BUILD_DIR%\web\" /s /i /y
) else (
    echo ⚠ Aucun dossier web trouvé
)

REM Copier libs dans le WAR
mkdir "%BUILD_DIR%\WEB-INF\lib" 2>nul
if exist "%LIB_DIR%\*.jar" (
    copy "%LIB_DIR%\*.jar" "%BUILD_DIR%\WEB-INF\lib\"
) else (
    echo ⚠ Aucun fichier JAR trouvé dans %LIB_DIR%
)

REM Créer le WAR
cd "%BUILD_DIR%"
jar cf "%WAR_FILE%" .
move "%WAR_FILE%" "..\"
cd ..

REM Déployer
if exist "%TOMCAT_WEBAPPS%\%APP_NAME%.war" del "%TOMCAT_WEBAPPS%\%APP_NAME%.war"
if exist "%TOMCAT_WEBAPPS%\%APP_NAME%" rmdir /s /q "%TOMCAT_WEBAPPS%\%APP_NAME%"
move "%WAR_FILE%" "%TOMCAT_WEBAPPS%\"

REM Redémarrer Tomcat
@REM echo Arrêt de Tomcat...
@REM call "%TOMCAT_HOME%\bin\shutdown.bat"
@REM timeout /t 3 /nobreak >nul

@REM echo Démarrage de Tomcat...
@REM call "%TOMCAT_HOME%\bin\startup.bat"

echo ✅ Déploiement terminé !
echo Application disponible sur:
echo Index : http://localhost:8080/%APP_NAME%/
echo Servlet : http://localhost:8080/%APP_NAME%/FrontServlet
pause