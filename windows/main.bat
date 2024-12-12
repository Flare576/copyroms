@echo off
if [%1]==[] (
    echo Do not call "main.bat" directly - use one of the other .bat files!
    exit /b
)
set filter=FILTERS\%~1
set r_folder=%~2
set l_folder=ROMS\%~3
set unzipAfter=%~4

REM Step 1 - check for rclone and download/extract if missing
if not exist rclone.exe (
    echo Downloading rclone
    setlocal enabledelayedexpansion
    set temp_dir=%TEMP%\rclone_temp
    rmdir /q /s "!temp_dir!" 2>nul
    mkdir "!temp_dir!"
    pushd !temp_dir!
    powershell -c "Invoke-WebRequest -Uri 'https://downloads.rclone.org/rclone-current-windows-amd64.zip' -OutFile 'rclone.zip'"
    powershell -Command "Expand-Archive -Path rclone.zip -DestinationPath ."
    FOR /d %%i IN (rclone-*-amd64) DO move %%i\rclone.exe rclone.exe
    popd
    copy !temp_dir!\rclone.exe .
    endlocal
)

REM Step 2 - If zips were extracted, we need to filter the filter list
if not "%unzipAfter%"=="" if exist "%l_folder%" (
    set tempFilter=%TEMP%\tempFilter%RANDOM%.txt
    del "%tempFilter%" 2>nul
    >"%tempFilter%" (
        for /f "delims=" %%z in (%filter%) do (
            setlocal enabledelayedexpansion
            set z=%%z
            set f=%%~nz
            if not exist "%l_folder%\!f!" (
                echo !z!
            )
            endlocal
        )
    )
    set filter=%tempFilter%
)

REM Step 3 - download
rclone.exe copy -v --ignore-existing --http-no-head --include-from "%filter%" ":http,url='https://myrient.erista.me':%r_folder%" "%l_folder%"

REM Step 4 - Unzip if necessary
if not "%unzipAfter%"=="" (
    pushd "%l_folder%"
    setlocal enabledelayedexpansion
    for %%z in (*.zip) do (
        echo Unzipping %%z
        set safe=%%z
        set dest=%%~nz
        set safe=!safe:'=''!
        set dest=!dest:'=''!

        powershell -Command "Expand-Archive -Path '!safe!' -DestinationPath '!dest!'"
        del "%%z"
    )
    endlocal
    popd
)
