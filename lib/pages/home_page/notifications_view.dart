import 'package:get/get.dart';
import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/components/profile_icon.dart';
import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:livrodin/controllers/notification_controller.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final NotificationController _notificationController =
      Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _notificationController.getFilledNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(pageRadius),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: lightGrey,
        ),
        child: Column(
          children: [
            PageTitle(
              title: "Notificações",
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_rounded),
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: _notificationController.deleteAllNotifications,
                  icon: const Icon(Icons.clear_all_rounded),
                ),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  Obx(
                    () => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          var notificationFilled = _notificationController
                              .notificationsFilled[index];
                          return GestureDetector(
                            onTap: () {
                              _notificationController.deleteNotification(
                                notificationFilled.notification.id,
                              );
                              Get.toNamed("/profile");
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ProfileIcon(
                                        image: notificationFilled
                                            .user.profilePictureUrl,
                                        size: ProfileSize.lg,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notificationFilled.user.name,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formatDate(notificationFilled
                                                    .notification.createdAt)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Enviou uma mensagem",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount:
                            _notificationController.notificationsFilled.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
