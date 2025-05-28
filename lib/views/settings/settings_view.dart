import 'package:camera/camera.dart';
import 'package:financial_management_app/models/user_model.dart';
import 'package:financial_management_app/viewmodels/user_viewmodel.dart';
import 'package:financial_management_app/views/authentication/login_view.dart';
import 'package:financial_management_app/views/settings/widgets/change_currency.dart';
import 'package:financial_management_app/views/settings/widgets/edit_profile.dart';
import 'package:financial_management_app/views/settings/widgets/profile_avatar.dart';
import 'package:financial_management_app/widgets/custom_app_bar.dart';
import 'package:financial_management_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:financial_management_app/views/settings/widgets/camera_capture_screen.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late UserViewModel _userViewModel;
  CameraController? controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        controller = CameraController(_cameras![0], ResolutionPreset.max);
        await controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _logout() async {
    await _userViewModel.logoutUser();
    Get.off(
      () => const LoginView(),
      preventDuplicates: true,
      transition: Transition.noTransition,
    );
  }

  void _deleteAccount(_user) async {
    await _userViewModel.deleteUser(_user.id);
    Get.off(
      () => const LoginView(),
      preventDuplicates: true,
      transition: Transition.noTransition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder:
          (context, userViewModel, child) => Scaffold(
            appBar: CustomAppBar(title: "Settings", showActions: false),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            ProfileAvatar(
                              isLoading: userViewModel.busy,
                              username: userViewModel.user.username,
                              imageUrl:
                                  '${dotenv.env['CDN_URL']}/${userViewModel.user.email}_profile_picture.png',
                              onCameraTap:
                                  _isCameraInitialized
                                      ? () async {
                                        final photo = await Navigator.of(
                                          context,
                                        ).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    CameraCaptureScreen(
                                                      camera: _cameras![0],
                                                    ),
                                          ),
                                        );
                                        if (photo != null && mounted) {
                                          await userViewModel
                                              .uploadProfilePhoto(
                                                File(photo.path),
                                              );
                                        }
                                      }
                                      : () => debugPrint(
                                        'Camera not initialized or not available',
                                      ),
                            ),
                            const SizedBox(height: 16),
                            EditProfile(user: userViewModel.user),
                            const SizedBox(height: 16),
                            ChangeCurrency(user: userViewModel.user),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomButton(
                        label: "Logout",
                        backgroundColor: ButtonType.ghost,
                        onPressed: () {
                          _logout();
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: "Delete Account",
                        backgroundColor: ButtonType.secondary,
                        onPressed: () {
                          _deleteAccount(userViewModel.user);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
