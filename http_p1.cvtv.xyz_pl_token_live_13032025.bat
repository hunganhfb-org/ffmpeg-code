@echo off
setlocal enabledelayedexpansion

:: Thư mục chứa các file segment
set SEGMENT_DIR=D:\segments

:: URL của luồng trực tiếp
set TOKEN=http://p1.cvtv.xyz/pl?token=live

:: Tự động lấy OUTPUT_NAME từ URL (tên giữa dấu '/' cuối cùng và '?')
for /f "tokens=3 delims=/" %%a in ("%TOKEN%") do (
    for /f "tokens=1 delims=?" %%b in ("%%a") do (
        set OUTPUT_NAME=%%b
    )
)

:: Tạo OUTPUT_FILE và CONCAT_LIST
set OUTPUT_FILE=D:\%OUTPUT_NAME%.mkv
set CONCAT_LIST=%SEGMENT_DIR%\concat_list.txt

:: Tạo thư mục chứa segment (nếu chưa có)
if not exist "%SEGMENT_DIR%" mkdir "%SEGMENT_DIR%"

:: Xóa các file cũ (nếu có)
del "%SEGMENT_DIR%\*.ts" >nul 2>&1
del "%CONCAT_LIST%" >nul 2>&1

:: Ghi liên tục thành các segment nhỏ (60s mỗi segment)
start "Recording" cmd /c ^
ffmpeg -i "%TOKEN%" ^
-map 0:1 -map 0:2 -map 0:3? -c copy ^
-f segment -segment_time 60 -reset_timestamps 1 ^
"%SEGMENT_DIR%\%OUTPUT_NAME%_%%03d.ts"

:WAIT
echo Đang ghi hình... Nhấn Ctrl + S để dừng và nối file.
pause >nul
goto :CHECK_KEY

:CHECK_KEY
:: Kiểm tra nếu Ctrl + S được nhấn
choice /c S /n /t 1 /d S >nul
if errorlevel 1 goto :WAIT

:: Tạo file concat_list.txt
(for %%F in ("%SEGMENT_DIR%\%OUTPUT_NAME%_*.ts") do echo file '%%F') > "%CONCAT_LIST%"

:: Nối các file segment thành file hoàn chỉnh
ffmpeg -f concat -safe 0 -i "%CONCAT_LIST%" -c copy "%OUTPUT_FILE%"

:: Xóa các file segment tạm
del "%SEGMENT_DIR%\*.ts" >nul 2>&1
del "%CONCAT_LIST%" >nul 2>&1

echo ✅ Ghi hình hoàn tất! File đã lưu tại: %OUTPUT_FILE%
pause
exit
