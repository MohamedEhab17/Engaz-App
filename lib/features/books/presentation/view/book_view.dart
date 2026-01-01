import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/constants/app_colors.dart';
import 'package:engaz_app/core/constants/app_icons.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/utils/subjects_list.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:engaz_app/shared/data/model/book_dto.dart';
import 'package:engaz_app/features/books/data/model/grade_dto.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_cubit.dart';
import 'package:engaz_app/features/books/presentation/view_model/book/books_state.dart';
import 'package:engaz_app/features/books/presentation/widgets/custom_book_container.dart';
import 'package:engaz_app/core/widgets/custom_cupertino_pop_up.dart';
import 'package:engaz_app/core/widgets/custom_floating_action_button.dart';
import 'package:engaz_app/core/widgets/text_form_field_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookView extends StatefulWidget {
  const BookView({super.key, required this.grade});
  static const routeName = '/book';
  final GradeDto? grade;

  @override
  State<BookView> createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksCubit, CustomerState>(
      listener: (context, state) {
        if (state is GetBooksFailure) {
          Toast.error(context, state.message);
        }
        if (state is BookAddSuccess) {
          Toast.success(context, "Book added successfully".tr());
        }
        if (state is BookAddFailure) {
          Toast.error(context, state.message);
        }
        if (state is BookUpdateSuccess) {
          Toast.success(context, "Book updated successfully".tr());
        }
        if (state is BookUpdateFailure) {
          Toast.error(context, state.message);
        }
        if (state is BookDeleteSuccess) {
          Toast.success(context, "Book deleted successfully".tr());
        }
        if (state is BookDeleteFailure) {
          Toast.error(context, state.message);
        }
      },
      builder: (context, state) {
        List<BookDto> books = [];
        if (state is GetBookSuccess) {
          books = state.books;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.grade!.name.tr()),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
            padding: 16.vhPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFieldHelper(
                  isMobile: true,
                  controller: searchController,
                  action: TextInputAction.search,
                  suffixWidget: Image.asset(
                    AppIcons.iconsSearch,
                    color: AppColor.darkPrimary,
                  ),
                  hint: "search for a book or subject...".tr(),
                  onChanged: (value) {
                    context.read<BooksCubit>().searchBooks(
                      widget.grade!,
                      value ?? "",
                    );
                  },
                ),
                16.height,
                Expanded(
                  child: ListView.separated(
                    padding: 0.allPadding,
                    itemCount: books.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Skeletonizer(
                          enabled: state is GetBooksLoading,

                          child: CustoMBookContainer(
                            bookModel: books[index],
                            gradeDto: widget.grade!,
                          ),
                        ),
                    separatorBuilder: (context, index) => 16.height,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(
            toolTip: "Add New Book".tr(),
            heroTag: "add_new_book",
            onPressed: () {
              customCupertinoPopUp(
                context,
                title: "Add New Book",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Book Name".tr(),
                      style: AppTextStyles.body14(context),
                    ),
                    TextFormFieldHelper(
                      controller: nameController,
                      hint: "Book Name".tr(),
                    ),

                    6.height,
                    Text("Subject".tr(), style: AppTextStyles.body14(context)),
                    GestureDetector(
                      onTap: () async {
                        await showMenu<String>(
                          context: context,
                          color: Colors.white,
                          position: RelativeRect.fromLTRB(
                            20,
                            MediaQuery.sizeOf(context).height * 0.5 + 185,
                            20,
                            MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints.expand(
                            width: MediaQuery.sizeOf(context).width - 20,
                            height: MediaQuery.sizeOf(context).height * 0.4,
                          ),
                          items: List.generate(
                            subjects.length,
                            (index) => PopupMenuItem(
                              child: Text(
                                subjects[index].tr(),
                                style: AppTextStyles.body16(
                                  context,
                                ).copyWith(color: Colors.black),
                              ),
                              onTap: () {
                                subjectController.text = subjects[index];
                              },
                            ),
                          ),
                        );
                      },
                      child: TextFormFieldHelper(
                        controller: subjectController,
                        hint: "Subject".tr(),
                        enabled: false,
                      ),
                    ),
                    6.height,
                    Text("Price".tr(), style: AppTextStyles.body14(context)),
                    TextFormFieldHelper(
                      controller: priceController,
                      hint: "Price".tr(),
                    ),
                  ],
                ),
                buttonText: "Add".tr(),
                onPressed: () {
                  // Validate price before parsing
                  final priceText = priceController.text.trim();
                  if (priceText.isEmpty) {
                    Toast.warning(context, "Please enter price".tr());
                    return;
                  }
                  final price = double.tryParse(priceText);
                  if (price == null || price <= 0) {
                    Toast.warning(context, "Please enter a valid price".tr());
                    return;
                  }

                  if (nameController.text.trim().isEmpty) {
                    Toast.warning(context, "Please enter book name".tr());
                    return;
                  }

                  if (subjectController.text.trim().isEmpty) {
                    Toast.warning(context, "Please select subject".tr());
                    return;
                  }

                  context.read<BooksCubit>().addBook(
                    widget.grade!,
                    BookDto(
                      name: nameController.text.trim(),
                      subject: subjectController.text.trim(),
                      price: price,
                      gradeName: widget.grade!.name,
                      gradeId: widget.grade!.id,
                      addedToCart: false,
                    ),
                  );
                  nameController.clear();
                  subjectController.clear();
                  priceController.clear();
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  late TextEditingController searchController;
  late TextEditingController nameController;
  late TextEditingController subjectController;
  late TextEditingController priceController;

  @override
  initState() {
    searchController = TextEditingController();
    nameController = TextEditingController();
    subjectController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    subjectController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
