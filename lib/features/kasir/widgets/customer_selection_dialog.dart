import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_bengkel/core/theme/app_theme.dart';
import 'package:pos_bengkel/features/kasir/providers/customer_provider.dart';
import 'package:pos_bengkel/features/kasir/providers/cart_provider.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class CustomerSelectionDialog extends StatefulWidget {
  final Function(Customer?)? onCustomerSelected;

  const CustomerSelectionDialog({
    super.key,
    this.onCustomerSelected,
  });

  @override
  State<CustomerSelectionDialog> createState() =>
      _CustomerSelectionDialogState();
}

class _CustomerSelectionDialogState extends State<CustomerSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });

    if (_searchQuery.isNotEmpty) {
      context.read<CustomerProvider>().searchCustomers(_searchQuery);
    } else {
      context.read<CustomerProvider>().loadCustomers();
    }
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCustomerDialog(
        searchQuery: _searchQuery,
        onCustomerAdded: (customer) {
          if (widget.onCustomerSelected != null) {
            widget.onCustomerSelected!(customer);
          } else {
            context.read<CartProvider>().setCustomer(customer);
          }
          Navigator.pop(context); // Close customer selection dialog
        },
      ),
    );
  }

  void _selectCustomer(Customer? customer) {
    if (widget.onCustomerSelected != null) {
      widget.onCustomerSelected!(customer);
    } else {
      context.read<CartProvider>().setCustomer(customer);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pilih Customer',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cari nama atau nomor telepon...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        _performSearch();
                      }
                    },
                    onFieldSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Customer Umum Option
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),
                title: const Text('Customer Umum'),
                subtitle: const Text('Pelanggan tanpa data khusus'),
                onTap: () => _selectCustomer(null),
              ),
            ),
            const SizedBox(height: 8),

            // Customer List
            Expanded(
              child: Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) {
                  if (customerProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final customers = _searchQuery.isNotEmpty
                      ? customerProvider.searchResults
                      : customerProvider.customers;

                  if (customers.isEmpty && _searchQuery.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_search,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Customer "$_searchQuery" tidak ditemukan',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showAddCustomerDialog,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Tambah Customer Baru'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (customers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada customer',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showAddCustomerDialog,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Tambah Customer Baru'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.secondary.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.secondary,
                            ),
                          ),
                          title: Text(customer.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(customer.phoneNumber),
                              if (customer.address != null &&
                                  customer.address!.isNotEmpty)
                                Text(
                                  customer.address!,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          onTap: () => _selectCustomer(customer),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Add Customer Button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddCustomerDialog,
                icon: const Icon(Icons.person_add),
                label: const Text('Tambah Customer Baru'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCustomerDialog extends StatefulWidget {
  final String searchQuery;
  final Function(Customer) onCustomerAdded;

  const AddCustomerDialog({
    super.key,
    required this.searchQuery,
    required this.onCustomerAdded,
  });

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill name if search query exists
    if (widget.searchQuery.isNotEmpty) {
      _nameController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final customer = Customer(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final customerProvider = context.read<CustomerProvider>();
    final success = await customerProvider.createCustomer(customer);

    if (success && mounted) {
      final createdCustomer = customerProvider.customers.first; // Latest added
      widget.onCustomerAdded(createdCustomer);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer ${customer.name} berhasil ditambahkan'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              customerProvider.errorMessage ?? 'Gagal menambahkan customer'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tambah Customer Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Customer *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama customer tidak boleh kosong';
                  }
                  if (value.trim().length < 2) {
                    return 'Nama customer minimal 2 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon *',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  if (value.trim().length < 10) {
                    return 'Nomor telepon minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat (Opsional)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer<CustomerProvider>(
                      builder: (context, customerProvider, _) {
                        return ElevatedButton(
                          onPressed:
                              customerProvider.isLoading ? null : _handleSubmit,
                          child: customerProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Simpan'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
