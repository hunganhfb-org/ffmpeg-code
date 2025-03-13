@echo off
setlocal enabledelayedexpansion

:: Cấu hình
set URL="http://p1.cvtv.xyz/SA1?token=live"
set OUTPUT="D:/UCL_SA1.mkv"

:record
:: Ghi trực tiếp vào file chính, bỏ qua track không tồn tại
echo [INFO] Đang ghi vào %OUTPUT% với các track hiện có...
ffmpeg -i %URL% -map 0:1? -map 0:2? -map 0:3? -map 0:4? -c copy -f mpegts -muxdelay 0.1 -y "%OUTPUT%"

:: Tự động reconnect nếu stream ngắt
echo [INFO] Stream ngắt, thử kết nối lại...
ping -n 2 127.0.0.1 >nul
goto record
