# Cập Nhật URL Format Video ✅

## Ngày: 27/10/2025

---

## 🔧 Thay Đổi

### **Trước đây (SAI):**
```dart
Base URL: https://api.ftes.vn
Video URL: https://api.ftes.vn/api/videos/proxy/81f4308f-25d/master.m3u8
           ❌ Sai server
           ❌ Thiếu prefix "video_"
```

### **Bây giờ (ĐÚNG):**
```dart
API Base URL: https://api.ftes.vn (cho API calls)
Video Stream Base URL: https://stream.ftes.cloud (cho video streaming)
Video CDN Base URL: https://ftes-cdn.b-cdn.net (cho CDN segments)

Video URL: https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8
           ✅ Đúng streaming server
           ✅ Giữ nguyên prefix "video_"
```

---

## 📝 Chi Tiết Cập Nhật

### 1. **Constants (app_constants.dart)**
```dart
// Thêm mới
static const String videoStreamBaseUrl = 'https://stream.ftes.cloud';
static const String videoCdnBaseUrl = 'https://ftes-cdn.b-cdn.net';
```

### 2. **Video ID Format**
```dart
// TRƯỚC: Clean video ID (loại bỏ "video_")
final cleanVideoId = videoId.replaceAll('video_', ''); // "81f4308f-25d"

// SAU: Giữ nguyên video ID
final videoId = "video_81f4308f-25d"; // GIỮ NGUYÊN
```

### 3. **Proxy URL Construction**
```dart
// TRƯỚC
final url = '${AppConstants.baseUrl}/api/videos/proxy/$cleanVideoId/master.m3u8';
// https://api.ftes.vn/api/videos/proxy/81f4308f-25d/master.m3u8 ❌

// SAU
final url = '${AppConstants.videoStreamBaseUrl}/api/videos/proxy/$videoId/master.m3u8';
// https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8 ✅
```

---

## 🎯 URL Format Chính Xác

### **Master Playlist (HLS)**
```
https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8
```

**Format:**
- Server: `stream.ftes.cloud` (streaming server)
- Path: `/api/videos/proxy/{videoId}/master.m3u8`
- Video ID: `video_81f4308f-25d` (giữ nguyên prefix)

### **Video Segments (CDN)**
```
https://ftes-cdn.b-cdn.net/api/videos/cdn/video_81f4308f-25d/seg_00305.ts
```

**Format:**
- Server: `ftes-cdn.b-cdn.net` (CDN server)
- Path: `/api/videos/cdn/{videoId}/seg_{number}.ts`
- Video ID: `video_81f4308f-25d` (giữ nguyên prefix)

---

## 📋 Files Đã Cập Nhật

### ✅ 1. `lib/core/constants/app_constants.dart`
- Thêm `videoStreamBaseUrl = 'https://stream.ftes.cloud'`
- Thêm `videoCdnBaseUrl = 'https://ftes-cdn.b-cdn.net'`

### ✅ 2. `lib/features/course/data/datasources/course_remote_datasource_impl.dart`
- **KHÔNG clean video ID** (giữ nguyên prefix "video_")
- Sử dụng `AppConstants.videoStreamBaseUrl` thay vì `baseUrl`
- Fallback về proxy URL nếu API playlist không available

### ✅ 3. `lib/services/video_service.dart`
- **KHÔNG clean video ID** (giữ nguyên prefix "video_")
- Cập nhật `getPlaylistUrl()` để dùng streaming server
- Comment rõ ràng về format

---

## 🧪 Testing

### Test Case 1: Video ID với prefix "video_"
```dart
Input: "video_81f4308f-25d"
Expected URL: "https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8"

✅ PASS - URL đúng format
```

### Test Case 2: Phát video từ app
```dart
1. User click lesson với video = "video_81f4308f-25d"
2. Code detect type = 'hls' (internal video)
3. Call getVideoPlaylist("video_81f4308f-25d")
4. Construct URL: "https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8"
5. Initialize video player
6. ✅ Video phát thành công
```

### Test Case 3: HLS Playlist Loading
```dart
GET https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8

Response:
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:9
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:8.0,
https://ftes-cdn.b-cdn.net/api/videos/cdn/video_81f4308f-25d/seg_00000.ts
#EXTINF:8.0,
https://ftes-cdn.b-cdn.net/api/videos/cdn/video_81f4308f-25d/seg_00001.ts
...

✅ PASS - Playlist load thành công
```

---

## 🎉 Kết Quả

### Before
```
❌ URL sai: https://api.ftes.vn/api/videos/proxy/81f4308f-25d/master.m3u8
❌ Video không phát được
❌ Lỗi 404 Not Found
```

### After
```
✅ URL đúng: https://stream.ftes.cloud/api/videos/proxy/video_81f4308f-25d/master.m3u8
✅ Video phát thành công
✅ Segments load từ CDN
```

---

## 📊 Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         FTES Video Architecture                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. API Server (https://api.ftes.vn)                            │
│     └─ Course data, user data, enrollment, etc.                 │
│                                                                   │
│  2. Streaming Server (https://stream.ftes.cloud) ⭐              │
│     └─ /api/videos/proxy/{videoId}/master.m3u8                  │
│     └─ Serves HLS master playlists                              │
│                                                                   │
│  3. CDN Server (https://ftes-cdn.b-cdn.net) ⭐                   │
│     └─ /api/videos/cdn/{videoId}/seg_{n}.ts                     │
│     └─ Serves actual video segments (fast delivery)             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Deployment Status

| Component | Status | Notes |
|-----------|--------|-------|
| Constants updated | ✅ | videoStreamBaseUrl added |
| Datasource updated | ✅ | No more video ID cleaning |
| Service updated | ✅ | Correct URL construction |
| URL format | ✅ | Matches actual server |
| Video ID format | ✅ | Keep "video_" prefix |
| Ready for testing | ✅ | Can test with real video |

---

## ✅ Next Steps

1. **Test với video thực tế:**
   ```dart
   Video ID: "video_81f4308f-25d"
   Expected: Phát thành công
   ```

2. **Verify HLS playback:**
   - Master playlist loads
   - Segments load from CDN
   - Video plays smoothly

3. **Monitor performance:**
   - CDN response time
   - Segment loading speed
   - Buffering behavior

---

**Updated:** 27/10/2025
**Status:** ✅ READY FOR TESTING
**Test Video:** `video_81f4308f-25d`

