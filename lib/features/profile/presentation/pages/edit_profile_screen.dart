import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ftes/utils/text_styles.dart';
import 'package:ftes/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:ftes/features/profile/domain/entities/profile.dart';
import 'package:ftes/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  Profile? _currentProfile;
  bool _isLoading = true;
  bool _isUpdating = false;
  bool _isUploadingImage = false;
  String? _selectedGender;
  DateTime? _selectedDate;
  File? _selectedImage;
  String? _currentAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _descriptionController.dispose();
    _jobNameController.dispose();
    _facebookController.dispose();
    _youtubeController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      
      if (authViewModel.currentUser?.id != null) {
        await profileViewModel.getProfileById(authViewModel.currentUser!.id);
        
        if (profileViewModel.currentProfile != null) {
          setState(() {
            _currentProfile = profileViewModel.currentProfile;
            _populateFields(profileViewModel.currentProfile!);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Không thể lấy thông tin hồ sơ');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Không thể lấy thông tin người dùng');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Lỗi khi tải thông tin hồ sơ: $e');
    }
  }

  void _populateFields(Profile profile) {
    _fullNameController.text = profile.name;
    _phoneController.text = profile.phoneNumber;
    _descriptionController.text = profile.description;
    _jobNameController.text = profile.jobName;
    _facebookController.text = profile.facebook;
    _youtubeController.text = profile.youtube;
    _twitterController.text = profile.twitter;
    _currentAvatarUrl = profile.avatar;
    
    // Set date of birth
    if (profile.dataOfBirth.isNotEmpty) {
      try {
        _selectedDate = DateTime.parse(profile.dataOfBirth);
        _dateOfBirthController.text = '${_selectedDate!.day.toString().padLeft(2, '0')}/'
            '${_selectedDate!.month.toString().padLeft(2, '0')}/'
            '${_selectedDate!.year}';
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }
    
    // Set gender
    if (profile.gender.isNotEmpty) {
      _selectedGender = profile.gender;
      _genderController.text = _getGenderDisplayName(profile.gender);
    }
  }

  String _getGenderDisplayName(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
      case 'nam':
        return 'Nam';
      case 'female':
      case 'nữ':
        return 'Nữ';
      case 'other':
      case 'khác':
        return 'Khác';
      default:
        return 'Khác';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
                ),
              )
            : Column(
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
                    color: Colors.black.withValues(alpha: 0.1),
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
            'Chỉnh sửa hồ sơ',
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
        GestureDetector(
          onTap: (_isUploadingImage || kIsWeb) ? null : _selectImage,
          child: Container(
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
            child: _isUploadingImage
                ? const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0961F5)),
                      ),
                    ),
                  )
                : _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.file(
                          _selectedImage!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              _currentAvatarUrl!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Color(0xFF0961F5),
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF0961F5),
                          ),
          ),
        ),
        
        const SizedBox(height: 15),
        
        // Edit Image Button
        GestureDetector(
          onTap: (_isUploadingImage || kIsWeb) ? null : _selectImage,
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
            child: _isUploadingImage
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF167F71)),
                    ),
                  )
                : Icon(
                    kIsWeb ? Icons.block : Icons.camera_alt,
                    color: kIsWeb ? Colors.grey : const Color(0xFF167F71),
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
            label: 'Họ và tên',
            icon: null,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _addressController,
            label: 'Địa chỉ',
            icon: null,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _dateOfBirthController,
            label: 'Ngày sinh',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () {
              _selectDate();
            },
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _genderController,
            label: 'Giới tính',
            icon: Icons.keyboard_arrow_down,
            readOnly: true,
            onTap: () {
              _selectGender();
            },
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _descriptionController,
            label: 'Mô tả',
            icon: null,
            maxLines: 3,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _jobNameController,
            label: 'Nghề nghiệp',
            icon: null,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _facebookController,
            label: 'Facebook',
            icon: Icons.facebook,
            keyboardType: TextInputType.url,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _youtubeController,
            label: 'YouTube',
            icon: Icons.play_circle,
            keyboardType: TextInputType.url,
          ),
          
          const SizedBox(height: 18),
          
          _buildTextField(
            controller: _twitterController,
            label: 'Twitter',
            icon: Icons.alternate_email,
            keyboardType: TextInputType.url,
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
    int maxLines = 1,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: maxLines > 1 ? 80 : 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
        maxLines: maxLines,
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
      child: GestureDetector(
        onTap: _isUpdating ? null : _updateProfile,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _isUpdating ? Colors.grey : const Color(0xFF0961F5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 12),
              Text(
                _isUpdating ? 'Đang cập nhật...' : 'Cập nhật',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
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
                'Chọn giới tính',
                style: AppTextStyles.heading1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Nam'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'male';
                    _genderController.text = 'Nam';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Nữ'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'female';
                    _genderController.text = 'Nữ';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Khác'),
                onTap: () {
                  setState(() {
                    _selectedGender = 'other';
                    _genderController.text = 'Khác';
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

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isUpdating = true;
      });

      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      
      if (authViewModel.currentUser?.id == null) {
        _showErrorDialog('Không thể lấy thông tin người dùng');
        return;
      }

      // Validate required fields
      if (_fullNameController.text.trim().isEmpty) {
        _showErrorDialog('Vui lòng nhập họ và tên');
        return;
      }

      // Create update request
      final requestData = <String, dynamic>{
        'name': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        'dataOfBirth': _selectedDate?.toIso8601String(),
        'gender': _selectedGender,
        'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        'jobName': _jobNameController.text.trim().isEmpty ? null : _jobNameController.text.trim(),
        'facebook': _facebookController.text.trim().isEmpty ? null : _facebookController.text.trim(),
        'youtube': _youtubeController.text.trim().isEmpty ? null : _youtubeController.text.trim(),
        'twitter': _twitterController.text.trim().isEmpty ? null : _twitterController.text.trim(),
        'avatar': _currentAvatarUrl,
      };

      // Call API
      final success = await profileViewModel.updateProfile(authViewModel.currentUser!.id, requestData);
      
      if (success) {
        setState(() {
          _currentProfile = profileViewModel.currentProfile;
          _isUpdating = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật hồ sơ thành công!'),
            backgroundColor: Color(0xFF0961F5),
          ),
        );

        // Navigate back
        Navigator.pop(context);
      } else {
        setState(() {
          _isUpdating = false;
        });
        _showErrorDialog(profileViewModel.errorMessage ?? 'Cập nhật hồ sơ thất bại');
      }
      
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      _showErrorDialog('Lỗi khi cập nhật hồ sơ: $e');
    }
  }

  Future<void> _selectImage() async {
    try {
      if (kIsWeb) {
        // For web platform, use HTML file input
        _showWebImagePicker();
      } else {
        // For mobile platforms
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        
        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });
          
          // Upload image immediately
          await _uploadImage();
        }
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi chọn ảnh: $e');
    }
  }

  void _showWebImagePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn ảnh'),
          content: const Text('Chức năng upload ảnh chưa hỗ trợ trên web. Vui lòng sử dụng ứng dụng mobile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    
    try {
      setState(() {
        _isUploadingImage = true;
      });
      
      String? imageUrl;
      if (kIsWeb) {
        // For web, we can't upload files directly, so we'll skip upload
        // and just show a message
        setState(() {
          _isUploadingImage = false;
        });
        _showErrorDialog('Chức năng upload ảnh chưa hỗ trợ trên web. Vui lòng sử dụng ứng dụng mobile.');
        return;
      } else {
        final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
        imageUrl = await profileViewModel.uploadImage(filePath: _selectedImage!.path);
      }
      
      if (imageUrl != null) {
        setState(() {
          _currentAvatarUrl = imageUrl;
          _isUploadingImage = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload ảnh thành công!'),
            backgroundColor: Color(0xFF0961F5),
          ),
        );
      } else {
        setState(() {
          _isUploadingImage = false;
        });
        _showErrorDialog('Upload ảnh thất bại');
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      _showErrorDialog('Lỗi khi upload ảnh: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
