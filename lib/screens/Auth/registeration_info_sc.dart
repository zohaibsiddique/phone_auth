import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:phone_auth/entities/Place.dart';
import 'package:phone_auth/entities/Users.dart';
import 'package:phone_auth/services/database_service.dart';
import 'package:phone_auth/ui_components/img_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../main.dart';
import '../home/home_sc.dart';
import 'file:///G:/Projects/Flutter/phone_auth/lib/screens/Auth/registeration_info_sc.dart';
import 'package:phone_auth/services/auth_service.dart';
import 'package:phone_auth/ui_components/main_button.dart';
import 'package:phone_auth/util/colors.dart';
import 'package:phone_auth/util/constants.dart';
import 'package:phone_auth/util/styles.dart';
import 'package:phone_auth/util/util.dart';
import 'package:provider/provider.dart';


class RegistrationInfoSC extends StatefulWidget {
  static String route = '/reg_info';
  @override
  _RegistrationInfoSCState createState() => _RegistrationInfoSCState();
}

class _RegistrationInfoSCState extends State<RegistrationInfoSC> {

  AuthService authService; DatabaseService dbService;
  var UID;

  static List<Place> places = [
    Place(name: "Multan"),
    Place(name: "Chashma"),
    Place(name: "Faislabad"),
    Place(name: "Islamabad"),
    Place(name: "Lahore"),
  ];

  final _placesList = places.map((place) => MultiSelectItem<Place>(place, place.name)).toList();
  List<Place> _selectedPlaces = [];


  @override
  void initState() {
    authService = context.read<AuthService>();
    dbService = context.read<DatabaseService>();
    UID = authService.getUser()?.uid;

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool isMale = false;
  String dateOfBirth = "";
  String _imagePath = "";
  String uploadedPath = "";
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();

  Future uploadFile() async {
    try {
      Util.showProgressDialog(context);
      Reference storageReference = FirebaseStorage.instance.ref().child(UID);
      UploadTask uploadTask = storageReference.putFile(File(_imagePath));
      await uploadTask.then((e) {print("Upload Complete ${e.toString()}");});
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
            print("File URL ${fileURL.toString()}");
            uploadedPath = fileURL.toString();
          });
      Util.pop(context);
    } catch (e) {
      Util.pop(context);
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {if (pickedFile != null) {_imagePath = pickedFile.path;} else {}});

    uploadFile().timeout(Duration(seconds: 30), onTimeout:(){
      Util.pop(context);
      setState(() {_imagePath = "";});
      Util.showToastMessage(Constants.upload_image_error, Colors.white, Colors.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Constants.let_us_know, style: Styles.screenTitle,),
                SizedBox(height: 30,),
                Center(child: ImgPicker(width: 100,height: 100, onTap: getImage, path: _imagePath,)),
                SizedBox(height: 20,),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: Constants.your_name,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
                  validator: (value) => value.isEmpty ? Constants.error_empty : null,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Constants.gender, style: Styles.sectionTitle,),
                    GroupButton(
                      spacing: 5,
                      isRadio: true,
                      direction: Axis.horizontal,
                      onSelected: (index, isSelected) {
                        isMale = index == 0 ? true : false;
                      },
                      buttons: [Constants.male, Constants.female],
                      selectedTextStyle: Styles.selectedTextStyle,
                      unselectedTextStyle: Styles.unselectedTextStyle,
                      selectedColor: Colors.white,
                      unselectedColor: Colors.grey[300],
                      selectedBorderColor: primaryColor,
                      unselectedBorderColor: Colors.grey[500],
                      borderRadius: BorderRadius.circular(5.0),
                      selectedShadow: <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                      unselectedShadow: <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                DateTimeField(
                  decoration: InputDecoration(
                    labelText: Constants.date_birth,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (date){dateOfBirth = date.toString();},
                  format: Util.formatDate(),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(context: context, firstDate: DateTime(1900), initialDate: currentValue ?? DateTime.now(), lastDate: DateTime(2100),);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                MultiSelectBottomSheetField(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  searchable: true,
                  buttonText: Text("Interests"),
                  title: Text("Places"),
                  items: _placesList,
                  onConfirm: (values) {
                    _selectedPlaces = values;
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedPlaces.remove(value);
                      });
                    },
                  ),
                ),
                _selectedPlaces == null || _selectedPlaces.isEmpty ? Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "None selected",
                      style: TextStyle(color: Colors.black54),
                    )) : Container()
                ,
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    MainButton(
                      text: Constants.continuee.toUpperCase(),
                      OnPressed: () {
                          if (_formKey.currentState.validate()) {
                            Util.showProgressDialog(context);
                            try{
                              var interests = [];
                              _selectedPlaces.forEach((element) {
                                interests.add(element.name);
                              });

                              var object = Users(name: nameController.text, dob: dateOfBirth, gender: isMale,
                                  image:uploadedPath, interests: FieldValue.arrayUnion(interests));

                              dbService.saveObj(UID, object).then((value){
                                Util.pop(context); // hide progress dialog
                                print("user added");
                                Util.potUntil(context, MyApp.route);
                                Util.navigate(context, HomeSC.route);
                              });
                            } on Exception catch(e){
                              Util.pop(context);
                              Util.showSnackBarWithContext(context, e.toString(), Constants.ok, 10);
                            }
                          } else {}
                      },
                      width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
