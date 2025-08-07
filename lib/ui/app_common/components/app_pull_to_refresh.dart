import 'package:danapaniexpress/core/common_imports.dart';

import '../../../core/packages_import.dart';

class AppPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppPullToRefresh({super.key, required this.child, required this.onRefresh});

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> with SingleTickerProviderStateMixin {
  double pullDistance = 0.0;
  bool isRefreshing = false;
  late AnimationController _animationController;

  static const double triggerPullDistance = 100;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleRefresh() async {
    setState(() => isRefreshing = true);
    await widget.onRefresh();
    setState(() {
      pullDistance = 0;
      isRefreshing = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification && !isRefreshing) {
          setState(() {
            pullDistance += notification.overscroll / 2;
          });

          if (pullDistance >= triggerPullDistance) {
            _handleRefresh();
          }
        }

        if (notification is ScrollEndNotification && !isRefreshing) {
          if (pullDistance < triggerPullDistance) {
            _animationController.forward(from: 0).then((_) {
              setState(() => pullDistance = 0);
            });
          }
        }

        return false;
      },
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, pullDistance.clamp(0, 100)),
            child: widget.child,
          ),
          if (pullDistance > 0)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: isRefreshing
                    ? Lottie.asset(
                  AppAnims.animLoading2Skin(isDark).toString(),
                  width: 50,
                  height: 50,
                  repeat: true,
                )
                    : const Icon(Icons.arrow_downward),
              ),
            ),
        ],
      ),
    );
  }
}
