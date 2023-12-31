import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:multiselect/multiselect.dart';
import '../../DateModels/PatientAdultModel.dart';
import '../../DateModels/patient_childmodel.dart';
import '../../DateModels/pharmacy_model.dart';
import '../../component/component.dart';
import '../../network/my_database.dart';
import '../../widgets/appbar.dart';
import '../../widgets/my_button.dart';
import '../../widgets/text_Filed.dart';

class Addtreatment extends StatefulWidget {
  static const String screenRoute = 'Addtreatment';

  const Addtreatment({Key? key}) : super(key: key);

  @override
  State<Addtreatment> createState() => _AddtreatmentState();
}

TextEditingController codeController = TextEditingController();
bool child = false;
bool adult = false;
String selectedPatient = "";

class _AddtreatmentState extends State<Addtreatment> {
  String scanBarcode = 'BarCode Number';
  TextEditingController codeDrug = TextEditingController();
  TextEditingController nameDrug = TextEditingController();
  TextEditingController nameUnCheckedDrug = TextEditingController();
  List<PharmacyModel>? checkDrug = [];
  List<PharmacyModel>? uncheckDrug = [];
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

  List<String> selectedDrug = [];

  @override
  Widget build(BuildContext context) {
    PatientAdultModel patientAd = PatientAdultModel();
    PatientChildModel patientCh = PatientChildModel();
     PharmacyModel drugScan= PharmacyModel();
    return Scaffold(
      appBar: PreferredSize(
        child: appBardefult(
          context: context,
          data: 'Pharmacy',
          icon: Icon(Icons.menu),
        ),
        preferredSize: Size(100, 50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            sizedBoxhight(hight: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      width: 270,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey,
                      ),
                      child: Column(
                        children: [
                          sizedBoxhight(hight: 10),
                          Flexible(
                              flex: 3,
                              child: defultText(
                                  data: 'Select patient do u need search for',
                                  c: Colors.black,
                                  x: 15)),
                          sizedBoxhight(hight: 35),
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: defultText(
                                        data: 'Child', c: Colors.white)),
                                Flexible(
                                    flex: 1,
                                    child: Checkbox(
                                        value: child,
                                        onChanged: (val) {
                                          setState(() {
                                            child = val!;
                                            adult = false;
                                            if (val) {
                                              selectedPatient = "ch";
                                            }
                                          });
                                        })),
                                Flexible(
                                    flex: 1,
                                    child: defultText(
                                        data: 'Adult', c: Colors.white)),
                                Flexible(
                                    flex: 1,
                                    child: Checkbox(
                                        value: adult,
                                        onChanged: (val) {
                                          setState(() {
                                            adult = val!;
                                            child = false;
                                            if (val) {
                                              selectedPatient = "ad";
                                            }
                                          });
                                        })),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
            sizedBoxhight(hight: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: defultText(data: 'Search')),
                sizedBoxWidth(width: 20),
                Flexible(
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                sizedBoxWidth(width: 20),
                Flexible(
                    child: Container(
                  width: 100,
                  height: 50,
                  child: mysignin(
                    color: Colors.green,
                    title: 'search',
                    size: 18,
                    onPressed: () {
                      setState(() {});
                      print(codeController.text);
                    },
                  ),
                ))
              ],
            ),
            sizedBoxhight(hight: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 1,
                    child: selectedPatient == "ad"
                        ? StreamBuilder<QuerySnapshot<PatientAdultModel>>(
                            stream:
                                MyDataBase.getPatientAdult(codeController.text),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text('No patient data found!');
                              } else {
                                patientAd = snapshot.data!.docs[0].data();
                                print("data ${patientAd.screening}");
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 1000,
                                  height: 80,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: defultText(
                                            data:
                                                "Patient’s Name: ${patientAd.nameAdultPatient}",
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                        sizedBoxWidth(width: 300),
                                        Flexible(
                                          flex: 1,
                                          child: defultText(
                                            data:
                                                'Code: ${patientAd.codeAdultPatient}',
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                        sizedBoxWidth(width: 50),
                                        Flexible(
                                          flex: 1,
                                          child: defultText(
                                            data:
                                                'Sex: ${patientAd.sexAdultPatient}',
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : StreamBuilder<QuerySnapshot<PatientChildModel>>(
                            stream:
                                MyDataBase.getPatientChild(codeController.text),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text('No patient data found!');
                              } else {
                                patientCh = snapshot.data!.docs[0].data();
                                print("data ${patientAd.screening}");
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 1000,
                                  height: 80,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: defultText(
                                            data:
                                                "Patient’s Name: ${patientCh.nameChildPatient}",
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                        sizedBoxWidth(width: 300),
                                        Flexible(
                                          flex: 1,
                                          child: defultText(
                                            data:
                                                'Code: ${patientCh.codeChildPatient}',
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                        sizedBoxWidth(width: 50),
                                        Flexible(
                                          flex: 1,
                                          child: defultText(
                                            data:
                                                'Sex: ${patientCh.sexChildPatient}',
                                            c: Colors.black,
                                            x: 19,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          )),
              ],
            ),
            sizedBoxhight(hight: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    
                    defultTextField(width: 150, text: 'Scanner',controller: codeDrug),
                    // Container(
                    //   decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(8),border: Border.all(color: Colors.green)),
                    //   padding: EdgeInsets.all(8),
                    //   width: 200,
                    //   height: 50,
                    //   child: TextField(
                    //     controller: codeDrug,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         codeDrug.text = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                   
                    StreamBuilder<QuerySnapshot<PharmacyModel>>(
                        stream: MyDataBase.getDrug(codeDrug.text),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Text('No Medicine data found!');
                          } else {
                              drugScan =
                                snapshot.data!.docs[0].data();

                            print("name drug ${drugScan.nameDrug}");
                            return Text("drug checked ${drugScan.nameDrug}");
                          }
                        }),
                    Container(
                      width: 100,
                      height: 50,
                      child: mysignin(
                        color: Colors.green,
                        title: 'Scan',
                        size: 18,
                        onPressed: () {
                          setState(() {});
                          addToList(drugScan);
                          drugScan.numberDrug = drugScan.numberDrug!-1;
                          MyDataBase.updateDrug(drugScan);

                        },
                      ),
                    ),
                    defultTextField(
                        width: 150,
                        text: 'Name Drug',
                        controller: nameDrug,
                        onChanged: (val) {
                          setState(() {
                            nameDrug = val;
                          });
                        }),
                    Container(
                      width: 100,
                      height: 50,
                      child: mysignin(
                        color: Colors.green,
                        title: 'Add',
                        size: 18,
                        onPressed: () {
                          // setState(() {
                          //   if (drugScan.numberDrug == 0) {
                          //     if (!uncheckDrug.contains(drugScan)) {
                          //       uncheckDrug.add(drugScan);
                          //       print("drugsUnCheched");
                          //     }
                          //     checkDrug.remove(drugScan);
                          //   } else {
                          //     if (!checkDrug.contains(drugScan)) {
                          //       checkDrug.add(drugScan);
                          //       print("drugsCheched");
                          //     }
                          //     uncheckDrug.remove(drugScan);
                          //   }
                          // });
                          PharmacyModel namedDrug = PharmacyModel(
                              codeDrug: "0",nameDrug: nameDrug.text,numberDrug: -1,expiryDateDrug: selectedDate
                          );
                          MyDataBase.addDrug(namedDrug);
                          checkDrug?.add(namedDrug);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                sizedBoxWidth(width: 30),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: 300,
                    height: 300,
                    child: Column(
                      children: [
                        defultText(
                            data: 'List of Checked Drug', c: Colors.white),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Expanded(
                          child: Scrollable(
                            axisDirection: AxisDirection.down,
                            viewportBuilder:
                                (BuildContext context, ViewportOffset offset) {
                              return Column(
                                children: [
                                  SizedBox(height: offset.pixels),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: checkDrug?.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          height: 50,
                                          child: Center(child: Text(checkDrug![index].nameDrug ?? "")),
                                        );
                                      },
                                    ),
                                  ),
                                  // StreamBuilder(
                                  //   stream: MyDataBase.getListUrine(true),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasError) {
                                  //       return Center(
                                  //           child: Text(
                                  //         "something went wrong",
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headlineMedium,
                                  //       ));
                                  //     }
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return const Center(
                                  //         child: CircularProgressIndicator(),
                                  //       );
                                  //     } // sania tb
                                  //     List<PatientAdultModel> patientList =
                                  //         snapshot.data?.docs
                                  //                 .map((e) => e.data())
                                  //                 .toList() ??
                                  //             [];
                                  //     return patientList.isNotEmpty
                                  //         ? Expanded(
                                  //             child: ListView.builder(
                                  //               itemCount: patientList.length,
                                  //               itemBuilder:
                                  //                   (BuildContext context,
                                  //                       int index) {
                                  //                 return Container(
                                  //                   height: 50,
                                  //                   child: Center(
                                  //                       child: Text(patientList[
                                  //                                   index]
                                  //                               .codeAdultPatient ??
                                  //                           "")),
                                  //                 );
                                  //               },
                                  //             ),
                                  //           )
                                  //         : Container(
                                  //             margin: EdgeInsets.only(top: 220),
                                  //             child: Text(
                                  //               textAlign: TextAlign.center,
                                  //               "no patient yet ...",
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .bodyMedium
                                  //                   ?.copyWith(
                                  //                       color: Colors.green,
                                  //                       fontWeight:
                                  //                           FontWeight.bold),
                                  //             ),
                                  //           );
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            sizedBoxhight(hight: 20),
            Divider(
              height: 2,
            ),
            sizedBoxhight(hight: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children:[
                  defultText(data: 'Unchecked Drugs', x: 20),
                  SizedBox(height: 15,),
                  // StreamBuilder(
                  //   stream: MyDataBase.getUnCheckDrugList(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       return Center(
                  //           child: Text(
                  //             "something went wrong",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .headlineMedium,
                  //           ));
                  //     }
                  //     if (snapshot.connectionState ==
                  //         ConnectionState.waiting) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } // sania tb
                  //     List<String>? drug =
                  //         (snapshot.data?.docs
                  //             .map((e) => e.data().nameDrug)
                  //             .toList() ??
                  //             []).cast<String>();
                  //      //List<String>? selectedDrug =[];
                  //
                  //     return Container(
                  //       width: 170,
                  //         height: 60,
                  //         child: DropDownMultiSelect(
                  //           options: drug,
                  //           selectedValues: selectedDrug,
                  //           onChanged: (value) {
                  //             selectedDrug = value;
                  //
                  //             print('you have selected $selectedDrug fruits.');
                  //           },
                  //         ),
                  //       );
                  //   },
                  // ),
                  // SizedBox(height: 15,),
                  // Container(
                  //   width: 100,
                  //   height: 50,
                  //   child: mysignin(
                  //     color: Colors.green,
                  //     title: 'Add',
                  //     size: 18,
                  //     onPressed: () {
                  //       // setState(() {
                  //       //   if (drugScan.numberDrug == 0) {
                  //       //     if (!uncheckDrug.contains(drugScan)) {
                  //       //       uncheckDrug.add(drugScan);
                  //       //       print("drugsUnCheched");
                  //       //     }
                  //       //     checkDrug.remove(drugScan);
                  //       //   } else {
                  //       //     if (!checkDrug.contains(drugScan)) {
                  //       //       checkDrug.add(drugScan);
                  //       //       print("drugsCheched");
                  //       //     }
                  //       //     uncheckDrug.remove(drugScan);
                  //       //   }
                  //       // });
                  //       uncheckDrug.add(selectedDrug as PharmacyModel);
                  //
                  //       drugScan.numberDrug = drugScan.numberDrug!-1;
                  //       MyDataBase.updateDrug(drugScan);
                  //       setState(() {});
                  //     },
                  //   ),
                  // ),
                  // DropdownButton<String>(
                  //     value: selectedday, // 1-done
                  //     items: Chosedaylist.map(
                  //           (day) => DropdownMenuItem(
                  //         value: day,
                  //         child: Text(
                  //           day,
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ),
                  //     ).toList(),
                  //     onChanged: (day) => setState(() => selectedday = day!)),
                  defultTextField(
                    width: 150,
                    text: 'Name Drug',
                    controller: nameUnCheckedDrug,
                    onChanged: (val) {
                      setState(() {
                        nameUnCheckedDrug = val;
                      });
                    }),
                  Container(
                    width: 100,
                    height: 50,
                    child: mysignin(
                      color: Colors.green,
                      title: 'Add',
                      size: 18,
                      onPressed: () {
                        // setState(() {
                        //   if (drugScan.numberDrug == 0) {
                        //     if (!uncheckDrug.contains(drugScan)) {
                        //       uncheckDrug.add(drugScan);
                        //       print("drugsUnCheched");
                        //     }
                        //     checkDrug.remove(drugScan);
                        //   } else {
                        //     if (!checkDrug.contains(drugScan)) {
                        //       checkDrug.add(drugScan);
                        //       print("drugsCheched");
                        //     }
                        //     uncheckDrug.remove(drugScan);
                        //   }
                        // });
                        PharmacyModel namedDrug = PharmacyModel(
                          codeDrug: "0",nameDrug: nameUnCheckedDrug.text,numberDrug: -1,expiryDateDrug: selectedDate
                        );
                        MyDataBase.addDrug(namedDrug);
                        uncheckDrug?.add(namedDrug);
                        setState(() {});
                      },
                    ),
                  ),

                ]),
                sizedBoxWidth(width: 120),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    width: 300,
                    height: 300,
                    child: Column(
                      children: [
                        defultText(
                            data: 'List of UnChecked Drug', c: Colors.white),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Expanded(
                          child: Scrollable(
                            axisDirection: AxisDirection.down,
                            viewportBuilder:
                                (BuildContext context, ViewportOffset offset) {
                              return Column(
                                children: [
                                  SizedBox(height: offset.pixels),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: uncheckDrug?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                                  uncheckDrug![index].nameDrug??"")),
                                        );
                                      },
                                    ),
                                  ),
                                  // StreamBuilder(
                                  //   stream: MyDataBase.getListUrine(true),
                                  //   builder: (context, snapshot) {
                                  //     if (snapshot.hasError) {
                                  //       return Center(
                                  //           child: Text(
                                  //         "something went wrong",
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .headlineMedium,
                                  //       ));
                                  //     }
                                  //     if (snapshot.connectionState ==
                                  //         ConnectionState.waiting) {
                                  //       return const Center(
                                  //         child: CircularProgressIndicator(),
                                  //       );
                                  //     } // sania tb
                                  //     List<PatientAdultModel> patientList =
                                  //         snapshot.data?.docs
                                  //                 .map((e) => e.data())
                                  //                 .toList() ??
                                  //             [];
                                  //     return patientList.isNotEmpty
                                  //         ? Expanded(
                                  //             child: ListView.builder(
                                  //               itemCount: patientList.length,
                                  //               itemBuilder:
                                  //                   (BuildContext context,
                                  //                       int index) {
                                  //                 return Container(
                                  //                   height: 50,
                                  //                   child: Center(
                                  //                       child: Text(patientList[
                                  //                                   index]
                                  //                               .codeAdultPatient ??
                                  //                           "")),
                                  //                 );
                                  //               },
                                  //             ),
                                  //           )
                                  //         : Container(
                                  //             margin: EdgeInsets.only(top: 220),
                                  //             child: Text(
                                  //               textAlign: TextAlign.center,
                                  //               "no patient yet ...",
                                  //               style: Theme.of(context)
                                  //                   .textTheme
                                  //                   .bodyMedium
                                  //                   ?.copyWith(
                                  //                       color: Colors.green,
                                  //                       fontWeight:
                                  //                           FontWeight.bold),
                                  //             ),
                                  //           );
                                  //   },
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            sizedBoxhight(hight: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mysignin(
                    color: Colors.green,
                    title: 'Add Drug',
                    size: 16,
                    onPressed: () {
                      patientAd.drugsChecked=checkDrug;
                      patientAd.drugsUnChecked=uncheckDrug;
                      patientAd.reportPharma="done";
                      MyDataBase.updatePatientAdult(patientAd);
                      patientCh.drugsChecked=checkDrug;
                      patientCh.drugsUnChecked=uncheckDrug;
                      patientCh.reportPharma="done";
                      MyDataBase.updatePatientChild(patientCh);
                    }),
                sizedBoxhight(hight: 30),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   if (!mounted) return;
  //   setState(() {
  //     scanBarcode = barcodeScanRes;
  //   });
  // }
  addToList(PharmacyModel drugModel){
    if(drugModel.numberDrug!>0){

      checkDrug?.add(drugModel);
    }else {
      uncheckDrug?.add(drugModel);
    }
  }
}
