import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/colors.dart';
import 'rent_details_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isShowingUnreadOnly = true;
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      // Menggunakan localhost untuk testing di Web (Chrome)
      final response = await http.get(
        Uri.parse("http://localhost/api_penyewaan/get_notifications.php"),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            _notifications = result['data'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Filter notifikasi berdasarkan Tab yang dipilih
  List<dynamic> get _filteredNotifications {
    if (!_isShowingUnreadOnly) return _notifications;
    return _notifications.where((n) => n['is_unread'] == true).toList();
  }

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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryNavy,
                    ),
                  )
                : _filteredNotifications.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada notifikasi saat ini",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchNotifications,
                    color: AppColors.primaryNavy,
                    child: ListView.builder(
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notif = _filteredNotifications[index];
                        return _buildNotificationItem(
                          notif['title'],
                          notif['sub'],
                          notif['time'], // Menampilkan tanggal pesanan
                          notif['code'].toString(),
                          notif['is_unread'],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    String title, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
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

  Widget _buildNotificationItem(
    String title,
    String sub,
    String time,
    String code,
    bool isUnread,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentDetailsPage(orderId: code),
          ),
        ).then((_) {
          // Refresh notifikasi setelah menutup halaman detail (berjaga-jaga jika admin mengubah status)
          _fetchNotifications();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Memberikan warna background berbeda jika belum dibaca
          color: isUnread ? const Color(0xFFFDF6E9) : Colors.white,
          border: const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: isUnread ? AppColors.primaryNavy : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isUnread
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isUnread ? Colors.black : Colors.black87,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      color: isUnread ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isUnread
                          ? AppColors.primaryGold
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "ID: $code",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isUnread ? Colors.black : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
