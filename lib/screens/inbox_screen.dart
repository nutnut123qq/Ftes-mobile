import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/models/chat_item.dart';
import 'package:ftes/models/call_item.dart';
import 'package:ftes/screens/chat_messages_screen.dart';
import 'package:ftes/screens/voice_call_screen.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int _selectedTabIndex = 0; // 0 = Chat, 1 = Calls

  // Sample chat data
  final List<ChatItem> _chats = [
    const ChatItem(
      id: '1',
      name: 'Natasha',
      lastMessage: 'Hi, Good Evening Bro.!',
      time: '14:59',
      avatar: '',
    ),
    const ChatItem(
      id: '2',
      name: 'Alex',
      lastMessage: 'I Just Finished It.!',
      time: '06:35',
      avatar: '',
    ),
    const ChatItem(
      id: '3',
      name: 'John',
      lastMessage: 'How are you?',
      time: '08:10',
      avatar: '',
    ),
    const ChatItem(
      id: '4',
      name: 'Mia',
      lastMessage: 'OMG, This is Amazing..',
      time: '21:07',
      avatar: '',
    ),
    const ChatItem(
      id: '5',
      name: 'Maria',
      lastMessage: 'Wow, This is Really Epic',
      time: '09:15',
      avatar: '',
    ),
    const ChatItem(
      id: '6',
      name: 'Tiya',
      lastMessage: 'Hi, Good Evening Bro.!',
      time: '14:59',
      avatar: '',
    ),
    const ChatItem(
      id: '7',
      name: 'Manisha',
      lastMessage: 'I Just Finished It.!',
      time: '06:35',
      avatar: '',
    ),
    const ChatItem(
      id: '8',
      name: 'Beverly J. Barbee',
      lastMessage: 'Perfect.!',
      time: '06:54',
      avatar: '',
    ),
  ];

  // Sample call data
  final List<CallItem> _calls = [
    const CallItem(
      id: '1',
      name: 'Johan',
      date: 'Nov 03, 202X',
      type: CallType.incoming,
      avatar: '',
    ),
    const CallItem(
      id: '2',
      name: 'Timothee mathew',
      date: 'Nov 05, 202X',
      type: CallType.incoming,
      avatar: '',
    ),
    const CallItem(
      id: '3',
      name: 'Amanriya',
      date: 'Nov 06, 202X',
      type: CallType.outgoing,
      avatar: '',
    ),
    const CallItem(
      id: '4',
      name: 'Tanisha',
      date: 'Nov 15, 202X',
      type: CallType.missed,
      avatar: '',
    ),
    const CallItem(
      id: '5',
      name: 'Shravya',
      date: 'Nov 17, 202X',
      type: CallType.outgoing,
      avatar: '',
    ),
    const CallItem(
      id: '6',
      name: 'Tamanha',
      date: 'Nov 18, 202X',
      type: CallType.missed,
      avatar: '',
    ),
    const CallItem(
      id: '7',
      name: 'Hilda M. Hernandez',
      date: 'Nov 19, 202X',
      type: CallType.outgoing,
      avatar: '',
    ),
    const CallItem(
      id: '8',
      name: 'Wanda T. Seidl',
      date: 'Nov 21, 202X',
      type: CallType.incoming,
      avatar: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Header
            _buildHeader(),
            
            const SizedBox(height: 20),
            
            // Tabs
            _buildTabs(),
            
            const SizedBox(height: 20),
            
            // Content
            Expanded(
              child: _selectedTabIndex == 0 ? _buildChatsList() : _buildCallsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(selectedIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Indox',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // Handle search tap
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search,
                color: Color(0xFF202244),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Row(
        children: [
          // Chat Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0 ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Chat',
                    style: AppTextStyles.body1.copyWith(
                      color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Calls Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1 ? const Color(0xFF167F71) : const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'Calls',
                    style: AppTextStyles.body1.copyWith(
                      color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
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
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return _buildChatItem(chat, index);
        },
      ),
    );
  }

  Widget _buildChatItem(ChatItem chat, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatMessagesScreen(chat: chat),
          ),
        );
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF0961F5),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Chat Info
            Expanded(
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name and Time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.name,
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF202244),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat.time,
                            style: AppTextStyles.body1.copyWith(
                              color: const Color(0xFF545454),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 1),
                      
                      // Last Message and Unread Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF545454),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (index < 4) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0961F5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
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
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _calls.length,
        itemBuilder: (context, index) {
          final call = _calls[index];
          return _buildCallItem(call, index);
        },
      ),
    );
  }

  Widget _buildCallItem(CallItem call, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoiceCallScreen(
              contactName: call.name,
              contactAvatar: call.avatar,
              callType: call.type,
            ),
          ),
        );
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF0961F5),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Call Info
            Expanded(
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name
                      Text(
                        call.name,
                        style: AppTextStyles.body1.copyWith(
                          color: const Color(0xFF202244),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 1),
                      
                      // Call Type and Date
                      Row(
                        children: [
                          _buildCallTypeIndicator(call.type),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              call.date,
                              style: AppTextStyles.body1.copyWith(
                                color: const Color(0xFF545454),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Call Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.call,
                color: Color(0xFF0961F5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallTypeIndicator(CallType type) {
    Color color;
    IconData icon;
    
    switch (type) {
      case CallType.incoming:
        color = const Color(0xFF0961F5);
        icon = Icons.add;
        break;
      case CallType.outgoing:
        color = const Color(0xFF00C851);
        icon = Icons.remove;
        break;
      case CallType.missed:
        color = const Color(0xFFFF4444);
        icon = Icons.close;
        break;
    }
    
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 12,
      ),
    );
  }
}