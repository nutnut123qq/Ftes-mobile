## Hướng dẫn style 3D trong app WISE Buddy

Tài liệu này mô tả **ngôn ngữ thiết kế 3D** đang dùng ở các màn như `IELTS Speaking`, `Word Collection`… và cách **tái sử dụng** qua các widget chung trong `lib/src/core/widgets`.

---

## 1. Nguyên tắc chung của style 3D

- **Hai lớp chính**:
  - **Face layer**: bề mặt chính (button, card, bubble…), thường có:
    - Gradient dọc (trên nhạt, dưới đậm) với tone theo chức năng (primary, sky, success…).
    - Border radius lớn (8–999) để tạo cảm giác “mềm”.
  - **Shadow layer**: khối ở dưới:
    - Dùng `BoxShadow` hoặc 1 `Container` dịch xuống `depth3D` px.
    - Màu shadow là **bản đậm hơn** của màu chính (xem `Button3DColors`, `CommonCard3D`).

- **Hiệu ứng nhấn (pressed)**:
  - Khi nhấn, **face layer dịch xuống** gần shadow (`translationY = depth3D`) → cảm giác bấm được.
  - Shadow thu nhỏ/biến mất (height/offset giảm về 0).

- **Âm thanh & Haptic**:
  - Với element tương tác lớn (`Button3D`, `TabBar3D`, `CommonCard3D`):
    - Play sound qua `AudioService().playSoundEffect(...)`.
    - Dùng `HapticFeedback.lightImpact()` khi tap/press.

- **Màu sắc theo trạng thái**:
  - Primary: đỏ (`Button3DVariant.primary`, `AppColors.redXXX`).
  - Sky / Blue: hành động nhẹ, secondary, CTA mềm.
  - Success: emerald (hoàn thành, đúng).
  - Locked / disabled: grayscale (`AppColors.grayXXX`, thêm `ColorFiltered` cho ảnh).

---

## 2. Các widget 3D dùng chung

### 2.1 `Button3D`

- **File**: `lib/src/core/widgets/button_3d.dart`
- **Công dụng**: CTA chính, nút hành động có 3D depth + âm thanh + haptic.
- **Props quan trọng**:
  - `text`: label.
  - `onPressed`: callback khi tap thường.
  - `onHoldStart` / `onHoldEnd`: hỗ trợ giữ để record (như bài speaking).
  - `variant`: `Button3DVariant.primary | success | sky | blue | orange | purple | def`.
  - `height`, `borderRadius`, `icon`, `iconOnRight`, `isLoading`, `enableShimmer`.

**Ví dụ (nút View Details kiểu 3D sky, icon bên phải):**

```dart
Button3D(
  text: 'Đánh giá chi tiết',
  onPressed: () { /* open bottom sheet */ },
  variant: Button3DVariant.sky,
  height: 40,
  borderRadius: 999,
  fontSize: 14,
  icon: Icons.arrow_forward_ios_rounded,
  iconOnRight: true,
  mainAxisAlignment: MainAxisAlignment.center,
)
```

**Mặc định style 3D:**
- Shadow dùng `_shadowColor` theo `variant`, offset `depth3D`.
- Face gradient lấy từ `Button3DColors` (top/bottom color).

---

### 2.2 `TabBar3D`

- **File**: `lib/src/core/widgets/tab_bar_3d.dart`
- **Công dụng**: thanh tab 3D (như ở `IeltsSpeakingScreen`).
- **Props chính**:
  - `controller`: `TabController` bên ngoài.
  - `tabs`: danh sách `Tab3DItem(label, icon?, badge?)`.
  - `activeColor`, `inactiveColor`, `activeTextColor`, `inactiveTextColor`.

**Ví dụ (2 tab Part 1 / Part 2&3):**

```dart
TabBar3D(
  controller: _tabController,
  tabs: const [
    Tab3DItem(label: 'Part 1', icon: Icons.looks_one_outlined),
    Tab3DItem(label: 'Part 2 & 3', icon: Icons.looks_two_outlined),
  ],
  activeColor: AppColors.red500,
  inactiveColor: AppColors.gray100,
  activeTextColor: Colors.white,
  inactiveTextColor: AppColors.gray600,
)
```

**3D behavior:**
- Item active có gradient `activeColor → activeColor.withAlpha(0.85)` và shadow phía dưới.
- Khi nhấn: face dịch xuống `depth3D`, shadow co lại (giống `Button3D`).

---

### 2.3 `CommonCard3D`

- **File**: `lib/src/core/widgets/common_card_3d.dart`
- **Công dụng**: card ngang full-width với ảnh bên trái + nội dung bên phải, dùng ở:
  - `IELTS Speaking` (topic list).
  - `Word Collection` (`WordCollectionListScreen`, `TopicListScreen`).
- **Props chính**:
  - `imageUrl | imageAssetPath | customImage`: bắt buộc 1 trong 3.
  - `title`, `subtitle`, `tags`, `metadata`.
  - `isCompleted`, `isPremium`, `isLocked`.
  - `height`.

**Ví dụ (card bộ sưu tập từ vựng):**

```dart
CommonCard3D(
  imageUrl: c.imageUrl,
  title: c.name,
  subtitle: c.description.isNotEmpty ? c.description : null,
  tags: const [],
  metadata: null,
  onTap: () {
    // Điều hướng
  },
  height: 100,
  isCompleted: false,
  isPremium: false,
  isLocked: false,
)
```

**Đặc điểm 3D:**
- `shadowHeight = 6`: có **shadow layer** phía dưới card, màu theo trạng thái (`_shadowColor`).
- **Face** gradient:
  - Completed: xanh `Button3DColors.successTop/Bottom`.
  - Premium: vàng `AppColors.amber400/600`.
  - Thường: trắng → `AppColors.gray50`.
- Ảnh bên trái bo tròn phía trái, nội dung + tags + metadata bên phải.

---

### 2.4 `PracticeCard3D`

- **File**: `lib/src/core/widgets/practice_card_3d.dart`
- **Công dụng**: card 3D theo **level** (excellent/good/fair/poor), dùng cho kết quả luyện tập.
- **Props**:
  - `child`: nội dung bên trong.
  - `score` (0–100) hoặc `level` trực tiếp.
  - `depth3D`, `padding`, `borderRadius`.

**Ví dụ:**

```dart
PracticeCard3D(
  score: 78, // tự map ra level good
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text('Overall score 7.0'),
      Text('Phát âm tốt, cần cải thiện fluency.'),
    ],
  ),
)
```

**3D behavior:**
- Hai lớp shadow: 1 layer offset `depth3D`, 1 soft shadow `blurRadius=8`.
- Màu nền & border đổi theo level (emerald, amber, orange, red, gray).

---

### 2.5 `SearchField3D`

- **File**: `lib/src/core/widgets/3D/search_field_3d.dart`
- **Công dụng**: ô search dạng pill 3D, dùng ở `WordCollection` screens.
- **Props**:
  - `hintText`, `onChanged`, `controller?`, `height`, `contentPadding`.

**Ví dụ:**

```dart
SearchField3D(
  hintText: 'Tìm kiếm bộ sưu tập...',
  onChanged: (value) => controller.searchTerm.value = value,
)
```

**3D behavior:**
- Shadow pill cố định phía dưới (`depth3D = 6`).
- Face trắng, border radius 999, border xám.

---

### 2.6 `Streak3DNumber`

- **File**: `lib/src/core/widgets/3d_number.dart`
- **Công dụng**: render số với hiệu ứng 3D text (hai lớp text: main + shadow).
- **Props**:
  - `number` (String), `color?`, `fontSize`, `depth3D`, `letterSpacing`.

**Ví dụ:**

```dart
const Streak3DNumber(
  number: '7',
  fontSize: 48,
  depth3D: 4,
)
```

---

### 2.7 `MessageBubble3D`

- **File**: `lib/src/core/widgets/message_bubble_3d.dart`
- **Công dụng**: bubble chat 3D (dùng cho hội thoại, audio playing).
- **Props**:
  - `child`, `color` hoặc `gradient`, `depth3D`, `isPlaying`, `onTap`.

**Ví dụ:**

```dart
MessageBubble3D(
  gradient: const LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  depth3D: 3,
  isPlaying: isPlaying,
  child: const Text('This is a 3D chat bubble'),
)
```

---

## 3. Cách apply style 3D cho widget mới

Khi bạn tạo widget 3D mới trong `lib/src/core/widgets`, nên theo các bước:

1. **Quyết định loại 3D**:
   - Button / tab → giống `Button3D` / `TabBar3D`: dùng gradient + shadow offset nhỏ.
   - Card / container lớn → giống `CommonCard3D` / `PracticeCard3D`.
   - Text / icon → giống `Streak3DNumber`.

2. **Áp dụng pattern 2 lớp**:
   - Dùng `Stack` + `Positioned` (shadow phía dưới, face phía trên) hoặc `Container` + `BoxShadow`.
   - Khi có trạng thái pressed → dịch face xuống, giảm shadow.

3. **Tái sử dụng màu**:
   - Dùng `Button3DColors` và `AppColors` để đảm bảo đồng bộ.

4. **Âm thanh & Haptic (nếu tương tác)**:
   - Reuse logic từ `Button3D` / `TabBar3D`: gọi `AudioService` + `HapticFeedback`.

Làm như vậy, toàn bộ các màn (IELTS Speaking, Word Collection, Lessons, v.v.) sẽ có **ngôn ngữ 3D thống nhất**, dễ maintain và dễ mở rộng thêm widget 3D mới. 

