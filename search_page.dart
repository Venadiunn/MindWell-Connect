import 'package:flutter/material.dart';
import '../providers/mental_health_state.dart';
import 'package:provider/provider.dart';
import '../widgets/resource_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<String> _selectedTags = [];
  String? _selectedCategory;
  String? _selectedType;
  String? _selectedUrgency;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.watch<MentalHealthState>().resources;
    final categories = resources.map((r) => r.category).toSet().where((c) => c.isNotEmpty).toList();
    final types = resources.map((r) => r.type).toSet().where((t) => t.isNotEmpty).toList();
    final urgencies = resources.map((r) => r.urgency).toSet().where((u) => u.isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Search Resources')),
      body: Column(
        children: [
          _buildSearchField(),
          _buildTagList(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: _buildDropdown('Category', categories, _selectedCategory, (val) {
                  setState(() => _selectedCategory = val);
                })),
                const SizedBox(width: 8),
                Expanded(child: _buildDropdown('Type', types, _selectedType, (val) {
                  setState(() => _selectedType = val);
                })),
                const SizedBox(width: 8),
                Expanded(child: _buildDropdown('Urgency', urgencies, _selectedUrgency, (val) {
                  setState(() => _selectedUrgency = val);
                })),
              ],
            ),
          ),
          _buildSearchResults(resources),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search by tags',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _selectedTags = value
                .split(',')
                .map((tag) => tag.trim().toLowerCase())
                .where((tag) => tag.isNotEmpty)
                .toList();
          });
        },
      ),
    );
  }

  Widget _buildTagList() {
  final allTags = context.select((MentalHealthState state) => state.allTags);

    return Wrap(
      spacing: 8.0,
      children: allTags.map((tag) {
        return FilterChip(
          label: Text(tag),
          selected: _selectedTags.contains(tag),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTags.add(tag);
              } else {
                _selectedTags.remove(tag);
              }
              _searchController.text = _selectedTags.join(', ');
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchResults(List resources) {
    final filteredResources = resources.where((resource) {
      final matchesTags = _selectedTags.isEmpty || resource.tags.any((tag) => _selectedTags.contains(tag));
      final matchesCategory = _selectedCategory == null || _selectedCategory!.isEmpty || resource.category == _selectedCategory;
      final matchesType = _selectedType == null || _selectedType!.isEmpty || resource.type == _selectedType;
      final matchesUrgency = _selectedUrgency == null || _selectedUrgency!.isEmpty || resource.urgency == _selectedUrgency;
      return matchesTags && matchesCategory && matchesType && matchesUrgency;
    }).toList();
    return Expanded(
      child: ListView.builder(
        itemCount: filteredResources.length,
        itemBuilder: (context, index) {
          return ResourceCard(resource: filteredResources[index]);
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selected, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      initialValue: selected,
      items: [
        const DropdownMenuItem<String>(value: '', child: Text('Any')),
        ...items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))),
      ],
      onChanged: onChanged,
    );
  }
}