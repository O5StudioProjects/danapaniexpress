
import '../core/common_imports.dart';
import '../entry/common_main.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setUpEnv(Flavor.prod);
  FirebaseConfig.setUpFirebaseStrings(Flavor.prod);
  EnvAnim.setUpAppAnimations(Flavor.prod);
  EnvColors.setUpAppColors(Flavor.prod);
  EnvImages.setUpAppImages(Flavor.prod);
  EnvStrings.setUpAppStrings(Flavor.prod);
  commonMain();
}