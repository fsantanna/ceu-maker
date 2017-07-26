@echo off

set CEU_SRC=%1
if exist %CEU_SRC%\main.ceu set CEU_SRC=%CEU_SRC%\main.ceu
for %%A in ("%CEU_SRC%") do (
    set CEU_DIR=%%~dpA
)

set PATH=%~dp0\..\mingw\bin

cd %~dp0

lua53.exe ceu.lua --pre --pre-args="-Iceu\include -DCEU_SRC=%CEU_SRC%" --pre-input="ceu\pico.ceu" --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass --env --env-types=ceu\env\types.h --env-main=ceu\env\main.c --cc --cc-args="-Ic\include -Lc\lib -lm -lmingw32 -lSDL2main -lSDL2 -lSDL2_gfx -lSDL2_image -lSDL2_mixer -lSDL2_ttf -lSDL2_net" --cc-output=dist\tmp.exe
if ERRORLEVEL 1 goto ERROR

mkdir %CEU_DIR%\dist\
mkdir %CEU_DIR%\dist\res\
copy %CEU_DIR%\res\*.* %CEU_DIR%\dist\res\
copy res\tiny.ttf %CEU_DIR%\dist\ > NUL
cd %CEU_DIR%\dist\

tmp.exe
if ERRORLEVEL 1 goto ERROR
exit

:ERROR
pause
