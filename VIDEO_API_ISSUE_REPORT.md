# Báo Cáo Vấn Đề Video API

## Ngày: 27/10/2025

## 🚨 Vấn Đề Phát Hiện

Sau khi test với Bearer token thực tế, **TẤT CẢ các API endpoints video đều trả về 404 Not Found:**

### APIs Đã Test (Tất cả đều 404):

```bash
✗ GET /api/videos/3c169dd7-987/playlist?presign=true
  Response: 404 Not Found

✗ GET /api/videos/3c169dd7-987/status  
  Response: 404 Not Found

✗ GET /api/videos/proxy/3c169dd7-987/master.m3u8
  Response: 404 Not Found
```

**Bearer Token đã sử dụng:** (hợp lệ, role ADMIN)
```
eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIwZmQzYWEzOS0yNjc3LTRkNDQtOTNhOS1lNWU5ZTU4NmZlNDIiLCJzY29wZSI6IlJPTEVfQURNSU4iLCJpc3MiOiJmdW5ueWNvZGUuZWR1IiwiZXhwIjoxNzYxODIyNjcwLCJpYXQiOjE3NjE1NjM0NzAsImRldmljZUlkIjoiN2ExODllY2ItMDZmMi00NGIwLThiZTItZmMyZTc2NWY4MDI0IiwianRpIjoiZDQyNjNmMDAtYWI4ZC00OGZiLTk5NTUtNmYwNWRjMWExZmQ4In0.kbHECJvbbgLrVwPlO8zx51sG34Eg-4xMMIJGthXXyf91kgmGOFv4caSaYMDbTY5TPsVfzCRMaFez8AzlomS8dg
```

## 📋 Phân Tích

### 1. API Doc vs Reality

**API Doc (đã cung cấp):**
```
GET /api/videos/{videoId}/playlist
GET /api/videos/{videoId}/status
GET /api/videos/proxy/{videoId}/master.m3u8
```

**Thực tế:** Không có endpoint nào tồn tại trên server (tất cả 404)

### 2. Video Data Hiện Tại

Từ database/API, video được lưu dưới dạng:
- Format: `video_3c169dd7-987`
- Field trong Lesson model: `video` (String)
- Đây có thể là:
  - Video ID nội bộ
  - Hoặc direct URL (YouTube, Vimeo, etc.)

## ❓ Câu Hỏi Cần Làm Rõ

### Cho Backend Team:

1. **Các API video đã được implement chưa?**
   - `/api/videos/{videoId}/playlist`
   - `/api/videos/{videoId}/status`
   - `/api/videos/proxy/{videoId}/master.m3u8`

2. **Video ID `video_3c169dd7-987` có tồn tại trong database không?**
   - Nếu có, nó được lưu ở table/collection nào?
   - Format video ID chính xác là gì?

3. **Video hiện tại đang được stream như thế nào?**
   - Qua CDN?
   - Direct URL?
   - HLS streaming service?

### Cho Frontend/Mobile Team:

4. **Trước đây video được phát như thế nào?**
   - Có endpoint cũ nào đang hoạt động không?
   - Video URL format thực tế là gì?

5. **Có lesson/video nào đang hoạt động không?**
   - Nếu có, video URL của nó là gì?
   - Format khác `video_3c169dd7-987` không?

## 💡 Giải Pháp Tạm Thời

Đã implement **temporary workaround** trong code:

### Hiện Tại:
- ✅ Nếu video là **direct URL** (http, YouTube, etc.) → Phát trực tiếp
- ✅ Nếu video là **YouTube URL** → Sử dụng YouTube player
- ❌ Nếu video là **videoId** (format `video_xxx`) → **Hiển thị error message** yêu cầu backend implement API

### Error Message Hiển Thị:
```
Video API chưa được implement trên backend.
Video ID: video_3c169dd7-987

Vui lòng liên hệ backend team để:
1. Implement API /api/videos/{videoId}/playlist
2. Hoặc cung cấp direct video URL thay vì videoId
```

## 🔧 Các Phương Án Giải Quyết

### Phương Án 1: Backend Implement APIs (Khuyến Nghị)

**Backend cần implement:**

```typescript
// 1. Get video playlist
GET /api/videos/{videoId}/playlist
Response: {
  videoId: string,
  cdnPlaylistUrl: string,
  presignedUrl?: string,
  proxyPlaylistUrl?: string
}

// 2. Get video status
GET /api/videos/{videoId}/status
Response: {
  status: "ready" | "processing" | "failed" | "pending",
  message?: string
}

// 3. Proxy HLS streaming
GET /api/videos/proxy/{videoId}/master.m3u8
Response: HLS playlist content (.m3u8 file)
```

**Ưu điểm:**
- ✅ Security tốt (presigned URLs, auth checking)
- ✅ Có thể track video usage
- ✅ Flexible (CDN, proxy, direct URL)
- ✅ Hỗ trợ video processing status

### Phương Án 2: Lưu Direct Video URL

**Thay đổi:**
- Database: Lưu full video URL thay vì video ID
- Format: `https://cdn.example.com/videos/xxx.m3u8` hoặc `https://youtube.com/watch?v=xxx`

**Ưu điểm:**
- ✅ Đơn giản, không cần API
- ✅ Hoạt động ngay

**Nhược điểm:**
- ❌ Khó manage (thay đổi CDN/URL)
- ❌ Không có presigned URLs (security issue)
- ❌ Không track được usage

### Phương Án 3: Sử dụng Legacy Endpoint

**Nếu có endpoint cũ đang hoạt động:**
- Tìm và sử dụng endpoint video streaming hiện có
- Update code để dùng endpoint đó
- Migrate dần sang API mới

## 📝 Action Items

### Urgent (Cần làm ngay):

- [ ] **Backend:** Check xem video APIs có được implement chưa
- [ ] **Backend:** Verify video ID `video_3c169dd7-987` trong database
- [ ] **Backend:** Cung cấp thông tin về video streaming architecture hiện tại
- [ ] **Mobile:** Test với các video khác xem có video nào hoạt động không

### Short-term (Ngắn hạn):

- [ ] **Backend:** Implement video APIs nếu chưa có
- [ ] **Mobile:** Update code khi APIs ready
- [ ] **QA:** Test toàn bộ video flow

### Long-term (Dài hạn):

- [ ] Document video architecture đầy đủ
- [ ] Setup monitoring cho video streaming
- [ ] Implement video analytics

## 📊 Current Status

```
Backend Video APIs:  ❌ Not Implemented / 404
Frontend Code:       ✅ Ready (waiting for APIs)
Workaround:          ✅ Temporary error handling
Testing:             ⏸️  Blocked (waiting for backend)
```

## 📞 Liên Hệ

**Cần clarification từ:**
- Backend Team: API implementation status
- DevOps Team: Video streaming infrastructure
- Product Team: Video feature requirements

---

**Cập nhật lần cuối:** 27/10/2025
**Người báo cáo:** AI Assistant (via code analysis & API testing)

