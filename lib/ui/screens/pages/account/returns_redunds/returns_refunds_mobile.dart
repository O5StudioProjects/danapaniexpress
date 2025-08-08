import 'package:danapaniexpress/core/common_imports.dart';


class ReturnsRefundsMobile extends StatelessWidget {
  const ReturnsRefundsMobile({super.key});

  bool get isUrdu => isRightLang;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.backgroundColorSkin(isDark),
      child: Column(
        children: [
          appBarCommon(
            title: AppLanguage.returnsRefundsStr(appLanguage),
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
                      ? "🔁 ریٹرن اور ریفنڈ پالیسی – دانا پانی ایکسپریس"
                      : "🔁 Returns & Refunds Policy – Dana Pani Express"),

                  sectionTitle(isUrdu ? "1. تعارف" : "1. Overview"),
                  sectionBody(isUrdu
                      ? "دانا پانی ایکسپریس میں، ہم صارفین کو بہترین خدمات فراہم کرنے کی کوشش کرتے ہیں۔ اگر آپ کے آرڈر میں کوئی مسئلہ ہو، تو ہم مدد کے لیے حاضر ہیں۔"
                      : "At Dana Pani Express, we strive to ensure that your grocery shopping experience is smooth and satisfactory. However, if there is any issue with your order, we are here to help."),

                  sectionTitle(isUrdu ? "2. واپسی کے اہل اشیاء" : "2. Return Eligibility"),
                  sectionBody(isUrdu
                      ? "- صرف وہ اشیاء واپس کی جا سکتی ہیں جو خراب، زائد المیعاد، یا غلط ڈیلیور کی گئی ہوں۔\n- شکایت ڈیلیوری کے 24 گھنٹوں کے اندر، تصویر یا ویڈیو ثبوت کے ساتھ دی جائے۔"
                      : "- Only perishable items that are damaged, expired, or incorrect at the time of delivery are eligible for return.\n- Items must be reported within 24 hours of delivery along with photo or video proof."),

                  sectionTitle(isUrdu ? "3. ناقابل واپسی اشیاء" : "3. Non-Returnable Items"),
                  sectionBody(isUrdu
                      ? "- تازہ سبزیاں، پھل، دودھ، یا فریز شدہ اشیاء واپس نہیں کی جا سکتیں جب تک کہ وہ خراب یا غلط نہ ہوں۔\n- استعمال شدہ یا کھولی گئی اشیاء کی واپسی نہیں ہوگی۔"
                      : "- Fresh items such as vegetables, fruits, dairy, and frozen products cannot be returned unless they are spoiled or delivered incorrectly.\n- Items opened or used after delivery are not eligible."),

                  sectionTitle(isUrdu ? "4. ریفنڈ کا عمل" : "4. Refund Process"),
                  sectionBody(isUrdu
                      ? "- واپسی کی منظوری کے بعد، رقم آپ کے اصل ادائیگی کے طریقے یا دانا پانی والٹ میں منتقل کر دی جائے گی۔\n- ریفنڈ کی تکمیل 5–7 کاروباری دنوں میں ہو گی۔"
                      : "- Once your return request is approved, we will initiate a refund to your original payment method or Dana Pani Express wallet.\n- Refunds are processed within 5–7 business days."),

                  sectionTitle(isUrdu ? "5. آرڈر منسوخی" : "5. Order Cancellations"),
                  sectionBody(isUrdu
                      ? "- آرڈر پیک ہونے یا ڈیلیوری پر جانے کے بعد منسوخ نہیں کیا جا سکتا۔\n- کسی شاذ و نادر صورت میں، اگر ہم آرڈر منسوخ کرتے ہیں، تو مکمل ریفنڈ جاری کیا جائے گا۔"
                      : "- Orders cannot be canceled once they are packed or out for delivery.\n- In rare cases, we may cancel an order due to unavailability or unforeseen circumstances. A full refund will be issued in such cases."),

                  sectionTitle(isUrdu ? "6. سپورٹ سے رابطہ" : "6. Contact Support"),
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
