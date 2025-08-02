import 'package:danapaniexpress/core/common_imports.dart';
import 'package:danapaniexpress/domain/controllers/terms_conditions_controller/terms_conditions_controller.dart';

class TermsConditionsMobile extends StatelessWidget {
  const TermsConditionsMobile({super.key});

  bool get isUrdu => appLanguage == URDU_LANGUAGE;

  @override
  Widget build(BuildContext context) {
    var terms = Get.find<TermsConditionsController>();
    var isStart = Get.arguments[IS_START] as bool;
    return Obx(
      ()=> Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundColorSkin(isDark),
        child: Column(
          children: [
            appBarCommon(
              title: AppLanguage.termsConditionsStr(appLanguage),
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
                        ? "📜 شرائط و ضوابط – دانا پانی ایکسپریس"
                        : "📜 Terms & Conditions – Dana Pani Express"),

                    sectionBody(isUrdu
                        ? "یہ شرائط و ضوابط آپ کی دانا پانی ایکسپریس موبائل ایپ اور سروسز کے استعمال کو کنٹرول کرتی ہیں۔ ایپ کا استعمال کرتے ہوئے، آپ ان شرائط سے اتفاق کرتے ہیں۔"
                        : "These Terms & Conditions govern your use of the Dana Pani Express mobile app and services. By using our app, you agree to these Terms."),

                    sectionTitle(isUrdu ? "1. شرائط کی قبولیت" : "1. Acceptance of Terms"),
                    sectionBody(isUrdu
                        ? "- آپ کی عمر کم از کم 18 سال ہونی چاہیے\n- آپ ان شرائط اور پرائیویسی پالیسی سے متفق ہوں\n- آپ کو قانونی طور پر معاہدہ کرنے کا اختیار حاصل ہو"
                        : "- You must be at least 18 years old\n- You agree to these Terms and our Privacy Policy\n- You have the legal capacity to enter a binding agreement"),

                    sectionTitle(isUrdu ? "2. سروس کا خلاصہ" : "2. Service Overview"),
                    sectionBody(isUrdu
                        ? "دانا پانی ایکسپریس آن لائن گروسری سروس فراہم کرتا ہے جو مخصوص علاقوں میں ڈیلیوری فراہم کرتا ہے۔ دستیابی اور قیمتیں مختلف ہو سکتی ہیں۔"
                        : "Dana Pani Express offers online grocery delivery services within selected areas. Availability and prices may vary."),

                    sectionTitle(isUrdu ? "3. اکاؤنٹ رجسٹریشن" : "3. Account Registration"),
                    sectionBody(isUrdu
                        ? "- درست معلومات دینا ضروری ہے\n- پاس ورڈ کی حفاظت آپ کی ذمہ داری ہے\n- ہم کسی غیر مجاز رسائی کے ذمہ دار نہیں"
                        : "- You must provide accurate information\n- You are responsible for protecting your password\n- We are not liable for unauthorized access"),

                    sectionTitle(isUrdu ? "4. آرڈرز اور ادائیگیاں" : "4. Orders & Payments"),
                    sectionBody(isUrdu
                        ? "- آرڈر کنفرم ہونے کے بعد تبدیل یا منسوخ نہیں ہو سکتا\n- قیمتیں PKR میں ہیں اور بغیر اطلاع کے تبدیل ہو سکتی ہیں\n- ادائیگیاں محفوظ گیٹ وے کے ذریعے ہوں گی"
                        : "- Orders cannot be changed or canceled after confirmation\n- Prices are in PKR and may change without notice\n- Payments are processed securely"),

                    sectionTitle(isUrdu ? "5. ڈیلیوری پالیسی" : "5. Delivery Policy"),
                    sectionBody(isUrdu
                        ? "- دی گئی وقت کا تخمینہ ہوتا ہے، گارنٹی نہیں\n- صارف کی غیر موجودگی میں ڈیلیوری ملتوی یا منسوخ ہو سکتی ہے\n- چارجز علاقے اور آرڈر پر منحصر ہوں گے"
                        : "- Delivery time is estimated, not guaranteed\n- If unavailable, your delivery may be rescheduled or canceled\n- Charges depend on location and order value"),

                    sectionTitle(isUrdu ? "6. ریٹرن اور ریفنڈ" : "6. Returns & Refunds"),
                    sectionBody(isUrdu
                        ? "- خراب یا ایکسپائر اشیاء ہی واپس یا تبدیل ہو سکتی ہیں\n- 24 گھنٹے میں شکایت کے ساتھ ثبوت دینا ضروری ہے\n- ریفنڈ 5–7 دن میں مکمل ہو گا"
                        : "- Only damaged or expired items are returnable\n- Contact support within 24 hours with proof\n- Refunds (if approved) will be issued in 5–7 working days"),

                    sectionTitle(isUrdu ? "7. صارف کا رویہ" : "7. User Conduct"),
                    sectionBody(isUrdu
                        ? "آپ کو غیر قانونی یا گمراہ کن سرگرمیوں سے باز رہنا ہوگا۔ جعلی معلومات، ایپ کے ساتھ چھیڑ چھاڑ یا فراڈ ممنوع ہے۔"
                        : "You must not use the app for illegal or misleading activity. Providing false info or tampering with the system is prohibited."),

                    sectionTitle(isUrdu ? "8. اکاؤنٹ معطلی اور اختتام" : "8. Suspension & Termination"),
                    sectionBody(isUrdu
                        ? "ہم آپ کا اکاؤنٹ کسی بھی وقت بند یا معطل کر سکتے ہیں اگر آپ ان شرائط کی خلاف ورزی کریں۔"
                        : "We may suspend or terminate your account at any time if you violate these Terms."),

                    sectionTitle(isUrdu ? "9. دانشورانہ ملکیت" : "9. Intellectual Property"),
                    sectionBody(isUrdu
                        ? "ایپ میں موجود تمام لوگوز، مواد اور ڈیزائن دانا پانی ایکسپریس کی ملکیت ہیں۔ بغیر اجازت استعمال ممنوع ہے۔"
                        : "All logos, content, and designs in the app belong to Dana Pani Express. Unauthorized use is prohibited."),

                    sectionTitle(isUrdu ? "10. ذمہ داری کی حد" : "10. Limitation of Liability"),
                    sectionBody(isUrdu
                        ? "ہم قدرتی آفات یا تیسری پارٹی کی خرابیوں کی وجہ سے ہونے والے نقصان کے ذمہ دار نہیں۔"
                        : "We are not liable for any damages due to natural disasters or third-party service failures."),

                    sectionTitle(isUrdu ? "11. شرائط میں تبدیلیاں" : "11. Changes to Terms"),
                    sectionBody(isUrdu
                        ? "ہم وقتاً فوقتاً ان شرائط کو اپڈیٹ کر سکتے ہیں۔ ایپ کا استعمال جاری رکھنے کا مطلب ان سے اتفاق ہے۔"
                        : "We may update these Terms at any time. Continued use means you accept the updated Terms."),

                    sectionTitle(isUrdu ? "12. ہم سے رابطہ کریں" : "12. Contact Us"),
                    sectionBody(isUrdu
                        ? "📧  ای میل: ${ContactUs.Email}\n 📞  فون: ${ContactUs.Phone}"
                        : "📧  Email: ${ContactUs.Email}\n 📞  Phone: ${ContactUs.Phone}"),
                    setHeight(MAIN_VERTICAL_PADDING),
                    isStart
                    ? Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          child: GestureDetector(
                            onTap: (){
                              terms.acceptTerms.value =  !terms.acceptTerms.value;
                            },
                            child: Row(
                              children: [
                                appIcon(iconType: IconType.SVG,
                                    icon: terms.acceptTerms.value ? icRadioButtonSelected :icRadioButton,
                                    color: AppColors.materialButtonSkin(isDark)),
                                setWidth(8.0),
                                Expanded(child: appText(text: 'I have read and accept the terms of services.',
                                    maxLines: 2,
                                    textStyle: bodyTextStyle())),
                              ],
                            ),
                          ),
                        ),
                        setHeight(MAIN_VERTICAL_PADDING),
                        Row(
                          children: [
                            Expanded(child: appMaterialButton(text: 'Decline', onTap: (){
                             SystemNavigator.pop();
                            })),
                            setWidth(MAIN_HORIZONTAL_PADDING),
                            Expanded(
                                child:
                                    terms.acceptTermsStatus.value == Status.LOADING
                                ? loadingIndicator()
                                : appMaterialButton(text: 'Continue', isDisable: !terms.acceptTerms.value, onTap: () async {
                              if(terms.acceptTerms.value){
                                terms.onTapContinue();
                              }
                            })),
                          ],
                        ),
                        setHeight(MAIN_VERTICAL_PADDING)
                      ],
                    )
                        : SizedBox.shrink()


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
