import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_auth/entities/Users.dart';
import 'package:phone_auth/util/constants.dart';

import 'auth_service.dart';

class DatabaseService {

  DatabaseService(this.authService) {
    uid = authService.getUser()?.uid;
    print("Setting UID ......... $uid");
  }

  static var dbInstance;
  String uid;
  final AuthService authService;

  static FirebaseFirestore init() {
    dbInstance = FirebaseFirestore.instance;
    return dbInstance;
  }

  Future<void> saveObj(var uid, Users object) async {
    return dbInstance.collection(Constants.users_coll).doc(uid).set(object.toJson());
  }

  // Future<UserProfile> getUserProfile() async {
  //   DocumentReference docRef = await dbInstance
  //       .collection('profiles ')
  //       .document(authService.getUser()?.uid);
  //   var docSnap = await docRef.get();
  //   return UserProfile.fromJson(docSnap.data());
  // }
  //
  // Future<List<OfferedRide>> getRides() async {
  //   CollectionReference collectionRef = await dbInstance.collection('rides');
  //   print(collectionRef.id);
  //   QuerySnapshot querySnapshot = await collectionRef.get();
  //   print(querySnapshot.toString());
  //   List<QueryDocumentSnapshot> docs = await querySnapshot.docs;
  //   print(docs.length.toString());
  //   var docData = await docs.map((doc) => doc.data());
  //   print(docData.length.toString());
  //   var rides = await docData.map((jsonRide) => OfferedRide.fromJson(jsonRide));
  //   print(rides.length.toString());
  //   rides.toList().forEach((element) {print(element.toString());});
  //   return await rides.toList();
  // }
  //
  // Future<void> saveCar(Car car) async {
  //   var collectionRef = await dbInstance.collection('profiles');
  //   var documentRef = await collectionRef.doc(uid);
  //   var carsCollectionRef = await documentRef.collection('cars');
  //   var addResult = carsCollectionRef.add(car.toJson());
  //   // var res = carDocs.;
  //   // return res;
  //   // print(docs.runtimeType);
  //   return addResult;
  // }
  //
  // Future<void> saveRide(OfferedRide ride) async {
  //   var collectionRef = await dbInstance.collection('rides');
  //   var addResult = collectionRef.add(ride.toJson());
  //   return addResult;
  // }
  //
  // Future<List<Car>> getCars() async {
  //   DocumentReference docRef = await dbInstance.collection('profiles').doc(uid);
  //   var querySnapShot = await docRef.collection('cars').get();
  //   return await querySnapShot.docs
  //       .map((doc) => doc.data())
  //       .map((map) => Car.fromJson(map))
  //       .toList();
  // }
}
