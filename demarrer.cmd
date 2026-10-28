@echo off
rem ---------------------------------------------------------------
rem  Apercu local du lanceur "Mes apps"
rem  Double-clique ce fichier : il ouvre la page dans le navigateur.
rem  Ferme la fenetre noire pour arreter le serveur.
rem ---------------------------------------------------------------

cd /d "%~dp0public"
set PORT=8765

start "" "http://127.0.0.1:%PORT%/"

where python >nul 2>nul
if %errorlevel%==0 (
  python -m http.server %PORT% --bind 127.0.0.1
) else (
  py -m http.server %PORT% --bind 127.0.0.1
)

pause
