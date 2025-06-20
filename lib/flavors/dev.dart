
import 'package:danapaniexpress/core/common_imports.dart';
import '../entry/common_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setUpEnv(Flavor.dev);
  await EnvColors.setUpAppColors(Flavor.dev);
  FirebaseConfig.setUpFirebaseStrings(Flavor.dev);
  EnvAnim.setUpAppAnimations(Flavor.dev);
  EnvImages.setUpAppImages(Flavor.dev);
  EnvStrings.setUpAppStrings(Flavor.dev);

  commonMain();
}