@echo off
setlocal enabledelayedexpansion

:: Cấu hình
set URL="http://p1.cvtv.xyz/SA1?token=live"
set TEMP_FILE="D:\pl_temp.mkv"
set OUTPUT_FILE="D:\pl_complete.mkv"

:: Ghi liên tục, chuyển giữa track 1 và 2
echo [INFO] Bắt đầu ghi stream...
ffmpeg -i %URL% ^
-map 0:2 -map 0:v -c copy -f mpegts -y "%TEMP_FILE%" ^
-map 0:1 -map 0:v -c copy -f mpegts -y "%TEMP_FILE%" ^
-err_detect ignore_err

:: Sau khi hoàn tất, gộp file lại
echo [INFO] Quá trình hoàn tất. Đổi tên file thành %OUTPUT_FILE%...
rename "%TEMP_FILE%" "pl_complete.mkv"

echo [INFO] Ghi xong. File đã được lưu tại %OUTPUT_FILE%.
pause
