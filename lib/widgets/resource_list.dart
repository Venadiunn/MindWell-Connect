import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mental_health_state.dart';
import 'resource_card.dart';

class ResourceList extends StatefulWidget {
  const ResourceList({super.key});

  @override
  State<ResourceList> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  @override
  void initState() {
    super.initState();
    // Trigger lazy initialization after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentalHealthState>().ensureInitialized();
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialized = context.select((MentalHealthState s) => s.isInitialized);
    final resources = context.select((MentalHealthState s) => s.resources);

    if (!initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return ResourceCard(resource: resource);
      },
    );
  }
}