import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'Auth.dart';

class FirebaseOperations with ChangeNotifier {
  String initUserName, initUserAvatar, initUserSurename;

  String get getInitUserName => initUserName;
  String get getInitUserSurename => initUserSurename;
  String get getInitUserAvatar => initUserAvatar;

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .get()
        .then((doc) {
      print("Fetching user data");
      initUserName = doc.data()['name'];
      initUserSurename = doc.data()['surename'];
      initUserAvatar = doc.data()['avatar'];
      print(initUserName);
      print(initUserSurename);
      print(initUserAvatar);
      notifyListeners();
    });
  }

  Future deleteUserData(
    String userUid,
    dynamic collection,
  ) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future deleteUserPostData(BuildContext context, String postId) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .collection("Posts")
        .doc(postId)
        .delete();
  }

  Future deleteUser(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(Provider.of<CurrentUser>(context, listen: false).getUid)
        .delete();
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(followingUid)
        .collection("followers")
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("Users")
          .doc(followerUid)
          .collection("following")
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future deletefollowUser(
    String followingUid,
    String followingDocId,
    String followerUid,
    String followerDocId,
  ) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(followingUid)
        .collection("followers")
        .doc(followingDocId)
        .delete()
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection("Users")
          .doc(followerUid)
          .collection("following")
          .doc(followerDocId)
          .delete();
    });
  }

  Future followClimb(
      BuildContext context, String climbId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection("Climb")
        .doc(climbId)
        .collection("followers")
        .doc(subDocId)
        .set({
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "Time": Timestamp.now(),
    });
  }

  Future followingUserClimb(
      BuildContext context, String climbId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(subDocId)
        .collection("followers")
        .doc(climbId)
        .set({
      "name": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      "Uid": Provider.of<CurrentUser>(context, listen: false).getUid,
      "avatar": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserAvatar,
      "Surename": Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserSurename,
      "Time": Timestamp.now(),
    });
  }

  Future deleteFollowClimb(
      BuildContext context, String climbId, String subDocId) async {
    await FirebaseFirestore.instance
        .collection("Climb")
        .doc(climbId)
        .collection("followers")
        .doc(subDocId)
        .delete();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(
          Provider.of<CurrentUser>(context, listen: false).getUid,
        )
        .collection("FollowClimb")
        .doc(climbId)
        .delete();
  }

  Future deleteUserClimbData(BuildContext context, String climbId) async {
    await FirebaseFirestore.instance.collection("Climb").doc(climbId).delete();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(
          Provider.of<CurrentUser>(context, listen: false).getUid,
        )
        .collection("Climb")
        .doc(climbId)
        .delete();
  }
}
