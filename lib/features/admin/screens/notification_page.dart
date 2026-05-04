import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'rent_details_page.dart'; // Pastikan path import ini benar

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isShowingUnreadOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                _buildTabItem(
                  "Belum Dibaca",
                  isActive: _isShowingUnreadOnly,
                  onTap: () => setState(() => _isShowingUnreadOnly = true),
                ),
                _buildTabItem(
                  "Semua",
                  isActive: !_isShowingUnreadOnly,
                  onTap: () => setState(() => _isShowingUnreadOnly = false),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: _isShowingUnreadOnly
                  ? _buildUnreadList()
                  : _buildAllList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primaryNavy : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUnreadList() {
    return [
      _buildSectionHeader("HARI INI"),
      _buildNotificationItem("Pesanan Baru", "Menyewa kostum 'Anoman'", "2m lalu", "#CR-8821"),
      _buildNotificationItem("Pesanan Baru", "Menyewa kostum 'Clara I'", "1j lalu", "#CR-8795"),
    ];
  }

  List<Widget> _buildAllList() {
    return [
      ..._buildUnreadList(),
      _buildSectionHeader("KEMARIN"),
      _buildNotificationItem("Pesanan Baru", "Menyewa 'Raja dan Ratu'", "1h lalu", "#CR-8642"),
      _buildNotificationItem("Pesanan Baru", "Menyewa 'Shinta'", "1h lalu", "#CR-8511"),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.offWhite,
      child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildNotificationItem(String title, String sub, String time, String code) {
    return InkWell( // Menggunakan InkWell agar ada efek tekan (ripple)
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentDetailsPage(orderId: code),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFFDF6E9),
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            const Icon(Icons.shopping_bag_outlined),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sub),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(4)),
                    child: Text(code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}