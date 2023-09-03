import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app.dart';

class Indicator extends StatefulWidget {
  final Widget child;

  const Indicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> with TickerProviderStateMixin{
  final _controller = IndicatorController(refreshEnabled: true);
  static const _indicatorSize = 150.0;
  bool isVisible = false;


  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return CustomRefreshIndicator(
      trigger: IndicatorTrigger.leadingEdge,
      indicatorFinalizeDuration: const Duration(milliseconds: 300),
      indicatorSettleDuration: const Duration(milliseconds: 100),
      indicatorCancelDuration: const Duration(milliseconds: 1000),
      leadingScrollIndicatorVisible: true,
      offsetToArmed: _indicatorSize,
      controller: _controller,
      onRefresh: () => Future(() => appProvider.toggleArchiveMode()),
      onStateChanged: (change) {
        if (change.didChange(from: IndicatorState.dragging, to: IndicatorState.armed)) {
          setState(() {
            isVisible = true;
          });
        } else if (isVisible) {
          setState(() {
            isVisible = false;
          });
        }
      },
      child: widget.child,
      completeStateDuration: const Duration(milliseconds: 10),
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
          return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Visibility(
                    visible: isVisible,
                    child: Container(
                      height: 100,
                      child: Column(
                        children: [
                          Icon(Icons.lock_open_rounded, size: 68),
                          Center(child: appProvider.isArchiveMode ? Text("Release to open normal page", style: TextStyle(fontSize: 20)) : Text("Release to open archive page", style: TextStyle(fontSize: 20)))
                        ]
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (ctx, _) {
                      return Transform.translate(
                        offset: Offset(
                          0.0,
                          100 * _controller.value,
                        ),
                        child: child,
                      );
                    })
                ],
              ),
            );
      },
    );
  }
}