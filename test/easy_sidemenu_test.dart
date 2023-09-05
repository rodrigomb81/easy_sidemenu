import 'package:easy_sidemenu/src/global/global.dart';
import 'package:easy_sidemenu/src/side_menu.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var globalSideMenuController = SideMenuController();
var globalSideMenuStyle = SideMenuStyle();

void main() {
  /// This is a regression test for https://github.com/Jamalianpour/easy_sidemenu/issues/46
  testWidgets(
      'When displayMode is "compact", the width is correct after building the widget twice',
      (tester) async {
    // Initialize controller
    globalSideMenuController = SideMenuController();
    globalSideMenuStyle = SideMenuStyle(
        displayMode: SideMenuDisplayMode.compact,);

    await tester.pumpWidget(const TestApp());

    final firstWidth = tester.getSize(find.byType(AnimatedContainer)).width;

    expect(firstWidth, equals(globalSideMenuStyle.compactSideMenuWidth));

    await tester.tap(find.byType(SideMenuItem));

    // Wait for navigation
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));

    // Wait for navigation, again
    await tester.pumpAndSettle();

    final secondWidth = tester.getSize(find.byType(AnimatedContainer)).width;

    expect(firstWidth, equals(secondWidth));

    // These two avoid the exception 'A Timer is still pending even after the
    // widget tree was disposed.'
    await tester.pumpWidget(const Placeholder());
    await tester.pump(const Duration(seconds: 1));
  });

  /// This is a regression test for https://github.com/Jamalianpour/easy_sidemenu/issues/46
  testWidgets(
      'When displayMode is "open", the width is correct after building the widget twice',
      (tester) async {
    // Initialize controller
    globalSideMenuController = SideMenuController();
    globalSideMenuStyle = SideMenuStyle(
        displayMode: SideMenuDisplayMode.open);

    await tester.pumpWidget(const TestApp());

    final firstWidth = tester.getSize(find.byType(AnimatedContainer)).width;

    expect(firstWidth, globalSideMenuStyle.openSideMenuWidth);

    await tester.tap(find.byType(SideMenuItem));

    // Wait for navigation
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));

    // Wait for navigation, again
    await tester.pumpAndSettle();

    final secondWidth = tester.getSize(find.byType(AnimatedContainer)).width;

    expect(firstWidth, equals(secondWidth));

    // These two avoid the exception 'A Timer is still pending even after the
    // widget tree was disposed.'
    await tester.pumpWidget(const Placeholder());
    await tester.pump(const Duration(seconds: 1));
  });
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FirstPage(),
      routes: {
        SecondPage.routeName: (context) => const SecondPage(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Page')),
      body: Stack(
        children: [
          Row(
            children: [
              SideMenu(
                controller: globalSideMenuController,
                items: [
                  SideMenuItem(
                    title: 'Go to Page 2',
                    priority: 0,
                    icon: const Icon(Icons.send),
                    onTap: (_, __) {
                      Navigator.of(context)
                          .popAndPushNamed(SecondPage.routeName);
                    },
                  )
                ],
                style: globalSideMenuStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  static const String routeName = '/second';

  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go Back'),
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/');
          },
        ),
      ),
    );
  }
}
