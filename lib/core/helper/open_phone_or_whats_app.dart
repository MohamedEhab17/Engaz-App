import 'package:url_launcher/url_launcher.dart';

Future<void> openPhoneOrWhatsApp(String phone) async {
  final cleanPhone = normalizePhone(phone);

  final whatsappUri = Uri.parse('whatsapp://send?phone=$cleanPhone');

  final phoneUri = Uri.parse(
    'tel:$phone',
  );

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
  }
}

String normalizePhone(String phone) {
  return phone.replaceAll('+', '').replaceAll(' ', '').replaceAll('-', '');
}
