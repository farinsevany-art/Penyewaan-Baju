import 'package:flutter/material.dart';

class StatusUpdateSheet extends StatefulWidget {
  final String currentStatus;
  final Function(String) onSave;

  const StatusUpdateSheet({super.key, required this.currentStatus, required this.onSave});

  @override
  State<StatusUpdateSheet> createState() => _StatusUpdateSheetState();
}

class _StatusUpdateSheetState extends State<StatusUpdateSheet> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar di bagian atas
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ubah Status Pesanan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
          ),
          const Text('Kelola tahapan penyewaan kostum', style: TextStyle(color: Colors.orangeAccent)),
          const SizedBox(height: 20),

          // Daftar Opsi Status
          _buildOption('Menunggu Deposit', 'Awaiting Deposit', Icons.account_balance_wallet_outlined),
          _buildOption('Diproses', 'Processing', Icons.sync_rounded),
          _buildOption('Aktif/Disewa', 'Active/Rented', Icons.check_circle_outline),
          _buildOption('Selesai/Kembali', 'Completed/Returned', Icons.assignment_returned_outlined),
          _buildOption('Dibatalkan', 'Cancelled', Icons.cancel_outlined),

          const SizedBox(height: 20),

          // Tombol Simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                widget.onSave(selectedStatus); // Kirim data kembali ke halaman utama
                Navigator.pop(context); // Tutup pop-up
              },
              icon: const Icon(Icons.save_outlined, color: Colors.orangeAccent),
              label: const Text('Simpan Perubahan', style: TextStyle(color: Colors.orangeAccent, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A234E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, String subtitle, IconData icon) {
    bool isSelected = selectedStatus == title;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.orangeAccent : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: title,
        groupValue: selectedStatus,
        onChanged: (val) => setState(() => selectedStatus = val!),
        activeColor: Colors.orange,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        secondary: Icon(icon, color: isSelected ? Colors.orangeAccent : Colors.orange.withOpacity(0.4)),
      ),
    );
  }
}