import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/colors.dart';
import '../../auth/widgets/auth_background.dart';
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

  List<dynamic> get _filteredNotifications {
    if (!_isShowingUnreadOnly) return _notifications;

    return _notifications.where((n) => n['is_unread'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,

      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/Logotransparan.png',
            fit: BoxFit.contain,
          ),
        ),

        leadingWidth: 48,

        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primaryGold,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: AuthBackground(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                border: Border.all(color: AppColors.primaryGold, width: 1),
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
                        color: AppColors.primaryGold,
                      ),
                    )
                  : _filteredNotifications.isEmpty
                  ? const Center(
                      child: Text(
                        "Tidak ada notifikasi saat ini",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchNotifications,
                      color: AppColors.primaryGold,

                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),

                        itemCount: _filteredNotifications.length,

                        itemBuilder: (context, index) {
                          final notif = _filteredNotifications[index];

                          return _buildNotificationItem(
                            notif['title'],
                            notif['sub'],
                            notif['time'],
                            notif['code'].toString(),
                            notif['is_unread'],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
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
            color: isActive
                ? AppColors.primaryGold.withOpacity(0.12)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(16),

            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.primaryGold : Colors.transparent,
                width: 3,
              ),
            ),
          ),

          child: Text(
            title,
            textAlign: TextAlign.center,

            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.primaryNavy : Colors.grey,
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
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentDetailsPage(orderId: code),
          ),
        ).then((_) {
          _fetchNotifications();
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isUnread ? AppColors.primaryGold : Colors.grey.shade200,
            width: 1.2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,

              decoration: BoxDecoration(
                color: isUnread
                    ? AppColors.primaryGold.withOpacity(0.15)
                    : Colors.grey.shade100,

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                Icons.shopping_bag_outlined,
                color: isUnread ? AppColors.primaryNavy : Colors.grey,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    sub,

                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: isUnread
                          ? AppColors.primaryGold
                          : Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(8),
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

            const SizedBox(width: 10),

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
