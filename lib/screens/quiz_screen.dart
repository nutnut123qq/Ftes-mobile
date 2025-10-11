import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../models/save_user_exercise_request.dart';
import '../utils/text_styles.dart';

class QuizScreen extends StatefulWidget {
  final int exerciseId;
  final int userId;
  final String? exerciseTitle;

  const QuizScreen({
    super.key,
    required this.exerciseId,
    required this.userId,
    this.exerciseTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().loadExercise(widget.exerciseId);
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập câu trả lời'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = context.read<ExerciseProvider>();
    final request = SaveUserExerciseRequest(
      userId: widget.userId,
      exerciseId: widget.exerciseId,
      userAnswer: _answerController.text.trim(),
    );

    final success = await provider.submitAnswer(request);

    if (success && mounted) {
      setState(() {
        _hasSubmitted = true;
      });
      _showResultDialog(provider.lastSubmission!.isCorrect);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Có lỗi xảy ra khi nộp bài'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng 😔',
                style: AppTextStyles.heading1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCorrect
                  ? 'Xuất sắc! Câu trả lời của bạn hoàn toàn chính xác.'
                  : 'Câu trả lời chưa chính xác. Đừng lo, hãy thử lại nhé!',
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 16),
              Text(
                'Gợi ý: Hãy xem lại bài học và thử lại.',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!isCorrect)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _hasSubmitted = false;
                  _answerController.clear();
                });
              },
              child: Text(
                'Thử lại',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF0961F5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to curriculum
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0961F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              isCorrect ? 'Tiếp tục' : 'Quay lại',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Consumer<ExerciseProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0961F5),
                ),
              );
            }

            if (provider.error != null && provider.currentExercise == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Color(0xFFF44336),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không thể tải bài tập',
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF202244),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error ?? 'Đã có lỗi xảy ra',
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF545454),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0961F5),
                      ),
                      child: const Text('Quay lại'),
                    ),
                  ],
                ),
              );
            }

            if (provider.currentExercise == null) {
              return const Center(
                child: Text('Không tìm thấy bài tập'),
              );
            }

            final exercise = provider.currentExercise!;

            return Column(
              children: [
                _buildHeader(exercise.title),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExerciseCard(exercise.description),
                        const SizedBox(height: 20),
                        if (exercise.question != null && exercise.question!.isNotEmpty)
                          _buildQuestionCard(exercise.question!),
                        const SizedBox(height: 20),
                        _buildAnswerSection(provider),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 26,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF202244),
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0961F5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.heading1.copyWith(
                        color: const Color(0xFF202244),
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description,
                color: Color(0xFF0961F5),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Mô tả bài tập',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0961F5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.help_outline,
                color: Color(0xFF0961F5),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Câu hỏi',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF0961F5),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSection(ExerciseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Câu trả lời của bạn',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _answerController,
            enabled: !_hasSubmitted,
            maxLines: 5,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập câu trả lời của bạn tại đây...',
              hintStyle: AppTextStyles.body1.copyWith(
                color: const Color(0xFFB4BDC4),
                fontSize: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_hasSubmitted || provider.isSubmitting)
                ? null
                : _submitAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0961F5),
              disabledBackgroundColor: const Color(0xFFB4BDC4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 3,
            ),
            child: provider.isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _hasSubmitted ? 'Đã nộp bài' : 'Nộp bài',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
