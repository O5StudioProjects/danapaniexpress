
import '../core/common_imports.dart';
import '../entry/common_main.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setUpEnv(Flavor.rider);
  FirebaseConfig.setUpFirebaseStrings(Flavor.rider);
  EnvAnim.setUpAppAnimations(Flavor.rider);
  EnvColors.setUpAppColors(Flavor.rider);
  EnvImages.setUpAppImages(Flavor.rider);
  EnvStrings.setUpAppStrings(Flavor.rider);
  commonMain();
}