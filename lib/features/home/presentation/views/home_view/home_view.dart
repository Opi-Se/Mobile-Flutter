import 'package:flutter/material.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/recommendations_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: RecommendationsList(),
      ),
    );
  }
}
