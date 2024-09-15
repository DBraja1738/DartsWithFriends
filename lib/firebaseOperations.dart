import "package:cloud_firestore/cloud_firestore.dart";

Future<DocumentSnapshot> getUserByEmail(String email) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Return the first matching document
      return querySnapshot.docs.first;
    } else {
      throw Exception('No user found with that email.');
    }
  } catch (e) {
    print('Failed to fetch user: $e');
    rethrow;
  }
}

void fetchWinnerUserAndUpdate(String email) async {
  try {
     // Replace with the email you want to query
    DocumentSnapshot userDoc = await getUserByEmail(email);

    // Access user data from the document
    var userData = userDoc.data() as Map<String, dynamic>;
    print('User Data: ${userData['uid']}');

    int currentWins = userData["wins"] ?? 0;
    int currentGames = userData["numberOfGames"] ?? 0;

    int updatedWins = currentWins+1;
    int updatedGames = currentGames+1;
    double updatedWinrate = (updatedWins/updatedGames)*100;

    DocumentReference userRef = userDoc.reference;
    await userRef.update({
      "wins": updatedWins,
      "numberOfGames": updatedGames,
      "winrate": updatedWinrate,
    });

  } catch (e) {
    print('Error fetching user: $e');
  }
}

void fetchLoserUserAndUpdate(String email) async {
  try {
    // Replace with the email you want to query
    DocumentSnapshot userDoc = await getUserByEmail(email);

    // Access user data from the document
    var userData = userDoc.data() as Map<String, dynamic>;
    print('User Data: ${userData['uid']}');

    int currentWins = userData["wins"] ?? 0;
    int currentGames = userData["numberOfGames"] ?? 0;


    int updatedGames = currentGames+1;
    double updatedWinrate = (currentWins/updatedGames)*100;



    DocumentReference userRef = userDoc.reference;
    await userRef.update({
      "wins": currentWins,
      "numberOfGames": updatedGames,
      "winrate": updatedWinrate,
    });

  } catch (e) {
    print('Error fetching user: $e');
  }
}
