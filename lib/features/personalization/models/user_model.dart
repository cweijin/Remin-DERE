import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:remindere/utils/formatters/formatter.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  final String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  int unread;

  // Constructor for UserModel
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.unread = 0,
  });

  // Helper function to get the full name
  String get fullName => '$firstName $lastName';

  // Helper function to format phone number
  String get formattedPhoneNo => RFormatter.formatPhoneNumber(phoneNumber);

  // Helper function to generate search keywords for current user
  List<String> searchKeywords() {
    Set<String> finalKeywords = {};

    List<String> keywordHelper(String str) {
      List<String> keywords = [];
      List<String> charList = str.split('');
      String currStr = '';

      for (String char in charList) {
        currStr += char;
        keywords.add(currStr);
      }

      return keywords;
    }

    finalKeywords.addAll(keywordHelper(fullName.toLowerCase()));
    finalKeywords.addAll(keywordHelper(lastName.toLowerCase()));
    finalKeywords.addAll(keywordHelper(email.toLowerCase()));

    return finalKeywords.toList();
  }

  // Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(" ");

  // Static function to generate a username from the full name
  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername =
        "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "rem_$camelCaseUsername"; // Add "rem_" prefix
    return usernameWithPrefix;
  }

  // Static function to create an empty user model
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
      );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJSON() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Unread': unread,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        unread: data['Unread'] ?? 0,
      );
    } else {
      return UserModel.empty();
    }
  }

  // @override
  // operator ==(other) {
  //   if (other is UserModel) {
  //     return id == other.id;
  //   }
  //   return false;
  // }

  // @override
  // int get hashCode => Object.hash(id, email);
}
