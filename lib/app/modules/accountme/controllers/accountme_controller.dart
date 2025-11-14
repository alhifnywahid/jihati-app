import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPlatform {
  final String platform;
  final String username;
  final String url;

  SocialMediaPlatform({
    required this.platform,
    required this.username,
    required this.url,
  });
}

class AccountmeController extends GetxController {
  final List<SocialMediaPlatform> socialMediaData = [
    SocialMediaPlatform(
      platform: "Instagram",
      username: "pwformasiruasurabayaa",
      url: "https://www.instagram.com/pwformasiruasurabayaa",
    ),
    SocialMediaPlatform(
      platform: "Facebook",
      username: "PW Formasi Rua Surabaya",
      url: "https://facebook.com/profile.php?id=61572250394606",
    ),
    SocialMediaPlatform(
      platform: "TikTok",
      username: "pwformasiruasurabaya",
      url: "https://www.tiktok.com/@pwformasiruasurabaya",
    ),
  ];

  IconData getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'tiktok':
        return Icons.music_note;
      default:
        return Icons.link;
    }
  }

  Color getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'tiktok':
        return const Color(0xFF000000);
      default:
        return Colors.grey;
    }
  }

  Future<void> launchUrlWithFeedback(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!success) { 
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } else {
        if (context.mounted) {
          showError(context, 'Tidak dapat membuka $url');
        }
      }
    } catch (e) {
      if (context.mounted) {
        showError(context, 'Terjadi kesalahan: $e');
      }
    }
  }

  void showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}
