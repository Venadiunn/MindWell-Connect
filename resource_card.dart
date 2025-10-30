import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../models/mental_health_resource.dart';
import '../providers/mental_health_state.dart';

class ResourceCard extends StatelessWidget {
  final MentalHealthResource resource;

  const ResourceCard({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(resource.name),
            subtitle: Text(resource.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    resource.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: resource.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    final provider = context.read<MentalHealthState>();
                    provider.toggleFavorite(resource);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () async {
                    final url = Uri.parse(resource.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                const Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...List.generate(5, (i) => IconButton(
                  icon: Icon(
                    i < resource.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  iconSize: 20,
                  onPressed: () {
                    final provider = context.read<MentalHealthState>();
                    provider.setRating(resource, i + 1);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}