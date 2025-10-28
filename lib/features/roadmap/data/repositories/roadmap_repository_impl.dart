import '../../domain/entities/roadmap.dart';


// Mock implementation of RoadmapRepository: Mock data for testing purposes
// Thay bằng dữ liệu thật từ API hoặc database trong tương lai
class RoadmapRepositoryImpl {
  Future<Roadmap> fetchRoadmapMock() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network

    return Roadmap(
      skills: ['C programming', 'Data Structures', 'Algorithms', 'Git'],
      steps: [
        RoadmapStep(
          title: 'Java Programming Fundamentals',
          description:
          'Giới thiệu về ngôn ngữ Java, cú pháp cơ bản, JVM, các kiểu dữ liệu, cấu trúc điều khiển, xử lý lỗi và ngoại lệ.',
          hasCourse: false,
        ),
        RoadmapStep(
          title: 'Object-Oriented Programming in Java',
          description:
          'Nghiên cứu sâu về các nguyên tắc lập trình hướng đối tượng (Kế thừa, Đa hình, Trừu tượng) và cách áp dụng trong Java.',
          hasCourse: false,
        ),
        RoadmapStep(
          title: 'Advanced Java Concepts',
          description:
          'Tìm hiểu về Java Collections, Generics, Stream API, Lambda, Concurrency và I/O.',
          hasCourse: false,
        ),
        RoadmapStep(
          title: 'Database Management with SQL',
          description:
          'Học về hệ quản trị cơ sở dữ liệu quan hệ (RDBMS), thiết kế ERD, truy vấn SQL.',
          hasCourse: false,
        ),
        RoadmapStep(
          title: 'DevOps and CI/CD for Java Applications',
          description:
          'Tích hợp liên tục (CI) và triển khai liên tục (CD) với Jenkins, GitLab CI/CD cho ứng dụng Java.',
          hasCourse: true,
          buttonLabel: 'Xem khóa học',
        ),
      ],
    );
  }
}
