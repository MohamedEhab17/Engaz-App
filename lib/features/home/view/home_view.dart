import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/grades_list.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/data/repo/repository/book_repository_impl.dart';
import 'package:engaz_app/features/books/presentation/view/book_view.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_cubit.dart';
import 'package:engaz_app/features/home/widgets/grade_list_tile.dart';
import 'package:engaz_app/features/app_section/view_model/bottom_navigation_bar_visibility_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String routeName = '/home';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.hPadding,
      child: ListView.separated(
        controller: scrollController,
        separatorBuilder: (context, index) => const Divider(height: 16),
        itemCount: GradeConstants.gradesList.length,
        itemBuilder: (context, index) => GradeListTile(
          title: GradeConstants.gradesList[index],
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    BlocProvider(
                  create: (_) => BooksCubit(injectableBookRepository())
                    ..fetchBooks(
                      GradeDto(
                        id: index + 1,
                        name: GradeConstants.gradesList[index],
                      ),
                    ),
                  child: BookView(
                    grade: GradeDto(
                      id: index + 1,
                      name: GradeConstants.gradesList[index],
                    ),
                  ),
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
        ),
      ),

      //  SingleChildScrollView(
      //   controller: scrollController,
      //   child: Column(
      //     children: [
      //       for (int i = 0; i < GradeConstants.gradesList.length; i++) ...{
      //         GradeListTile(
      //           title: GradeConstants.gradesList[i],
      //           onTap: () {
      //             Navigator.pushNamed(
      //               context,
      //               BookView.routeName,
      //               arguments: GradeDto(
      //                 id: i + 1,
      //                 name: GradeConstants.gradesList[i],
      //               ),
      //             );
      //           },
      //         ),
      //         i != GradeConstants.gradesList.length - 1
      //             ? const Divider(height: 16)
      //             : SizedBox.shrink(),
      //       },
      //     ],
      //   ),
      // ),
    );
  }
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      final cubit = context.read<BottomNavigationBarVisibilityCubit>();
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        cubit.hide();
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        cubit.show();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

}
