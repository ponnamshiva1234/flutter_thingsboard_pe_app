import 'package:flutter/material.dart';
import 'package:thingsboard_app/core/context/tb_context.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/modules/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:thingsboard_app/modules/dashboard/presentation/controller/dashboard_page_controller.dart';
import 'package:thingsboard_app/modules/dashboard/presentation/widgets/dashboard_widget.dart';
import 'package:thingsboard_app/utils/services/endpoint/i_endpoint_service.dart';
import 'package:thingsboard_app/widgets/tb_app_bar.dart';

class MainDashboardPage extends TbContextWidget {
  MainDashboardPage(
      TbContext tbContext, {
        required this.controller,
        super.key,
      }) : super(tbContext);

  final DashboardPageController controller;

  @override
  State<StatefulWidget> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends TbContextState<MainDashboardPage>
    with TickerProviderStateMixin {
  final dashboardTitleValue = ValueNotifier('Dashboard');
  final hasRightLayout = ValueNotifier(false);

  late final Animation<double> rightLayoutMenuAnimation;
  late final AnimationController rightLayoutMenuController;

  DashboardController? _dashboardController;
  ValueNotifier<bool>? _dashboardLoadingCtrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TbAppBar(
        tbContext,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        showLoadingIndicator: false,
        elevation: 1,
        shadowColor: Colors.transparent,
        title: ValueListenableBuilder<String>(
          valueListenable: dashboardTitleValue,
          builder: (context, title, widget) {
            return FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.centerLeft,
              child: Text(title),
            );
          },
        ),
        canGoBack: true,
      ),
      drawer: _buildDrawer(),
      body: ValueListenableBuilder<String?>(
        valueListenable: getIt<IEndpointService>().listenEndpointChanges,
        builder: (context, value, _) {
          return SafeArea(
            bottom: false,
            child: DashboardWidget(
              tbContext,
              titleCallback: (title) {
                dashboardTitleValue.value = title;
              },
              pageController: widget.controller,
              controllerCallback: (controller, loadingCtrl) {
                _dashboardController = controller;
                _dashboardLoadingCtrl = loadingCtrl;
                widget.controller.setDashboardController(controller);

                controller.hasRightLayout.addListener(() {
                  hasRightLayout.value = controller.hasRightLayout.value;
                });
                controller.rightLayoutOpened.addListener(() {
                  if (controller.rightLayoutOpened.value) {
                    rightLayoutMenuController.forward();
                  } else {
                    rightLayoutMenuController.reverse();
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Text(
                'Dashboard Menu',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard Home'),
            onTap: () {
              Navigator.pop(context);
              // Handle Dashboard home navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Handle Settings navigation
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: hasRightLayout,
            builder: (context, hasRightLayout, widget) {
              if (hasRightLayout) {
                return ListTile(
                  leading: const Icon(Icons.menu_open),
                  title: const Text('Toggle Right Layout'),
                  onTap: () {
                    Navigator.pop(context);
                    _dashboardController?.toggleRightLayout();
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    rightLayoutMenuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    rightLayoutMenuAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: rightLayoutMenuController,
    );

    widget.controller.setDashboardTitleNotifier(dashboardTitleValue);
  }

  @override
  void dispose() {
    rightLayoutMenuController.dispose();
    dashboardTitleValue.dispose();
    hasRightLayout.dispose();
    super.dispose();
  }
}