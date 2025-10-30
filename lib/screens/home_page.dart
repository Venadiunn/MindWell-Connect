import 'package:flutter/material.dart';
import '../screens/add_resource_page.dart';
import '../screens/recommendations_page.dart';
import '../screens/search_page.dart';
import '../screens/breathing_exercise_page.dart';
import '../widgets/resource_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const ResourceList(),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Mental Health Resources'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddResourcePage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.spa),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BreathingExercisePage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.recommend),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecommendationsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}