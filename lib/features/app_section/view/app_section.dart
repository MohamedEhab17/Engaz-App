import 'package:engaz_app/core/constants/app_icons.dart';
import 'package:engaz_app/core/constants/app_images.dart';
import 'package:engaz_app/core/theme/theme_cubit.dart';
import 'package:engaz_app/core/theme/theme_model.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_impl.dart';
import 'package:engaz_app/features/customers/presentation/view/customers_view.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer/customer_cubit.dart';
import 'package:engaz_app/features/reservations/presentation/view/reservations_view.dart';
import 'package:engaz_app/core/widgets/switch_button_widget.dart';
import 'package:engaz_app/features/home/view/home_view.dart';
import 'package:engaz_app/features/app_section/view_model/bottom_navigation_bar_cubit.dart';
import 'package:engaz_app/features/app_section/view_model/bottom_navigation_bar_visibility_cubit.dart';
import 'package:engaz_app/features/app_section/view_model/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSection extends StatefulWidget {
  const AppSection({super.key});
  static const routeName = "/app_section";

  @override
  State<AppSection> createState() => _AppSectionsState();
}

class _AppSectionsState extends State<AppSection> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleCubit(),
      child: BlocProvider(
        create: (context) => BottomNavigationBarCubit(),
        child: BlocBuilder<ThemeCubit, ThemeModel>(
          builder: (context, state) {
            return BlocBuilder<BottomNavigationBarCubit, int>(
              builder: (context, indexCubit) {
                return Scaffold(
                  appBar: AppBar(
                    leading: Image.asset(
                      AppImages.imagesLogo,
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    ),

                    actions: [
                      SwitchButtonWidget(
                        checked: state.isDark,
                        onChanged: (val) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeThumbImage: AppIcons.iconsDarkMode,
                        inactiveThumbImage: AppIcons.iconsLightMode,
                      ),
                      const SizedBox(width: 10),
                      BlocConsumer<LocaleCubit, String>(
                        listener: (context, state) {
                          if (state == 'ar') {
                            context.setLocale(const Locale('ar'));
                          } else {
                            context.setLocale(const Locale('en'));
                          }
                        },
                        builder: (context, state) {
                          return SwitchButtonWidget(
                            checked: state == 'en',
                            onChanged: (val) {
                              context.read<LocaleCubit>().toggleLanguage();
                            },
                            activeThumbImage: AppIcons.iconsTranslation,
                            inactiveThumbImage: AppIcons.iconsTranslation,
                          );
                        },
                      ),
                    ],
                  ),
                  body: PageView(
                    controller: pageController,
                    children: screens,
                    onPageChanged: (index) {
                      context.read<BottomNavigationBarCubit>().changeTab(index);
                    },
                  ),
                  bottomNavigationBar:
                      BlocBuilder<BottomNavigationBarVisibilityCubit, bool>(
                        builder: (context, isVisible) {
                          return Visibility(
                            visible: isVisible,
                            child: Padding(
                              padding: 10.bottomPadding,
                              child: NavigationBar(
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                elevation: 2,
                                height: kBottomNavigationBarHeight,
                                selectedIndex: context
                                    .watch<BottomNavigationBarCubit>()
                                    .state,
                                onDestinationSelected: (index) {
                                  context
                                      .read<BottomNavigationBarCubit>()
                                      .changeTab(index);
                                  pageController.animateToPage(
                                    index,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeOutBack,
                                  );
                                },
                                destinations: [
                                  NavigationDestination(
                                    selectedIcon: Icon(IconlyBold.bookmark),
                                    icon: Icon(IconlyLight.bookmark),
                                    label: "Books".tr(),
                                  ),
                                  NavigationDestination(
                                    selectedIcon: Icon(IconlyBold.user3),
                                    icon: Icon(IconlyLight.user3),
                                    label: "Customers".tr(),
                                  ),
                                  NavigationDestination(
                                    selectedIcon: Icon(IconlyBold.document),
                                    icon: Icon(IconlyLight.document),
                                    label: "Reservations".tr(),
                                  ),
                                  // NavigationDestination(
                                  //   //levels
                                  //   selectedIcon: Icon(IconlyBold.chart),
                                  //   icon: Icon(IconlyLight.chart),
                                  //   label: "Reports".tr(),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  late PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> screens = [
    HomeView(),
    BlocProvider(
      create: (context) =>
          CustomerCubit(injectableCustomerRepository())..fetchCustomers(),
      child: CustomersView(),
    ),
    ReservationsView(),
    // ReportsView(),
  ];
}
