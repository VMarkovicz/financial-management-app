import 'dart:io';

import 'package:financial_management_app/widgets/paper_container.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String username;
  final String imageUrl;
  final VoidCallback? onCameraTap;
  final bool isLoading;

  const ProfileAvatar({
    super.key,
    required this.username,
    required this.imageUrl,
    this.onCameraTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PaperContainer(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      isLoading
                          ? null
                          : imageUrl.isNotEmpty
                          ? FileImage(File(imageUrl)) as ImageProvider
                          : null,
                  child:
                      isLoading
                          ? CircularProgressIndicator()
                          : imageUrl.isEmpty
                          ? Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                    ),
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: () => onCameraTap?.call(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              username,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
