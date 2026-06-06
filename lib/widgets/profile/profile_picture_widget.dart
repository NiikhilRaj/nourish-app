import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? profilePhotoBase64;
  final bool isEditMode;
  final ValueChanged<String>? onPhotoChanged;

  const ProfilePictureWidget({
    super.key,
    this.profilePhotoBase64,
    this.isEditMode = false,
    this.onPhotoChanged,
  });

  static const List<String> _animalAvatars = ['assets/images/profile_icons/'];

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (profilePhotoBase64 != null && profilePhotoBase64!.isNotEmpty) {
      if (profilePhotoBase64!.startsWith('assets/')) {
        imageWidget = Image.asset(
          profilePhotoBase64!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } else {
        try {
          final bytes = base64Decode(profilePhotoBase64!);
          imageWidget = Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          );
        } catch (e) {
          imageWidget = _buildPlaceholder();
        }
      }
    } else {
      imageWidget = _buildPlaceholder();
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(child: imageWidget),
          ),
          if (isEditMode)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showPhotoSourceBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        if (onPhotoChanged != null) {
          onPhotoChanged!(base64String);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _showPhotoSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  'Choose Profile Picture',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Chivo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _animalAvatars.length,
                  itemBuilder: (context, index) {
                    final assetPath = _animalAvatars[index];
                    return GestureDetector(
                      onTap: () {
                        if (onPhotoChanged != null) {
                          onPhotoChanged!(assetPath);
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12.0),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                profilePhotoBase64 == assetPath
                                    ? const Color(0xffFFC009)
                                    : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(assetPath, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
