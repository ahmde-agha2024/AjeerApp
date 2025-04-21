import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> getPackageInfo() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  String version = info.version;
  String buildNumber = info.buildNumber;
  return 'Version'.tr() + " $version";
}
