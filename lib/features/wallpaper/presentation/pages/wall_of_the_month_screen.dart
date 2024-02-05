import 'package:alt__wally/core/common/widgets/wallpaper_carousel.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_cubit.dart';
import 'package:alt__wally/features/wallpaper/presentation/cubit/wall_of_the_month/wall_of_the_month_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WallOfTheMonthScreen extends StatefulWidget {
  static const String routeName = '/wall-of-the-month-screen';
  final int index;
  const WallOfTheMonthScreen({super.key, required this.index});

  @override
  State<WallOfTheMonthScreen> createState() => _WallOfTheMonthScreenState();
}

class _WallOfTheMonthScreenState extends State<WallOfTheMonthScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallOfTheMonthCubit, WallOfTheMonthState>(
      builder: (context, state) {
        if (state is WallOfTheMonthInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WallOfTheMonthLoaded) {
          return WallpaperCarousel(
              title: "Wall of the month",
              index: widget.index,
              wallpapers: state.wallpapers);
        } else if (state is WallOfTheMonthLoadingFailed) {
          return Text('Failed to load wallpapers');
        } else {
          return Container();
        }
      },
    );
  }
}
