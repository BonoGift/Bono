import 'dart:io';
import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/signup/delivery_address.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);
  @override
  _CreateProfileState createState() => _CreateProfileState();
}
class _CreateProfileState extends State<CreateProfile> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  var formt = DateFormat('dd-MMM-yyyy');
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pro.image == null ? SizedBox(
                    height: 150,
                    width: getWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 210,
                          child: Stack(
                            children: [
                              const Align(
                                alignment:Alignment.center,
                                child:  CircleAvatar(
                                  radius: 70,
                                  backgroundImage: AssetImage(defaultImage),
                                ),
                              ),
                              Align(
                                alignment: Alignment(1.0,0.9),
                                child: TextButton(
                                    onPressed: ()=> pro.getImage(),
                                    child: Text("Edit")),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 210,
                        child: Stack(
                          children: [
                            Align(
                              alignment:Alignment.center,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: FileImage(File(pro.image!.path)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: ()=> pro.getImage(),
                                  child: Text("Edit")),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text("Name*"),
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    height: 42,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextFormField(
                          validator: (val){
                            if(val!.isEmpty){
                              return "Name is Required";
                            }
                          },
                          onChanged: (val){
                            pro.setName(val);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Name",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Age*"),
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                          height: 40,
                          // padding: const EdgeInsets.all(6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //   width: getWidth(context) / 6,
                                // ),
                                Center(child: Text(pro.dob.toString())),
                                // TextButton(onPressed: (){}, child: Text("edit"))
                              ],
                            ))
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Phone number*"),
                  const SizedBox(height: 10,),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: TextFormField(
                            validator: (val){
                              if(val!.isEmpty){
                                return "Phone is Required";
                              }
                            },
                            onChanged: (val){
                              pro.setPhoneNum(val);
                            },
                            controller: pro.phoneNumber,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Name",
                            ),
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Email"),
                  const SizedBox(height: 10,),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          onChanged: (val){
                            pro.setEmail(val);
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Eamil"
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Home Country"),
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: SizedBox(
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Container(
                                  //   width: getWidth(context) / 6,
                                  // ),
                                  CountryCodePicker(
                                    onChanged: (val)=> pro.setDialCode(val.dialCode!),
                                    enabled: true,
                                    showFlagMain: true,
                                    showCountryOnly: true,
                                    initialSelection: pro.code,
                                    // showCountryOnly: true,
                                    // showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    // showDropDownButton: true,
                                    showOnlyCountryWhenClosed: true,
                                  ),
                                  // TextButton(onPressed: (){}, child: Text("edit"))
                                ],
                              ),
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      Text("Add a Delivery Address",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text("Delivery Address One*"),
                  const SizedBox(height: 10,),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: SizedBox(
                              height: 45,
                              // padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: getWidth(context) / 6,
                                  ),
                                  Text(pro.deliTitle),
                                  TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (contxt) => const DeliveryAddress(isFromDob: false)));}, child: Text("edit"),
                                  ),
                                ],
                              ),
                          )
                      ),
                    ),
                  ),
                  MaterialButton(
                   color: Colors.blue,
                   onPressed: (){},
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      const Text("Add More Delivery Address",style: TextStyle(color: Colors.white),),
                      const SizedBox(width: 10,),
                      Image.asset(addBtn,height: 20,width: 20,)
                    ],
                   ),
                  ),
                  MaterialButton(
                    minWidth: getWidth(context),
                    color: Colors.blue,
                    onPressed: (){
                      pro.makeWaitingState();
                      pro.signUpUser(context,true);
                    },
                    child: pro.isWaitingCon ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),):const Text("Done",style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
