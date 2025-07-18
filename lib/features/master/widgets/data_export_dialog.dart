import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';

class DataExportDialog extends StatefulWidget {
  final String title;
  final List<ExportOption> exportOptions;
  final List<ExportField>? availableFields;
  final Function(ExportConfig) onExport;

  const DataExportDialog({
    super.key,
    required this.title,
    required this.exportOptions,
    this.availableFields,
    required this.onExport,
  });

  @override
  State<DataExportDialog> createState() => _DataExportDialogState();
}

class _DataExportDialogState extends State<DataExportDialog> {
  ExportOption? _selectedOption;
  bool _includeHeaders = true;
  List<String> _selectedFields = [];
  final _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.exportOptions.isNotEmpty) {
      _selectedOption = widget.exportOptions.first;
    }
    if (widget.availableFields != null) {
      _selectedFields = widget.availableFields!
          .where((field) => field.isSelectedByDefault)
          .map((field) => field.key)
          .toList();
    }
    _fileNameController.text = _generateFileName();
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  String _generateFileName() {
    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return '${widget.title.toLowerCase().replaceAll(' ', '_')}_$dateStr';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.export,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export ${widget.title}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Pilih format dan konfigurasi export',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Iconsax.close_circle),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Export Format
            const Text(
              'Format Export',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.exportOptions.map((option) => RadioListTile<ExportOption>(
              title: Row(
                children: [
                  Icon(option.icon, size: 20, color: option.color),
                  const SizedBox(width: 8),
                  Text(option.label),
                ],
              ),
              subtitle: option.description != null
                  ? Text(option.description!)
                  : null,
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            )),
            const SizedBox(height: 24),

            // File Name
            const Text(
              'Nama File',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _fileNameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama file',
                suffixText: _selectedOption?.extension,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            const Text(
              'Opsi Export',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Sertakan Header Kolom'),
              subtitle: const Text('Menambahkan nama kolom di baris pertama'),
              value: _includeHeaders,
              onChanged: (value) {
                setState(() {
                  _includeHeaders = value ?? true;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),

            // Field Selection (if available)
            if (widget.availableFields != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Pilih Kolom',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: widget.availableFields!.length,
                  itemBuilder: (context, index) {
                    final field = widget.availableFields![index];
                    return CheckboxListTile(
                      title: Text(field.label),
                      subtitle: field.description != null
                          ? Text(field.description!)
                          : null,
                      value: _selectedFields.contains(field.key),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedFields.add(field.key);
                          } else {
                            _selectedFields.remove(field.key);
                          }
                        });
                      },
                      dense: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFields = widget.availableFields!
                            .map((field) => field.key)
                            .toList();
                      });
                    },
                    child: const Text('Pilih Semua'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFields.clear();
                      });
                    },
                    child: const Text('Hapus Semua'),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _canExport() ? _handleExport : null,
                  icon: const Icon(Iconsax.export, size: 16),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _canExport() {
    return _selectedOption != null &&
           _fileNameController.text.isNotEmpty &&
           (widget.availableFields == null || _selectedFields.isNotEmpty);
  }

  void _handleExport() {
    final config = ExportConfig(
      format: _selectedOption!,
      fileName: _fileNameController.text,
      includeHeaders: _includeHeaders,
      selectedFields: widget.availableFields != null ? _selectedFields : null,
    );
    
    Navigator.of(context).pop();
    widget.onExport(config);
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<ExportOption> exportOptions,
    List<ExportField>? availableFields,
    required Function(ExportConfig) onExport,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DataExportDialog(
        title: title,
        exportOptions: exportOptions,
        availableFields: availableFields,
        onExport: onExport,
      ),
    );
  }
}

class ExportOption {
  final String label;
  final String value;
  final String? description;
  final IconData icon;
  final Color color;
  final String extension;

  const ExportOption({
    required this.label,
    required this.value,
    this.description,
    required this.icon,
    required this.color,
    required this.extension,
  });
}

class ExportField {
  final String key;
  final String label;
  final String? description;
  final bool isSelectedByDefault;

  const ExportField({
    required this.key,
    required this.label,
    this.description,
    this.isSelectedByDefault = true,
  });
}

class ExportConfig {
  final ExportOption format;
  final String fileName;
  final bool includeHeaders;
  final List<String>? selectedFields;

  const ExportConfig({
    required this.format,
    required this.fileName,
    required this.includeHeaders,
    this.selectedFields,
  });
}

// Common export options
class CommonExportOptions {
  static const csv = ExportOption(
    label: 'CSV',
    value: 'csv',
    description: 'Format tabel yang dapat dibuka di Excel',
    icon: Iconsax.document_text,
    color: AppColors.success,
    extension: '.csv',
  );

  static const excel = ExportOption(
    label: 'Excel',
    value: 'xlsx',
    description: 'File Excel dengan formatting',
    icon: Iconsax.document_download,
    color: AppColors.info,
    extension: '.xlsx',
  );

  static const pdf = ExportOption(
    label: 'PDF',
    value: 'pdf',
    description: 'Dokumen PDF yang dapat dicetak',
    icon: Iconsax.document_1,
    color: AppColors.error,
    extension: '.pdf',
  );

  static List<ExportOption> get all => [csv, excel, pdf];
  static List<ExportOption> get tableFormats => [csv, excel];
  static List<ExportOption> get documentFormats => [pdf];
}