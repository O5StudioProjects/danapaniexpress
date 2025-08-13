import 'package:danapaniexpress/core/common_imports.dart';

class BottomMessagesSection extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMore;
  final bool reachedEnd;
  final String message;
  const BottomMessagesSection({super.key, required this.isLoadingMore, required this.hasMore, required this.reachedEnd, required this.message});

  @override
  Widget build(BuildContext context) {

    // ✅ Only show when all products are scrolled & no more left
    if (!hasMore && reachedEnd) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: appText(
          text: message,
          textStyle: itemTextStyle(),
        ),
      );
    }

    // ✅ Show loading if fetching more
    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: loadingIndicator(),
      );
    }

    return SizedBox(); // nothing to show
  }
}