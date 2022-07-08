import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade/UIs/custom_navigation_bar.dart';
import 'package:trade/colors.dart';
import 'package:trade/custom_icons_icons.dart';
import 'package:trade/pages/exchanges_page.dart';
import 'package:trade/pages/home_page.dart';
import 'package:trade/pages/profile_page.dart';
import 'package:trade/providers/provider_page_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  double? splashHeight;
  Alignment alignment = Alignment.center;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(seconds: 1),
      ).then((value) => changeSplash()),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = Provider.of<ProviderPageController>(context).selectedPage;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onTappedBar(_selectedIndex);
    });
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              splahScreen(),
              body(),
              CustomBottomNavigationBar(
                bottomNavBarItems: [
                  BottomNavBarItem(text: "Home", iconData: CustomIcons.home),
                  BottomNavBarItem(
                      text: "Exchanges",
                      iconData: Icons.change_circle_outlined),
                  BottomNavBarItem(text: "Profile", iconData: CustomIcons.user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget splahScreen() {
    return AnimatedContainer(
      alignment: alignment,
      duration: const Duration(milliseconds: 1400),
      width: double.maxFinite,
      height: splashHeight ?? MediaQuery.of(context).size.height,
      color: color1,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          "Exchanger",
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget body() {
    return SizedBox(
      height: (MediaQuery.of(context).size.height -
          kBottomNavigationBarHeight -
          kToolbarHeight -
          MediaQuery.of(context).padding.top -
          8),
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[HomePage(), ExchangesPage(), ProfilePage()],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: color1,
      elevation: 10,
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.grey,
      onTap: _onTappedBar,
      items: const [
        BottomNavigationBarItem(icon: Icon(CustomIcons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.change_circle_outlined), label: "Exchanges"),
        BottomNavigationBarItem(icon: Icon(CustomIcons.user), label: "Profile"),
      ],
    );
  }

  Text textTrader() {
    return const Text("Exchanger",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600));
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  void changeSplash() {
    setState(() {
      alignment = Alignment.centerLeft;
      splashHeight = kToolbarHeight;
    });
  }
}
