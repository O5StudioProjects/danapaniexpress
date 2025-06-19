
import 'package:danapaniexpress/core/common_imports.dart';
import '../entry/common_main.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setUpEnv(Flavor.dev);
  FirebaseConfig.setUpFirebaseStrings(Flavor.dev);
  EnvAnim.setUpAppAnimations(Flavor.dev);
  EnvColors.setUpAppColors(Flavor.dev);
  EnvImages.setUpAppImages(Flavor.dev);
  EnvStrings.setUpAppStrings(Flavor.dev);

  commonMain();
}