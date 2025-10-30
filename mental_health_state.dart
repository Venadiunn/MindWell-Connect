import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/mental_health_resource.dart';

class MentalHealthState extends ChangeNotifier {
  void toggleFavorite(MentalHealthResource resource) {
    resource.isFavorite = !resource.isFavorite;
    notifyListeners();
  }

  void setRating(MentalHealthResource resource, int rating) {
    resource.rating = rating;
    notifyListeners();
  }
  final List<MentalHealthResource> _resources = [];
  bool _initialized = false;

  MentalHealthState();

  bool get isInitialized => _initialized;

  /// Ensure resources are loaded. This loads from assets/resources.json on first call.
  Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      final jsonString = await rootBundle.loadString('assets/resources.json');
      final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
      _resources.addAll(data.map((e) {
        final map = e as Map<String, dynamic>;
        final tags = (map['tags'] as List<dynamic>?)
                ?.map((t) => t.toString())
                .toList() ??
            <String>[];
        return MentalHealthResource(
          name: map['name']?.toString() ?? '',
          description: map['description']?.toString() ?? '',
          url: map['url']?.toString() ?? '',
          tags: tags,
          category: map['category']?.toString() ?? '',
          type: map['type']?.toString() ?? '',
          urgency: map['urgency']?.toString() ?? '',
        );
      }));
    } catch (e) {
      // If loading/parsing asset fails, fall back to a small built-in set
      _resources.addAll([
        MentalHealthResource(
          name: 'Crisis Text Line',
          description: '24/7 text-based support',
          url: 'https://www.crisistextline.org',
          tags: ['crisis', 'depression', 'anxiety'],
        ),
        MentalHealthResource(
          name: 'NAMI',
          description: 'National Alliance on Mental Illness',
          url: 'https://www.nami.org',
          tags: ['education', 'support', 'community'],
        ),
      ]);
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  List<MentalHealthResource> get resources => List.unmodifiable(_resources);
  
    List<MentalHealthResource> get recommendedResources {
      // For now, return the first 3 resources as recommendations
      return _resources.take(3).toList();
    }

  List<String> get allTags => _resources
      .expand((resource) => resource.tags)
      .toSet()
      .toList();

  void addResource(MentalHealthResource resource) {
    _resources.add(resource);
    notifyListeners();
  }

  List<MentalHealthResource> getResourcesByTags(List<String> tags) {
    if (tags.isEmpty) return resources;

    return _resources.where((resource) {
      return resource.tags.any((tag) => tags.contains(tag));
    }).toList();
  }
}