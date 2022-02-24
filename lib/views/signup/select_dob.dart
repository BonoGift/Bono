import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/signup/delivery_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class SelectDOB extends StatefulWidget {
  const SelectDOB({Key? key}) : super(key: key);

  @override
  _SelectDOBState createState() => _SelectDOBState();
}

class _SelectDOBState extends State<SelectDOB> {
  var formtr = DateFormat('MMM');
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(butteryFly,height: 60,),
                    ),
                  ),
                  const Text("Congratulations!",style: TextStyle(color: Colors.blue,fontSize: 22,fontWeight: FontWeight.w500),),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(butteryFly,height: 60,),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 30,),
                  ),
                  const Text("Let's get started",),
                  RotatedBox(
                    quarterTurns: 4,
                    child: Image.asset(butteryFly,height: 30,),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Text("When is your birthday",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  DatePicker.showPicker(
                      context,
                      showTitleActions: true,
                      // minTime: DateTime(1950, 3, 5),
                      // maxTime: DateTime.now(),
                      onChanged: (date) {
                        var formt = DateFormat('dd-MMM-yyyy');

                        pro.setDOB(formt.format(date).toString(),date);
                      }, onConfirm: (date) {

                      },);
                      // currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  width: getWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all()
                        ),
                        child: Center(
                          child: Text(pro.dob != null ? pro.dob!.substring(7,11) :pro.todayDate.year.toString()),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all()
                        ),
                        child: Center(
                          child: Text(pro.dob != null ? pro.dob!.substring(3,6) :formtr.format(pro.todayDate).toString()),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all()
                        ),
                        child: Center(
                          child: Text(pro.dob != null ? pro.dob!.substring(0,2) :pro.todayDate.day.toString()),
                        ),
                      )
                    ],
                  )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      // pro.checkIfUSer('+923033374110');
                      Navigator.pop(context);
                      },
                    child: const Text("Cancel"),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (contxt) => const DeliveryAddress(isFromDob: true)));
                    },
                    child: const Text("Next",style: TextStyle(color: Colors.white),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
