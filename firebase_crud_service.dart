import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCrudService {
  final CollectionReference playerCollection =
      FirebaseFirestore.instance.collection('playerProfiles');

  // CREATE: Add a new player profile
  Future<void> createPlayerProfile(String playerId, Map<String, dynamic> profileData) async {
    try {
      await playerCollection.doc(playerId).set(profileData);
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  // READ: Fetch a player's profile by ID
  Future<Map<String, dynamic>?> readPlayerProfile(String playerId) async {
    try {
      DocumentSnapshot doc = await playerCollection.doc(playerId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  // UPDATE: Update a player's profile
  Future<void> updatePlayerProfile(String playerId, Map<String, dynamic> updates) async {
    try {
      await playerCollection.doc(playerId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // DELETE: Remove a player's profile
  Future<void> deletePlayerProfile(String playerId) async {
    try {
      await playerCollection.doc(playerId).delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }
}
