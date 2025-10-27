# Tóm Tắt Cập Nhật API Video

## Ngày: 27/10/2025

## Vấn Đề
- Ứng dụng gặp lỗi 404 khi phát video HLS
- Code đang tự tạo URL proxy trực tiếp mà không gọi API để lấy playlist
- Sử dụng endpoint cũ `/api/videos/stream/{videoId}/master.m3u8` thay vì endpoint mới

## Giải Pháp

### 1. Cập Nhật API Endpoints (app_constants.dart)
Thêm các endpoint video mới:
```dart
// Video Endpoints
static const String videoPlaylistEndpoint = '/api/videos'; // /{videoId}/playlist
static const String videoStatusEndpoint = '/api/videos'; // /{videoId}/status
static const String videoProgressEndpoint = '/api/videos'; // /{videoId}/progress
static const String videoProxyEndpoint = '/api/videos/proxy'; // /{videoId}/master.m3u8
```

### 2. Cập Nhật VideoService (services/video_service.dart)

#### Thêm method mới:
```dart
Future<VideoPlaylistResponse> getVideoPlaylist(String videoId, {bool presign = false})
```
- Gọi API `/api/videos/{videoId}/playlist` để lấy playlist URLs
- Tự động clean videoId (remove prefix "video_")
- Trả về VideoPlaylistResponse với các URLs: cdnPlaylistUrl, presignedUrl, proxyPlaylistUrl

#### Cập nhật VideoStatus:
- Thay đổi status values: "ready", "processing", "failed", "pending" (theo API mới)
- Cập nhật logic `isReady`, `isProcessing`, `hasError`

#### Thêm model mới:
```dart
class VideoPlaylistResponse {
  final String videoId;
  final String? cdnPlaylistUrl;
  final String? presignedUrl;
  final String? proxyPlaylistUrl;
  
  String? getBestUrl() // Priority: presignedUrl > cdnPlaylistUrl > proxyPlaylistUrl
}
```

### 3. Cập Nhật VideoProvider (providers/video_provider.dart)

Thêm method mới:
```dart
Future<VideoPlaylistResponse?> fetchVideoPlaylist(String videoId, {bool presign = true})
```
- Gọi API playlist thông qua VideoService
- Handle loading state và error
- Export VideoPlaylistResponse và VideoStatus để dùng ở nơi khác

### 4. Cập Nhật CourseVideoPage (features/course/presentation/pages/course_video_page.dart)

#### Thay đổi chính:
- Bỏ method `_setupHlsVideoDirectly()` (tạo URL trực tiếp)
- Thêm method `_setupHlsVideo()` mới:
  1. Gọi `viewModel.loadVideoPlaylist()` để lấy playlist từ API
  2. Chọn URL tốt nhất theo thứ tự ưu tiên: presignedUrl > cdnPlaylistUrl > proxyPlaylistUrl
  3. Initialize video player với URL từ API
  4. Thêm error dialog khi không thể tải video

### 5. Cập Nhật Legacy Screen (screens/my_course_ongoing_video_screen.dart)

- Thay đổi từ `getPlaylistUrl()` (tạo URL trực tiếp) sang `fetchVideoPlaylist()` (gọi API)
- Sử dụng `playlist.getBestUrl()` để chọn URL tốt nhất
- Thêm fallback về proxy URL nếu không lấy được playlist từ API
- Cập nhật logic monitor video status

### 6. Cập Nhật CourseVideoViewModel (features/course/presentation/viewmodels/course_video_viewmodel.dart)

- Cập nhật comment để rõ ràng hơn về flow load playlist
- Playlist sẽ được load bởi page khi cần thiết

## Flow Mới Để Phát Video HLS

### Từ CourseVideoPage:
1. Check enrollment (via ViewModel)
2. Nếu đã enroll và là HLS video:
   - Gọi `viewModel.loadVideoPlaylist(videoId)`
   - API được gọi: `GET /api/videos/{videoId}/playlist?presign=true`
   - Nhận về VideoPlaylist với các URLs
   - Chọn URL tốt nhất (presignedUrl > cdnPlaylistUrl > proxyPlaylistUrl)
   - Initialize video player với URL đã chọn

### Từ Legacy Screen:
1. Check video status trước
2. Nếu video ready:
   - Gọi `videoProvider.fetchVideoPlaylist(videoId)`
   - Nhận về VideoPlaylistResponse
   - Sử dụng `getBestUrl()` để lấy URL tốt nhất
   - Initialize video player
3. Nếu đang processing: monitor status cho đến khi ready

## API Endpoints Sử Dụng

### 1. GET /api/videos/{videoId}/playlist
**Query Params:**
- `presign`: boolean (optional) - tạo presigned URL

**Response:**
```json
{
  "videoId": "string",
  "cdnPlaylistUrl": "string",
  "presignedUrl": "string",
  "proxyPlaylistUrl": "string"
}
```

### 2. GET /api/videos/{videoId}/status
**Response:**
```json
{
  "status": "string", // "ready", "processing", "failed", "pending"
  "message": "string"
}
```

### 3. GET /api/videos/proxy/{videoId}/master.m3u8
- Proxy endpoint để stream video (fallback)

## Lưu Ý Quan Trọng

1. **Auto-clean videoId**: Tất cả các API calls tự động xóa prefix "video_" nếu có
2. **Priority URLs**: Ưu tiên sử dụng presignedUrl > cdnPlaylistUrl > proxyPlaylistUrl
3. **Fallback**: Nếu API playlist fail, fallback về proxy URL trực tiếp
4. **Authentication**: Tất cả requests đều gửi kèm Bearer token trong header
5. **Error Handling**: Hiển thị dialog error khi không thể tải video

## Files Đã Thay Đổi

1. ✅ lib/core/constants/app_constants.dart
2. ✅ lib/services/video_service.dart
3. ✅ lib/providers/video_provider.dart
4. ✅ lib/features/course/presentation/pages/course_video_page.dart
5. ✅ lib/features/course/presentation/viewmodels/course_video_viewmodel.dart
6. ✅ lib/screens/my_course_ongoing_video_screen.dart

## Đã Bỏ Vimeo

- Không tìm thấy code xử lý Vimeo trong codebase
- Chỉ hỗ trợ 2 loại video:
  1. **HLS** (internal video) - qua API playlist
  2. **YouTube** - embed trực tiếp

## Testing

Sau khi cập nhật, test lại:
1. ✅ Phát video HLS từ CourseVideoPage
2. ✅ Phát video HLS từ MyCourseOngoingVideoScreen
3. ✅ Phát YouTube video
4. ✅ Handle video đang processing
5. ✅ Handle lỗi 404 và các lỗi khác

## Kết Quả

- ✅ Không còn lỗi 404 khi phát video
- ✅ Sử dụng đúng API mới theo documentation
- ✅ Code clean hơn, dễ maintain
- ✅ Có error handling tốt hơn
- ✅ Hỗ trợ nhiều URL options (CDN, presigned, proxy)

