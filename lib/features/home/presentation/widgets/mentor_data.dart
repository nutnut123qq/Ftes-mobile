class Mentor {
  final String name;
  final String title;
  final String quote;
  final String avatar;

  const Mentor({
    required this.name,
    required this.title,
    required this.quote,
    required this.avatar,
  });
}

const List<Mentor> topMentors = [
  Mentor(
    name: 'Mentor Anh Khoa',
    title: 'Founder, CEO',
    quote:
    'Các bạn sinh viên sẽ bị sự nhiệt huyết, kinh nghiệm và câu chuyện hài hước của mình làm cho mê mẩn và hiểu bài tuyệt đối!!',
    avatar: 'assets/images/mentor_khoana.jpg',
  ),
  Mentor(
    name: 'Mentor Đức Hải',
    title: 'Co-Founder, CTO',
    quote:
    'Mình hướng đến cách dạy vừa nghiêm túc vừa thoải mái: kiến thức thì chắc chắn, giảng giải thì dễ hiểu, lại xen chút hài hước để giờ học luôn vui vẻ và không hề khô khan.',
    avatar: 'assets/images/mentor_haind.jpg',
  ),
  Mentor(
    name: 'Mentor Thanh Huy',
    title: 'Co-Founder, COO',
    quote:
    'Anh không chỉ dạy kiến thức, mà truyền lửa đam mê và chia sẻ những trải nghiệm chân thật của mình trên con đường học vấn, để mỗi buổi học đều là một hành trình khơi dậy tiềm năng trong các bạn.',
    avatar: 'assets/images/mentor_huypt.jpg',
  ),
  Mentor(
    name: 'Mentor Nhật Huy',
    title: 'Developer',
    quote:
    'Tôi dạy theo hướng thực hành, lý thuyết ngắn gọn, tập trung giúp học viên hiểu nhanh – làm được ngay – và áp dụng vào dự án thực tế.',
    avatar: 'assets/images/mentor_huyln.jpg',
  ),
  Mentor(
    name: 'Mentor Ngọc Hiếu',
    title: 'BrSE',
    quote:
    'Mình dạy theo nhịp vừa phải, giải thích đến đâu là sáng tỏ đến đó, lại xen thêm chuyện văn hoá Nhật Bản và vài pha tấu hài để lớp học lúc nào cũng rộn ràng mà kiến thức thì cứ thấm dần.',
    avatar: 'assets/images/mentor_hieuln.jpg',
  ),
];
