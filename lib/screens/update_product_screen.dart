import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/view_product_screen.dart';
import 'package:product_manager/utils/firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductScreen extends StatefulWidget {
  final String patientId;
  final User _user;

  const UpdateProductScreen(
      {Key? key, required User user, required this.patientId})
      : _user = user,
        super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  DateTime dateTime = DateTime(2023, 01, 19);
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pageNumberController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final FocusNode _dateOfBirthFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> userId;
  late String currentUserId = '';
  bool _isLoaded = false;

  final _firstNameKey = GlobalKey();
  final _lastNameKey = GlobalKey();
  final _dateOfBirthNameKey = GlobalKey();
  final _phoneNumberKey = GlobalKey();
  final _pageNumberKey = GlobalKey();

  final String requireFieldValidateMsg =
      "patient_page.require_field_validate_msg".tr();
  String formTitle = "patient_page.form_title".tr();

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneNumberController.dispose();
    _pageNumberController.dispose();
    _dateOfBirthFocusNode.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = _prefs.then((SharedPreferences prefs) {
      currentUserId = prefs.getString('uid') ?? '';
      return prefs.getString('uid') ?? '';
    });
    getPatientInfo();
  }

  Future getPatientInfo() async {
    product? patient =
        await FireStore.getEntryById('patient', widget.patientId);
    if (patient != null) {
      _firstNameController.text = patient.firstName!;
      _lastNameController.text = patient.lastName!;
      _pageNumberController.text = patient.pageNumber!;
      _phoneNumberController.text = patient.phoneNumber!;
      _dateOfBirthController.text = patient.dateOfBirth!;
    }
    setState(() {
      _isLoaded = true;
    });
  }

  Future savePatient() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      } else {
        product patient = product(
            widget.patientId,
            _firstNameController.text,
            _lastNameController.text,
            _dateOfBirthController.text,
            _phoneNumberController.text,
            _pageNumberController.text,
            currentUserId);
        FireStore.updateEntryWithId(
                'patient', widget.patientId, patient.toMap())
            .then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ViewProductScreen(user: widget._user),
            ),
          );
        });
        // showSuccessAlert(context);
      }
    } catch (error) {
      // executed for errors of all types other than Exception
      print(error);
      // showErrorAlert(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: !_isLoaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background.jpg"),
                        fit: BoxFit.cover,
                        opacity: 0.4,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: _firstNameKey,
                            controller: _firstNameController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return requireFieldValidateMsg;
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "patient_page.first_name".tr(),
                              prefixIcon: const Icon(Icons
                                  .person), // Add person icon for first name
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            key: _lastNameKey,
                            controller: _lastNameController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return requireFieldValidateMsg;
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "patient_page.last_name".tr(),
                              prefixIcon: const Icon(Icons
                                  .person), // Add person icon for last name
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            key: _dateOfBirthNameKey,
                            controller: _dateOfBirthController,
                            focusNode: _dateOfBirthFocusNode,
                            validator: (String? value) {
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "patient_page.date_of_birth".tr(),
                              prefixIcon: Icon(Icons.calendar_today),
                              // Add calendar icon for date of birth
                              hintText:
                                  '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                              // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                            ),
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: dateTime,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                              if (newDate == null) return;
                              setState(() {
                                dateTime = newDate;
                                _dateOfBirthController.text =
                                    '${dateTime.day}/${dateTime.month}/${dateTime.year}'; // Tarih değerini kaydet
                              });
                            },
                            onEditingComplete: () {
                              _dateOfBirthFocusNode
                                  .unfocus(); // Form alanından çıkıldığında (tarih seçiminden sonra), odak durumunu kaldırır.
                            },
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            key: _pageNumberKey,
                            controller: _pageNumberController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return requireFieldValidateMsg;
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "patient_page.page_number".tr(),
                              prefixIcon: const Icon(Icons
                                  .pages), // Add pages icon for page number
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            key: _phoneNumberKey,
                            controller: _phoneNumberController,
                            validator: (String? value) {
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "patient_page.phone_number".tr(),
                              prefixIcon: const Icon(
                                  Icons.phone), // Add the phone icon here
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Expanded(child: Container()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FloatingActionButton(
                                tooltip: 'general.save'.tr(),
                                onPressed: () async {
                                  await savePatient();
                                },
                                child: const Icon(Icons.save),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  var navigator = Navigator.of(context);
                                  navigator.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewProductScreen(user: widget._user),
                                    ),
                                  );
                                },
                                tooltip: 'general.back'.tr(),
                                child: const Icon(Icons.arrow_back_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ],
                ),
        ),
      ),
    );
  }
}
// ElevatedButton.icon(
// icon: const Icon(Icons.save),
// label: Text('general.save'.tr()),
// onPressed: () async {
// await savePatient();
// }),
