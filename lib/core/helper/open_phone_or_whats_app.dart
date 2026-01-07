import 'package:url_launcher/url_launcher.dart';

Future<void> openPhoneOrWhatsApp(String phone) async {
  if (phone.trim().isEmpty) return;

  final cleanPhone = normalizePhone(phone);

  final whatsappUri = Uri.parse('whatsapp://send?phone=$cleanPhone');

  final phoneUri = Uri.parse('tel:$cleanPhone');

  try {
    final launched = await launchUrl(
      whatsappUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      await _launchPhone(phoneUri);
    }
  } catch (_) {
    await _launchPhone(phoneUri);
  }
}

Future<void> _launchPhone(Uri phoneUri) async {
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
  } else {
    // Show error toast if unable to launch
  }
}

String normalizePhone(String phone) {
  return phone
      .replaceAll('+', '')
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('(', '')
      .replaceAll(')', '');
}
