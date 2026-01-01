import 'package:easy_localization/easy_localization.dart';
import 'package:engaz_app/core/theme/app_text_styles.dart';
import 'package:engaz_app/core/utils/extensions.dart';
import 'package:engaz_app/core/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:engaz_app/features/app_section/view_model/bottom_navigation_bar_visibility_cubit.dart';
import 'package:engaz_app/features/customers/data/repo/repository/customer_repository_impl.dart';
import 'package:engaz_app/features/reservations/data/model/reservation_row_dto.dart';
import 'package:engaz_app/features/reservations/presentation/view_model/reservations_cubit.dart';
import 'package:engaz_app/features/reservations/presentation/view_model/reservations_state.dart';
import 'package:engaz_app/features/reservations/presentation/widgets/reservation_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({super.key});
  static String routeName = '/reservations';

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final cubit = context.read<BottomNavigationBarVisibilityCubit>();
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        cubit.hide();
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        cubit.show();
      }
    });

    // Fetch reservations when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationsCubit>().fetchReservations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReservationsCubit(injectableCustomerRepository())
            ..fetchReservations(),
      child: BlocListener<ReservationsCubit, ReservationsState>(
        listener: (context, state) {
          if (state is ReservationsError) {
            Toast.error(context, state.message);
          }
          if (state is ReservationFinalized) {
            Toast.success(context, "Reservation finalized successfully".tr());
          }
          if (state is ReservationFinalizeError) {
            Toast.error(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Builder(
                builder: (context) {
                  return TabBar(
                    controller: _tabController,

                    tabs: [
                      Tab(text: "Not Ready".tr()),
                      Tab(text: "Ready".tr()),
                    ],
                  );
                },
              ),
            ),
          ),
          body: BlocBuilder<ReservationsCubit, ReservationsState>(
            builder: (context, state) {
              if (state is ReservationsLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    padding: 16.allPadding,
                    itemCount: 5,
                    itemBuilder: (_, index) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is ReservationsLoaded) {
                final reservations = _tabController.index == 0
                    ? state.notReadyReservations
                    : state.readyReservations;

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReservationsList(state.notReadyReservations, false),
                    _buildReservationsList(state.readyReservations, true),
                  ],
                );
              }

              return Center(
                child: Text(
                  "Failed to load reservations".tr(),
                  style: AppTextStyles.body16(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsList(
    List<ReservationRowDto> reservations,
    bool isReady,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: 16.allPadding,
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        return ReservationRowItem(
          reservation: reservations[index],
          isReady: isReady,
          onFinalize: () {
            if (reservations[index].bookId != null) {
              context.read<ReservationsCubit>().finalizeReservation(
                reservations[index].bookId!,
              );
            }
          },
          // onDelete: () {
          //   _showDeleteConfirmation(context, reservations[index]);
          // },
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ReservationRowDto reservation,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Reservation".tr()),
        content: Text(
          "Are you sure you want to delete this reservation? This action cannot be undone."
              .tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (reservation.bookId != null) {
                context.read<ReservationsCubit>().deleteReservation(
                  reservation.bookId!,
                );
                Toast.success(context, "Reservation deleted successfully".tr());
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text("Delete".tr()),
          ),
        ],
      ),
    );
  }
}
