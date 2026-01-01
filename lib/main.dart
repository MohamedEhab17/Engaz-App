import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/services/preferences_service.dart';
import 'package:engaz_app/core/theme/theme_model.dart';
import 'package:engaz_app/features/books/presentation/view/book_view.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_impl.dart';
import 'package:engaz_app/features/customers/presentation/view/customers_view.dart';
import 'package:engaz_app/features/customers/presentation/view_model/book_popup/book_popup_cubit.dart';
import 'package:engaz_app/features/customers/presentation/view_model/customer_book/customer_book_cubit.dart';
import 'package:engaz_app/features/home/view/home_view.dart';
import 'package:engaz_app/features/app_section/view/app_section.dart';
import 'package:engaz_app/core/theme/styles.dart';
import 'package:engaz_app/core/theme/theme_cubit.dart';
import 'package:engaz_app/features/app_section/view_model/bottom_navigation_bar_visibility_cubit.dart';
import 'package:engaz_app/features/reports/view/reports_view.dart';
import 'package:engaz_app/features/reservations/presentation/view_model/reservations_cubit.dart';
import 'package:engaz_app/features/reservations/presentation/view/reservations_view.dart';
import 'package:engaz_app/shared/presentation/view_model/popup_form/popup_form_cubit_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase initialization failed - app cannot function without Firebase
    // In production, consider showing an error screen or retry mechanism
    if (kDebugMode) {
      debugPrint("Firebase initialization error: $e");
    }
    rethrow;
  }
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit(PreferencesService())),
        BlocProvider(create: (context) => BottomNavigationBarVisibilityCubit()),
        BlocProvider(create: (context) => PopupFormCubit()),
        BlocProvider(
          create: (_) => CustomerBookCubit(injectableCustomerRepository()),
        ),
        BlocProvider(
          create: (_) => BookPopupCubit(injectableCustomerRepository()),
        ),
        BlocProvider(
          create: (context) => ReservationsCubit(injectableCustomerRepository())..fetchReservations(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        saveLocale: true,
        child: const EngazApp(),
      ),
    ),
  );
}

class EngazApp extends StatelessWidget {
  const EngazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeModel>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(411, 899),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'إنجاز',
            themeAnimationCurve: Curves.fastOutSlowIn,
            themeAnimationDuration: const Duration(milliseconds: 1500),
            theme: Styles.themeData(
              isDarkTheme: state.isDark,
              context: context,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: {
              AppSection.routeName: (context) => const AppSection(),
              HomeView.routeName: (context) => const HomeView(),
              BookView.routeName: (context) => const BookView(grade: null),
              CustomersView.routeName: (context) => const CustomersView(),
              ReservationsView.routeName: (context) => const ReservationsView(),
              ReportsView.routeName: (context) => const ReportsView(),
            },
            initialRoute: AppSection.routeName,
          ),
        );
      },
    );
  }
}
