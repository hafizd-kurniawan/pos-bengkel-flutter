import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/core/utils/currency_formatter.dart';
import 'package:pos_bengkel/core/utils/date_formatter.dart';
import 'package:pos_bengkel/features/servis/providers/reconditioning_provider.dart';
import 'package:pos_bengkel/shared/models/reconditioning.dart';

class ReconditioningScreen extends StatefulWidget {
  const ReconditioningScreen({super.key});

  @override
  State<ReconditioningScreen> createState() => _ReconditioningScreenState();
}

class _ReconditioningScreenState extends State<ReconditioningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReconditioningProvider>().loadAllReconditioningJobs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rekondisi Kendaraan'),
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Iconsax.add_circle),
              text: 'Buat Job',
            ),
            Tab(
              icon: Icon(Iconsax.task),
              text: 'Daftar Job',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CreateReconditioningTab(),
          _ReconditioningListTab(),
        ],
      ),
    );
  }
}

class _CreateReconditioningTab extends StatefulWidget {
  const _CreateReconditioningTab();

  @override
  _CreateReconditioningTabState createState() => _CreateReconditioningTabState();
}

class _CreateReconditioningTabState extends State<_CreateReconditioningTab> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _estimatedCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReconditioningProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVehicleSelection(provider),
                const SizedBox(height: 16),
                _buildInvoiceNumberField(provider),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildEstimatedCostField(),
                const SizedBox(height: 16),
                _buildNotesField(),
                const SizedBox(height: 24),
                _buildCreateButton(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVehicleSelection(ReconditioningProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kendaraan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.selectedVehicleId,
              isExpanded: true,
              hint: const Text('Pilih kendaraan untuk direkondisi'),
              items: provider.availableVehicles.map((vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle.vehicleId,
                  child: Text(vehicle.displayName),
                );
              }).toList(),
              onChanged: (String? vehicleId) {
                provider.setSelectedVehicleId(vehicleId);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceNumberField(ReconditioningProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nomor Invoice',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Iconsax.document_text, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                provider.invoiceNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi Pekerjaan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Jelaskan pekerjaan rekondisi yang akan dilakukan',
            prefixIcon: const Icon(Iconsax.note_text),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            context.read<ReconditioningProvider>().setDescription(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Deskripsi pekerjaan wajib diisi';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEstimatedCostField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimasi Biaya',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _estimatedCostController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Masukkan estimasi biaya rekondisi',
            prefixIcon: const Icon(Iconsax.money_add),
            prefixText: 'Rp ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            final cost = double.tryParse(value) ?? 0;
            context.read<ReconditioningProvider>().setEstimatedCost(cost);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Estimasi biaya wajib diisi';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Estimasi biaya harus berupa angka positif';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Catatan tambahan (opsional)',
            prefixIcon: const Icon(Iconsax.note),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            context.read<ReconditioningProvider>().setNotes(value);
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton(ReconditioningProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: provider.canCreateJob ? () => _createJob() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Buat Job Rekondisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _createJob() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ReconditioningProvider>();
    final success = await provider.createReconditioningJob();

    if (success) {
      // Clear form
      _descriptionController.clear();
      _estimatedCostController.clear();
      _notesController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job rekondisi berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal membuat job rekondisi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ReconditioningListTab extends StatefulWidget {
  const _ReconditioningListTab();

  @override
  _ReconditioningListTabState createState() => _ReconditioningListTabState();
}

class _ReconditioningListTabState extends State<_ReconditioningListTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReconditioningProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.jobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.task, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'Belum ada job rekondisi',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.jobs.length,
          itemBuilder: (context, index) {
            final job = provider.jobs[index];
            return _buildJobCard(job);
          },
        );
      },
    );
  }

  Widget _buildJobCard(ReconditioningJob job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showJobDetails(job),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.invoiceNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${job.jobId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(job.status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(job.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(job.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimasi Biaya:', style: TextStyle(fontSize: 12)),
                        Text(
                          CurrencyFormatter.format(job.estimatedCost),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (job.actualCost > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Biaya Aktual:', style: TextStyle(fontSize: 12)),
                          Text(
                            CurrencyFormatter.format(job.actualCost),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Iconsax.calendar, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Mulai: ${DateFormatter.formatDate(job.startDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (job.completedDate != null) ...[
                    const SizedBox(width: 16),
                    Icon(Iconsax.tick_circle, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      'Selesai: ${DateFormatter.formatDate(job.completedDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'Terbuka';
      case 'in_progress':
        return 'Dikerjakan';
      case 'completed':
        return 'Selesai';
      default:
        return status;
    }
  }

  void _showJobDetails(ReconditioningJob job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReconditioningDetailScreen(job: job),
      ),
    );
  }
}

class ReconditioningDetailScreen extends StatefulWidget {
  final ReconditioningJob job;

  const ReconditioningDetailScreen({super.key, required this.job});

  @override
  State<ReconditioningDetailScreen> createState() => _ReconditioningDetailScreenState();
}

class _ReconditioningDetailScreenState extends State<ReconditioningDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ReconditioningProvider>();
      provider.loadReconditioningDetailsByJob(widget.job.jobId!);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Detail Rekondisi'),
        backgroundColor: AppColors.surface,
        actions: [
          if (widget.job.status != 'completed')
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'complete') {
                  _completeJob();
                } else if (value == 'add_detail') {
                  _showAddDetailDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'add_detail',
                  child: Text('Tambah Detail'),
                ),
                const PopupMenuItem(
                  value: 'complete',
                  child: Text('Selesaikan Job'),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Informasi'),
            Tab(text: 'Detail Pekerjaan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobInfoTab(),
          _buildJobDetailsTab(),
        ],
      ),
    );
  }

  Widget _buildJobInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Job',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Invoice Number', widget.job.invoiceNumber),
              _buildInfoRow('Status', _getStatusText(widget.job.status)),
              _buildInfoRow('Deskripsi', widget.job.description),
              _buildInfoRow('Estimasi Biaya', CurrencyFormatter.format(widget.job.estimatedCost)),
              if (widget.job.actualCost > 0)
                _buildInfoRow('Biaya Aktual', CurrencyFormatter.format(widget.job.actualCost)),
              _buildInfoRow('Tanggal Mulai', DateFormatter.formatDate(widget.job.startDate)),
              if (widget.job.completedDate != null)
                _buildInfoRow('Tanggal Selesai', DateFormatter.formatDate(widget.job.completedDate!)),
              if (widget.job.notes != null && widget.job.notes!.isNotEmpty)
                _buildInfoRow('Catatan', widget.job.notes!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailsTab() {
    return Consumer<ReconditioningProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.jobDetails.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.note_text, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'Belum ada detail pekerjaan',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.job.status != 'completed') ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddDetailDialog,
                    child: const Text('Tambah Detail'),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.jobDetails.length,
          itemBuilder: (context, index) {
            final detail = provider.jobDetails[index];
            return _buildDetailCard(detail);
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(ReconditioningDetail detail) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    detail.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    detail.itemType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty: ${detail.quantity}'),
                Text('@ ${CurrencyFormatter.format(detail.unitPrice)}'),
                Text(
                  CurrencyFormatter.format(detail.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (detail.notes != null && detail.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                detail.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddDetailDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddDetailDialog(jobId: widget.job.jobId!),
    );
  }

  Future<void> _completeJob() async {
    final provider = context.read<ReconditioningProvider>();
    final success = await provider.completeReconditioningJob(widget.job.jobId!);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job rekondisi berhasil diselesaikan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal menyelesaikan job'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _AddDetailDialog extends StatefulWidget {
  final String jobId;

  const _AddDetailDialog({required this.jobId});

  @override
  _AddDetailDialogState createState() => _AddDetailDialogState();
}

class _AddDetailDialogState extends State<_AddDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Detail Pekerjaan'),
      content: Consumer<ReconditioningProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Item',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => provider.setItemName(value),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Nama item wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: provider.itemType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Item',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'parts', child: Text('Sparepart')),
                    DropdownMenuItem(value: 'service', child: Text('Jasa')),
                    DropdownMenuItem(value: 'materials', child: Text('Material')),
                  ],
                  onChanged: (value) => provider.setItemType(value!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => provider.setQuantity(int.tryParse(value) ?? 0),
                        validator: (value) => (int.tryParse(value ?? '') ?? 0) <= 0
                            ? 'Jumlah harus > 0'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _unitPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga Satuan',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            provider.setUnitPrice(double.tryParse(value) ?? 0),
                        validator: (value) => (double.tryParse(value ?? '') ?? 0) < 0
                            ? 'Harga tidak boleh negatif'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:'),
                      Text(
                        CurrencyFormatter.format(provider.totalDetailPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        Consumer<ReconditioningProvider>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: provider.canAddDetail ? () => _addDetail(provider) : null,
              child: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Tambah'),
            );
          },
        ),
      ],
    );
  }

  Future<void> _addDetail(ReconditioningProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.addReconditioningDetail(widget.jobId);
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Detail berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal menambah detail'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}