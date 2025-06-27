import 'package:barbqtonight/core/extensions/spacing_extension.dart';
import 'package:barbqtonight/core/extensions/text_style_extension.dart';
import 'package:barbqtonight/core/extensions/theme_extension.dart';
import 'package:barbqtonight/core/route_structure/go_navigator.dart';
import 'package:barbqtonight/core/route_structure/go_router.dart';
import 'package:barbqtonight/core/theme/bloc/theme_bloc.dart';
import 'package:barbqtonight/core/theme/bloc/theme_event.dart';
import 'package:barbqtonight/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool isExpanded = false;

  // _storeOnBoarding() async {
  //   await SharedPrefHelper.putInt(SharedPrefHelper.utils.onBoard, 1);
  // }

  @override
  void initState() {
    // _storeOnBoarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch.adaptive(
            activeColor: Palette.themecolor,
            inactiveThumbColor: Palette.themecolor,
            value: context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark,
            onChanged: (val) {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                  isExpanded = currentIndex == 1;
                });
              },
              controller: _pageController,
              children: const [
                CreatePage(
                  image: 'assets/images/svg/onboard-1.svg',
                  title: "Practice More",
                  subtitle:
                      "Learn more and more with your own schedule. anywhere and anytime for studying",
                  color: Palette.themecolor,
                ),
                CreatePage(
                  image: 'assets/images/svg/onboard-2.svg',
                  title: "Find a Course",
                  subtitle:
                      "Join our online educational platform and find your best courses to enjoy processing",
                  color: Palette.themecolor,
                ),
              ],
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: _buildIndicator()),
                  GestureDetector(
                    onTap: () {
                      // _storeOnBoarding();
                      // Go.namedreplace(context, 'sign-up');
                      setState(() {
                        if (currentIndex == 0) {
                          _pageController.jumpToPage(1);
                          isExpanded = true;
                        } else if (currentIndex == 1) {
                          Go.onNamedReplace(context, RouteName.loginPage);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      width: isExpanded ? 170 : 70,
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.themecolor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      duration: const Duration(milliseconds: 600),
                      child:
                          currentIndex == 1
                              ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Get Started",
                                    style: TextStyle(
                                      color: themewhitecolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  10.kW,
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: themewhitecolor,
                                  ),
                                ],
                              )
                              : const Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: themewhitecolor,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeindicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Palette.themecolor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _inactiveindicator(bool isInActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10.0,
      width: isInActive ? 20 : 8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: themegreycolor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 2; i++) {
      if (currentIndex == i) {
        indicators.add(_activeindicator(true));
      } else {
        indicators.add(_inactiveindicator(false));
      }
    }

    return indicators;
  }
}

class CreatePage extends StatelessWidget {
  final String image;
  final String title;
  final Color color;
  final String subtitle;
  const CreatePage({
    super.key,
    required this.image,
    required this.title,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 450,
            width: size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  image,
                  height: 450,
                  width: size.width / 100 * 80,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(color: color).bold,
          ),
        ),
        5.kH,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            style: context.textTheme.bodyLarge?.copyWith(color: color).w600,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
