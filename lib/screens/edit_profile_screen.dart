import 'package:flutter/material.dart';
import 'package:ftes/utils/colors.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/widgets/bottom_navigation_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController(text: 'Alex');
  final TextEditingController _nickNameController = TextEditingController(text: 'Alex');
  final TextEditingController _dateOfBirthController = TextEditingController(text: '01/01/1990');
  final TextEditingController _emailController = TextEditingController(text: 'hernandex.redial@gmail.ac.in');
  final TextEditingController _phoneController = TextEditingController(text: '( +91 )  987-848-1225');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _studentController = TextEditingController(text: 'Student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar Space
            const SizedBox(height: 25),
            
            // Navigation Bar
            _buildNavigationBar(),
            
            const SizedBox(height: 20),
            
            // Profile Image
            _buildProfileImage(),
            
            const SizedBox(height: 20),
            
            // Form Fields
            Expanded(
              child: _buildFormFields(),
            ),
            
            // Update Button
            _buildUpdateButton(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
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
            'Edit Profile',
            style: AppTextStyles.heading1.copyWith(
              color: const Color(0xFF202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(45),
            border: Border.all(
              color: const Color(0xFF167F71),
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Color(0xFF0961F5),
          ),
        ),
        
        const SizedBox(height: 15),
        
        // Edit Image Button
        GestureDetector(
          onTap: () {
            // Handle image selection
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF167F71),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Color(0xFF167F71),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        children: [
          _buildTextField(
            controller: _fullNameController,
            label: 'Full Name',
            icon: null,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _nickNameController,
            label: 'Nick Name',
            icon: null,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _dateOfBirthController,
            label: 'Date of Birth',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () {
              _selectDate();
            },
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _phoneController,
            label: 'Phone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _genderController,
            label: 'Gender',
            icon: Icons.keyboard_arrow_down,
            readOnly: true,
            onTap: () {
              _selectGender();
            },
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _studentController,
            label: 'Student',
            icon: null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        style: AppTextStyles.body1.copyWith(
          color: const Color(0xFF202244),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body1.copyWith(
            color: const Color(0xFF505050),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: icon != null ? Icon(
            icon,
            color: const Color(0xFF0961F5),
            size: 20,
          ) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 39),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0961F5),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Update',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _dateOfBirthController.text = 
              '${selectedDate.day.toString().padLeft(2, '0')}/'
              '${selectedDate.month.toString().padLeft(2, '0')}/'
              '${selectedDate.year}';
        });
      }
    });
  }

  void _selectGender() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Gender',
                style: AppTextStyles.heading1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Male'),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Female'),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Female';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Other'),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Other';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
