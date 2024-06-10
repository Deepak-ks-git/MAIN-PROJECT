import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({Key? key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  late Uint8List _imageBytes = Uint8List(0);
  late List<String> _companyDetails = [];
  bool _isLoading = false;
  bool _isUploading = false;
  File? _selectedImage;

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _companyIdController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _address1Controller = TextEditingController();
  TextEditingController _address2Controller = TextEditingController();
  TextEditingController _address3Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final logoUrl = 'http://192.168.1.143:3000/LOGO_COMPANY';
    final detailsUrl = 'http://192.168.1.143:3000/companyDetails'; // Update with your API URL

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch logo
      final logoResponse = await http.get(Uri.parse(logoUrl));
      if (logoResponse.statusCode == 200) {
        setState(() {
          _imageBytes = logoResponse.bodyBytes;
        });
      } else {
        // Handle logo retrieval failure
        _imageBytes = Uint8List(0); // Reset image bytes
        print('Failed to load company logo');
      }

      // Fetch company details
      final detailsResponse = await http.get(Uri.parse(detailsUrl));
      if (detailsResponse.statusCode == 200) {
        final jsonData = jsonDecode(detailsResponse.body);
        // Convert integer elements to strings
        setState(() {
          _companyDetails = jsonData[0].map<String>((e) => e.toString()).toList();
          _isLoading = false;
          // Initialize controllers with fetched data
          _companyIdController.text = _companyDetails.isNotEmpty ? _companyDetails[0] : '';
          _companyNameController.text = _companyDetails.isNotEmpty ? _companyDetails[1] : '';
          _address1Controller.text = _companyDetails.isNotEmpty ? _companyDetails[2] : '';
          _address2Controller.text = _companyDetails.isNotEmpty ? _companyDetails[3] : '';
          _address3Controller.text = _companyDetails.isNotEmpty ? _companyDetails[4] : '';
          _websiteController.text = _companyDetails.isNotEmpty ? _companyDetails[5] : '';
          _emailController.text = _companyDetails.isNotEmpty ? _companyDetails[6] : '';
          _phoneController.text = _companyDetails.isNotEmpty ? _companyDetails[7] : '';
        });
      } else {
        // Handle company details retrieval failure
        _companyDetails = []; // Reset company details
        print('Failed to load company details');
        _isLoading = false;
      }
    } catch (e) {
      print('Error fetching data: $e');
      _isLoading = false;
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imageBytes = File(pickedImage.path).readAsBytesSync();
      });
    }
  }

  Future<void> _uploadImageAndDetails() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_selectedImage != null) {
        await _uploadImage(); // Upload image if selected
      }
      await _updateCompanyDetails(); // Update company details
      _showSuccessDialog();
    } catch (e) {
      print('Error uploading image and details: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null || _companyDetails.isEmpty) {
      // No image selected or company details not loaded
      return;
    }

    final serverUrl = 'http://192.168.1.143:3000/uploadlogo';
    final companyId = _companyDetails[0]; // Assuming company ID is the first detail

    try {
      // Combine upload process with a delay to ensure minimum progress time
      await Future.wait([
        Future.delayed(Duration(milliseconds: 500)),
        _performUpload(serverUrl, companyId)
      ]);

      print('Image uploaded successfully');
    } catch (e) {
      print('Error uploading image: $e');
      rethrow; // Rethrow the error to be caught by _uploadImageAndDetails
    }
  }

  Future<void> _performUpload(String serverUrl, String companyId) async {
    var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.fields['company_id'] = companyId;
    request.files.add(
      await http.MultipartFile.fromPath('logo', _selectedImage!.path),
    );

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Image upload failed with status code: ${response.statusCode}');
    }
  }

  Future<void> _updateCompanyDetails() async {
    // Validate if any field is empty
    if (_companyDetails.any((element) => element.isEmpty)) {
      print('Company details cannot be empty');
      return;
    }

    final updateUrl = 'http://192.168.1.143:3000/updateCompanyDetails'; // Update with your API URL

    try {
      final response = await http.post(Uri.parse(updateUrl), body: {
        'company_id': _companyDetails[0],
        'company_name': _companyDetails[1],
        'address1': _companyDetails[2],
        'address2': _companyDetails[3],
        'address3': _companyDetails[4],
        'website': _companyDetails[5],
        'mailid': _companyDetails[6],
        'phno': _companyDetails[7],
      });

      if (response.statusCode == 200) {
        print('Company details updated successfully');
      } else {
        print('Failed to update company details');
      }
    } catch (e) {
      print('Error updating company details: $e');
      rethrow; // Rethrow the error to be caught by _uploadImageAndDetails
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Text("Your organization profile has been saved."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF1E2736);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Profile',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: myColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _uploadImageAndDetails, // Call the combined upload function
            child: Text(
              'SAVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 222, 222, 222),
            padding: const EdgeInsets.all(10.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Main Container for Image and Company Details
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: _imageBytes.isEmpty ? _selectImage : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: _imageBytes.isNotEmpty
                                            ? null
                                            : Color.fromARGB(255, 218, 217, 217),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      alignment: Alignment.center,
                                      child: _imageBytes.isNotEmpty
                                          ? Image.memory(
                                              _imageBytes,
                                              fit: BoxFit.contain,
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.upload_sharp,
                                                  size: 30,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Upload Logo',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    if (_imageBytes.isNotEmpty)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: _selectImage,
                                          icon: Icon(Icons.edit),
                                          color: Colors.black,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                buildInputField(
                                  'Company Name',
                                  _companyNameController,
                                ),
                                buildInputField(
                                  'Company ID',
                                  _companyIdController,
                                ),
                                buildInputField(
                                  'Website',
                                  _websiteController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        // Container for Additional Company Details
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInputField(
                                'Address Line 1',
                                _address1Controller,
                              ),
                              buildInputField(
                                'Address Line 2',
                                _address2Controller,
                              ),
                              buildInputField(
                                'Address Line 3',
                                _address3Controller,
                              ),
                              buildInputField(
                                'Email',
                                _emailController,
                              ),
                              buildInputField(
                                'Phone',
                                _phoneController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (_isUploading)
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
        TextField(
          controller: controller,
          readOnly: false, // Make the text field editable
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          ),
          style: TextStyle(
            fontSize: 16,
          ),
          onChanged: (newValue) {
            // Update company details when text changes
            setState(() {
              switch (label) {
                case 'Company Name':
                  _companyDetails[1] = newValue;
                  break;
                case 'Company ID':
                  _companyDetails[0] = newValue;
                  break;
                case 'Website':
                  _companyDetails[5] = newValue;
                  break;
                case 'Address Line 1':
                  _companyDetails[2] = newValue;
                  break;
                case 'Address Line 2':
                  _companyDetails[3] = newValue;
                  break;
                case 'Address Line 3':
                  _companyDetails[4] = newValue;
                  break;
                case 'Email':
                  _companyDetails[6] = newValue;
                  break;
                case 'Phone':
                  _companyDetails[7] = newValue;
                  break;
                default:
                  break;
              }
            });
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CompanyProfile(),
  ));
}

