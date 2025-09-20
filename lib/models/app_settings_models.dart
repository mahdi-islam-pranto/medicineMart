/// App Settings Models
///
/// This file contains models for app settings data that comes from the API.
/// These settings include app name, contact info, version, and other configurable data.

/// App Settings Data Model
class AppSettings {
  final String dateFormat;
  final String language;
  final String appName;
  final String appShortDescription;
  final String logo;
  final String email;
  final String apiUrl;
  final String appVersion;
  final String domainUrl;
  final String number;
  final String enableFirebase;
  final String firebaseServerkey;
  final String firebaseApikey;
  final String firebaseAuthdomain;
  final String firebaseProjectid;
  final String firebaseStoragebucket;
  final String firebaseMessagingsenderid;
  final String firebaseAppid;
  final String firebaseMeasurementid;

  const AppSettings({
    required this.dateFormat,
    required this.language,
    required this.appName,
    required this.appShortDescription,
    required this.logo,
    required this.email,
    required this.apiUrl,
    required this.appVersion,
    required this.domainUrl,
    required this.number,
    required this.enableFirebase,
    required this.firebaseServerkey,
    required this.firebaseApikey,
    required this.firebaseAuthdomain,
    required this.firebaseProjectid,
    required this.firebaseStoragebucket,
    required this.firebaseMessagingsenderid,
    required this.firebaseAppid,
    required this.firebaseMeasurementid,
  });

  /// Create AppSettings from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      dateFormat: json['date_format'] ?? '',
      language: json['language'] ?? 'en',
      appName: json['app_name'] ?? 'Health & Medicine',
      appShortDescription: json['app_short_description'] ?? '',
      logo: json['logo'] ?? '',
      email: json['email'] ?? '',
      apiUrl: json['api_url'] ?? '',
      appVersion: json['app_version'] ?? '1.0.0',
      domainUrl: json['domain_url'] ?? '',
      number: json['number'] ?? '',
      enableFirebase: json['enable_firebase'] ?? '0',
      firebaseServerkey: json['firebase_serverkey'] ?? '',
      firebaseApikey: json['firebase_apikey'] ?? '',
      firebaseAuthdomain: json['firebase_authdomain'] ?? '',
      firebaseProjectid: json['firebase_projectid'] ?? '',
      firebaseStoragebucket: json['firebase_storagebucket'] ?? '',
      firebaseMessagingsenderid: json['firebase_messagingsenderid'] ?? '',
      firebaseAppid: json['firebase_appid'] ?? '',
      firebaseMeasurementid: json['firebase_measurementid'] ?? '',
    );
  }

  /// Convert AppSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'date_format': dateFormat,
      'language': language,
      'app_name': appName,
      'app_short_description': appShortDescription,
      'logo': logo,
      'email': email,
      'api_url': apiUrl,
      'app_version': appVersion,
      'domain_url': domainUrl,
      'number': number,
      'enable_firebase': enableFirebase,
      'firebase_serverkey': firebaseServerkey,
      'firebase_apikey': firebaseApikey,
      'firebase_authdomain': firebaseAuthdomain,
      'firebase_projectid': firebaseProjectid,
      'firebase_storagebucket': firebaseStoragebucket,
      'firebase_messagingsenderid': firebaseMessagingsenderid,
      'firebase_appid': firebaseAppid,
      'firebase_measurementid': firebaseMeasurementid,
    };
  }

  /// Create a copy with updated values
  AppSettings copyWith({
    String? dateFormat,
    String? language,
    String? appName,
    String? appShortDescription,
    String? logo,
    String? email,
    String? apiUrl,
    String? appVersion,
    String? domainUrl,
    String? number,
    String? enableFirebase,
    String? firebaseServerkey,
    String? firebaseApikey,
    String? firebaseAuthdomain,
    String? firebaseProjectid,
    String? firebaseStoragebucket,
    String? firebaseMessagingsenderid,
    String? firebaseAppid,
    String? firebaseMeasurementid,
  }) {
    return AppSettings(
      dateFormat: dateFormat ?? this.dateFormat,
      language: language ?? this.language,
      appName: appName ?? this.appName,
      appShortDescription: appShortDescription ?? this.appShortDescription,
      logo: logo ?? this.logo,
      email: email ?? this.email,
      apiUrl: apiUrl ?? this.apiUrl,
      appVersion: appVersion ?? this.appVersion,
      domainUrl: domainUrl ?? this.domainUrl,
      number: number ?? this.number,
      enableFirebase: enableFirebase ?? this.enableFirebase,
      firebaseServerkey: firebaseServerkey ?? this.firebaseServerkey,
      firebaseApikey: firebaseApikey ?? this.firebaseApikey,
      firebaseAuthdomain: firebaseAuthdomain ?? this.firebaseAuthdomain,
      firebaseProjectid: firebaseProjectid ?? this.firebaseProjectid,
      firebaseStoragebucket: firebaseStoragebucket ?? this.firebaseStoragebucket,
      firebaseMessagingsenderid: firebaseMessagingsenderid ?? this.firebaseMessagingsenderid,
      firebaseAppid: firebaseAppid ?? this.firebaseAppid,
      firebaseMeasurementid: firebaseMeasurementid ?? this.firebaseMeasurementid,
    );
  }

  @override
  String toString() {
    return 'AppSettings(appName: $appName, email: $email, number: $number, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.dateFormat == dateFormat &&
        other.language == language &&
        other.appName == appName &&
        other.appShortDescription == appShortDescription &&
        other.logo == logo &&
        other.email == email &&
        other.apiUrl == apiUrl &&
        other.appVersion == appVersion &&
        other.domainUrl == domainUrl &&
        other.number == number &&
        other.enableFirebase == enableFirebase &&
        other.firebaseServerkey == firebaseServerkey &&
        other.firebaseApikey == firebaseApikey &&
        other.firebaseAuthdomain == firebaseAuthdomain &&
        other.firebaseProjectid == firebaseProjectid &&
        other.firebaseStoragebucket == firebaseStoragebucket &&
        other.firebaseMessagingsenderid == firebaseMessagingsenderid &&
        other.firebaseAppid == firebaseAppid &&
        other.firebaseMeasurementid == firebaseMeasurementid;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      dateFormat,
      language,
      appName,
      appShortDescription,
      logo,
      email,
      apiUrl,
      appVersion,
      domainUrl,
      number,
      enableFirebase,
      firebaseServerkey,
      firebaseApikey,
      firebaseAuthdomain,
      firebaseProjectid,
      firebaseStoragebucket,
      firebaseMessagingsenderid,
      firebaseAppid,
      firebaseMeasurementid,
    ]);
  }
}

/// App Settings API Response Model
class AppSettingsResponse {
  final bool success;
  final String message;
  final AppSettings? data;
  final String? error;

  const AppSettingsResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  /// Create successful response
  factory AppSettingsResponse.success({
    required String message,
    required AppSettings data,
  }) {
    return AppSettingsResponse(
      success: true,
      message: message,
      data: data,
    );
  }

  /// Create error response
  factory AppSettingsResponse.error(String error) {
    return AppSettingsResponse(
      success: false,
      message: error,
      error: error,
    );
  }

  /// Create AppSettingsResponse from JSON
  factory AppSettingsResponse.fromJson(Map<String, dynamic> json) {
    try {
      final status = json['status']?.toString() ?? '';
      final success = status == '200' || status == 'success';
      
      return AppSettingsResponse(
        success: success,
        message: json['message'] ?? '',
        data: success && json['data'] != null 
            ? AppSettings.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        error: success ? null : (json['error'] ?? json['message'] ?? 'Unknown error'),
      );
    } catch (e) {
      return AppSettingsResponse.error('Failed to parse response: $e');
    }
  }

  @override
  String toString() {
    return 'AppSettingsResponse(success: $success, message: $message, data: $data, error: $error)';
  }
}
