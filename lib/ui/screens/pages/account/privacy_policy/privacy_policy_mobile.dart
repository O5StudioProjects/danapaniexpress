import 'package:danapaniexpress/core/common_imports.dart';

class PrivacyPolicyMobile extends StatelessWidget {
  const PrivacyPolicyMobile({super.key});

  bool get isUrdu => appLanguage == URDU_LANGUAGE;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: AppLanguage.privacyPolicyStr(appLanguage),
            isBackNavigation: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(MAIN_HORIZONTAL_PADDING),
              child: Column(
                crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  mainTitle(isUrdu
                      ? "🛡️ پرائیویسی پالیسی – دانا پانی ایکسپریس"
                      : "🛡️ Privacy Policy – Dana Pani Express"),

                  sectionBody(isUrdu
                      ? "دانا پانی ایکسپریس میں، ہم آپ کی رازداری کی قدر کرتے ہیں اور آپ کی ذاتی معلومات کے تحفظ کے لیے پرعزم ہیں۔ یہ پالیسی وضاحت کرتی ہے کہ ہم آپ کا ڈیٹا کیسے اکٹھا کرتے ہیں، استعمال کرتے ہیں اور محفوظ رکھتے ہیں۔"
                      : "At Dana Pani Express, we value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our mobile app or services."),

                  sectionTitle(isUrdu ? "1. ہم کون سی معلومات اکٹھی کرتے ہیں" : "1. Information We Collect"),
                  sectionBody(isUrdu
                      ? "- ذاتی معلومات: نام، فون نمبر، ای میل، پتہ، اور ادائیگی کی تفصیلات۔\n"
                      "- ڈیوائس ڈیٹا: IP ایڈریس، ایپ ورژن، ڈیوائس ٹائپ، اور OS۔\n"
                      "- لوکیشن ڈیٹا: صرف آپ کی اجازت سے، درست ڈلیوری کے لیے۔"
                      : "- Personal Information: Name, phone number, email address, delivery address, and payment details.\n"
                      "- Device & Usage Data: IP address, app version, device type, OS, and app behavior.\n"
                      "- Location Data: Used with permission for accurate deliveries."),

                  sectionTitle(isUrdu ? "2. معلومات کے استعمال کا طریقہ" : "2. How We Use Your Information"),
                  sectionBody(isUrdu
                      ? "- آرڈر پروسیسنگ اور ڈیلیوری کے لیے\n"
                      "- کسٹمر سپورٹ اور ایپ کے تجربے کو بہتر بنانے کے لیے\n"
                      "- پروموشن، اپڈیٹس، اور نوٹیفکیشن بھیجنے کے لیے\n"
                      "- فراڈ کو روکنے اور سیکیورٹی یقینی بنانے کے لیے"
                      : "- To process and deliver orders\n"
                      "- To improve app experience and support\n"
                      "- To send updates, offers, and notifications\n"
                      "- To prevent fraud and ensure security"),

                  sectionTitle(isUrdu ? "3. ڈیٹا شیئرنگ اور افشاء" : "3. Data Sharing & Disclosure"),
                  sectionBody(isUrdu
                      ? "ہم آپ کی معلومات کو بیچتے یا کرائے پر نہیں دیتے۔ تاہم، ہم اسے درج ذیل کے ساتھ شیئر کر سکتے ہیں:\n"
                      "- ڈلیوری پارٹنرز (آرڈر کی تکمیل کے لیے)\n"
                      "- پیمنٹ گیٹ ویز (محفوظ ادائیگی کے لیے)\n"
                      "- قانونی ادارے (اگر قانون کا تقاضا ہو)"
                      : "We do not sell or rent your data. We may share with:\n"
                      "- Delivery partners (to fulfill orders)\n"
                      "- Payment gateways (for transactions)\n"
                      "- Legal authorities when required"),

                  sectionTitle(isUrdu ? "4. ڈیٹا سیکیورٹی" : "4. Data Security"),
                  sectionBody(isUrdu
                      ? "ہم آپ کے ڈیٹا کی حفاظت کے لیے صنعتی معیار کی سیکیورٹی تکنیکس استعمال کرتے ہیں، لیکن آن لائن ڈیٹا مکمل طور پر محفوظ نہیں ہوتا۔"
                      : "We use industry-standard practices to protect your data. While we strive for complete security, no online method is 100% secure."),

                  sectionTitle(isUrdu ? "5. آپ کے حقوق اور اختیارات" : "5. Your Rights & Choices"),
                  sectionBody(isUrdu
                      ? "- اپنی معلومات دیکھنے یا اپڈیٹ کرنے کا حق\n"
                      "- اپنا اکاؤنٹ اور ڈیٹا ڈیلیٹ کروانے کا حق\n"
                      "- پروموشنل پیغامات بند کرنے کا اختیار"
                      : "- View or update your information\n"
                      "- Request account/data deletion\n"
                      "- Opt-out of promotional messages"),

                  sectionTitle(isUrdu ? "6. بچوں کی رازداری" : "6. Children’s Privacy"),
                  sectionBody(isUrdu
                      ? "ہم 13 سال سے کم عمر بچوں سے شعوری طور پر کوئی ڈیٹا اکٹھا نہیں کرتے۔ اگر ایسا ڈیٹا ملے تو ہم فوراً اسے حذف کر دیں گے۔"
                      : "We do not knowingly collect information from children under 13. If found, we delete it immediately."),

                  sectionTitle(isUrdu ? "7. پالیسی میں تبدیلیاں" : "7. Changes to This Policy"),
                  sectionBody(isUrdu
                      ? "ہم وقتاً فوقتاً اس پالیسی میں تبدیلی کر سکتے ہیں۔ تبدیلیاں ایپ میں ظاہر کی جائیں گی۔ ایپ کا مزید استعمال ان تبدیلیوں کی منظوری سمجھا جائے گا۔"
                      : "We may update this policy. Changes will appear in the app. Continued use implies acceptance."),

                  sectionTitle(isUrdu ? "8. رابطہ کریں" : "8. Contact Us"),
                  sectionBody(isUrdu
                      ? "📧  ای میل: ${ContactUs.Email}\n 📞  فون: ${ContactUs.Phone}"
                      : "📧  Email: ${ContactUs.Email}\n 📞  Phone: ${ContactUs.Phone}"),
                  setHeight(MAIN_VERTICAL_PADDING)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
