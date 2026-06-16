import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../model/banner_model.dart';
import '../../../../services/web_utils.dart' as web_utils;
import '../../../../reusable/colors.dart';
import '../../../../reusable/snack_bar.dart';
import 'banner_widgets.dart';

class BannerUploadCard extends StatefulWidget {
  final Function(BannerModel) onUpload;
  final BannerService bannerService;

  const BannerUploadCard({super.key, required this.onUpload, required this.bannerService});

  @override
  State<BannerUploadCard> createState() => _BannerUploadCardState();
}

class _BannerUploadCardState extends State<BannerUploadCard> {
  // Position options for betting app
  final List<String> positionOptions = ['Carousel Banner', '2x2 Banner', '4x4 Banner'];

  Uint8List? _selectedImageData;
  bool isHover = false;
  String _selectedGameType = '';
  String _selectedPosition = '';
  bool _isActive = true;

  Future<void> _pickImage() async {
    try {
      final bytes = await web_utils.pickFileBytes(accept: 'image/*');
      if (bytes != null) {
        setState(() {
          _selectedImageData = Uint8List.fromList(bytes);
        });
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'Failed to pick image: $e', error: true);
    }
  }

  void _uploadBanner() {
    // Validate
    if (_selectedImageData == null) {
      showSnackBar(context, 'Please select an image', error: true);
      return;
    }

    if (_selectedGameType.isEmpty) {
      showSnackBar(context, 'Please select a game type', error: true);
      return;
    }

    if (_selectedPosition.isEmpty) {
      showSnackBar(context, 'Please select a banner position', error: true);
      return;
    }

    // Convert position display name to code
    String positionCode = '';
    switch (_selectedPosition) {
      case 'Carousel Banner':
        positionCode = 'carousel';
        break;
      case '2x2 Banner':
        positionCode = '2x2';
        break;
      case '4x4 Banner':
        positionCode = '4x4';
        break;
    }

    final newBanner = BannerModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameType: _selectedGameType,
      position: positionCode,
      isActive: _isActive,
      imageData: _selectedImageData,
      size: _selectedImageData!.lengthInBytes / 1024 / 1024,
      format: _getImageFormat(_selectedImageData!),
      createdAt: DateTime.now(),
    );

    widget.onUpload(newBanner);
    showSnackBar(context, 'Banner uploaded successfully!');

    setState(() {
      _selectedImageData = null;
      _selectedGameType = '';
      _selectedPosition = '';
      _isActive = true;
    });
  }

  String _getImageFormat(Uint8List data) {
    if (data.length < 8) return 'UNKNOWN';
    if (data[0] == 0x89 && data[1] == 0x50 && data[2] == 0x4E && data[3] == 0x47) return 'PNG';
    if (data[0] == 0xFF && data[1] == 0xD8) return 'JPG';
    return 'UNKNOWN';
  }

  @override
  Widget build(BuildContext context) {
    final gameTypes = widget.bannerService.getGameTypes();

    return BannerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_upload, color: blue, size: 24),
              SizedBox(width: 8),
              Text(
                'Add New Banner',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Image Upload with aspect ratio hint
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Banner Image *',
                    style: TextStyle(color: black, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  Text(_getAspectRatioHint(), style: TextStyle(color: blue, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              MouseRegion(
                onEnter: (_) => setState(() => isHover = true),
                onExit: (_) => setState(() => isHover = false),
                child: InkWell(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: isHover ? blue.withValues(alpha: 0.1) : cmsCardBorder,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isHover ? blue : grey, width: isHover ? 2 : 0.5),
                    ),
                    child: _selectedImageData == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload, size: 48, color: grey),
                              SizedBox(height: 16),
                              Text(
                                'Click to upload image',
                                style: TextStyle(color: black, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4),
                              Text('Supports: JPG, PNG', style: TextStyle(color: cmsHeader, fontSize: 12)),
                            ],
                          )
                        : Center(child: Image.memory(_selectedImageData!, fit: BoxFit.contain, height: 180)),
                  ),
                ),
              ),
            ],
          ),

          // Game Type
          BannerDropdown(
            title: 'Game Type *',
            hint: 'Select game type',
            value: _selectedGameType,
            items: gameTypes,
            onChanged: (value) {
              setState(() {
                _selectedGameType = value!;
              });
            },
          ),
          // Banner Position
          BannerDropdown(
            title: 'Banner Position *',
            hint: 'Select banner position',
            value: _selectedPosition,
            items: positionOptions,
            onChanged: (value) {
              setState(() {
                _selectedPosition = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          // Status
          Row(
            children: [
              const Text(
                'Active Status',
                style: TextStyle(color: black, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Switch(
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeThumbColor : blue,
                inactiveTrackColor: blue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Add Button
          SizedBox(
            width: double.infinity,
            height: 45,
            child: CmsCTAButton(type: 1, action: _uploadBanner, icon: Icons.upload, title: 'Add Banner'),
          ),
        ],
      ),
    );
  }

  String _getAspectRatioHint() {
    switch (_selectedPosition) {
      case 'Carousel Banner':
        return '(Recommended: 1200x400)';
      case '2x2 Banner':
        return '(Recommended: 400x400)';
      case '4x4 Banner':
        return '(Recommended: 200x200)';
      default:
        return '';
    }
  }
}
