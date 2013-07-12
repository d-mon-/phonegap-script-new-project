@echo off

GOTO:REM1
===================================================
Fichier bat créé par guérin olivier (AKA d_mon || whiteCrow)
@Byagency-interactive
contact : olivier@byagency.com

creation d'une application phonegap simplifié
variable d environnement : %phonegap% / %USERNAME / %JAVA_HOME%
=================================================
:REM1

set desktop_path=C:\Users\%username%\Desktop
echo %desktop_path%
::REM test de la viariable %JAVA_HOME%
if not exist "%JAVA_HOME%" echo JAVA_HOME non définis! &pause$exit
echo JAVA_HOME found!
cd %JAVA_HOME%
if "%errorlevel%"=="1" echo "JAVA_HOME, chemin incorrect!"&pause&exit


::REM  Verification de l existence de la variable %phonegap%, test si le chemin est correct si phonegap existe
if exist "%phonegap%" goto phonegap_exist


::REM rentrez une nouvelle variable pour %phonegap%
:define_phonegap_path
set /p phonegap= veuillez definir le chemin du lib de phonegap (ex : C:\phonegap-2.9.0\lib) :
cd %phonegap%
if "%errorlevel%"=="1" cls&echo mauvais chemin, reessayez!&goto define_phonegap_path
cd android\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\android\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path 
cd %phonegap%
cd ios\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\ios\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path  
:error_define_phonegap

set /p choices= vous avez rentre %phonegap% , voullez valider ce choix [y/n] :
if "%choices%"=="y" goto create_environment
if "%choices%"=="n" goto define_phonegap_path
echo choix invalide : %choices%
goto error_define_phonegap

::REM creation de la variable d'environnement en local
:create_environment
cd %phonegap%\
if "%errorlevel%"=="1" cls&echo mauvais chemin, reessayez!&goto define_phonegap_path
:error_create_environment
set /p choices=voulez vous definir ce chemin dans une variable d'environnement ? [y/n] :
if "%choices%"=="y" goto create_environment_var
if "%choices%"=="n" cls&goto phonegap_exist
echo choix invalide : %choices%
goto error_create_environment


::REM passage de la variable local en global (utilisation futur)
:create_environment_var
setX PHONEGAP %phonegap%
cls&goto menu


::REM simple verification du chemin 
:phonegap_exist
cd %phonegap%
if "%errorlevel%"=="1" cls&echo mauvais chemin, reessayez!&goto define_phonegap_path
echo PHONEGAP found!
cd android\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\android\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path
cd %phonegap%
cd ios\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\ios\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path
goto menu




::REM menu pour choisir la création de l'application
:menu
echo phonegap path = %phonegap%
echo ========================[MENU]========================
echo rentrez 1 pour creer une nouvelle application android
echo rentrez 2 pour creer une nouvelle application iphone
echo rentrez 9 pour modifier le chemin du dossier phonegap
echo rentrez 0 pour quitter
echo.
set /p choices= "entrez votre choix :"
if "%choices%"=="1" set mobile=android&goto creation
if "%choices%"=="2" set mobile=iphone&goto creation
if "%choices%"=="9" cls&goto define_phonegap_path
if "%choices%"=="0" exit
cls
echo choix invalide : %choices%
goto menu


::REM affectation des paramètres pour la création de l'application
:creation
cls
echo.
echo ================[CREATION DE L'APPLICATION]====================
echo vous avez choisi de creer une application %mobile%
echo vous pouvez tapez 42 a tout moment pour revenir au menu.
echo commencez la creation d'une application Phonegap 
echo (chemin,nom du dossier,nom du package,nom de l'application,...):
:error_path
echo.
set /p repo="Choisissez le repertoire (1=bureau ou C:\example\sousdossier) :"
if "%repo%"=="1" set repo=%desktop_path%
if "%repo%"=="42" cls&goto menu
cd "%repo%"
if "%errorlevel%"=="1" echo le chemin %repo% est incorrect&goto error_path
echo chemin choisi : %repo%
:continue_app
:error_filename
echo.
set /p filename="choisissez le nom du dossier :"
if "%filename%"=="42" cls&goto menu
cd "%repo%\%filename%"
if "%errorlevel%"=="0" echo le chemin %repo%\%filename% existe déjà, veuillez choisir un nom de dossier qui n'existe pas&goto error_filename

echo introuvable? PARFAIT! on peut le creer :D
:back_check_filename
echo %repo%\%filename%
echo.
set /p package_name="choisissez le nom du package (ex : com.byagency.test) :"
if "%package_name%"=="42" cls&goto menu
echo.
set /p app_name="choisissez le nom de l'applicationv (ex : my_new_app) :"
if "%app_name%"=="42" cls&goto menu


cd %phonegap%
if "%errorlevel%"=="1" goto define_phonegap_path
if "%mobile%"=="android" cd android\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\android\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path 
if "%mobile%"=="iphone" cd ios\bin
if "%errorlevel%"=="1" cls&echo le dossier %phonegap%\ios\bin est introuvable&echo veuillez redefinir un repertoire!&goto define_phonegap_path

if "%repo%"=="1" GOTO app_on_desktop

:error_create_app	 
echo.
set /p choices="souhaitez-vous lancer la commande (./create %repo%\%filename% %package_name% %app_name%) [y/n] :"

if "%choices%"=="y" goto create_application
if "%choices%"=="n" cls&goto menu
cls
echo choix invalide : %choices%
goto error_create_app



:create_application
cls
echo creation de l'application %mobile%.
echo patientez un instant
if "%mobile%"=="android" call %phonegap%\android\bin\create %repo%\%filename% %package_name% %app_name% 
if "%mobile%"=="iphone" call %phonegap%\ios\bin\create %repo%\%filename% %package_name% %app_name%
echo.
echo.
echo il ne reste plus qu'a importer le projet dans votre IDE
echo si votre application retourne un classNotFound au lancement :
echo ouvrir src/%package_name% et faire un refractor sur %app_name% (methode prefere)
echo sinon, ouvrir l'AndroidManifest.xml
echo changer l'android:name par .%app_name%
pause
goto return_menu_or_exit


:return_menu_or_exit
cls
:error_return_menu_or_exit
set /p choices= souhaitez-vous revenir au menu (y:menu,n:exit) [y/n] : 
if "%choices%"=="y" cls&goto menu
if "%choices%"=="n" exit	
echo choix invalide : %choices%
cls
goto error_return_menu_or_exit
