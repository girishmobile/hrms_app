import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms/data/models/profile/profile_model.dart';
import 'package:intl/intl.dart';

import '../core/api/api_config.dart';
import '../core/api/gloable_status_code.dart';
import '../core/api/network_repository.dart';
import '../core/hive/app_config_cache.dart';
import '../core/hive/user_model.dart';
import '../core/widgets/component.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  File? _pickedFile;
  String? _imageUrl;

  File? get pickedFile => _pickedFile;

  String? get imageUrl => _imageUrl;

  void setNetworkImage(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  void setPickedFile(File file) {
    _pickedFile = file;
    notifyListeners();
  }

  void clearImage() {
    _pickedFile = null;
    _imageUrl = null;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  String? _profileImage;

  String? get profileImage => _profileImage;

  void setProfileImage(String? imageUrl) {
    _profileImage = imageUrl;
    notifyListeners(); // ⚡ Notifies all listeners to rebuild
  }

  Future<void> loadProfileFromCache() async {
    UserModel? user = await AppConfigCache.getUserModel();
    _profileImage = user?.data?.user?.profileImage;

    notifyListeners();
  }

  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;
  Future<void> getUserDetails({required Map<String, dynamic> body}) async {
    _setLoading(true);

    debugPrint('===$body');
    try {
      final response = await callApi(
        url: ApiConfig.getUserDetailsByIdUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        _profileModel = ProfileModel.fromJson(json.decode(response));

        setNetworkImage(
          '${ApiConfig.imageBaseUrl}/${_profileModel?.profileImage ?? ''}',
        );
        //final decoded = jsonDecode(response);
        final existingUserModel = await AppConfigCache.getUserModel();
        final existingToken = existingUserModel?.data?.token;
        final formattedJson = {
          "response": "success",
          "data": {
            "token": existingToken, // ✅ keep old token if available
            "user": {
              "id": _profileModel?.id,
              "firstname": _profileModel?.firstname ?? '',
              "lastname": _profileModel?.lastname ?? '',
              "email": _profileModel?.email ?? '',
              "employee_id": _profileModel?.employeeId ?? '',
              "profile_image": _profileModel?.profileImage ?? '',
              "profile": _profileModel?.profileImage ?? '',
              "role":
                  _profileModel?.roles != null &&
                      _profileModel!.roles!.isNotEmpty
                  ? {
                      "id": _profileModel!.roles![0].id,
                      "name": _profileModel!.roles![0].name,
                    }
                  : null,
              "batch_data": _profileModel?.location != null
                  ? {
                      "id": _profileModel!.location!.id,
                      "working_days": _profileModel!.location!.workingDays,
                      "alt_sat": _profileModel!.location!.altSat,
                    }
                  : null,
              "location_id": _profileModel?.location?.id,
            },
          },
        };
        final userModel = UserModel.fromJson(
          Map<String, dynamic>.from(formattedJson),
        );
        await AppConfigCache.saveUserModel(userModel);

        await loadProfileFromCache();
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('===$e');
      _setLoading(false);
    }
  }

  Future<void> uploadProfileImage({required String filePath}) async {
    _setLoading(true);
    try {
      var uri = Uri.parse(ApiConfig.uploadProfileImageUrl);

      var request = http.MultipartRequest('POST', uri);

      // 🔹 Add text fields

      // 🔹 Add image file
      var file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);

      final headers = await ApiConfig.getCommonHeaders();
      request.headers.addAll(headers);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response: ${response.body}');
      debugPrint('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final fileName = jsonResponse['filename'];

        /* Map<String, dynamic> body = {
          "profile_image": fileName,

        };*/
        /*  Map<String, dynamic> body(ProfileModel profile) {
          return {
            "id": profile.id,
            "firstname": profile.firstname,
            "lastname": profile.lastname,
            "employee_id": profile.employeeId,
            "about": profile.about,
            "company_name": profile.companyName ?? "",
            "spouse_name": profile.spouseName ?? "",
            "spouse_occuption": profile.spouseOccuption ?? "",
            "spouse_dob": profile.spouseDob,
            "child1_name": profile.child1Name ?? "",
            "child1_occuption": profile.child1Occuption ?? "",
            "child1_dob": profile.child1Dob,
            "child2_name": profile.child2Name ?? "",
            "child2_occuption": profile.child2Occuption ?? "",
            "child2_dob": profile.child2Dob,
            "child3_name": profile.child3Name ?? "",
            "child3_occuption": profile.child3Occuption ?? "",
            "child3_dob": profile.child3Dob,
            "email": profile.email,
            "company_email": profile.companyEmail,
            "address": profile.address,
            "per_address": profile.perAddress,
            "allowed_login": profile.allowedLogin,
            "is_wfh_allowed": profile.isWfhAllowed,
            "on_probation": profile.onProbation,
            "on_notice": profile.onNotice,
            "on_training": profile.onTraining,
            "is_manager": profile.isManager,
            "marital_status": profile.maritalStatus,
            "probation_end_date": profile.probationEndDate,
            "joining_date": profile.joiningDate,
            "increment_date": profile.incrementDate,
            "exit_date": profile.exitDate,
            "user_exit_status": profile.userExitStatus,
            "date_of_birth": profile.dateOfBirth,
            "marriage_anniversary_date": profile.marriageAnniversaryDate,
            "contact_no": profile.contactNo,
            "emergency_contact_no": profile.emergencyContactNo,
            "emergency_contact_person": profile.emergencyContactPerson,
            "blood_group": profile.bloodGroup,
            "driving_license_number": profile.drivingLicenseNumber,
            "pan_number": profile.panNumber,
            "aadhar_number": profile.aadharNumber,
            "aadhar_password": profile.aadharPassword,
            "voter_id_number": profile.voterIdNumber,
            "uan_number": profile.uanNumber,
            "pf_number": profile.pfNumber,
            "esic_number": profile.esicNumber,
            "driving_license_image": profile.drivingLicenseImage,
            "pan_id_image": profile.panIdImage,
            "aadhar_id_image": profile.aadharIdImage,
            "voter_id_image": profile.voterIdImage,
            "lc": profile.lc,
            "marksheet": profile.marksheet,
            "offer_later_file": profile.offerLaterFile,
            "joining_letter_file": profile.joiningLetterFile,
            "contract_file": profile.contractFile,
            "resume_file": profile.resumeFile,
            "appointment_letter": profile.appointmentLetter,
            "increment_letter": profile.incrementLetter,
            "promotion_letter": profile.promotionLetter,
            "relieving_letter": profile.relievingLetter,
            "exp_letter": profile.expLetter,
            "appreciation_letter": profile.appreciationLetter,
            "document_returns_letter": profile.documentReturnsLetter,
            "no_due_certificate": profile.noDueCertificate,
            "acknowledgement_letter": profile.acknowledgementLetter,
            "warning_letter": profile.warningLetter,
            "passport_number": profile.passportNumber,
            "passport_issue_date": profile.passportIssueDate,
            "passport_expiry_date": profile.passportExpiryDate,
            "passport_image": profile.passportImage,
            "visa_number": profile.visaNumber,
            "visa_issue_date": profile.visaIssueDate,
            "visa_expiry_date": profile.visaExpiryDate,
            "visa_image": profile.visaImage,
            "slack_username": profile.slackUsername,
            "linkdin_username": profile.linkdinUsername,
            "facebook_username": profile.facebookUsername,
            "profile_image": fileName,
            "twitter_username": profile.twitterUsername,
            "certifications_courses": profile.certificationsCourses,
            "other_work_experirnce": profile.otherWorkExperirnce,
            "gender": profile.gender?.id, // ✅ only ID
            "user_work": profile.userWork ?? [],
            "user_qualification": profile.userQualification ?? [],
          };
        }
*/
        Map<String, dynamic> requestBody = _buildProfileUpdateBody(
          _profileModel!,
          fileName,
        );
        await updateProfileData(body: requestBody);

        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: "Failed to upload image. ${response.reasonPhrase}",
        );
        _setLoading(false);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Upload error: $e');
      _setLoading(false);
    }
  }

  String? _formatDate(dynamic date) {
    if (date == null) return null;
    if (date is String) return date; // already formatted
    if (date is DateTime) {
      return DateFormat('dd-MM-yyyy').format(date);
    }
    return null;
  }

  Map<String, dynamic> _buildProfileUpdateBody(
    ProfileModel profile,
    String fileName,
  ) {
    return {
      "id": profile.id,
      "spouse_dob": _formatDate(profile.spouseDob),
      "child1_dob": _formatDate(profile.child1Dob),
      "joining_date": _formatDate(profile.joiningDate),
      "increment_date": _formatDate(profile.incrementDate),
      "probation_end_date": _formatDate(profile.probationEndDate),
      "exit_date": _formatDate(profile.exitDate),
      "date_of_birth": _formatDate(profile.dateOfBirth),
      "marriage_anniversary_date": _formatDate(profile.marriageAnniversaryDate),
      "passport_issue_date": _formatDate(profile.passportIssueDate),
      "passport_expiry_date": _formatDate(profile.passportExpiryDate),
      "visa_issue_date": _formatDate(profile.visaIssueDate),
      "visa_expiry_date": _formatDate(profile.visaExpiryDate),
      "firstname": profile.firstname,
      "lastname": profile.lastname,
      "employee_id": profile.employeeId,
      "about": profile.about,
      "company_name": profile.companyName ?? "",
      "spouse_name": profile.spouseName ?? "",
      "spouse_occuption": profile.spouseOccuption ?? "",

      "child1_name": profile.child1Name ?? "",
      "child1_occuption": profile.child1Occuption ?? "",

      "child2_name": profile.child2Name ?? "",
      "child2_occuption": profile.child2Occuption ?? "",
      "child2_dob": profile.child2Dob,
      "child3_name": profile.child3Name ?? "",
      "child3_occuption": profile.child3Occuption ?? "",
      "child3_dob": profile.child3Dob,
      "email": profile.email,
      "company_email": profile.companyEmail,
      "address": profile.address,
      "per_address": profile.perAddress,
      "allowed_login": profile.allowedLogin,
      "is_wfh_allowed": profile.isWfhAllowed,
      "on_probation": profile.onProbation,
      "on_notice": profile.onNotice,
      "on_training": profile.onTraining,
      "is_manager": profile.isManager,
      "marital_status": profile.maritalStatus,

      "user_exit_status": profile.userExitStatus,

      "contact_no": profile.contactNo,
      "emergency_contact_no": profile.emergencyContactNo,
      "emergency_contact_person": profile.emergencyContactPerson,
      "blood_group": profile.bloodGroup,
      "driving_license_number": profile.drivingLicenseNumber,
      "pan_number": profile.panNumber,
      "aadhar_number": profile.aadharNumber,
      "aadhar_password": profile.aadharPassword,
      "voter_id_number": profile.voterIdNumber,
      "uan_number": profile.uanNumber,
      "pf_number": profile.pfNumber,
      "esic_number": profile.esicNumber,
      "driving_license_image": profile.drivingLicenseImage,
      "pan_id_image": profile.panIdImage,
      "aadhar_id_image": profile.aadharIdImage,
      "voter_id_image": profile.voterIdImage,
      "lc": profile.lc,
      "marksheet": profile.marksheet,
      "offer_later_file": profile.offerLaterFile,
      "joining_letter_file": profile.joiningLetterFile,
      "contract_file": profile.contractFile,
      "resume_file": profile.resumeFile,
      "appointment_letter": profile.appointmentLetter,
      "increment_letter": profile.incrementLetter,
      "promotion_letter": profile.promotionLetter,
      "relieving_letter": profile.relievingLetter,
      "exp_letter": profile.expLetter,
      "appreciation_letter": profile.appreciationLetter,
      "document_returns_letter": profile.documentReturnsLetter,
      "no_due_certificate": profile.noDueCertificate,
      "acknowledgement_letter": profile.acknowledgementLetter,
      "warning_letter": profile.warningLetter,
      "passport_number": profile.passportNumber,

      "passport_image": profile.passportImage,
      "visa_number": profile.visaNumber,

      "visa_image": profile.visaImage,
      "slack_username": profile.slackUsername,
      "linkdin_username": profile.linkdinUsername,
      "facebook_username": profile.facebookUsername,
      "profile_image": fileName, // ✅ updated file name
      "twitter_username": profile.twitterUsername,
      "certifications_courses": profile.certificationsCourses,
      "other_work_experirnce": profile.otherWorkExperirnce,
      "gender": profile.gender?.id,
      "user_work": profile.userWork ?? [],
      "user_qualification": profile.userQualification ?? [],
    };
  }

  Future<void> updateProfileData({required Map<String, dynamic> body}) async {
    _setLoading(true);

    debugPrint('===$body');
    try {
      final response = await callApi(
        url: ApiConfig.updateProfileDataUrl,
        method: HttpMethod.post,
        body: body,
        headers: null,
      );

      if (globalStatusCode == 200) {
        debugPrint('json.decode(response)${json.decode(response)}');
        UserModel? user = await AppConfigCache.getUserModel();
        Map<String, dynamic> body = {"employee_id": user?.data?.user?.id};

        getUserDetails(body: body);

        final context = navigatorKey.currentContext;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                json.decode(response),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        _setLoading(false);
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",

          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('===$e');
      _setLoading(false);
    }
  }
}
