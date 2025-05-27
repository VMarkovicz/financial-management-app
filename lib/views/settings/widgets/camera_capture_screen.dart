import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraCaptureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  late CameraController _controller;
  bool _isInitialized = false;
  XFile? _capturedPhoto;
  late List<CameraDescription> _cameras;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    _cameras = await availableCameras();
    _selectedCameraIndex = _cameras.indexWhere(
      (c) => c.lensDirection == widget.camera.lensDirection,
    );
    await _initializeController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _initializeController(
    CameraDescription cameraDescription,
  ) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.max);
    await _controller.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    setState(() {
      _isInitialized = false;
    });
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeController(_cameras[_selectedCameraIndex]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      final photo = await _controller.takePicture();
      setState(() {
        _capturedPhoto = photo;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to take photo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Photo')),
      body:
          _capturedPhoto == null
              ? SizedBox.expand(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.previewSize?.width ?? 1,
                            height: _controller.value.previewSize?.height ?? 1,
                            child: CameraPreview(_controller),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _takePhoto,
                            child: const Text('Take Photo'),
                          ),
                          const SizedBox(height: 12),
                          if (_cameras.length > 1)
                            ElevatedButton(
                              onPressed: _switchCamera,
                              child: const Text('Switch Camera'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      File(_capturedPhoto!.path),
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.of(context).pop(_capturedPhoto),
                      child: const Text('Use This Photo'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _capturedPhoto = null),
                      child: const Text('Retake'),
                    ),
                  ],
                ),
              ),
    );
  }
}
