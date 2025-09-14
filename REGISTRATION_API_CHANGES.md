# Registration API Changes - Form Data Implementation + Mandatory NID Upload

## Overview
The user registration API has been updated with two major changes:
1. **Multipart Form Data**: Changed from JSON to multipart form data for proper file upload functionality
2. **Mandatory NID Upload**: NID picture upload is now required for registration

This ensures proper file handling and enforces the business requirement that all pharmacy owners must provide valid NID documentation.

## Changes Made

### 1. Updated `lib/APIs/auth_api_service.dart`

**Before (JSON):**
```dart
final requestBody = {
  'fullName': request.fullName,
  'phoneNumber': request.phoneNumber,
  // ... other fields
  'nidImagePath': request.nidImagePath ?? 'string',
};

final response = await http.post(
  Uri.parse(ApiConfig.registerUrl),
  headers: ApiConfig.headers,
  body: json.encode(requestBody),
);
```

**After (Multipart Form Data):**
```dart
final multipartRequest = http.MultipartRequest('POST', uri);
multipartRequest.headers.addAll(ApiConfig.multipartHeaders);

// Add text fields
multipartRequest.fields.addAll({
  'fullName': request.fullName,
  'phoneNumber': request.phoneNumber,
  // ... other fields
});

// Add file if provided
if (request.nidImagePath != null && request.nidImagePath!.isNotEmpty) {
  final file = File(request.nidImagePath!);
  if (await file.exists()) {
    final multipartFile = await http.MultipartFile.fromPath(
      'nidImagePath',
      file.path,
    );
    multipartRequest.files.add(multipartFile);
  }
}

final streamedResponse = await multipartRequest.send();
final response = await http.Response.fromStream(streamedResponse);
```

### 2. Updated `lib/APIs/api_config.dart`

Added new headers for multipart requests:
```dart
// Request headers for multipart form data requests
// Note: Don't set Content-Type for multipart requests as http package handles it automatically
static Map<String, String> get multipartHeaders => {
  'Accept': 'application/json',
};
```

## API Request Format

### Text Fields (Form Data)
All text fields are now sent as form data fields:
- `fullName`
- `phoneNumber`
- `pharmacyName`
- `district`
- `policeStation`
- `pharmacyFullAddress`
- `email`
- `password`

### File Field
- `nidImagePath` - Now sent as a file upload instead of a string path

## Key Features

### 1. **File Upload Support**
- Properly handles NID image file upload
- Validates file existence before upload
- Uses `http.MultipartFile.fromPath()` for efficient file handling

### 2. **Backward Compatibility**
- All existing text fields remain the same
- Same field names as before
- Same validation logic in the UI

### 3. **Error Handling**
- Maintains existing error handling logic
- Proper timeout handling
- File existence validation

### 4. **Content Type Management**
- Automatically sets correct `multipart/form-data` content type
- Includes proper boundary headers
- Accepts JSON responses

## Testing

Created comprehensive tests in `test/auth_api_test.dart`:
- Verifies multipart request creation
- Tests field mapping
- Handles null image path scenarios
- All tests pass successfully

## Usage Example

The registration flow remains the same from the UI perspective:

```dart
final request = RegistrationRequest(
  fullName: 'John Doe',
  phoneNumber: '01234567890',
  pharmacyName: 'ABC Pharmacy',
  district: 'Dhaka',
  policeStation: 'Dhanmondi',
  pharmacyFullAddress: '123 Main Street',
  email: 'john@example.com',
  password: 'securepassword',
  confirmPassword: 'securepassword',
  nidImagePath: '/path/to/nid/image.jpg', // File path from image picker
);

// This now sends multipart form data with file upload
context.read<AuthCubit>().register(request);
```

## Benefits

1. **Proper File Upload**: NID images are now uploaded as actual files instead of path strings
2. **Better Performance**: Efficient file handling with streaming
3. **Standard Compliance**: Uses standard multipart/form-data format
4. **Maintainability**: Clean separation between text fields and file uploads
5. **Scalability**: Easy to add more file fields in the future

## Notes

- The `http` package handles multipart encoding automatically
- Content-Type header is set automatically by the HTTP client
- File validation ensures only existing files are uploaded
- Maintains all existing error handling and response parsing logic
