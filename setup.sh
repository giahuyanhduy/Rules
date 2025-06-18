#!/bin/bash

# Đường dẫn tới file rules trên GitHub
RULES_URL="https://raw.githubusercontent.com/giahuyanhduy/Rules/main/50-usb-serial.rules"
# Đường dẫn đích để sao chép file
DEST_PATH="/etc/udev/rules.d/50-usb-serial.rules"

# Tải file từ GitHub
echo "Đang tải file 50-usb-serial.rules từ GitHub..."
if ! curl -fsSL "$RULES_URL" -o /tmp/50-usb-serial.rules; then
    echo "Lỗi: Không thể tải file từ GitHub. Vui lòng kiểm tra URL hoặc kết nối mạng."
    exit 1
fi

# Kiểm tra xem file đã tải có tồn tại và không rỗng
if [ ! -s /tmp/50-usb-serial.rules ]; then
    echo "Lỗi: File tải về không tồn tại hoặc rỗng."
    exit 1
fi

# Sao chép file vào /etc/udev/rules.d/ với quyền root
echo "Đang sao chép file vào /etc/udev/rules.d/..."
if ! sudo cp /tmp/50-usb-serial.rules "$DEST_PATH"; then
    echo "Lỗi: Không thể sao chép file vào $DEST_PATH. Vui lòng kiểm tra quyền."
    exit 1
fi

# Đặt quyền cho file rules
echo "Đang đặt quyền cho file..."
if ! sudo chmod 644 "$DEST_PATH"; then
    echo "Lỗi: Không thể đặt quyền cho file."
    exit 1
fi

# Reload udev rules
echo "Đang reload udev rules..."
if ! sudo udevadm control --reload-rules; then
    echo "Lỗi: Không thể reload udev rules."
    exit 1
fi

# Trigger udev
echo "Đang trigger udev..."
if ! sudo udevadm trigger; then
    echo "Lỗi: Không thể trigger udev."
    exit 1
fi

# Xóa file tạm
rm -f /tmp/50-usb-serial.rules

echo "Hoàn tất! File 50-usb-serial.rules đã được sao chép và udev rules đã được reload."
exit 0
