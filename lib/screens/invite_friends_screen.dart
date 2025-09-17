import 'package:flutter/material.dart';
import '../models/contact_item.dart';
import '../utils/colors.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final List<ContactItem> _contacts = [
    ContactItem(
      id: '1',
      name: 'Rani Thomas',
      phoneNumber: '(+91) 702-897-7965',
    ),
    ContactItem(
      id: '2',
      name: 'Anastasia',
      phoneNumber: '(+91) 702-897-7965',
    ),
    ContactItem(
      id: '3',
      name: 'Vaibhav',
      phoneNumber: '(+91) 727-688-4052',
      isInvited: true,
    ),
    ContactItem(
      id: '4',
      name: 'Rahul Juman',
      phoneNumber: '(+91) 601-897-1714',
    ),
    ContactItem(
      id: '5',
      name: 'Abby',
      phoneNumber: '(+91) 802-312-3206',
      isInvited: true,
    ),
  ];

  void _onInviteTap(int index) {
    setState(() {
      _contacts[index] = _contacts[index].copyWith(
        isInvited: !_contacts[index].isInvited,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Invite Friends',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Jost',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),
              // Contacts List Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Contact Items
                    for (int i = 0; i < _contacts.length; i++) ...[
                      _buildContactItem(_contacts[i], i),
                      if (i < _contacts.length - 1)
                        Container(
                          height: 1,
                          color: const Color(0xFFE5E5E5),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Share Options
              _buildShareOptions(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(ContactItem contact, int index) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          // Name and Phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Jost',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.phoneNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    fontFamily: 'Mulish',
                  ),
                ),
              ],
            ),
          ),
          // Invite Button
          GestureDetector(
            onTap: () => _onInviteTap(index),
            child: Container(
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                color: contact.isInvited 
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Invite',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: contact.isInvited 
                        ? AppColors.textPrimary
                        : Colors.white,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share Invite Via',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Jost',
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildShareIcon(Icons.message, () {}),
            _buildShareIcon(Icons.message_outlined, () {}),
            _buildShareIcon(Icons.telegram, () {}),
            _buildShareIcon(Icons.more_horiz, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildShareIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 18,
        ),
      ),
    );
  }
}
