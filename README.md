aku ingin kamu mengembangkan aplikasi pos bengkel dengan flutter, dengan ekspetasi tampilan modern, ke kiniaan yang di lihat oleh user bagus dan mudah di operasikan, pastikan setiap fitur harus sesuai detail, pastikan pengembangan hanya di selain di scope web admin, 



Tentu, ini adalah pembagian kontrak API untuk peran Superadmin, Kasir, dan Mekanik, beserta rekomendasi platform (Admin Web Panel atau Aplikasi Flutter) untuk masing-masing peran.



Secara umum, Superadmin memiliki akses penuh ke semua data untuk konfigurasi dan pengawasan, Kasir fokus pada transaksi dan interaksi dengan pelanggan, sedangkan Mekanik fokus pada eksekusi pekerjaan servis.



👨‍💼 Superadmin (Admin Web Panel)

Superadmin memiliki hak akses tertinggi dan bertanggung jawab atas data master, konfigurasi sistem, dan pengawasan menyeluruh. Semua endpoint ini paling cocok diakses melalui Admin Web Panel karena sifatnya yang kompleks dan memerlukan tampilan data yang detail.



🔑 Manajemen Fondasi & Pengguna

Superadmin mengatur data inti sistem, termasuk siapa saja yang bisa mengaksesnya.



Users Management (/api/v1/users):



POST, GET, GET /:id, PUT /:id, DELETE /:id



Alasan: Hanya superadmin yang boleh membuat, melihat, mengubah, dan menghapus akun pengguna lain (kasir, mekanik, admin lain).



Outlets Management (/api/v1/outlets):



POST, GET, GET /:id, PUT /:id, DELETE /:id



Alasan: Mengelola data cabang atau bengkel adalah tanggung jawab strategis level atas.



📦 Manajemen Inventaris & Jasa (Data Master)

Superadmin bertanggung jawab penuh atas semua data master terkait produk dan jasa.



Categories (/api/v1/categories): POST, GET, PUT, DELETE



Suppliers (/api/v1/suppliers): POST, GET, PUT, DELETE



Unit Types (/api/v1/unit-types): POST, GET, PUT, DELETE



Products (/api/v1/products): POST, GET, PUT, DELETE, termasuk POST /:id/stock untuk penyesuaian stok manual.



Service Categories (/api/v1/service-categories): POST, GET, PUT, DELETE



Services (/api/v1/services): POST, GET, PUT, DELETE



Alasan: Semua ini adalah data master yang menjadi dasar operasional. Kesalahan input pada level ini akan berdampak ke semua transaksi.



📊 Manajemen Keuangan & Laporan

Superadmin memantau kesehatan finansial dan semua transaksi di seluruh outlet.



Payment Methods (/api/v1/payment-methods): POST, GET, PUT, DELETE



Alasan: Mengkonfigurasi metode pembayaran yang diterima.



Transactions (/api/v1/transactions):



GET, GET /:id, GET /invoice, GET /status, GET /date-range, GET /customers/:id/transactions, GET /outlets/:id/transactions



Alasan: Untuk audit, laporan, dan pengawasan penuh terhadap semua transaksi. Superadmin juga sebaiknya menjadi satu-satunya yang bisa PUT (mengubah) dan DELETE (membatalkan) transaksi jika terjadi kesalahan fatal.



Cash Flows (/api/v1/cash-flows):



POST, GET, PUT, DELETE



Alasan: Mengelola dan mengawasi seluruh arus kas masuk dan keluar dari semua outlet.



🛠️ Pengawasan Penuh Pekerjaan Servis

Superadmin dapat melihat dan mengelola semua pekerjaan servis dari semua mekanik di semua outlet.



Service Jobs (/api/v1/service-jobs): GET, GET /:id, PUT /:id, DELETE /:id



Service Details (/api/v1/service-details): GET, PUT /:id, DELETE /:id



Service Job History (/api/v1/service-jobs/:id/histories): GET



Alasan: Untuk pengawasan kualitas, penyelesaian sengketa, dan analisis kinerja.



💰 Kasir (Aplikasi Flutter)

Peran Kasir adalah ujung tombak transaksi. Antarmukanya harus cepat dan efisien, sehingga Aplikasi Flutter di tablet atau smartphone sangat cocok.



🧑‍🤝‍🧑 Manajemen Pelanggan & Kendaraan

Kasir berinteraksi langsung dengan pelanggan untuk registrasi dan penerimaan servis.



Customers (/api/v1/customers):



POST: Membuat pelanggan baru.



GET, GET /:id, GET /search, GET /phone: Mencari dan melihat data pelanggan.



PUT /:id: Memperbarui data pelanggan (misal: alamat atau nomor telepon).



Customer Vehicles (/api/v1/customer-vehicles):



POST: Mendaftarkan kendaraan baru milik pelanggan.



GET, GET /:id, GET /search, GET /customers/:id/vehicles: Mencari dan melihat data kendaraan.



PUT /:id: Memperbarui data kendaraan.



🛒 Transaksi & Pembayaran

Fungsi utama kasir adalah memproses transaksi penjualan dan servis.



Products (/api/v1/products):



GET, GET /:id, GET /sku, GET /barcode, GET /search: Mencari produk untuk ditambahkan ke transaksi. Akses hanya baca (read-only).



Services (/api/v1/services):



GET, GET /:id, GET /code, GET /search: Mencari jasa untuk ditambahkan ke order servis. Akses hanya baca (read-only).



Service Jobs (/api/v1/service-jobs):



POST: Membuat order servis baru saat pelanggan datang.



GET, GET /:id, GET /status: Melihat daftar dan status pekerjaan, terutama yang sudah selesai dan siap untuk pembayaran.



Service Details (/api/v1/service-details):



POST: Menambahkan detail jasa atau spare part ke dalam sebuah order servis.



Transactions (/api/v1/transactions):



POST: Membuat transaksi (invoice) setelah servis atau penjualan selesai.



GET, GET /:id, GET /invoice: Melihat transaksi yang baru dibuat untuk mencetak struk atau konfirmasi.



Cash Flows (/api/v1/cash-flows):



POST, GET /type: Mencatat pemasukan dari transaksi atau pengeluaran kecil (petty cash).



🔧 Mekanik (Aplikasi Flutter)

Mekanik fokus pada eksekusi pekerjaan. Mereka butuh informasi detail tentang tugas mereka dan kemampuan untuk memperbarui status pekerjaan secara real-time dari bengkel. Aplikasi Flutter sangat ideal untuk ini.



📋 Manajemen Pekerjaan Servis

Ini adalah menu utama bagi seorang mekanik.



Service Jobs (/api/v1/service-jobs):



GET, GET /:id, GET /status: Melihat daftar pekerjaan yang ditugaskan kepadanya (user_id bisa difilter di backend) dan detailnya.



PUT /:id: Mengupdate diagnosis, catatan, atau item yang digunakan selama pengerjaan.



PUT /:id/status: Fungsi paling penting. Mengubah status pekerjaan (misal: dari "Pending" ke "In Progress", lalu ke "Completed").



Service Details (/api/v1/service-details):



POST, PUT /:id, DELETE /:id: Menambah, mengubah, atau menghapus jasa/spare part yang digunakan selama servis berdasarkan temuan di lapangan.



GET /api/v1/service-jobs/:id/details: Melihat semua detail item dalam satu pekerjaan.



Service Job History (/api/v1/service-jobs/:id/histories):



GET: Melihat riwayat perubahan status pada pekerjaan yang sedang ditangani.



ℹ️ Akses Informasi Pendukung

Mekanik perlu melihat informasi, tetapi tidak mengubahnya.



Customers (/api/v1/customers/:id): GET /:id



Alasan: Hanya untuk melihat detail pelanggan dari pekerjaan yang sedang dilakukan (misal: untuk menghubungi jika ada konfirmasi). Akses hanya baca.



Customer Vehicles (/api/v1/customer-vehicles/:id): GET /:id



Alasan: Melihat detail spesifik kendaraan (nomor rangka, mesin, tahun produksi) yang sedang dikerjakan. Akses hanya baca.



Products (/api/v1/products): GET, GET /search



Alasan: Untuk memeriksa ketersediaan stok atau detail spare part. Akses hanya baca.



Ringkasan Tabel Hak Akses

Kategori Endpoint	Superadmin (Web)	Kasir (Flutter)	Mekanik (Flutter)

Users	✅ CRUD	❌	❌

Outlets	✅ CRUD	❌	❌

Customers & Vehicles	✅ CRUD	✍️ CRU	👁️ Read-Only

Inventory (Master)	✅ CRUD	👁️ Read-Only	👁️ Read-Only

Services (Master)	✅ CRUD	👁️ Read-Only	👁️ Read-Only

Service Jobs	✅ CRUD	✍️ Create & Read	✍️ Read & Update Status

Service Details	✅ CRUD	✍️ Create & Read	✅ CRUD (terbatas pada job-nya)

Financial (Transactions)	✅ CRUD	✍️ Create & Read	❌

Financial (Cash Flow)	✅ CRUD	✍️ Create & Read	❌



Export to Sheets

Legenda:



✅ CRUD: Akses penuh (Create, Read, Update, Delete).



✍️ CRU/Create & Read/Update: Akses sebagian, sesuai kebutuhan peran.



👁️ Read-Only: Hanya bisa melihat data.



❌ No Access: Tidak memiliki akses.





ini ada api kontrak nya



🚀 API Documentation

Complete API reference for POS Bengkel system integration with Flutter applications.



Base URL & Authentication

Base URL: http://localhost:3000



Content-Type: application/json



Note: Authentication endpoints are under development. Currently, all endpoints are accessible without authentication.



Response Format

All API responses follow a consistent structure:



Success Response

{

  "status": "success",

  "message": "Operation completed successfully",

  "data": {

    // Response data object

  }

}

Paginated Response

{

  "status": "success",

  "message": "Data retrieved successfully",

  "data": [

    // Array of objects

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 100,

    "pages": 10

  }

}

Error Response

{

  "status": "error",

  "message": "Error description",

  "error": "Detailed error message"

}

Status Codes

200 - OK

201 - Created

400 - Bad Request

404 - Not Found

500 - Internal Server Error

Foundation APIs

Health Check

GET /health

Check API health status.



Response:



{

  "status": "success",

  "message": "API is running",

  "data": {

    "service": "POS Bengkel API",

    "version": "1.0.0",

    "timestamp": "2024-01-01T10:00:00Z"

  }

}

Users Management

POST /api/v1/users

Create a new user.



Request Body:



{

  "name": "John Doe",

  "email": "john@example.com",

  "password": "password123",

  "outlet_id": 1

}

Validation Rules:



name: required, min 2 characters

email: required, valid email format

password: required, min 6 characters

outlet_id: optional, must exist in outlets table

Response:



{

  "status": "success",

  "message": "User created successfully",

  "data": {

    "user_id": 1,

    "name": "John Doe",

    "email": "john@example.com",

    "outlet_id": 1,

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop",

      "branch_type": "Pusat",

      "city": "Jakarta"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/users

List all users with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Users retrieved successfully",

  "data": [

    {

      "user_id": 1,

      "name": "John Doe",

      "email": "john@example.com",

      "outlet_id": 1,

      "outlet": {

        "outlet_id": 1,

        "outlet_name": "Main Workshop",

        "branch_type": "Pusat",

        "city": "Jakarta"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/users/:id

Get user by ID.



Path Parameters:



id: User ID

Response:



{

  "status": "success",

  "message": "User retrieved successfully",

  "data": {

    "user_id": 1,

    "name": "John Doe",

    "email": "john@example.com",

    "outlet_id": 1,

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop",

      "branch_type": "Pusat",

      "city": "Jakarta"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/users/:id

Update user information.



Path Parameters:



id: User ID

Request Body:



{

  "name": "John Doe Updated",

  "email": "john.updated@example.com",

  "outlet_id": 2

}

Response:



{

  "status": "success",

  "message": "User updated successfully",

  "data": {

    "user_id": 1,

    "name": "John Doe Updated",

    "email": "john.updated@example.com",

    "outlet_id": 2,

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/users/:id

Delete user (soft delete).



Path Parameters:



id: User ID

Response:



{

  "status": "success",

  "message": "User deleted successfully"

}

Outlets Management

POST /api/v1/outlets

Create a new outlet.



Request Body:



{

  "outlet_name": "Main Workshop",

  "branch_type": "Pusat",

  "city": "Jakarta",

  "address": "Jl. Merdeka No. 123",

  "phone_number": "021-12345678",

  "status": "Aktif"

}

Validation Rules:



outlet_name: required

branch_type: required

city: required

address: optional

phone_number: optional

status: optional (default: "Aktif")

Response:



{

  "status": "success",

  "message": "Outlet created successfully",

  "data": {

    "outlet_id": 1,

    "outlet_name": "Main Workshop",

    "branch_type": "Pusat",

    "city": "Jakarta",

    "address": "Jl. Merdeka No. 123",

    "phone_number": "021-12345678",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/outlets

List all outlets with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Outlets retrieved successfully",

  "data": [

    {

      "outlet_id": 1,

      "outlet_name": "Main Workshop",

      "branch_type": "Pusat",

      "city": "Jakarta",

      "address": "Jl. Merdeka No. 123",

      "phone_number": "021-12345678",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/outlets/:id

Get outlet by ID.



Path Parameters:



id: Outlet ID

Response:



{

  "status": "success",

  "message": "Outlet retrieved successfully",

  "data": {

    "outlet_id": 1,

    "outlet_name": "Main Workshop",

    "branch_type": "Pusat",

    "city": "Jakarta",

    "address": "Jl. Merdeka No. 123",

    "phone_number": "021-12345678",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/outlets/:id

Update outlet information.



Path Parameters:



id: Outlet ID

Request Body:



{

  "outlet_name": "Main Workshop - Updated",

  "address": "Jl. Merdeka No. 123 - Updated",

  "phone_number": "021-87654321"

}

Response:



{

  "status": "success",

  "message": "Outlet updated successfully",

  "data": {

    "outlet_id": 1,

    "outlet_name": "Main Workshop - Updated",

    "branch_type": "Pusat",

    "city": "Jakarta",

    "address": "Jl. Merdeka No. 123 - Updated",

    "phone_number": "021-87654321",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/outlets/:id

Delete outlet (soft delete).



Path Parameters:



id: Outlet ID

Response:



{

  "status": "success",

  "message": "Outlet deleted successfully"

}

Customer Management APIs

Customers

POST /api/v1/customers

Create a new customer.



Request Body:



{

  "name": "John Doe",

  "phone_number": "081234567890",

  "address": "Jl. Sudirman No. 456",

  "status": "Aktif"

}

Validation Rules:



name: required, min 2 characters, max 255 characters

phone_number: required, min 10 characters, max 20 characters, unique

address: optional

status: optional (default: "Aktif")

Response:



{

  "status": "success",

  "message": "Customer created successfully",

  "data": {

    "customer_id": 1,

    "name": "John Doe",

    "phone_number": "081234567890",

    "address": "Jl. Sudirman No. 456",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/customers

List all customers with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Customers retrieved successfully",

  "data": [

    {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890",

      "address": "Jl. Sudirman No. 456",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customers/:id

Get customer by ID.



Path Parameters:



id: Customer ID

Response:



{

  "status": "success",

  "message": "Customer retrieved successfully",

  "data": {

    "customer_id": 1,

    "name": "John Doe",

    "phone_number": "081234567890",

    "address": "Jl. Sudirman No. 456",

    "status": "Aktif",

    "vehicles": [

      {

        "vehicle_id": 1,

        "plate_number": "B1234XYZ",

        "brand": "Toyota",

        "model": "Avanza",

        "production_year": 2020

      }

    ],

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/customers/:id

Update customer information.



Path Parameters:



id: Customer ID

Request Body:



{

  "name": "John Doe Updated",

  "address": "Jl. Sudirman No. 456 Updated"

}

Response:



{

  "status": "success",

  "message": "Customer updated successfully",

  "data": {

    "customer_id": 1,

    "name": "John Doe Updated",

    "phone_number": "081234567890",

    "address": "Jl. Sudirman No. 456 Updated",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/customers/:id

Delete customer (soft delete).



Path Parameters:



id: Customer ID

Response:



{

  "status": "success",

  "message": "Customer deleted successfully"

}

GET /api/v1/customers/search

Search customers by name or phone number.



Query Parameters:



q: Search query

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Customers found",

  "data": [

    {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890",

      "address": "Jl. Sudirman No. 456",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customers/phone

Get customer by phone number.



Query Parameters:



phone_number: Customer phone number

Response:



{

  "status": "success",

  "message": "Customer retrieved successfully",

  "data": {

    "customer_id": 1,

    "name": "John Doe",

    "phone_number": "081234567890",

    "address": "Jl. Sudirman No. 456",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

Customer Vehicles

POST /api/v1/customer-vehicles

Create a new customer vehicle.



Request Body:



{

  "customer_id": 1,

  "plate_number": "B1234XYZ",

  "brand": "Toyota",

  "model": "Avanza",

  "type": "MPV",

  "production_year": 2020,

  "chassis_number": "CH1234567890123456",

  "engine_number": "ENG1234567890",

  "color": "Silver",

  "notes": "Customer vehicle in good condition"

}

Validation Rules:



customer_id: required, must exist in customers table

plate_number: required, min 3 characters, max 20 characters, unique

brand: required, min 2 characters, max 100 characters

model: required, min 2 characters, max 100 characters

type: required, min 2 characters, max 100 characters

production_year: required, between 1900 and 2030

chassis_number: required, min 10 characters, max 100 characters, unique

engine_number: required, min 5 characters, max 100 characters, unique

color: required, min 2 characters, max 50 characters

notes: optional

Response:



{

  "status": "success",

  "message": "Customer vehicle created successfully",

  "data": {

    "vehicle_id": 1,

    "customer_id": 1,

    "plate_number": "B1234XYZ",

    "brand": "Toyota",

    "model": "Avanza",

    "type": "MPV",

    "production_year": 2020,

    "chassis_number": "CH1234567890123456",

    "engine_number": "ENG1234567890",

    "color": "Silver",

    "notes": "Customer vehicle in good condition",

    "customer": {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/customer-vehicles

List all customer vehicles with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Customer vehicles retrieved successfully",

  "data": [

    {

      "vehicle_id": 1,

      "customer_id": 1,

      "plate_number": "B1234XYZ",

      "brand": "Toyota",

      "model": "Avanza",

      "type": "MPV",

      "production_year": 2020,

      "chassis_number": "CH1234567890123456",

      "engine_number": "ENG1234567890",

      "color": "Silver",

      "notes": "Customer vehicle in good condition",

      "customer": {

        "customer_id": 1,

        "name": "John Doe",

        "phone_number": "081234567890"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customer-vehicles/:id

Get customer vehicle by ID.



Path Parameters:



id: Vehicle ID

Response:



{

  "status": "success",

  "message": "Customer vehicle retrieved successfully",

  "data": {

    "vehicle_id": 1,

    "customer_id": 1,

    "plate_number": "B1234XYZ",

    "brand": "Toyota",

    "model": "Avanza",

    "type": "MPV",

    "production_year": 2020,

    "chassis_number": "CH1234567890123456",

    "engine_number": "ENG1234567890",

    "color": "Silver",

    "notes": "Customer vehicle in good condition",

    "customer": {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/customer-vehicles/:id

Update customer vehicle information.



Path Parameters:



id: Vehicle ID

Request Body:



{

  "model": "Avanza Veloz",

  "color": "Black",

  "notes": "Customer vehicle upgraded to Veloz variant"

}

Response:



{

  "status": "success",

  "message": "Customer vehicle updated successfully",

  "data": {

    "vehicle_id": 1,

    "customer_id": 1,

    "plate_number": "B1234XYZ",

    "brand": "Toyota",

    "model": "Avanza Veloz",

    "type": "MPV",

    "production_year": 2020,

    "chassis_number": "CH1234567890123456",

    "engine_number": "ENG1234567890",

    "color": "Black",

    "notes": "Customer vehicle upgraded to Veloz variant",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/customer-vehicles/:id

Delete customer vehicle (soft delete).



Path Parameters:



id: Vehicle ID

Response:



{

  "status": "success",

  "message": "Customer vehicle deleted successfully"

}

GET /api/v1/customer-vehicles/search

Search customer vehicles by plate number, brand, or model.



Query Parameters:



q: Search query (plate number, brand, model)

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Customer vehicles found",

  "data": [

    {

      "vehicle_id": 1,

      "customer_id": 1,

      "plate_number": "B1234XYZ",

      "brand": "Toyota",

      "model": "Avanza",

      "type": "MPV",

      "production_year": 2020,

      "customer": {

        "customer_id": 1,

        "name": "John Doe",

        "phone_number": "081234567890"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customers/:customer_id/vehicles

Get all vehicles for a specific customer.



Path Parameters:



customer_id: Customer ID

Response:



{

  "status": "success",

  "message": "Customer vehicles retrieved successfully",

  "data": [

    {

      "vehicle_id": 1,

      "customer_id": 1,

      "plate_number": "B1234XYZ",

      "brand": "Toyota",

      "model": "Avanza",

      "type": "MPV",

      "production_year": 2020,

      "chassis_number": "CH1234567890123456",

      "engine_number": "ENG1234567890",

      "color": "Silver",

      "notes": "Customer vehicle in good condition",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ]

}

Inventory Management APIs

Categories

POST /api/v1/categories

Create a new category.



Request Body:



{

  "name": "Spare Parts",

  "status": "Aktif"

}

Validation Rules:



name: required

status: optional (default: "Aktif")

Response:



{

  "status": "success",

  "message": "Category created successfully",

  "data": {

    "category_id": 1,

    "name": "Spare Parts",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/categories

List all categories with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Categories retrieved successfully",

  "data": [

    {

      "category_id": 1,

      "name": "Spare Parts",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/categories/:id

Get category by ID.



Path Parameters:



id: Category ID

Response:



{

  "status": "success",

  "message": "Category retrieved successfully",

  "data": {

    "category_id": 1,

    "name": "Spare Parts",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/categories/:id

Update category information.



Path Parameters:



id: Category ID

Request Body:



{

  "name": "Spare Parts - Updated",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Category updated successfully",

  "data": {

    "category_id": 1,

    "name": "Spare Parts - Updated",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/categories/:id

Delete category (soft delete).



Path Parameters:



id: Category ID

Response:



{

  "status": "success",

  "message": "Category deleted successfully"

}

GET /api/v1/categories/:id/products

Get all products in a category.



Path Parameters:



id: Category ID

Response:



{

  "status": "success",

  "message": "Category products retrieved successfully",

  "data": [

    {

      "product_id": 1,

      "product_name": "Brake Pad Toyota Avanza",

      "sku": "BP-TOY-AVZ-001",

      "selling_price": 200000,

      "stock": 25,

      "category_id": 1

    }

  ]

}

Suppliers

POST /api/v1/suppliers

Create a new supplier.



Request Body:



{

  "supplier_name": "PT Auto Parts Indonesia",

  "contact_person_name": "Budi Santoso",

  "phone_number": "021-87654321",

  "address": "Jl. Industri No. 45, Jakarta",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Supplier created successfully",

  "data": {

    "supplier_id": 1,

    "supplier_name": "PT Auto Parts Indonesia",

    "contact_person_name": "Budi Santoso",

    "phone_number": "021-87654321",

    "address": "Jl. Industri No. 45, Jakarta",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/suppliers

List all suppliers with pagination.



Response:



{

  "status": "success",

  "message": "Suppliers retrieved successfully",

  "data": [

    {

      "supplier_id": 1,

      "supplier_name": "PT Auto Parts Indonesia",

      "contact_person_name": "Budi Santoso",

      "phone_number": "021-87654321",

      "address": "Jl. Industri No. 45, Jakarta",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/suppliers/:id

Get supplier by ID.



Path Parameters:



id: Supplier ID

Response:



{

  "status": "success",

  "message": "Supplier retrieved successfully",

  "data": {

    "supplier_id": 1,

    "supplier_name": "PT Auto Parts Indonesia",

    "contact_person_name": "Budi Santoso",

    "phone_number": "021-87654321",

    "address": "Jl. Industri No. 45, Jakarta",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/suppliers/:id

Update supplier information.



Path Parameters:



id: Supplier ID

Request Body:



{

  "supplier_name": "PT Auto Parts Indonesia - Updated",

  "contact_person_name": "Budi Santoso Updated",

  "phone_number": "021-11111111"

}

Response:



{

  "status": "success",

  "message": "Supplier updated successfully",

  "data": {

    "supplier_id": 1,

    "supplier_name": "PT Auto Parts Indonesia - Updated",

    "contact_person_name": "Budi Santoso Updated",

    "phone_number": "021-11111111",

    "address": "Jl. Industri No. 45, Jakarta",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/suppliers/:id

Delete supplier (soft delete).



Path Parameters:



id: Supplier ID

Response:



{

  "status": "success",

  "message": "Supplier deleted successfully"

}

GET /api/v1/suppliers/search

Search suppliers by name or contact person.



Query Parameters:



q: Search query

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Suppliers found",

  "data": [

    {

      "supplier_id": 1,

      "supplier_name": "PT Auto Parts Indonesia",

      "contact_person_name": "Budi Santoso",

      "phone_number": "021-87654321",

      "address": "Jl. Industri No. 45, Jakarta",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/suppliers/:id/products

Get all products from a supplier.



Path Parameters:



id: Supplier ID

Response:



{

  "status": "success",

  "message": "Supplier products retrieved successfully",

  "data": [

    {

      "product_id": 1,

      "product_name": "Brake Pad Toyota Avanza",

      "sku": "BP-TOY-AVZ-001",

      "selling_price": 200000,

      "stock": 25,

      "supplier_id": 1

    }

  ]

}

Unit Types

POST /api/v1/unit-types

Create a new unit type.



Request Body:



{

  "name": "Pieces",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Unit type created successfully",

  "data": {

    "unit_type_id": 1,

    "name": "Pieces",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/unit-types

List all unit types.



Response:



{

  "status": "success",

  "message": "Unit types retrieved successfully",

  "data": [

    {

      "unit_type_id": 1,

      "name": "Pieces",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ]

}

GET /api/v1/unit-types/:id

Get unit type by ID.



Path Parameters:



id: Unit Type ID

Response:



{

  "status": "success",

  "message": "Unit type retrieved successfully",

  "data": {

    "unit_type_id": 1,

    "name": "Pieces",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/unit-types/:id

Update unit type information.



Path Parameters:



id: Unit Type ID

Request Body:



{

  "name": "Pieces - Updated",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Unit type updated successfully",

  "data": {

    "unit_type_id": 1,

    "name": "Pieces - Updated",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/unit-types/:id

Delete unit type (soft delete).



Path Parameters:



id: Unit Type ID

Response:



{

  "status": "success",

  "message": "Unit type deleted successfully"

}

Products

POST /api/v1/products

Create a new product.



Request Body:



{

  "product_name": "Brake Pad Toyota Avanza",

  "product_description": "High quality brake pad for Toyota Avanza",

  "cost_price": 150000,

  "selling_price": 200000,

  "stock": 25,

  "sku": "BP-TOY-AVZ-001",

  "barcode": "1234567890123",

  "has_serial_number": false,

  "shelf_location": "A1-B2",

  "usage_status": "Jual",

  "is_active": true,

  "category_id": 1,

  "supplier_id": 1,

  "unit_type_id": 1

}

Validation Rules:



product_name: required

cost_price: required, must be positive number

selling_price: required, must be positive number

stock: required, must be non-negative integer

sku: required, unique

category_id: required, must exist

supplier_id: required, must exist

unit_type_id: required, must exist

Response:



{

  "status": "success",

  "message": "Product created successfully",

  "data": {

    "product_id": 1,

    "product_name": "Brake Pad Toyota Avanza",

    "product_description": "High quality brake pad for Toyota Avanza",

    "cost_price": 150000,

    "selling_price": 200000,

    "stock": 25,

    "sku": "BP-TOY-AVZ-001",

    "barcode": "1234567890123",

    "has_serial_number": false,

    "shelf_location": "A1-B2",

    "usage_status": "Jual",

    "is_active": true,

    "category": {

      "category_id": 1,

      "name": "Spare Parts"

    },

    "supplier": {

      "supplier_id": 1,

      "supplier_name": "PT Auto Parts Indonesia"

    },

    "unit_type": {

      "unit_type_id": 1,

      "name": "Pieces"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/products

List all products with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Products retrieved successfully",

  "data": [

    {

      "product_id": 1,

      "product_name": "Brake Pad Toyota Avanza",

      "cost_price": 150000,

      "selling_price": 200000,

      "stock": 25,

      "sku": "BP-TOY-AVZ-001",

      "category": {

        "category_id": 1,

        "name": "Spare Parts"

      },

      "supplier": {

        "supplier_id": 1,

        "supplier_name": "PT Auto Parts Indonesia"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/products/:id

Get product by ID.



Path Parameters:



id: Product ID

Response:



{

  "status": "success",

  "message": "Product retrieved successfully",

  "data": {

    "product_id": 1,

    "product_name": "Brake Pad Toyota Avanza",

    "product_description": "High quality brake pad for Toyota Avanza",

    "cost_price": 150000,

    "selling_price": 200000,

    "stock": 25,

    "sku": "BP-TOY-AVZ-001",

    "barcode": "1234567890123",

    "has_serial_number": false,

    "shelf_location": "A1-B2",

    "usage_status": "Jual",

    "is_active": true,

    "category": {

      "category_id": 1,

      "name": "Spare Parts"

    },

    "supplier": {

      "supplier_id": 1,

      "supplier_name": "PT Auto Parts Indonesia"

    },

    "unit_type": {

      "unit_type_id": 1,

      "name": "Pieces"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/products/:id

Update product information.



Path Parameters:



id: Product ID

Request Body:



{

  "product_name": "Brake Pad Toyota Avanza - Updated",

  "selling_price": 220000

}

Response:



{

  "status": "success",

  "message": "Product updated successfully",

  "data": {

    "product_id": 1,

    "product_name": "Brake Pad Toyota Avanza - Updated",

    "selling_price": 220000,

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

GET /api/v1/products/sku

Get product by SKU.



Query Parameters:



sku: Product SKU

Response:



{

  "status": "success",

  "message": "Product retrieved successfully",

  "data": {

    "product_id": 1,

    "product_name": "Brake Pad Toyota Avanza",

    "sku": "BP-TOY-AVZ-001",

    "selling_price": 200000,

    "stock": 25

  }

}

GET /api/v1/products/barcode

Get product by barcode.



Query Parameters:



barcode: Product barcode

Response:



{

  "status": "success",

  "message": "Product retrieved successfully",

  "data": {

    "product_id": 1,

    "product_name": "Brake Pad Toyota Avanza",

    "sku": "BP-TOY-AVZ-001",

    "barcode": "1234567890123",

    "selling_price": 200000,

    "stock": 25

  }

}

GET /api/v1/products/usage-status

Get products by usage status.



Query Parameters:



status: Usage status (e.g., "Jual", "Pakai", "Jual&Pakai")

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Products retrieved successfully",

  "data": [

    {

      "product_id": 1,

      "product_name": "Brake Pad Toyota Avanza",

      "sku": "BP-TOY-AVZ-001",

      "selling_price": 200000,

      "stock": 25,

      "usage_status": "Jual"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/products/search

Search products by name or SKU.



Query Parameters:



q: Search query

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Products found",

  "data": [

    {

      "product_id": 1,

      "product_name": "Brake Pad Toyota Avanza",

      "sku": "BP-TOY-AVZ-001",

      "selling_price": 200000,

      "stock": 25

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/products/low-stock

Get products with low stock.



Query Parameters:



threshold: Stock threshold (default: 10)

Response:



{

  "status": "success",

  "message": "Low stock products retrieved successfully",

  "data": [

    {

      "product_id": 2,

      "product_name": "Engine Oil Filter",

      "sku": "EOF-001",

      "stock": 5,

      "threshold": 10

    }

  ]

}

POST /api/v1/products/:id/stock

Update product stock.



Path Parameters:



id: Product ID

Request Body:



{

  "quantity": -5

}

Validation Rules:



quantity: required, can be positive (add) or negative (reduce)

Response:



{

  "status": "success",

  "message": "Product stock updated successfully",

  "data": {

    "product_id": 1,

    "previous_stock": 25,

    "quantity_changed": -5,

    "current_stock": 20

  }

}

Service Management APIs

Service Categories

POST /api/v1/service-categories

Create a new service category.



Request Body:



{

  "name": "Engine Services",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Service category created successfully",

  "data": {

    "service_category_id": 1,

    "name": "Engine Services",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/service-categories

List all service categories with pagination.



Response:



{

  "status": "success",

  "message": "Service categories retrieved successfully",

  "data": [

    {

      "service_category_id": 1,

      "name": "Engine Services",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/service-categories/:id

Get service category by ID.



Path Parameters:



id: Service Category ID

Response:



{

  "status": "success",

  "message": "Service category retrieved successfully",

  "data": {

    "service_category_id": 1,

    "name": "Engine Services",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/service-categories/:id

Update service category.



Path Parameters:



id: Service Category ID

Request Body:



{

  "name": "Engine Services - Updated"

}

Response:



{

  "status": "success",

  "message": "Service category updated successfully",

  "data": {

    "service_category_id": 1,

    "name": "Engine Services - Updated",

    "status": "Aktif",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/service-categories/:id

Delete service category (soft delete).



Path Parameters:



id: Service Category ID

Response:



{

  "status": "success",

  "message": "Service category deleted successfully"

}

GET /api/v1/service-categories/:id/services

Get all services in a category.



Path Parameters:



id: Service Category ID

Response:



{

  "status": "success",

  "message": "Category services retrieved successfully",

  "data": [

    {

      "service_id": 1,

      "service_code": "ENG001",

      "name": "Engine Oil Change",

      "fee": 150000,

      "service_category_id": 1

    }

  ]

}

Services

POST /api/v1/services

Create a new service.



Request Body:



{

  "service_code": "ENG001",

  "name": "Engine Oil Change",

  "service_category_id": 1,

  "fee": 150000,

  "status": "Aktif"

}

Validation Rules:



service_code: required, unique

name: required

service_category_id: required, must exist

fee: required, must be positive number

status: optional (default: "Aktif")

Response:



{

  "status": "success",

  "message": "Service created successfully",

  "data": {

    "service_id": 1,

    "service_code": "ENG001",

    "name": "Engine Oil Change",

    "service_category_id": 1,

    "fee": 150000,

    "status": "Aktif",

    "service_category": {

      "service_category_id": 1,

      "name": "Engine Services"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/services

List all services with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Services retrieved successfully",

  "data": [

    {

      "service_id": 1,

      "service_code": "ENG001",

      "name": "Engine Oil Change",

      "service_category_id": 1,

      "fee": 150000,

      "status": "Aktif",

      "service_category": {

        "service_category_id": 1,

        "name": "Engine Services"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/services/:id

Get service by ID.



Path Parameters:



id: Service ID

Response:



{

  "status": "success",

  "message": "Service retrieved successfully",

  "data": {

    "service_id": 1,

    "service_code": "ENG001",

    "name": "Engine Oil Change",

    "service_category_id": 1,

    "fee": 150000,

    "status": "Aktif",

    "service_category": {

      "service_category_id": 1,

      "name": "Engine Services"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/services/:id

Update service information.



Path Parameters:



id: Service ID

Request Body:



{

  "name": "Engine Oil Change - Premium",

  "fee": 180000

}

Response:



{

  "status": "success",

  "message": "Service updated successfully",

  "data": {

    "service_id": 1,

    "service_code": "ENG001",

    "name": "Engine Oil Change - Premium",

    "fee": 180000,

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/services/:id

Delete service (soft delete).



Path Parameters:



id: Service ID

Response:



{

  "status": "success",

  "message": "Service deleted successfully"

}

GET /api/v1/services/code

Get service by code.



Query Parameters:



service_code: Service code

Response:



{

  "status": "success",

  "message": "Service retrieved successfully",

  "data": {

    "service_id": 1,

    "service_code": "ENG001",

    "name": "Engine Oil Change",

    "fee": 150000

  }

}

GET /api/v1/services/search

Search services by name or code.



Query Parameters:



q: Search query

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Services found",

  "data": [

    {

      "service_id": 1,

      "service_code": "ENG001",

      "name": "Engine Oil Change",

      "fee": 150000,

      "service_category": {

        "service_category_id": 1,

        "name": "Engine Services"

      }

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

Service Job Management APIs

The Service Job Management system handles the complete workflow of automotive service operations, from job creation to completion tracking.



Service Jobs

POST /api/v1/service-jobs

Create a new service job.



Request Body:



{

  "service_code": "SJ-2024-001",

  "customer_id": 1,

  "vehicle_id": 1,

  "user_id": 1,

  "outlet_id": 1,

  "service_date": "2024-01-01T09:00:00Z",

  "complaint": "Engine making strange noise",

  "diagnosis": "Need oil change and engine inspection",

  "estimated_cost": 500000,

  "status": "Pending",

  "notes": "Customer priority service"

}

Validation Rules:



service_code: required, unique

customer_id: required, must exist in customers table

vehicle_id: required, must exist in customer_vehicles table

user_id: required, must exist in users table

outlet_id: required, must exist in outlets table

service_date: required, ISO 8601 format

complaint: required

status: required, enum values: "Pending", "In Progress", "Completed", "Cancelled"

Response:



{

  "status": "success",

  "message": "Service job created successfully",

  "data": {

    "service_job_id": 1,

    "service_code": "SJ-2024-001",

    "customer_id": 1,

    "vehicle_id": 1,

    "user_id": 1,

    "outlet_id": 1,

    "service_date": "2024-01-01T09:00:00Z",

    "complaint": "Engine making strange noise",

    "diagnosis": "Need oil change and engine inspection",

    "estimated_cost": 500000,

    "actual_cost": 0,

    "status": "Pending",

    "notes": "Customer priority service",

    "customer": {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890"

    },

    "vehicle": {

      "vehicle_id": 1,

      "plate_number": "B1234XYZ",

      "brand": "Toyota",

      "model": "Avanza"

    },

    "user": {

      "user_id": 1,

      "name": "Mechanic John"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop"

    },

    "created_at": "2024-01-01T09:00:00Z",

    "updated_at": "2024-01-01T09:00:00Z"

  }

}

GET /api/v1/service-jobs

List all service jobs with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Service jobs retrieved successfully",

  "data": [

    {

      "service_job_id": 1,

      "service_code": "SJ-2024-001",

      "customer_id": 1,

      "vehicle_id": 1,

      "user_id": 1,

      "outlet_id": 1,

      "service_date": "2024-01-01T09:00:00Z",

      "complaint": "Engine making strange noise",

      "diagnosis": "Need oil change and engine inspection",

      "estimated_cost": 500000,

      "actual_cost": 450000,

      "status": "Completed",

      "customer": {

        "customer_id": 1,

        "name": "John Doe",

        "phone_number": "081234567890"

      },

      "vehicle": {

        "vehicle_id": 1,

        "plate_number": "B1234XYZ",

        "brand": "Toyota",

        "model": "Avanza"

      },

      "created_at": "2024-01-01T09:00:00Z",

      "updated_at": "2024-01-01T15:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/service-jobs/:id

Get service job by ID.



Path Parameters:



id: Service Job ID

Response:



{

  "status": "success",

  "message": "Service job retrieved successfully",

  "data": {

    "service_job_id": 1,

    "service_code": "SJ-2024-001",

    "customer_id": 1,

    "vehicle_id": 1,

    "user_id": 1,

    "outlet_id": 1,

    "service_date": "2024-01-01T09:00:00Z",

    "complaint": "Engine making strange noise",

    "diagnosis": "Need oil change and engine inspection",

    "estimated_cost": 500000,

    "actual_cost": 450000,

    "status": "Completed",

    "notes": "Customer priority service",

    "customer": {

      "customer_id": 1,

      "name": "John Doe",

      "phone_number": "081234567890",

      "address": "Jl. Sudirman No. 456"

    },

    "vehicle": {

      "vehicle_id": 1,

      "plate_number": "B1234XYZ",

      "brand": "Toyota",

      "model": "Avanza",

      "production_year": 2020

    },

    "user": {

      "user_id": 1,

      "name": "Mechanic John",

      "email": "mechanic@workshop.com"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop",

      "city": "Jakarta"

    },

    "service_details": [

      {

        "service_detail_id": 1,

        "service_id": 1,

        "quantity": 1,

        "unit_price": 150000,

        "subtotal": 150000

      }

    ],

    "created_at": "2024-01-01T09:00:00Z",

    "updated_at": "2024-01-01T15:00:00Z"

  }

}

PUT /api/v1/service-jobs/:id

Update service job information.



Path Parameters:



id: Service Job ID

Request Body:



{

  "diagnosis": "Oil change completed, engine inspection clean",

  "actual_cost": 450000,

  "notes": "Service completed successfully"

}

Response:



{

  "status": "success",

  "message": "Service job updated successfully",

  "data": {

    "service_job_id": 1,

    "service_code": "SJ-2024-001",

    "diagnosis": "Oil change completed, engine inspection clean",

    "actual_cost": 450000,

    "notes": "Service completed successfully",

    "updated_at": "2024-01-01T15:00:00Z"

  }

}

PUT /api/v1/service-jobs/:id/status

Update service job status.



Path Parameters:



id: Service Job ID

Request Body:



{

  "status": "In Progress",

  "status_notes": "Started working on the vehicle"

}

Response:



{

  "status": "success",

  "message": "Service job status updated successfully",

  "data": {

    "service_job_id": 1,

    "status": "In Progress",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

DELETE /api/v1/service-jobs/:id

Delete service job (soft delete).



Path Parameters:



id: Service Job ID

Response:



{

  "status": "success",

  "message": "Service job deleted successfully"

}

GET /api/v1/service-jobs/service-code

Get service job by service code.



Query Parameters:



service_code: Service code

Response:



{

  "status": "success",

  "message": "Service job retrieved successfully",

  "data": {

    "service_job_id": 1,

    "service_code": "SJ-2024-001",

    "customer_id": 1,

    "vehicle_id": 1,

    "status": "Completed",

    "service_date": "2024-01-01T09:00:00Z",

    "estimated_cost": 500000,

    "actual_cost": 450000

  }

}

GET /api/v1/service-jobs/status

Get service jobs by status.



Query Parameters:



status: Service job status

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Service jobs retrieved successfully",

  "data": [

    {

      "service_job_id": 1,

      "service_code": "SJ-2024-001",

      "status": "Completed",

      "service_date": "2024-01-01T09:00:00Z",

      "customer": {

        "customer_id": 1,

        "name": "John Doe"

      },

      "vehicle": {

        "vehicle_id": 1,

        "plate_number": "B1234XYZ"

      }

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customers/:customer_id/service-jobs

Get service jobs by customer.



Path Parameters:



customer_id: Customer ID

Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Customer service jobs retrieved successfully",

  "data": [

    {

      "service_job_id": 1,

      "service_code": "SJ-2024-001",

      "service_date": "2024-01-01T09:00:00Z",

      "status": "Completed",

      "estimated_cost": 500000,

      "actual_cost": 450000,

      "vehicle": {

        "vehicle_id": 1,

        "plate_number": "B1234XYZ",

        "brand": "Toyota",

        "model": "Avanza"

      }

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

Service Details

Service details represent individual services performed within a service job.



POST /api/v1/service-details

Create a new service detail.



Request Body:



{

  "service_job_id": 1,

  "service_id": 1,

  "quantity": 1,

  "unit_price": 150000,

  "discount": 0,

  "notes": "Standard oil change service"

}

Validation Rules:



service_job_id: required, must exist in service_jobs table

service_id: required, must exist in services table

quantity: required, must be positive number

unit_price: required, must be positive number

discount: optional, must be non-negative number

Response:



{

  "status": "success",

  "message": "Service detail created successfully",

  "data": {

    "service_detail_id": 1,

    "service_job_id": 1,

    "service_id": 1,

    "quantity": 1,

    "unit_price": 150000,

    "discount": 0,

    "subtotal": 150000,

    "notes": "Standard oil change service",

    "service": {

      "service_id": 1,

      "service_code": "ENG001",

      "name": "Engine Oil Change",

      "fee": 150000

    },

    "created_at": "2024-01-01T09:30:00Z",

    "updated_at": "2024-01-01T09:30:00Z"

  }

}

PUT /api/v1/service-details/:id

Update service detail.



Path Parameters:



id: Service Detail ID

Request Body:



{

  "quantity": 1,

  "unit_price": 180000,

  "discount": 10000,

  "notes": "Premium oil change service"

}

Response:



{

  "status": "success",

  "message": "Service detail updated successfully",

  "data": {

    "service_detail_id": 1,

    "service_job_id": 1,

    "service_id": 1,

    "quantity": 1,

    "unit_price": 180000,

    "discount": 10000,

    "subtotal": 170000,

    "notes": "Premium oil change service",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

DELETE /api/v1/service-details/:id

Delete service detail.



Path Parameters:



id: Service Detail ID

Response:



{

  "status": "success",

  "message": "Service detail deleted successfully"

}

GET /api/v1/service-jobs/:service_job_id/details

Get all service details for a service job.



Path Parameters:



service_job_id: Service Job ID

Response:



{

  "status": "success",

  "message": "Service job details retrieved successfully",

  "data": [

    {

      "service_detail_id": 1,

      "service_job_id": 1,

      "service_id": 1,

      "quantity": 1,

      "unit_price": 150000,

      "discount": 0,

      "subtotal": 150000,

      "notes": "Standard oil change service",

      "service": {

        "service_id": 1,

        "service_code": "ENG001",

        "name": "Engine Oil Change",

        "fee": 150000,

        "service_category": {

          "service_category_id": 1,

          "name": "Engine Services"

        }

      },

      "created_at": "2024-01-01T09:30:00Z",

      "updated_at": "2024-01-01T09:30:00Z"

    }

  ]

}

Service Job History

Service job history tracks status changes and important events throughout the service job lifecycle.



GET /api/v1/service-jobs/:service_job_id/histories

Get service job history.



Path Parameters:



service_job_id: Service Job ID

Response:



{

  "status": "success",

  "message": "Service job histories retrieved successfully",

  "data": [

    {

      "service_job_history_id": 1,

      "service_job_id": 1,

      "user_id": 1,

      "status_from": "Pending",

      "status_to": "In Progress",

      "notes": "Started working on the vehicle",

      "changed_at": "2024-01-01T10:00:00Z",

      "user": {

        "user_id": 1,

        "name": "Mechanic John"

      }

    },

    {

      "service_job_history_id": 2,

      "service_job_id": 1,

      "user_id": 1,

      "status_from": "In Progress",

      "status_to": "Completed",

      "notes": "Service completed successfully",

      "changed_at": "2024-01-01T15:00:00Z",

      "user": {

        "user_id": 1,

        "name": "Mechanic John"

      }

    }

  ]

}

Financial Management APIs

Payment Methods

POST /api/v1/payment-methods

Create a new payment method.



Request Body:



{

  "name": "Cash",

  "status": "Aktif"

}

Response:



{

  "status": "success",

  "message": "Payment method created successfully",

  "data": {

    "payment_method_id": 1,

    "name": "Cash",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/payment-methods

List all payment methods.



Response:



{

  "status": "success",

  "message": "Payment methods retrieved successfully",

  "data": [

    {

      "payment_method_id": 1,

      "name": "Cash",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    },

    {

      "payment_method_id": 2,

      "name": "Bank Transfer",

      "status": "Aktif",

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ]

}

GET /api/v1/payment-methods/:id

Get payment method by ID.



Path Parameters:



id: Payment Method ID

Response:



{

  "status": "success",

  "message": "Payment method retrieved successfully",

  "data": {

    "payment_method_id": 1,

    "name": "Cash",

    "status": "Aktif",

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/payment-methods/:id

Update payment method.



Path Parameters:



id: Payment Method ID

Request Body:



{

  "name": "Cash Payment - Updated"

}

Response:



{

  "status": "success",

  "message": "Payment method updated successfully",

  "data": {

    "payment_method_id": 1,

    "name": "Cash Payment - Updated",

    "status": "Aktif",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/payment-methods/:id

Delete payment method (soft delete).



Path Parameters:



id: Payment Method ID

Response:



{

  "status": "success",

  "message": "Payment method deleted successfully"

}

Transactions

POST /api/v1/transactions

Create a new transaction.



Request Body:



{

  "invoice_number": "INV-2024-001",

  "transaction_date": "2024-01-01T10:00:00Z",

  "user_id": 1,

  "customer_id": 1,

  "outlet_id": 1,

  "transaction_type": "Sale",

  "status": "sukses"

}

Validation Rules:



invoice_number: required, unique

transaction_date: required, ISO 8601 format

user_id: required, must exist

customer_id: optional, must exist if provided

outlet_id: required, must exist

transaction_type: required

status: required

Response:



{

  "status": "success",

  "message": "Transaction created successfully",

  "data": {

    "transaction_id": 1,

    "invoice_number": "INV-2024-001",

    "transaction_date": "2024-01-01T10:00:00Z",

    "user_id": 1,

    "customer_id": 1,

    "outlet_id": 1,

    "transaction_type": "Sale",

    "status": "sukses",

    "user": {

      "user_id": 1,

      "name": "John Doe"

    },

    "customer": {

      "customer_id": 1,

      "name": "Jane Smith"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/transactions

List all transactions with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Transactions retrieved successfully",

  "data": [

    {

      "transaction_id": 1,

      "invoice_number": "INV-2024-001",

      "transaction_date": "2024-01-01T10:00:00Z",

      "user_id": 1,

      "customer_id": 1,

      "outlet_id": 1,

      "transaction_type": "Sale",

      "status": "sukses",

      "user": {

        "user_id": 1,

        "name": "John Doe"

      },

      "customer": {

        "customer_id": 1,

        "name": "Jane Smith"

      },

      "outlet": {

        "outlet_id": 1,

        "outlet_name": "Main Workshop"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/transactions/:id

Get transaction by ID.



Path Parameters:



id: Transaction ID

Response:



{

  "status": "success",

  "message": "Transaction retrieved successfully",

  "data": {

    "transaction_id": 1,

    "invoice_number": "INV-2024-001",

    "transaction_date": "2024-01-01T10:00:00Z",

    "user_id": 1,

    "customer_id": 1,

    "outlet_id": 1,

    "transaction_type": "Sale",

    "status": "sukses",

    "user": {

      "user_id": 1,

      "name": "John Doe"

    },

    "customer": {

      "customer_id": 1,

      "name": "Jane Smith"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/transactions/:id

Update transaction.



Path Parameters:



id: Transaction ID

Request Body:



{

  "transaction_type": "Sale - Updated"

}

Response:



{

  "status": "success",

  "message": "Transaction updated successfully",

  "data": {

    "transaction_id": 1,

    "transaction_type": "Sale - Updated",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/transactions/:id

Delete transaction (soft delete).



Path Parameters:



id: Transaction ID

Response:



{

  "status": "success",

  "message": "Transaction deleted successfully"

}

GET /api/v1/transactions/invoice

Get transaction by invoice number.



Query Parameters:



invoice_number: Invoice number

Response:



{

  "status": "success",

  "message": "Transaction retrieved successfully",

  "data": {

    "transaction_id": 1,

    "invoice_number": "INV-2024-001",

    "transaction_date": "2024-01-01T10:00:00Z",

    "user_id": 1,

    "customer_id": 1,

    "outlet_id": 1,

    "transaction_type": "Sale",

    "status": "sukses"

  }

}

GET /api/v1/transactions/status

Get transactions by status.



Query Parameters:



status: Transaction status

Response:



{

  "status": "success",

  "message": "Transactions retrieved successfully",

  "data": [

    {

      "transaction_id": 1,

      "invoice_number": "INV-2024-001",

      "status": "sukses",

      "transaction_date": "2024-01-01T10:00:00Z"

    }

  ]

}

GET /api/v1/transactions/date-range

Get transactions by date range.



Query Parameters:



start_date: Start date (ISO 8601 format)

end_date: End date (ISO 8601 format)

page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Transactions retrieved successfully",

  "data": [

    {

      "transaction_id": 1,

      "invoice_number": "INV-2024-001",

      "transaction_date": "2024-01-01T10:00:00Z",

      "user_id": 1,

      "customer_id": 1,

      "outlet_id": 1,

      "transaction_type": "Sale",

      "status": "sukses",

      "user": {

        "user_id": 1,

        "name": "John Doe"

      },

      "customer": {

        "customer_id": 1,

        "name": "Jane Smith"

      }

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/customers/:id/transactions

Get transactions by customer.



Path Parameters:



id: Customer ID

Response:



{

  "status": "success",

  "message": "Customer transactions retrieved successfully",

  "data": [

    {

      "transaction_id": 1,

      "invoice_number": "INV-2024-001",

      "transaction_date": "2024-01-01T10:00:00Z",

      "transaction_type": "Sale",

      "status": "sukses"

    }

  ]

}

GET /api/v1/outlets/:id/transactions

Get transactions by outlet.



Path Parameters:



id: Outlet ID

Response:



{

  "status": "success",

  "message": "Outlet transactions retrieved successfully",

  "data": [

    {

      "transaction_id": 1,

      "invoice_number": "INV-2024-001",

      "transaction_date": "2024-01-01T10:00:00Z",

      "transaction_type": "Sale",

      "status": "sukses"

    }

  ]

}

Cash Flows

POST /api/v1/cash-flows

Create a new cash flow entry.



Request Body:



{

  "user_id": 1,

  "outlet_id": 1,

  "flow_type": "Pemasukan",

  "amount": 500000,

  "description": "Sale transaction payment",

  "flow_date": "2024-01-01T10:00:00Z"

}

Validation Rules:



user_id: required, must exist

outlet_id: required, must exist

flow_type: required, must be "Pemasukan" or "Pengeluaran"

amount: required, must be positive number

description: required

flow_date: required, ISO 8601 format

Response:



{

  "status": "success",

  "message": "Cash flow created successfully",

  "data": {

    "cash_flow_id": 1,

    "user_id": 1,

    "outlet_id": 1,

    "flow_type": "Pemasukan",

    "amount": 500000,

    "description": "Sale transaction payment",

    "flow_date": "2024-01-01T10:00:00Z",

    "user": {

      "user_id": 1,

      "name": "John Doe"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

GET /api/v1/cash-flows

List all cash flows with pagination.



Query Parameters:



page (optional): Page number (default: 1)

limit (optional): Items per page (default: 10)

Response:



{

  "status": "success",

  "message": "Cash flows retrieved successfully",

  "data": [

    {

      "cash_flow_id": 1,

      "user_id": 1,

      "outlet_id": 1,

      "flow_type": "Pemasukan",

      "amount": 500000,

      "description": "Sale transaction payment",

      "flow_date": "2024-01-01T10:00:00Z",

      "user": {

        "user_id": 1,

        "name": "John Doe"

      },

      "outlet": {

        "outlet_id": 1,

        "outlet_name": "Main Workshop"

      },

      "created_at": "2024-01-01T10:00:00Z",

      "updated_at": "2024-01-01T10:00:00Z"

    }

  ],

  "pagination": {

    "page": 1,

    "limit": 10,

    "total": 1,

    "pages": 1

  }

}

GET /api/v1/cash-flows/:id

Get cash flow by ID.



Path Parameters:



id: Cash Flow ID

Response:



{

  "status": "success",

  "message": "Cash flow retrieved successfully",

  "data": {

    "cash_flow_id": 1,

    "user_id": 1,

    "outlet_id": 1,

    "flow_type": "Pemasukan",

    "amount": 500000,

    "description": "Sale transaction payment",

    "flow_date": "2024-01-01T10:00:00Z",

    "user": {

      "user_id": 1,

      "name": "John Doe"

    },

    "outlet": {

      "outlet_id": 1,

      "outlet_name": "Main Workshop"

    },

    "created_at": "2024-01-01T10:00:00Z",

    "updated_at": "2024-01-01T10:00:00Z"

  }

}

PUT /api/v1/cash-flows/:id

Update cash flow.



Path Parameters:



id: Cash Flow ID

Request Body:



{

  "amount": 600000,

  "description": "Updated sale transaction payment"

}

Response:



{

  "status": "success",

  "message": "Cash flow updated successfully",

  "data": {

    "cash_flow_id": 1,

    "amount": 600000,

    "description": "Updated sale transaction payment",

    "updated_at": "2024-01-01T11:00:00Z"

  }

}

DELETE /api/v1/cash-flows/:id

Delete cash flow (soft delete).



Path Parameters:



id: Cash Flow ID

Response:



{

  "status": "success",

  "message": "Cash flow deleted successfully"

}

GET /api/v1/cash-flows/type

Get cash flows by type.



Query Parameters:



type: Flow type ("Pemasukan" or "Pengeluaran")

Response:



{

  "status": "success",

  "message": "Cash flows retrieved successfully",

  "data": [

    {

      "cash_flow_id": 1,

      "flow_type": "Pemasukan",

      "amount": 500000,

      "description": "Sale transaction payment",

      "flow_date": "2024-01-01T10:00:00Z"

    }

  ]

}

