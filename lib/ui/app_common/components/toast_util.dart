import 'package:danapaniexpress/core/common_imports.dart';

class ToastUtil {

  static void showToast(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
        Color backgroundColor = Colors.black87,
        Color textColor = Colors.white,
      }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration).then((_) => overlayEntry.remove());
  }
}
