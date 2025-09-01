@echo off
setlocal

if "%~1"=="" (
  echo Usage: %~nx0 ^<input_file^>
  exit /b 1
)

where ffmpeg >nul 2>nul
if errorlevel 1 (
  echo ffmpeg not found. Add it to PATH or use PowerShell script to specify full path.
  exit /b 1
)

set "input=%~1"
if not exist "%input%" (
  echo Input file not found: %input%
  exit /b 1
)

set "base=%~dpn1"
set "output=%base%.gif"
set "palette=%base%_palette.png"

rem Create color palette
ffmpeg -y -i "%input%" -vf "fps=15,scale=512:-1:flags=lanczos,palettegen" "%palette%" || goto :err

rem Generate GIF using the palette
ffmpeg -i "%input%" -i "%palette%" -filter_complex "fps=15,scale=512:-1:flags=lanczos[x];[x][1:v]paletteuse" "%output%" || goto :err

rem Clean up palette
del /q "%palette%" 2>nul

echo ✅ GIF saved as: %output%
exit /b 0

:err
echo ffmpeg failed. Aborting.
if exist "%palette%" del /q "%palette%" 2>nul
exit /b 1
