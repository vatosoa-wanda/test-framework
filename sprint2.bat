@echo off
setlocal enabledelayedexpansion

:: Paramètres
set SRC_DIR=src\main\java\sprint2
set BUILD_DIR=build
set PACKAGE_NAME=sprint2
set LIB_DIR=lib
set FRAMEWORK_JAR=%LIB_DIR%\Framework.jar

echo ==========================================
echo  Compilation et exécution du projet test-framework
echo ==========================================

:: Nettoyage du build
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"

echo 🔧 Compilation de tous les fichiers Java en une seule fois...

:: Compiler tous les fichiers Java ensemble pour résoudre les dépendances
javac -cp "%FRAMEWORK_JAR%" -d "%BUILD_DIR%" "%SRC_DIR%\*.java"

if errorlevel 1 (
    echo ❌ Erreur lors de la compilation
    echo.
    echo Tentative de compilation fichier par fichier...
    
    :: Si la compilation groupée échoue, essayer fichier par fichier
    :: D'abord compiler les classes de base
    if exist "%SRC_DIR%\SiteController.java" (
        echo Compilation de SiteController.java
        javac -cp "%FRAMEWORK_JAR%" -d "%BUILD_DIR%" "%SRC_DIR%\SiteController.java"
        if errorlevel 1 (
            echo ❌ Erreur lors de la compilation de SiteController.java
            pause
            exit /b 1
        )
    )
    
    @REM if exist "%SRC_DIR%\PageServlet.java" (
    @REM     echo Compilation de PageServlet.java
    @REM     javac -cp "%BUILD_DIR%;%FRAMEWORK_JAR%" -d "%BUILD_DIR%" "%SRC_DIR%\PageServlet.java"
    @REM     if errorlevel 1 (
    @REM         echo ❌ Erreur lors de la compilation de PageServlet.java
    @REM         pause
    @REM         exit /b 1
    @REM     )
    @REM )
    
    :: Enfin compiler MainScanner qui dépend des autres
    if exist "%SRC_DIR%\MainScanner.java" (
        echo Compilation de MainScanner.java
        javac -cp "%BUILD_DIR%;%FRAMEWORK_JAR%" -d "%BUILD_DIR%" "%SRC_DIR%\MainScanner.java"
        if errorlevel 1 (
            echo ❌ Erreur lors de la compilation de MainScanner.java
            pause
            exit /b 1
        )
    )
)

:: Vérifier si des fichiers .class ont été créés
dir "%BUILD_DIR%\sprint2" /b >nul 2>&1
if errorlevel 1 (
    echo ❌ Aucun fichier compilé trouvé
    pause
    exit /b 1
)

echo ✅ Compilation réussie !
echo.
echo 🔧 Exécution du programme...
java -cp "%BUILD_DIR%;%FRAMEWORK_JAR%" %PACKAGE_NAME%.MainScanner

if errorlevel 1 (
    echo ❌ Erreur lors de l'exécution
    pause
    exit /b 1
)

echo ✅ Programme terminé avec succès.
pause