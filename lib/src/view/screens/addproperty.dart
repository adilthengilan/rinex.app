import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  // Form controllers
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _kitchenController = TextEditingController();
  final _parkingController = TextEditingController();
  final _yearBuiltController = TextEditingController();
  final _priceController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  // Property type dropdown
  String _selectedPropertyType = 'House';
  final List<String> _propertyTypes = [
    'House',
    'Apartment',
    'Villa',
    'Condo',
    'Office',
  ];

  // Furnishing status
  String _furnishingStatus = 'Unfurnished';
  final List<String> _furnishingOptions = [
    'Furnished',
    'Semi-Furnished',
    'Unfurnished',
  ];

  // Property tags
  final List<String> _availableTags = [
    'Sea View',
    'Prime Location',
    'Corner Property',
  ];
  List<String> _selectedTags = [];

  // Boolean options
  bool _legalClearance = false;
  bool _loanAvailable = false;

  // Media files
  List<File> _selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Audio recording
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedAudioPath;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _kitchenController.dispose();
    _parkingController.dispose();
    _yearBuiltController.dispose();
    _priceController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _additionalInfoController.dispose();
    _recorder?.closeRecorder();
    _recordingTimer?.cancel();
    super.dispose();
  }

  // Initialize audio recorder
  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }

  // Image picker methods
  Future<void> _pickImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(images.map((xFile) => File(xFile.path)).toList());
    });
  }

  Future<void> _takePicture() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  // Remove image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Audio recording methods
  Future<void> _startRecording() async {
    final permission = await Permission.microphone.request();
    if (permission.isGranted) {
      final tempDir = Directory.systemTemp;
      final audioFile = File('${tempDir.path}/recorded_audio.aac');

      await _recorder!.startRecorder(toFile: audioFile.path);

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });

      // Start timer for recording duration
      _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder!.stopRecorder();
    _recordingTimer?.cancel();

    setState(() {
      _isRecording = false;
      _recordedAudioPath = path;
    });
  }

  // File picker for audio files
  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    );

    if (result != null) {
      setState(() {
        _recordedAudioPath = result.files.single.path;
      });
    }
  }

  // Format recording duration
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Property tag selection
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  // Form validation and submission
  void _submitForm() {
    // Basic validation
    if (_titleController.text.isEmpty) {
      _showSnackBar('Please enter property title');
      return;
    }
    if (_locationController.text.isEmpty) {
      _showSnackBar('Please enter location');
      return;
    }
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showSnackBar('Please enter phone number');
      return;
    }

    // Show success message
    _showSnackBar('Property posted successfully!');

    // Here you would typically send data to your backend
    _printFormData();
  }

  void _printFormData() {
    print('=== Property Form Data ===');
    print('Title: ${_titleController.text}');
    print('Location: ${_locationController.text}');
    print('Property Type: $_selectedPropertyType');
    print('Area: ${_areaController.text}');
    print('Bedrooms: ${_bedroomsController.text}');
    print('Bathrooms: ${_bathroomsController.text}');
    print('Kitchen: ${_kitchenController.text}');
    print('Furnishing: $_furnishingStatus');
    print('Parking: ${_parkingController.text}');
    print('Year Built: ${_yearBuiltController.text}');
    print('Price: ${_priceController.text}');
    print('Images: ${_selectedImages.length} files');
    print('Audio: $_recordedAudioPath');
    print('Name: ${_nameController.text}');
    print('Phone: ${_phoneController.text}');
    print('Email: ${_emailController.text}');
    print('Additional Info: ${_additionalInfoController.text}');
    print('Tags: $_selectedTags');
    print('Legal Clearance: $_legalClearance');
    print('Loan Available: $_loanAvailable');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 24),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Add new property',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please fill out the form below to add your property details',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 24),

                      // Title field
                      _buildSectionTitle('Title'),
                      _buildTextField(_titleController, 'Title'),

                      // Location field
                      _buildSectionTitle('Location'),
                      _buildTextField(
                        _locationController,
                        'Location',
                        icon: Icons.location_pin,
                      ),

                      // Property type dropdown
                      _buildSectionTitle('Property type'),
                      _buildDropdown(),

                      // Features section
                      _buildSectionTitle('Features'),
                      _buildTextField(_areaController, 'Area', suffix: 'Sqft'),
                      _buildNumberField(
                        _bedroomsController,
                        'Bedrooms',
                        Icons.bed,
                      ),
                      _buildNumberField(
                        _bathroomsController,
                        'Bathrooms',
                        Icons.bathroom,
                      ),
                      _buildNumberField(
                        _kitchenController,
                        'Kitchen',
                        Icons.kitchen,
                      ),
                      _buildFurnishingDropdown(),
                      _buildNumberField(
                        _parkingController,
                        'Parking Availability',
                        Icons.local_parking,
                      ),
                      _buildTextField(
                        _yearBuiltController,
                        'Year Built',
                        icon: Icons.calendar_today,
                      ),
                      _buildTextField(
                        _priceController,
                        'Price of property',
                        icon: Icons.attach_money,
                      ),

                      // Media upload section
                      _buildSectionTitle('Media Upload'),
                      _buildMediaUploadSection(),

                      // Voice upload section
                      _buildSectionTitle('Voice Upload'),
                      _buildVoiceUploadSection(),

                      // Contact details section
                      _buildSectionTitle('Contact details'),
                      _buildTextField(_nameController, 'Name'),
                      _buildTextField(_phoneController, 'Phone number'),
                      _buildTextField(_emailController, 'Email'),

                      // Additional information
                      _buildSectionTitle(
                        'Additional Information',
                        isOptional: true,
                      ),
                      _buildTextField(
                        _additionalInfoController,
                        'Lift, Security, CCTV, Gym, Pool, Garden, Power Backup, Club House, Maintenance, Water Supply, etc.',
                        maxLines: 4,
                      ),

                      // Property tags
                      _buildPropertyTagsSection(),

                      // Legal clearance and loan options
                      _buildCheckboxOption('Legal Clearance', _legalClearance, (
                        value,
                      ) {
                        setState(() => _legalClearance = value!);
                      }),
                      _buildCheckboxOption('Loan Available', _loanAvailable, (
                        value,
                      ) {
                        setState(() => _loanAvailable = value!);
                      }),

                      SizedBox(height: 20),

                      // Disclaimer text
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Ensure all property information and media files are accurate before clicking "Post Property"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 24),

                      // Submit button
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Post property',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for building UI components

  Widget _buildSectionTitle(String title, {bool isOptional = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title + (isOptional ? ' (optional)' : ''),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? icon,
    String? suffix,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey[500], size: 20)
              : null,
          suffixText: suffix,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildNumberField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
          suffixIcon: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF4A90E2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedPropertyType,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.home, color: Colors.grey[500], size: 20),
          border: InputBorder.none,
        ),
        items: _propertyTypes.map((type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList(),
        onChanged: (value) {
          setState(() => _selectedPropertyType = value!);
        },
      ),
    );
  }

  Widget _buildFurnishingDropdown() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: _furnishingStatus,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.chair, color: Colors.grey[500], size: 20),
          border: InputBorder.none,
          hintText: 'Furnishing Status',
        ),
        items: _furnishingOptions.map((option) {
          return DropdownMenuItem(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) {
          setState(() => _furnishingStatus = value!);
        },
      ),
    );
  }

  Widget _buildMediaUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Click on the upload button and select multiple images and videos from your device',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 12),

        // Display selected images
        if (_selectedImages.isNotEmpty)
          Container(
            height: 100,
            margin: EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return _buildAddImageButton();
                }
                return _buildImagePreview(index);
              },
            ),
          ),

        // Upload buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImages,
                icon: Icon(Icons.upload, size: 18),
                label: Text('Browse files'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF4A90E2),
                  side: BorderSide(color: Color(0xFF4A90E2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _takePicture,
                icon: Icon(Icons.camera_alt, size: 18),
                label: Text('Take Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Icon(Icons.add, color: Colors.grey[500], size: 30),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _selectedImages[index],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Drag to record your voice, release to stop, then upload the voice note',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 12),

        // Recording controls
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              // Record button
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Color(0xFF4A90E2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Waveform visualization (simplified)
              Expanded(
                child: Container(
                  height: 40,
                  child: _isRecording
                      ? Row(
                          children: List.generate(20, (index) {
                            return Container(
                              width: 2,
                              height: (index % 4 + 1) * 8.0,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A90E2),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            );
                          }),
                        )
                      : Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16),

              // Duration display
              Text(
                _isRecording ? _formatDuration(_recordingDuration) : '00:00',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        // Audio file path display
        if (_recordedAudioPath != null)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.audiotrack, color: Colors.green[600], size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Audio recorded successfully',
                    style: TextStyle(color: Colors.green[700], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

        SizedBox(height: 12),

        Text(
          'OR',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500]),
        ),
        SizedBox(height: 12),

        // Upload audio file button
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _pickAudioFile,
            icon: Icon(Icons.upload_file, size: 18),
            label: Text('Browse files'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF4A90E2),
              side: BorderSide(color: Color(0xFF4A90E2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        Text(
          'file name.mp3',
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPropertyTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.tag, color: Color(0xFF4A90E2), size: 20),
              SizedBox(width: 12),
              Text(
                'Property tags',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A90E2)),
            ],
          ),
        ),

        SizedBox(height: 16),

        // Tag options
        ..._availableTags.map((tag) {
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: _selectedTags.contains(tag)
                  ? Colors.blue[50]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedTags.contains(tag)
                    ? Color(0xFF4A90E2)
                    : Colors.transparent,
              ),
            ),
            child: GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Row(
                children: [
                  Text(
                    tag,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Spacer(),
                  if (_selectedTags.contains(tag))
                    Icon(Icons.check, color: Color(0xFF4A90E2), size: 20),
                ],
              ),
            ),
          );
        }).toList(),

        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black87)),
          Spacer(),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? Color(0xFF4A90E2) : Colors.grey[400]!,
                width: 2,
              ),
              color: value ? Color(0xFF4A90E2) : Colors.transparent,
            ),
            child: value
                ? Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ],
      ),
    ).asGestureDetector(onTap: () => onChanged(!value));
  }
}

// Extension to make any widget tappable
extension WidgetExtension on Widget {
  Widget asGestureDetector({required VoidCallback onTap}) {
    return GestureDetector(onTap: onTap, child: this);
  }
}
