## Web video lesson progress flow (FTES-frontend)

### 1. Màn detail course (web)

- **File**: `src/views/detail/index.tsx`
- Lấy data khoá học theo `slugName` và (optional) `userId`:
  - Hook: `useCourseBySlug(slugName, userIdParam, QUERY_TIME_PRESETS.NO_CACHE)`
  - Kết quả: `courseData` có `parts[]`, mỗi `part.lessons[]` chứa các trường:
    - `id`, `name`, `description`, `video`, `type`, các field trạng thái như `status`, `completed`, `watchedSeconds`, `videoDurationSeconds`, ...
- Truyền dữ liệu sang component danh sách bài học:
  - `ListLesson` (tức `ContentVideoCourse` bên videoCourse) nhận:
    - `partData`, `role`, `userJoin`, `courseId`, `slugNameCourse`, `userId`, `hasCertificate`.
- Ở màn detail **không** xử lý logic xem video / tiến độ; chỉ hiển thị và dẫn sang màn video theo slug / id / lesson.

### 2. Màn video course (web)

- **File**: `src/views/videoCourse/index.tsx` (`CourseVideo` component).
- URL params:
  - `id`: id của `Part` hiện tại.
  - `slugname`: slug của khoá học.
  - `userId`: (optional) id user truyền qua URL.
  - Query param: `lessonId` (bài học hiện tại).
- Lấy thông tin user đăng nhập:
  - Hook: `useAuth()` → `userId`, `isAuthenticated`, `user`.
- Lấy data khoá học giống màn detail:
  - Hook: `useCourseBySlug(slugname, userIdParam, QUERY_TIME_PRESETS.NO_CACHE)` → `courseData`.
  - Từ `courseData`:
    - Tìm `partData` theo `id` (param).
    - Tìm `selectedLesson` theo `selectedLessonId` (state, ban đầu từ query `lessonId`).
- Kiểm tra quyền truy cập video:
  - Hook: `useCheckVideoCourseAccess(partId, userId)`:
    - Nếu `hasAccess === false`:
      - Hiển thị thông báo lỗi (`MESSAGES.COMING_SOON`).
      - `router.push('/search')`.
- Kiểm tra user đã join khoá học:
  - Hook: `useProfileApplyCourse(userId, courseId)` với `enabled: !!userId && !!courseId`.
  - Giá trị `join` được truyền xuống header / content để điều khiển quyền thao tác và feedback.
- Tính tổng progress khoá học:
  - Hàm `calculateProgress()` duyệt tất cả `parts`:
    - `totalLessons` = tổng số `lessons`.
    - `completedLessons` = số lesson có `status === 'COMPLETED'` hoặc `completed === true`.
    - `progress% = round(completedLessons / totalLessons * 100)`.
  - Kết quả được truyền vào `VideoCourseHeader`.

### 3. Sidebar danh sách bài học

- **File**: `src/views/videoCourse/components/contentVideoCourse/index.tsx` (`ContentVideoCourse`).
- Nhận props:
  - `partData`, `courseData`, `onLessonSelect`, `selectedLessonId`, `slugname`, `userId`, `courseId`, `onClose`, `onDocumentOpen`.
- Dữ liệu dùng để render:
  - `parts = courseData.parts` nếu có, nếu không thì `[partData]` (backward compatibility).
- Tính thống kê cho từng part:
  - `getPartStats(part)`:
    - `completed = số lesson có status === 'COMPLETED'`.
    - `total = số lesson`.
    - `duration = tổng `videoDurationSeconds` hoặc `duration` → format `HH:mm:ss` hoặc `mm:ss`.
- Hiển thị mỗi `part` như 1 `Collapsible`:
  - Header:
    - Tên part, số lesson đã hoàn thành / tổng, tổng duration.
  - Body:
    - Duyệt `lessons` (sort theo `order`).
    - Tính `lessonStatus`:
      - `status` nếu có; nếu không thì `completed ? 'COMPLETED' : 'NOT_STARTED'`.
      - `getLessonStatusDisplay(lessonStatus)` để lấy màu / icon.
    - Nếu `type === 'VIDEO'`:
      - Render `Link` nhưng thực tế `href="#!"` và xử lý `onClick`:
        - Gọi `onLessonSelect(lesson.id)` (callback từ `CourseVideo`).
        - `ContentVideoCourse` không tự điều hướng; logic điều hướng bài học hiện tại do `CourseVideo` giữ (`selectedLessonId`).
    - Nếu **không phải video** (document/slide/exercise):
      - Render `button`:
        - Gọi `onDocumentOpen(lesson.id)` (callback từ `CourseVideo`) → sẽ đánh dấu hoàn thành (xem bên dưới).
        - Gọi `showDocumentModal(item.video)` → hiển thị nội dung HTML trong modal (`Modal` của antd).
    - Icon trạng thái:
      - Nếu `lessonStatus === 'COMPLETED'` → hiển thị `CheckCircle`.
      - Nếu `lessonStatus === 'IN_PROGRESS'` → hiển thị `BsPlayCircleFill`.
- Ở cuối danh sách:
  - Nếu `courseData.hasCertificate === true`:
    - Link sang `/certificate/{userId}/{courseId}`.
  - Nếu không:
    - Hiển thị tiêu đề certificate bị khoá kèm `LockOutlined`.

### 4. Hook quản lý tiến độ bài học

- **File**: `src/views/videoCourse/hooks/useLessonProgress.ts`.
- API sử dụng:
  - `lessonProgressApi.postVideoProgress(data: VideoProgressRequest)`:
    - Endpoint: `POST /lesson-progress/video?userId={optional}`.
    - Body:
      - `courseId`
      - `lessonId`
      - `watchedSeconds`
      - `videoDurationSeconds`
    - Backend quyết định `status`:
      - Trong comment ghi: `status = COMPLETED` nếu `watchedSeconds / videoDurationSeconds ≥ 0.9 (90%)`.
  - `lessonProgressApi.completeLesson(data: CompleteLessonRequest)`:
    - Endpoint: `POST /lesson-progress/complete?userId={optional}`.
    - Body:
      - `courseId`
      - `lessonId`
    - Dùng cho **bài không phải video** (document / slide / exercise).
- Hook `useLessonProgress({ userId, courseId, courseSlug, onStatusChange })` trả về:
  - `updateVideoProgress(lessonId, watchedSeconds, videoDurationSeconds, forceSync?)`
  - `syncProgressPeriodically(lessonId, watchedSeconds, videoDurationSeconds)`
  - `markLessonComplete(lessonId)`

#### 4.1. updateVideoProgress

- Mục đích: cập nhật liên tục tiến độ xem video (gửi watchedSeconds, duration).
- Bảo vệ / tối ưu:
  - Nếu thiếu `userId` hoặc `courseId` → **return** (không gọi API).
  - Dùng throttling:
    - Lưu `lastProgressUpdateRef` (lessonId, watched, duration, timestamp).
    - Nếu gọi liên tiếp cùng `lessonId`:
      - Bỏ qua nếu:
        - Thời gian từ lần update trước `< 5000ms` **và**
        - Thay đổi phần trăm tiến độ `< 5%`.
  - Debounce:
    - Xoá timeout cũ nếu có.
    - Đặt `setTimeout` 1 giây mới gọi API thực sự (responsive hơn khi kéo seek bar).
- Khi gọi API:
  - `lessonProgressApi.postVideoProgress({ courseId, lessonId, watchedSeconds: floor(watchedSeconds), videoDurationSeconds: floor(videoDurationSeconds), userId })`.
  - Sau khi thành công:
    - Cập nhật `lastProgressUpdateRef` với status mới từ `response.data.status`.
    - Cập nhật `lastSyncedWatchedSecondsRef` để track watchedSeconds đã sync.
    - Invalidate cache React Query:
      - `queryKeys.courses.bySlug(courseSlug)`
      - `queryKeys.courses.detail(courseId)`
    - Gọi callback `onStatusChange(lessonId, newStatus)` nếu có.
    - Nếu `newStatus === 'COMPLETED'` và `previousStatus !== 'COMPLETED'` → show toast "Đã hoàn thành bài học!".
- Xử lý lỗi:
  - Log console.
  - Nếu lỗi không phải network timeout hoặc status >= 500 → toast lỗi `"Lỗi khi cập nhật tiến độ. Vui lòng thử lại!"`.

#### 4.2. syncProgressPeriodically

- Mục đích: đồng bộ định kỳ `watchedSeconds` để tránh mất dữ liệu khi user xem lâu.
- Được gọi từ `InternalVideoBlock.onWatchedSecondsChange` (chi tiết ở phần dưới).
- Logic:
  - Nếu thiếu `userId` hoặc `courseId` → **return**.
  - Chỉ sync nếu `|watchedSeconds - lastSyncedWatchedSecondsRef.current| >= 1` giây.
  - Gọi `updateVideoProgress(lessonId, watchedSeconds, videoDurationSeconds, true)`:
    - `forceSync = true` bỏ qua throttling/thời gian giữa các lần update.

#### 4.3. markLessonComplete

- Mục đích: đánh dấu hoàn thành các lesson **không phải video**.
- Luồng:
  - Kiểm tra `userId` và `courseId`:
    - Nếu thiếu → toast "Vui lòng đăng nhập để đánh dấu hoàn thành" và dừng.
  - Gọi `lessonProgressApi.completeLesson({ courseId, lessonId, userId })`.
  - Nếu `response.data.status === 'COMPLETED'`:
    - Gọi `onStatusChange(lessonId, 'COMPLETED')` (nếu có).
    - Invalidate và refetch:
      - `queryKeys.courses.bySlug(courseSlug)`:
        - `invalidateQueries`.
        - `refetchQueries` ngay sau đó để UI cập nhật trạng thái lesson.
      - `queryKeys.courses.detail(courseId)`:
        - `invalidateQueries`.
        - `refetchQueries`.
    - Toast "Đã đánh dấu hoàn thành bài học".
- Xử lý lỗi:
  - Đọc message từ:
    - `error.response.data.messageDTO.message`
    - hoặc `error.response.data.message`
    - hoặc fallback `'Không thể đánh dấu hoàn thành bài học'`.
  - Toast message lỗi tương ứng.

### 5. Hook kiểm soát hành vi tua video

- **File**: `src/views/videoCourse/hooks/useVideoSeekControl.ts`.
- Mục tiêu:
  - Theo dõi *thời gian xem thực tế* (`watchedSeconds`) của video.
  - Chỉ cho phép tua tới vùng 80–90% video khi user **chưa xem đủ 90%** (chống "skip").
  - Tự động resume video tại vị trí user đã xem – vài giây lùi lại.
  - Không chặn hoàn toàn seek; chỉ chặn khi seek bằng thanh progress tới vùng cuối khi chưa đủ điều kiện.
- Input:
  - `videoRef`: ref tới `<video>` trong `InternalVideoBlock`.
  - `duration`: tổng thời lượng video (giây).
  - `enabled`: bật/tắt logic.
  - `initialWatchedSeconds`: thời gian đã xem lấy từ backend (db) để resume.
  - `onProgressChange(watchedSeconds, watchedPercentage)`.
  - `onWatchedSecondsChange(watchedSeconds)`.
- Output:
  - `watchedSeconds`: lớn nhất thời gian player đã xem (không phụ thuộc `currentTime` khi seek).
  - `watchedPercentage`: phần trăm đã xem (0–100).
  - `isSeekAllowed`: true nếu `watchedPercentage >= 90`.
  - `resetProgress()`, `resumeVideo()`.
- Các rule chính:
  - Hằng số:
    - `RESUME_OFFSET = 4` giây: resume tại `watchedSeconds - 4`.
    - `COMPLETION_THRESHOLD = 90` (%).
    - `BLOCK_SEEK_PERCENTAGE_MIN = 80`, `BLOCK_SEEK_PERCENTAGE_MAX = 90`.
    - `WATCHED_TIME_TOLERANCE = 2` giây.
  - Khi video có thể play lần đầu:
    - Nếu có `initialWatchedSeconds > 0` → tự gọi `resumeVideo()` một lần.
  - Tính `watchedSeconds`:
    - Chỉ cập nhật trong `timeupdate` khi:
      - Video đang `play`.
      - **Không** trong trạng thái `seeking`.
      - `currentTime` tăng liên tục, `deltaTime <= 1` giây (tránh nhảy do seek).
      - `currentTime` gần với `watchedSeconds` (chênh lệch <= 2 giây).
    - Điều này đảm bảo `watchedSeconds` chỉ tăng khi người dùng thật sự xem tiếp.
  - Khi `seeking`:
    - Ghi nhớ `seekStartPositionRef` và sau đó trong `seeked` xác định:
      - Hướng tua (forward/backward).
      - Vị trí muốn tua tới (`seekEndPosition`).
      - Phần trăm `seekPercentage = seekEndPosition / duration * 100`.
      - Phần trăm `currentWatchedPercentage` tính trên `watchedSeconds`.
    - Nếu seek **backward**:
      - Cho phép luôn.
    - Nếu seek **forward**:
      - Nếu `seekPercentage` nằm trong **[80%, 90%]** và `currentWatchedPercentage < 90%`:
        - **Chặn**:
          - Toast `"Bạn cần xem đủ 90% video trước khi có thể tua tới phần này!"`.
          - Đưa `currentTime` về `watchedSeconds`.
      - Nếu `currentWatchedPercentage ≥ 90%`:
        - Cho phép tua tự do.
      - Các trường hợp khác → cho phép.

### 6. Component video nội bộ (internal HLS player)

- **File**: `src/views/videoCourse/index.tsx` – component `InternalVideoBlock`.
- Điều kiện sử dụng video nội bộ:
  - `selectedLesson.video` match regex `/^video_[a-zA-Z0-9-]+$/`.
  - Khi đúng format này, dùng `InternalVideoBlock`; nếu không, fallback sang `iframe` YouTube (logic `getVideoEmbedUrl`).
- Nội dung chính:
  - State nội bộ:
    - `streamUrl`, `loading`, `error`.
    - `playbackRate`, `quality` (default `'1080p'`), `isFullscreen`, `showControls`.
    - `availableQualities`, `videoDuration`.
  - Lấy thông tin chất lượng video:
    - Gọi `videoApiService.getVideoQualities(videoId)`:
      - Trả về `available[]` và mapping `qualities`.
    - Nếu lỗi → fallback `['1080p']`.
  - Lấy playlist HLS:
    - Nếu quality `'720p'`:
      - Dùng proxy `VIDEO_API_BASE_URL/proxy/{videoId}_720p/master.m3u8`.
    - Mặc định:
      - Gọi `videoApiService.getPlaylist(videoId, { presign: true })`.
      - Dùng `playlist.proxyPlaylistUrl` nếu có (ghép với base); nếu không, fallback `VIDEO_API_BASE_URL/proxy/{videoId}/master.m3u8`.
  - Khởi tạo HLS:
    - Nếu `Hls.isSupported()`:
      - Tạo instance Hls với options được tối ưu (buffer, prefetch).
      - `hls.loadSource(streamUrl)` và `hls.attachMedia(video)`.
      - Lắng nghe:
        - `timeupdate` → cập nhật `videoDuration` + gọi `onProgress(watched, duration)`.
        - `loadedmetadata` → cập nhật `videoDuration`.
        - `Hls.Events.MANIFEST_PARSED` → restore `savedTimeRef.current` và auto play nếu trước đó đang play.
      - Cleanup:
        - Lưu `savedTimeRef.current = video.currentTime`, `wasPlayingRef.current = !video.paused`.
        - Destroy HLS instance.
    - Nếu không hỗ trợ HLS:
      - Set `video.src = streamUrl`, `video.load()`, lắng nghe `loadedmetadata` + `timeupdate` tương tự, restore thời gian.
  - Tích hợp với `useVideoSeekControl`:
    - Gọi hook với:
      - `videoRef`, `duration: videoDuration`, `enabled: true`, `initialWatchedSeconds`.
      - `onProgressChange`:
        - Nếu `onProgress` tồn tại → `onProgress(watchedSecs, videoDuration)`.
      - `onWatchedSecondsChange`:
        - Nếu `onWatchedSecondsChange` tồn tại → gọi với `watchedSecs` để sync định kỳ.
  - Tương tác với `useLessonProgress` (từ `CourseVideo`):
    - Props từ `CourseVideo`:
      - `onProgress(watchedSeconds, durationSeconds)`:
        - Gọi `updateVideoProgress(lessonId, watchedSeconds, durationSeconds)`.
      - `onWatchedSecondsChange(watchedSecs)`:
        - Gọi `syncProgressPeriodically(lessonId, watchedSecs, durationSecs)` với `durationSecs` lấy từ lesson.

### 7. Dòng chảy tổng thể: từ góc nhìn backend

1. **User mở màn video course**:
   - `GET` dữ liệu khoá học + parts + lessons thông qua hook `useCourseBySlug` (frontend gọi tới API `/courses/detail/{slugName}` hoặc tương đương).
   - Dữ liệu lesson bao gồm các trường trạng thái: `status`, `watchedSeconds`, `videoDurationSeconds`, `completed`, ...
2. **User chọn 1 lesson video trong sidebar**:
   - `ContentVideoCourse.onLessonSelect(lessonId)` → `CourseVideo.setSelectedLessonId(lessonId)` → `selectedLesson` cập nhật.
   - `CourseVideo` render lại `InternalVideoBlock` với `initialWatchedSeconds` và `videoDurationSeconds` lấy từ `selectedLesson`.
3. **Player HLS (`InternalVideoBlock`) chạy**:
   - Lấy playlist từ `videoApiService`.
   - Tính toán `watchedSeconds` local (frontend) thông qua `useVideoSeekControl`.
4. **Trong khi xem**:
   - `useVideoSeekControl`:
     - Cập nhật `watchedSeconds` / `watchedPercentage` local.
     - Chặn seek tới vùng 80–90% nếu user chưa xem đủ 90% thời lượng.
   - `InternalVideoBlock`:
     - Mỗi lần `onProgress` được gọi:
       - `CourseVideo.updateVideoProgress(lessonId, watchedSeconds, durationSeconds)`:
         - FRONTEND → `POST /lesson-progress/video?userId={userId}` với body `{ courseId, lessonId, watchedSeconds, videoDurationSeconds }`.
         - Backend:
           - Lưu `watchedSeconds`, `videoDurationSeconds`.
           - Tính `status` (`NOT_STARTED` / `IN_PROGRESS` / `COMPLETED`), theo rule >= 90% là `COMPLETED`.
         - FRONTEND:
           - Invalidate cache và refetch (lesson status, overall course progress).
5. **Đồng bộ định kỳ**:
   - `onWatchedSecondsChange` từ `useVideoSeekControl` gọi `syncProgressPeriodically(lessonId, watchedSecs, durationSecs)`:
     - FRONTEND: nếu chênh lệch >= 1 giây so với `lastSyncedWatchedSeconds` → gọi lại `updateVideoProgress` với `forceSync = true`.
     - Đảm bảo nếu user xem lâu nhưng network hoặc tab background vẫn được sync tiến độ.
6. **Khi user mở lesson type document/slide/exercise**:
   - Sidebar:
     - `button` `onClick`:
       - Gọi `onDocumentOpen(lessonId)`:
         - FRONTEND (CourseVideo):
           - Nếu có `userId` và `courseId` → gọi `markLessonComplete(lessonId)`:
             - `POST /lesson-progress/complete?userId={userId}` body `{ courseId, lessonId }`.
             - Backend: đặt `status = COMPLETED` cho lesson đó.
             - FRONTEND: invalidate + refetch course + detail, show toast.
       - Mở modal tài liệu (`Modal` hiển thị `item.video` như HTML).
7. **Khi backend trả về status mới**:
   - `useLessonProgress` callback `onStatusChange`:
     - Ở `CourseVideo`, callback đơn giản là:
       - Nếu `status === 'COMPLETED'` → `refetchCourse()` để update UI.
   - `CourseVideoHeader` nhận lại `progress` mới (tính từ số bài completed).
   - `ContentVideoCourse` hiển thị icon `CheckCircle` hoặc `IN_PROGRESS` tương ứng.

### 8. Gợi ý mapping sang mobile (Flutter)

> Phần này là định hướng triển khai mobile dựa trên flow web, không phải code hiện tại.

- **Entity / Model**:
  - `LessonProgress`:
    - `id`, `userId`, `courseId`, `lessonId`, `status`, `watchedSeconds`, `videoDurationSeconds`.
  - `Lesson` (trong domain mobile) nên bổ sung các field:
    - `status`, `watchedSeconds`, `videoDurationSeconds`, `type`, `video`, `completed` (optional để tương thích backend).
- **DataSource**:
  - `LessonProgressRemoteDataSource`:
    - `postVideoProgress(VideoProgressRequest)`:
      - `POST /lesson-progress/video?userId={userId}` với body giống web.
    - `completeLesson(CompleteLessonRequest)`:
      - `POST /lesson-progress/complete?userId={userId}`.
- **Repository & UseCases**:
  - `UpdateVideoProgressUseCase(courseId, lessonId, watchedSeconds, videoDurationSeconds)`.
  - `CompleteLessonUseCase(courseId, lessonId)`.
- **ViewModel (Flutter)**:
  - Tương đương `useLessonProgress`:
    - Giữ state `watchedSeconds`, `watchedPercentage`, `isSeekAllowed`.
    - Cơ chế:
      - Gửi `UpdateVideoProgressUseCase` định kỳ (mỗi vài giây) khi user xem.
      - Apply rule 80–90% / 90% nếu muốn chặn seek giống web (có thể implement trong custom video controller).
    - Khi backend trả `status === COMPLETED`:
      - Update lesson trong `MyCoursesViewModel` hoặc `CourseDetailViewModel`:
        - Set `status = COMPLETED`, `watchedSeconds`, `videoDurationSeconds`.
      - Recompute tổng progress khoá học nếu cần.
- **UI Player (Flutter)**:
  - Custom `VideoPlayer`:
    - Lắng nghe `position` và `duration` từ `VideoPlayerController`.
    - Gửi tiến độ:
      - Ví dụ mỗi `5s` hoặc khi delta tiến độ > `5%`.
      - Dùng `Timer` / `Stream` để debounce & throttle tương tự web.
    - Implement rule:
      - Chặn seek bằng thanh progress tới vùng 80–90% nếu `watchedPercentage < 90%`.
      - Cho phép seek tự do nếu `watchedPercentage >= 90%`.

File này mô tả đầy đủ luồng backend–frontend cho tiến độ xem video trên web để làm chuẩn khi implement tính năng tương tự trên mobile.

