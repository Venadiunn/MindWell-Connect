import 'package:flutter/material.dart';
import '../models/mental_health_resource.dart';
import '../providers/mental_health_state.dart';
import 'package:provider/provider.dart';

class AddResourcePage extends StatefulWidget {
  const AddResourcePage({super.key});

  @override
  State<AddResourcePage> createState() => _AddResourcePageState();
}

class _AddResourcePageState extends State<AddResourcePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Resource')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _urlController,
              label: 'URL',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a URL';
                }
                final uri = Uri.tryParse(value!);
                if (uri == null || !uri.hasAbsolutePath) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _tagsController,
              label: 'Tags (comma-separated)',
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter at least one tag';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: const Text('Add Resource'),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final resource = MentalHealthResource(
        name: _nameController.text,
        description: _descriptionController.text,
        url: _urlController.text,
        tags: _tagsController.text
            .split(',')
            .map((tag) => tag.trim().toLowerCase())
            .where((tag) => tag.isNotEmpty)
            .toList(),
      );
      context.read<MentalHealthState>().addResource(resource);
      Navigator.pop(context);
    }
  }
}