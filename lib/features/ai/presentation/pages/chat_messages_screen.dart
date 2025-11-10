import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ftes/core/utils/colors.dart';
import 'package:ftes/core/utils/text_styles.dart';
import 'package:ftes/core/di/injection_container.dart' as di;
import 'package:ftes/features/ai/presentation/viewmodels/ai_chat_viewmodel.dart';
import 'package:ftes/features/ai/domain/entities/ai_chat_message.dart';

class ChatMessagesScreen extends StatefulWidget {
  final String? lessonId;
  final String? lessonTitle;

  const ChatMessagesScreen({
    super.key,
    this.lessonId,
    this.lessonTitle,
  });

  @override
  State<ChatMessagesScreen> createState() => _ChatMessagesScreenState();
}

class _ChatMessagesScreenState extends State<ChatMessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  AiChatViewModel? _aiVm;

  @override
  void initState() {
    super.initState();
    
    // Initialize AI chat if lessonId is provided
    if (widget.lessonId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiVm = di.sl<AiChatViewModel>();
        _aiVm!.initializeLessonChat(
          widget.lessonId!,
          widget.lessonTitle ?? 'Lesson',
        );
      });
    }
    
    // Scroll to bottom when messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Date indicator
            _buildDateIndicator(),
            // Messages list
            Expanded(
              child: _buildMessagesList(),
            ),
            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lessonId != null 
                      ? 'AI Trợ Giảng - ${widget.lessonTitle ?? "Lesson"}'
                      : 'AI take care',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Trực tuyến',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // More options
          GestureDetector(
            onTap: () {
              // Handle more options
            },
            child: const Icon(
              Icons.more_vert,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.5),
          width: 1.8,
        ),
      ),
      child: Text(
        'Hôm nay',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    if (widget.lessonId == null) {
      final messages = _getLegacyMessages();
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 8),
        itemCount: messages.length,
        itemBuilder: (context, index) => _buildMessageBubble(messages[index]),
      );
    }

    if (_aiVm == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider<AiChatViewModel>.value(
      value: _aiVm!,
      child: Consumer<AiChatViewModel>(
        builder: (context, vm, child) {
          final messages = vm.messages.map(_ChatBubbleData.fromAiMessage).toList();

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 8),
            itemCount: messages.length + (vm.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length && vm.isLoading) {
                return _buildLoadingIndicator();
              }
              final message = messages[index];
              return _buildMessageBubble(message);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar for AI
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          // Loading bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AI đang suy nghĩ...',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatBubbleData message) {
    final isFromUser = message.isFromUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) ...[
            // Avatar for received messages
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.smart_toy, // Robot icon for AI
                color: AppColors.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isFromUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isFromUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == _ChatBubbleType.text) ...[
                    Text(
                      message.content,
                      style: AppTextStyles.bodyText.copyWith(
                        color: isFromUser ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ] else if (message.type == _ChatBubbleType.image) ...[
                    _buildImageMessage(),
                  ] else if (message.type == _ChatBubbleType.rating) ...[
                    _buildRatingMessage(message),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: AppTextStyles.caption.copyWith(
                      color: isFromUser 
                          ? Colors.white.withValues(alpha: 0.8) 
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            // Avatar for sent messages
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage() {
    return Container(
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildRatingMessage(_ChatBubbleData message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.content,
          style: AppTextStyles.bodyText.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < (message.rating ?? 0) ? Icons.star : Icons.star_border,
              color: AppColors.warning,
              size: 16,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Tin nhắn',
                  hintStyle: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _sendMessage(value.trim());
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_messageController.text.trim().isNotEmpty) {
                _sendMessage(_messageController.text.trim());
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String content) async {
    if (content.isEmpty) return;
    
    // Clear input
    _messageController.clear();
    
    // If using AI chat
    if (widget.lessonId != null) {
      if (_aiVm != null) {
        await _aiVm!.sendMessage(content);
      }
      
      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } else {
      // Mock behavior for non-AI chat
      setState(() {});
      
      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  List<_ChatBubbleData> _getLegacyMessages() {
    return const [
      _ChatBubbleData(
        id: '1',
        content: 'Hi, Nicholas Good Evening',
        time: '10:45',
        isFromUser: false,
      ),
      _ChatBubbleData(
        id: '2',
        content: 'How was your UI/UX Design Course Like.?',
        time: '12:45',
        isFromUser: false,
      ),
      _ChatBubbleData(
        id: '3',
        content: 'Hi, Morning too Ronald',
        time: '15:29',
        isFromUser: true,
      ),
      _ChatBubbleData(
        id: '4',
        content: '',
        time: '15:52',
        isFromUser: true,
        type: _ChatBubbleType.image,
      ),
      _ChatBubbleData(
        id: '5',
        content: 'Hello, i also just finished the Sketch Basic',
        time: '15:29',
        isFromUser: true,
        type: _ChatBubbleType.rating,
        rating: 5,
      ),
      _ChatBubbleData(
        id: '6',
        content: 'OMG, This is Amazing..',
        time: '13:59',
        isFromUser: false,
      ),
    ];
  }
}

enum _ChatBubbleType {
  text,
  image,
  rating,
}

class _ChatBubbleData {
  final String id;
  final String content;
  final String time;
  final bool isFromUser;
  final _ChatBubbleType type;
  final String? imageUrl;
  final int? rating;

  const _ChatBubbleData({
    required this.id,
    required this.content,
    required this.time,
    required this.isFromUser,
    this.type = _ChatBubbleType.text,
    this.imageUrl,
    this.rating,
  });

  factory _ChatBubbleData.fromAiMessage(AiChatMessage message) {
    final timestamp = message.timestamp;
    final formattedTime =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    return _ChatBubbleData(
      id: message.id,
      content: message.content,
      time: formattedTime,
      isFromUser: message.isFromUser,
      type: _mapAiType(message.type),
      imageUrl: message.imageUrl,
    );
  }

  static _ChatBubbleType _mapAiType(AiMessageType type) {
    switch (type) {
      case AiMessageType.image:
        return _ChatBubbleType.image;
      default:
        return _ChatBubbleType.text;
    }
  }
}
