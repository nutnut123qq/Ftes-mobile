# Thêm Logo cho App FTES

## Hướng dẫn nhanh (chỉ cần 2 bước)

### Bước 1: Thêm logo vào đây
Đặt file logo của bạn vào thư mục này với tên: **`app_icon.png`**

**Yêu cầu logo:**
- Kích thước: 1024x1024 px (hoặc lớn hơn, sẽ tự động resize)
- Định dạng: PNG
- Nền: Trong suốt (transparent) - khuyến nghị
- Hoặc nền màu trắng: #ffffff

### Bước 2: Chạy lệnh

Sau khi có file logo, mở terminal và chạy:

```bash
# Cài đặt package
flutter pub get

# Tạo icon tự động cho tất cả nền tảng
flutter pub run flutter_launcher_icons
```

Xong! Logo sẽ tự động được tạo cho:
- ✅ Android (tất cả các kích cỡ)
- ✅ iOS (tất cả các kích cỡ)
- ✅ Web
- ✅ Windows
- ✅ macOS

## Lưu ý
- Logo nên có góc bo tròn và nhìn đẹp khi hiển thị nhỏ (khoảng 20x20 px)
- Tránh chi tiết quá nhỏ, nên đơn giản và dễ nhận biết
- Kiểm tra logo trên thiết bị thật sau khi build

