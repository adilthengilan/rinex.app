class NotificationService {
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
  }) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(userId)
        .collection('items')
        .add({
          'title': title,
          'message': message,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }
}
