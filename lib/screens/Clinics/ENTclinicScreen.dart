import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bedaya/screens/Clinics/ClinicScreenChose.dart';
import 'package:multiselect/multiselect.dart';
import '../../DateModels/PatientAdultModel.dart';
import '../../component/component.dart';
import '../../network/my_database.dart';
import '../../widgets/appbar.dart';
import '../../widgets/my_button.dart';
class EntClinicScreen extends StatefulWidget {
  static const String screenRoute = 'EntClinicScreen';

  const EntClinicScreen({Key? key}) : super(key: key);

  @override
  State<EntClinicScreen> createState() => _EntClinicScreenState();
}

class _EntClinicScreenState extends State<EntClinicScreen> {
  List<String> CommondiagnosesforENT =
  ['Tonsilitis','Sinusitis','Pharyngitis','Otitis Media','Otitis Externa','Ear wax','Epistaxis','Allergic rhinitis',
    'Diarrhea',];
  List<String> SelectedCommondiagnosesforENT = [];
  // String SelectedCommondiagnosesforENT = 'Tonsilitis';
  TextEditingController codeController = TextEditingController();
  TextEditingController entdiagnoseController = TextEditingController();

  List<String> enttreatment = ['misaclor','Cefrone',
    'ceftriaxone','nercefaxon',
    'Suprax','CAPOTRIL','Rampecardin','Sinopril 10mg','Sinopril Co','Tritace Comp LS','Triacor','Virustat',
    'Antizole','bendax suspension 60 ml','Bendax tablet 200mg','vermizole',
    'Tamsunorm','Alexoprine','moxipen 500','Flumox 500','Augmentin 1g','Augram (Syrup)',
    'Augram 1 gm','clavimox','Curam','Hibiotic 1gm','hikma', 'Fawar fruit' ,'Trillerg' , 'propamethone',
    'Top-flam', 'Levofloxacin' ,
    'Kapron','Extrauma', 'marevan' , 'Antinal',
    'diasmect','lacteol fort','Lecteol fort','Eucarbon','Betaclotri','Daktacot',
    'diflucan','fluconazole','lamifen','Monicure 400mg',
    'monicure NH','Otocort','Treflucan','Viotic','Maxilase', 'megalase',
    'Tritone 100 mg', 'Tritone 200mg', 'Spasmofree', 'Visceralgine', 'ateno 100mg',
    'ateno 50mg', 'Zisrocin', 'Azimacron', 'Cyanaro', 'Betaserc', 'Bistol', 'Concor',
    'bambedil', 'Quibron -T/SR', 'Salbovent 2mg', 'Hi-cal', 'calcium D3F', 'Caldin C',
    'Cardilol', 'Carvipress', 'Isoptin', 'Norvasc', 'Regcor', 'Vasopine', 'Bilichol',
    'Cipro 500 mg', 'Bedrevide', 'Ur-aid', 'Urivin', 'URAID-N', 'All-vent', 'Babetone (Syrup)',
    'Balsam', 'cabella', 'Codaphen-N', 'Phenadone', 'Selgon', 'Windy', 'Co-Avazir', 'Cornergel',
    'Digenorm', 'spasmodigestin', 'Farcotilium', 'farcotilium', 'gastromotil', 'gastromotil', 'Motilium',
    'Villdagluse', 'Vildagluse Plus', 'Remowax', 'Neo Minophylline', 'Neo-bronchophane', 'Artelac',
    'normo- tear', 'Orchatears Plus', 'Poly fresh', 'Tears Guard', 'Efemyo', 'Feburic', 'Fluver',
    'fluvermal', 'Folic Acid', 'Fuci-Top', 'fusi-top', 'Fusiderm', 'Fusi-zon', 'Convetin', 'gaptin 400mg',
    'Mucosta', 'Gloriagent', 'Goba', 'Panthenol', 'MEBO', 'Daflon 500mg', 'dexaphen', 'Anallerge', 'levcet',
    'Levohistam', 'Stugeron', 'xaltec', 'Zyrtec', 'orchazid', 'Texacort', 'povidone', 'Enrich (Syrup)',
    'Enrich Plus', 'Haemojet', 'Enrich (Drops)', 'gastorelive', 'AllerBan', 'Lactulose', 'Picolax',
    'Tiralepsy', 'Tavanic', 'Floxabact', 'lignocaine hydrochloride', 'Hipamax Plus', 'Examide',
    'cidophage', 'Meclopram', 'Amrizole', 'Flagellat forte', 'Flagyl', 'Flagyl 250mg', 'Clear Air',
    'Kokast', 'Fortymox', 'Fortymox Plus', 'MUCO', 'Mucosol', 'mucotec', 'Neuroton', 'octatron',
    'Orange-C', 'SiderAl', 'Immuniphar', 'neurovit', 'Octozinc', 'pharovit', 'Kidistars', 'Myofen',
    'myoflex', 'Orphenadrine Plus', 'Otrivin (Adults)', 'Otrivin (Baby Saline)', 'Otrivin (Children)',
    'Isopto maxitrol', 'Nanazoxid', 'Mepafuran 100', 'mepafuran 50mg', 'nitro fast retard', 'Brufen 400mg',
    'Bruffen', 'contafever N', 'Declofenac', 'flotac', 'Indometacin Suppositories', 'megafen N', 'piroxiden',
    'Reparil-Gel N', 'Romafen', 'romalex', 'DG wash', 'Oracure', 'ORS', 'Hydro-safe salts', 'Adol', 'Cetal',
    'Paracetamol 500mg', 'Temporal', 'Neximerican 20 mg', 'Neximerican 40 mg', 'Omez 20', 'Pantopi 20',
    'pantoprazole', 'Vental Compositum', 'vental inhaler', 'Ventolin', 'viasalmol', 'amaryl', 'diavance',
    'Aggrax', 'Aggrex', 'Calamyl', 'Derma Med', 'Atorstat', 'lipicole 10', 'Lipicole 20', 'Lipona',
    'lipona 10mg', 'Epimag', 'Septrin D.S.', 'Adcocycline', 'Doxycost 200mg', 'vibramycin 100mg',
    'Tobrin', 'Tobrin', 'Ambezim-G', 'newbezim', 'Proximol', 'Renal-S', 'Rowatinex', 'Urinex', 'ursochol',
    'ursofalk', 'Vagyl', 'biovit 12 depot', 'Vidrop', 'Bone care', 'Zinc origin'

  ] ;
  TextEditingController  TreatmentController =TextEditingController ();
  List<String> SelectedTreatment = [] ;


  @override
  Widget build(BuildContext context) {
    PatientAdultModel patient = PatientAdultModel();
    return Scaffold(
      appBar: PreferredSize(
        child: appBardefult(
          data: 'ENT Clinic',
          icon: Icon(Icons.menu),
        ),
        preferredSize: Size(100, 50),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              sizedBoxhight(hight: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green,
                      ),
                      padding: EdgeInsets.all(10),
                      height: 80,
                      width: 250,
                      child: Center(
                          child: Text('ENT Clinic:', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),)),
                    ),
                  ),
                ],
              ),
              sizedBoxhight(hight: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          // t3aly ne3ml gmbha text button awel ma yedos 3leh ye search
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
                      child: StreamBuilder<QuerySnapshot<PatientAdultModel>>(
                        stream: MyDataBase.getPatient(codeController.text),
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
                            // Access the first patient from the query snapshot
                            //   List<PatientAdultModel> patientList =
                            //       snapshot.data?.docs.map((e) => e.data()).toList() ?? [];
                             patient = snapshot.data!.docs[0].data();
                            print("data ${patient.screening}");
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 1000,
                              height: 80,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: defultText(
                                        data:
                                        "Patient’s Name: ${patient.nameAdultPatient}",
                                        c: Colors.black,
                                        x: 19,
                                      ),
                                    ),
                                    sizedBoxWidth(width: 300),
                                    Flexible(
                                      flex: 1,
                                      child: defultText(
                                        data:
                                        'Code: ${patient.codeAdultPatient}',
                                        c: Colors.black,
                                        x: 19,
                                      ),
                                    ),
                                    sizedBoxWidth(width: 50),
                                    Flexible(
                                      flex: 1,
                                      child: defultText(
                                        data: 'Sex: ${patient.sexAdultPatient}',
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
              sizedBoxhight(hight: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  sizedBoxWidth(width: 20),
                  Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 165, 162, 162)),
                        padding: EdgeInsets.all(10),
                        width: 1000,
                        height: 150,
                        child: Column(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                    width: 1000,
                                    height: 50,
                                    child: Center(
                                      child: defultText(
                                          data: 'Diagnoses:',
                                          c: Colors.white),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    height: 90,
                                    width: 350,
                                    child: Center(
                                      child: TextFormField(
                                        controller: entdiagnoseController,
                                        decoration: InputDecoration(
                                          labelText: 'Result',
                                          hoverColor: Colors.black,
                                          focusColor: Colors.green,
                                          fillColor: Colors.green,
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 14,
                                        minLines: 1,
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                sizedBoxWidth(width: 10),
                                Flexible(
                                  flex: 4 ,
                                  child: Container(
                                    height: 50,
                                    width: 300,
                                    child: Center(
                                      child: DropDownMultiSelect(
                                        options: CommondiagnosesforENT ,
                                        selectedValues: SelectedCommondiagnosesforENT,
                                        onChanged: (value) {
                                          setState(() {
                                            SelectedCommondiagnosesforENT = value;
                                          });
                                          print('you have selected $SelectedCommondiagnosesforENT fruits.');
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                ],),
              sizedBoxhight(hight: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxWidth(width: 20),
                  Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromARGB(255, 165, 162, 162)),
                        padding: EdgeInsets.all(10),
                        width: 1000,
                        height: 150,
                        child: Column(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                    width: 1000,
                                    height: 50,
                                    child: Center(
                                      child: defultText(
                                          data: 'Treatment:',
                                          c: Colors.white),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    height: 90,
                                    width: 350,
                                    child: Center(
                                      child: TextFormField(
                                        controller: TreatmentController,
                                        decoration: InputDecoration(
                                          labelText: 'Treatment',
                                          hoverColor: Colors.black,
                                          focusColor: Colors.green,
                                          fillColor: Colors.green,
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 14,
                                        minLines: 1,
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                                sizedBoxWidth(width: 10),
                                Flexible(
                                  flex: 4 ,
                                  child: Container(
                                    height: 50,
                                    width: 300,
                                    child: Center(
                                      child: DropDownMultiSelect(
                                        options: enttreatment,
                                        selectedValues: SelectedTreatment,
                                        onChanged: (value) {
                                          setState(() {
                                            SelectedTreatment = value;
                                          });
                                          print('you have selected $SelectedTreatment fruits.');
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                ],),
              sizedBoxhight(hight: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: mysignin(
                      color: Colors.green,
                      x: Colors.black,
                      title: 'Save& add another Patient',
                      size: 25,
                      onPressed: (){
                        setState(() {
                          CommondiagnosesforENT.add(entdiagnoseController.text);
                          enttreatment.add(TreatmentController.text);
                          SelectedTreatment.add(TreatmentController.text);
                          SelectedCommondiagnosesforENT.add(entdiagnoseController.text);
                        });
                        patient.entdiagnoses = SelectedCommondiagnosesforENT;
                        patient.entTreatment =SelectedTreatment ;
                        MyDataBase.updatePatientAdult(patient);
                        clearTextField(entdiagnoseController, TreatmentController);
                        clearList(SelectedTreatment, SelectedCommondiagnosesforENT);
                        // Navigator.pushNamed(context, ChoseLabsScreen.screenRoute)

                      },
                    ),
                  ),
                  sizedBoxWidth(width: 20),
                  Flexible(
                    flex: 1,
                    child: mysignin(
                      color: Colors.green,
                      x: Colors.black,
                      title: 'Save&BacktoEdit',
                      size: 25,
                      onPressed: () => {
                        // Navigator.pushNamed(context, bloodLabScreen.screenRoute)
                      },
                    ),
                  ),
                  sizedBoxWidth(width: 20),
                ],
              ),
              sizedBoxhight(hight: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Flexible(
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text('Add Another Clinic' , style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white
                            ),),
                          ),
                          sizedBoxWidth(width: 20),
                          Flexible(child:  IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, ClinicScreenChose.screenRoute);
                              }
                              , icon: Icon(Icons.add)))
                        ],),
                    ),
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }
}
