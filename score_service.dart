import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the best score for a specific user
  Future<int> fetchBestScore(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc['bestScore'] ?? 0;
      }
    } catch (e) {
      print("Error fetching best score: $e");
    }
    return 0;
  }

  /// Update the best score for a specific user
  Future<void> updateBestScore(String userId, int newScore) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userId);
      await userDoc.set({'bestScore': newScore}, SetOptions(merge: true));
    } catch (e) {
      print("Error updating best score: $e");
    }
  }
}
