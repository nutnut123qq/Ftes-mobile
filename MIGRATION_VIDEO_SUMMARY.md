# Migration Video Course Player - HOÀN THÀNH ✅

## Tổng quan

Đã migrate thành công trang xem video course từ legacy code sang Clean Architecture theo chuẩn features/course.

## Trạng thái: ✅ HOÀN THÀNH

### Files đã tạo

**Domain Layer:**
- ✅ `lib/features/course/domain/entities/video_playlist.dart`
- ✅ `lib/features/course/domain/entities/video_status.dart`
- ✅ `lib/features/course/domain/constants/video_constants.dart`
- ✅ `lib/features/course/domain/usecases/get_video_playlist_usecase.dart`
- ✅ `lib/features/course/domain/usecases/get_video_status_usecase.dart`

**Data Layer:**
- ✅ `lib/features/course/data/models/video_playlist_model.dart`
- ✅ `lib/features/course/data/models/video_status_model.dart`
- ✅ Updated: `course_remote_datasource.dart` & `course_remote_datasource_impl.dart`
- ✅ Updated: `course_repository.dart` & `course_repository_impl.dart`

**Presentation Layer:**
- ✅ `lib/features/course/presentation/viewmodels/course_video_viewmodel.dart`
- ✅ `lib/features/course/presentation/pages/course_video_page.dart`
- ✅ Updated: `course_detail_page.dart` (navigation handler)

**Infrastructure:**
- ✅ Updated: `lib/features/course/di/course_injection.dart`
- ✅ Updated: `lib/core/di/injection_container.dart`
- ✅ Updated: `lib/core/constants/app_constants.dart` (routeCourseVideo)
- ✅ Updated: `lib/routes/app_routes.dart`
- ✅ Fixed: `lib/main.dart` (duplicate DI registration)

## Giải pháp kỹ thuật

### Vấn đề API Playlist (404)

API endpoint `/api/videos/{videoId}/playlist` không tồn tại trên backend.

**Giải pháp:** Sử dụng trực tiếp **Proxy URL**

```
https://api.ftes.vn/api/videos/proxy/{videoId}/master.m3u8
```

### Flow hoạt động

1. **User click lesson** trong Course Detail page
2. **Navigate** tới `CourseVideoPage` với params:
   - `lessonId`, `lessonTitle`, `courseTitle`
   - `videoUrl` (videoId), `courseId`

3. **CourseVideoPage khởi tạo:**
   ```dart
   - Get userId từ SharedPreferences
   - Call checkEnrollmentAndLoadVideo(userId, courseId, videoUrl)
   ```

4. **ViewModel xử lý:**
   ```dart
   - Check enrollment qua API
   - Nếu chưa enroll → return false → show dialog
   - Nếu đã enroll:
     - Detect video type (YouTube regex)
     - Set videoType = 'hls' or 'youtube'
     - Return true
   ```

5. **Page render video:**
   ```dart
   - YouTube: Extract ID → YouTubePlayerWidget
   - HLS: Construct proxy URL → VideoPlayerController
   ```

### Video URL Format

**HLS Proxy:**
```dart
final cleanVideoId = videoUrl.replaceAll('video_', '');
final proxyUrl = 'https://api.ftes.vn/api/videos/proxy/$cleanVideoId/master.m3u8';
```

**YouTube:**
```dart
final youtubeRegex = RegExp(r'(?:youtube\.com/(?:watch\?v=|embed/|v/|shorts/)|youtu\.be/)([a-zA-Z0-9_-]{11})');
if (youtubeRegex.hasMatch(url)) {
  // Use YouTubePlayerWidget
}
```

## Features

- ✅ Kiểm tra enrollment trước khi xem video
- ✅ Hỗ trợ cả HLS và YouTube
- ✅ Landscape mode tự động
- ✅ Error handling đầy đủ
- ✅ Clean Architecture (Domain → Data → Presentation)
- ✅ Dependency Injection với GetIt

## Bug Fixes

1. **Duplicate DI Registration:** Xóa `CourseInjection.init()` trong `main.dart` (đã có trong `injection_container.dart`)
2. **API 404:** Sử dụng proxy URL trực tiếp thay vì gọi playlist API
3. **VideoId Format:** Clean "video_" prefix trước khi construct URL

## Testing

Để test:
1. Login vào app
2. Vào Course Detail của một course đã enroll
3. Click vào một lesson
4. Video sẽ phát trong landscape mode

**HLS Video:** Proxy stream từ backend
**YouTube Video:** Embed iframe player

## Notes

- Backend không implement playlist API → dùng proxy URL
- Enrollment check bắt buộc trước khi xem
- Video controller tự động play sau khi initialize
- Landscape orientation set khi vào, reset khi thoát

