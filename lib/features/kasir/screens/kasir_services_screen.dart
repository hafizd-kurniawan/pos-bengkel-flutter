import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/service_provider.dart';
import '../providers/customer_provider.dart';
import '../../../shared/models/service.dart';
import '../../../shared/models/customer.dart';

class KasirServicesScreen extends StatefulWidget {
  const KasirServicesScreen({super.key});

  @override
  State<KasirServicesScreen> createState() => _KasirServicesScreenState();
}

class _KasirServicesScreenState extends State<KasirServicesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().loadServices();
      context.read<ServiceProvider>().loadServiceJobs();
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
        title: const Text('Servis'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Daftar Servis'),
            Tab(text: 'Pekerjaan Aktif'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ServiceListTab(),
          _ActiveJobsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateServiceJobDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'Buat Service Job Baru',
      ),
    );
  }

  void _showCreateServiceJobDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _CreateServiceJobScreen(),
      ),
    );
  }
}

class _ServiceListTab extends StatefulWidget {
  @override
  State<_ServiceListTab> createState() => _ServiceListTabState();
}

class _ServiceListTabState extends State<_ServiceListTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Cari servis...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              if (query.length >= 3 || query.isEmpty) {
                context.read<ServiceProvider>().searchServices(query);
              }
            },
          ),
        ),
        
        // Service List
        Expanded(
          child: Consumer<ServiceProvider>(
            builder: (context, serviceProvider, child) {
              if (serviceProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (serviceProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        serviceProvider.error!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          serviceProvider.clearError();
                          serviceProvider.loadServices();
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              final services = serviceProvider.services;

              if (services.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.build_outlined,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada layanan servis',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.build,
                          color: AppColors.success,
                        ),
                      ),
                      title: Text(
                        service.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${service.serviceCategory?.name ?? 'Kategori'} - ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(service.fee)}',
                      ),
                      trailing: Chip(
                        label: Text(service.status),
                        backgroundColor: service.status == 'Aktif' 
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.warning.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: service.status == 'Aktif' 
                              ? AppColors.success
                              : AppColors.warning,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => _showServiceDetail(context, service),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showServiceDetail(BuildContext context, Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(service.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kode', service.serviceCode),
            _buildDetailRow('Kategori', service.serviceCategory?.name ?? '-'),
            _buildDetailRow('Tarif', NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(service.fee)),
            _buildDetailRow('Status', service.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ActiveJobsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        if (serviceProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final serviceJobs = serviceProvider.serviceJobs;

        if (serviceJobs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_outline,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pekerjaan servis',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: serviceJobs.length,
          itemBuilder: (context, index) {
            final serviceJob = serviceJobs[index];
            final statusColor = _getStatusColor(serviceJob.status);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => _showServiceJobDetail(context, serviceJob),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            serviceJob.serviceCode,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(serviceJob.status),
                            backgroundColor: statusColor.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            serviceJob.customer?.name ?? 'Customer ${serviceJob.customerId}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.directions_car,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            serviceJob.vehicle?.plateNumber ?? 'Vehicle ${serviceJob.vehicleId}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Keluhan: ${serviceJob.complaint}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (serviceJob.diagnosis != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Diagnosis: ${serviceJob.diagnosis}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimasi: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(serviceJob.estimatedCost)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(serviceJob.serviceDate),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return AppColors.warning;
      case AppConstants.statusInProgress:
        return AppColors.info;
      case AppConstants.statusCompleted:
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showServiceJobDetail(BuildContext context, ServiceJob serviceJob) {
    context.read<ServiceProvider>().selectServiceJob(serviceJob);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ServiceJobDetailScreen(serviceJob: serviceJob),
      ),
    );
  }
}

class _CreateServiceJobScreen extends StatefulWidget {
  const _CreateServiceJobScreen();

  @override
  State<_CreateServiceJobScreen> createState() => _CreateServiceJobScreenState();
}

class _CreateServiceJobScreenState extends State<_CreateServiceJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _notesController = TextEditingController();
  
  Customer? _selectedCustomer;
  CustomerVehicle? _selectedVehicle;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<CustomerProvider>().loadCustomers();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    _estimatedCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Service Job Baru'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pelanggan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        title: Text(_selectedCustomer?.name ?? 'Pilih Pelanggan'),
                        subtitle: _selectedCustomer != null 
                            ? Text(_selectedCustomer!.phoneNumber)
                            : null,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showCustomerSelection(),
                        tileColor: AppColors.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Vehicle Selection
              if (_selectedCustomer != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kendaraan',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<CustomerProvider>(
                          builder: (context, customerProvider, child) {
                            final vehicles = customerProvider.vehicles;
                            
                            if (vehicles.isEmpty) {
                              return ListTile(
                                title: const Text('Belum ada kendaraan'),
                                subtitle: const Text('Tambah kendaraan terlebih dahulu'),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.warning.withOpacity(0.1),
                                  child: Icon(Icons.warning, color: AppColors.warning),
                                ),
                                tileColor: AppColors.grey50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }

                            return Column(
                              children: vehicles.map((vehicle) {
                                final isSelected = _selectedVehicle?.vehicleId == vehicle.vehicleId;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    title: Text(vehicle.plateNumber),
                                    subtitle: Text('${vehicle.brand} ${vehicle.model} (${vehicle.productionYear})'),
                                    leading: CircleAvatar(
                                      backgroundColor: isSelected 
                                          ? AppColors.primary.withOpacity(0.1)
                                          : AppColors.grey200,
                                      child: Icon(
                                        Icons.directions_car,
                                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                      ),
                                    ),
                                    trailing: isSelected ? Icon(Icons.check_circle, color: AppColors.primary) : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedVehicle = vehicle;
                                      });
                                    },
                                    tileColor: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.grey50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: isSelected 
                                          ? BorderSide(color: AppColors.primary)
                                          : BorderSide.none,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Service Details
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Servis',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Service Date
                      ListTile(
                        title: const Text('Tanggal Servis'),
                        subtitle: Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.info.withOpacity(0.1),
                          child: Icon(Icons.calendar_today, color: AppColors.info),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _selectDate(),
                        tileColor: AppColors.grey50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Complaint
                      TextFormField(
                        controller: _complaintController,
                        decoration: const InputDecoration(
                          labelText: 'Keluhan',
                          border: OutlineInputBorder(),
                          helperText: 'Deskripsikan keluhan atau masalah kendaraan',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Keluhan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Estimated Cost
                      TextFormField(
                        controller: _estimatedCostController,
                        decoration: const InputDecoration(
                          labelText: 'Estimasi Biaya',
                          border: OutlineInputBorder(),
                          prefixText: 'Rp ',
                          helperText: 'Perkiraan biaya servis',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Estimasi biaya tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Catatan (Opsional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit() ? _submitServiceJob : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Buat Service Job'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _selectedCustomer != null && 
           _selectedVehicle != null && 
           _complaintController.text.isNotEmpty &&
           _estimatedCostController.text.isNotEmpty;
  }

  void _showCustomerSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Pilih Pelanggan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<CustomerProvider>(
                    builder: (context, customerProvider, child) {
                      final customers = customerProvider.customers;
                      
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return ListTile(
                            title: Text(customer.name),
                            subtitle: Text(customer.phoneNumber),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(Icons.person, color: AppColors.primary),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedCustomer = customer;
                                _selectedVehicle = null; // Reset vehicle selection
                              });
                              context.read<CustomerProvider>().selectCustomer(customer);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitServiceJob() async {
    if (_formKey.currentState!.validate() && _canSubmit()) {
      final success = await context.read<ServiceProvider>().createServiceJob(
        customerId: _selectedCustomer!.customerId,
        vehicleId: _selectedVehicle!.vehicleId,
        userId: 1, // TODO: Get from auth provider
        outletId: 1, // TODO: Get from auth provider
        serviceDate: _selectedDate,
        complaint: _complaintController.text,
        estimatedCost: double.parse(_estimatedCostController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service job berhasil dibuat'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}

class _ServiceJobDetailScreen extends StatelessWidget {
  final ServiceJob serviceJob;

  const _ServiceJobDetailScreen({required this.serviceJob});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceJob.serviceCode),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: _getStatusColor(serviceJob.status),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Status: ${serviceJob.status}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getStatusColor(serviceJob.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pekerjaan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Kode Servis', serviceJob.serviceCode),
                    _buildDetailRow('Pelanggan', serviceJob.customer?.name ?? 'Customer ${serviceJob.customerId}'),
                    _buildDetailRow('Kendaraan', serviceJob.vehicle?.plateNumber ?? 'Vehicle ${serviceJob.vehicleId}'),
                    _buildDetailRow('Tanggal', DateFormat('dd MMMM yyyy').format(serviceJob.serviceDate)),
                    _buildDetailRow('Keluhan', serviceJob.complaint),
                    if (serviceJob.diagnosis != null)
                      _buildDetailRow('Diagnosis', serviceJob.diagnosis!),
                    _buildDetailRow('Estimasi', NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(serviceJob.estimatedCost)),
                    if (serviceJob.actualCost > 0)
                      _buildDetailRow('Biaya Aktual', NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(serviceJob.actualCost)),
                    if (serviceJob.notes != null)
                      _buildDetailRow('Catatan', serviceJob.notes!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Service Details
            Consumer<ServiceProvider>(
              builder: (context, serviceProvider, child) {
                final details = serviceProvider.serviceDetails;
                
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Detail Layanan',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showAddServiceDetail(context),
                              child: const Text('Tambah'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        if (details.isEmpty)
                          Center(
                            child: Text(
                              'Belum ada detail layanan',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          )
                        else
                          ...details.map((detail) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    detail.service?.name ?? 'Service ${detail.serviceId}',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  '${detail.quantity}x',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(detail.subtotal),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )),
                        
                        if (details.isNotEmpty) ...[
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(
                                  details.fold(0.0, (sum, detail) => sum + detail.subtotal),
                                ),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return AppColors.warning;
      case AppConstants.statusInProgress:
        return AppColors.info;
      case AppConstants.statusCompleted:
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddServiceDetail(BuildContext context) {
    // Implementation for adding service detail
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur tambah detail layanan akan segera tersedia'),
      ),
    );
  }
}