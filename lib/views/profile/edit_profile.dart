import 'dart:io';

import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/signup/delivery_address.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
            child: GestureDetector(
              onTap: () {
                disposeKeyboard();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pro.image == null
                        ? SizedBox(
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
                                      pro.userImage != ""
                                          ? Align(
                                              alignment: Alignment.center,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: pro.userImage,
                                                  progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                                    width: 140,
                                                    height: 140,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.grey[300]!,
                                                      highlightColor: Colors.white,
                                                      child: Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 140,
                                                  height: 140,
                                                ),
                                              ),
                                            )
                                          : const Align(
                                              alignment: Alignment.center,
                                              child: CircleAvatar(radius: 70, backgroundImage: AssetImage("assets/images/profile.png")),
                                            ),
                                      Align(
                                        alignment: const Alignment(1.0, 0.9),
                                        child: TextButton(onPressed: () => pro.getImage(), child: Text("Edit")),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 150,
                                width: 210,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage: FileImage(File(pro.image!.path)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(onPressed: () => pro.getImage(), child: Text("Edit")),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                    const SizedBox(height: 20),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       border: Border.all(),
                    //       borderRadius: BorderRadius.circular(20)
                    //   ),
                    //   height: 42,
                    //   child: Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left:8.0),
                    //       child: TextFormField(
                    //         controller: TextEditingController(text:pro.name),
                    //         validator: (val){
                    //           if(val!.isEmpty){
                    //             return "Name is Required";
                    //           }
                    //         },
                    //         onChanged: (val){
                    //           pro.setName(val);
                    //         },
                    //         textAlign: TextAlign.center,
                    //         decoration: const InputDecoration(
                    //           border: InputBorder.none,
                    //           hintText: "Enter Your Name",
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: pro.name),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Name is Required";
                        }
                      },
                      onChanged: (val) {
                        pro.setName(val);
                      },
                      decoration: InputDecoration(
                        // label: Text("Your Centered Label Text"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Full name*",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(
                        text: pro.dob ?? formt.format(pro.todayDate),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Name is Required";
                        }
                      },
                      onChanged: (val) {
                        pro.setName(val);
                      },
                      readOnly: true,
                      onTap: () {
                        DatePicker.showPicker(
                          context,
                          showTitleActions: true,
                          // minTime: DateTime(1950, 3, 5),
                          // maxTime: DateTime.now(),
                          onChanged: (date) {
                            var formt = DateFormat('dd.MMM.yyyy');

                            pro.setDOB(formt.format(date).toString(), date);
                          },
                          onConfirm: (date) {},
                        );
                      },
                      decoration: InputDecoration(
                        // label: Text("Your Centered Label Text"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Birthday*",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     DatePicker.showPicker(
                    //       context,
                    //       showTitleActions: true,
                    //       // minTime: DateTime(1950, 3, 5),
                    //       // maxTime: DateTime.now(),
                    //       onChanged: (date) {
                    //         var formt = DateFormat('dd-MMM-yyyy');
                    //
                    //         pro.setDOB(formt.format(date).toString(), date);
                    //       },
                    //       onConfirm: (date) {},
                    //     );
                    //     // currentTime: DateTime.now(), locale: LocaleType.en);
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(),
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Center(
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: Container(
                    //           height: 40,
                    //           // padding: const EdgeInsets.all(6),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               // Container(
                    //               //   width: getWidth(context) / 6,
                    //               // ),
                    //               Center(
                    //                 child: Text(
                    //                   pro.dob ?? formt.format(pro.todayDate),
                    //                 ),
                    //               ),
                    //               // TextButton(onPressed: (){}, child: Text("edit"))
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Phone is Required";
                        }
                      },
                      onChanged: (val) {
                        pro.setPhoneNum(val);
                      },
                      controller: pro.phoneNumber,
                      readOnly: true,
                      onTap: () {},
                      decoration: InputDecoration(
                        // label: Text("Your Centered Label Text"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Phone number*",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintText: "Enter Your Mobile Number",
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: pro.email),
                      onChanged: (val) {
                        pro.setEmail(val);
                      },
                      decoration: InputDecoration(
                        // label: Text("Your Centered Label Text"),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Email",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintText: "someone@email.com",
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          onTap: () {
                            disposeKeyboard();
                          },
                          decoration: InputDecoration(
                            // label: Text("Your Centered Label Text"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Nationality",
                            labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                                ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Container(
                                  //   width: getWidth(context) / 6,
                                  // ),
                                  CountryCodePicker(
                                    onChanged: (val) => pro.setDialCode(val.dialCode!),
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
                      ],
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       border: Border.all(),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 8.0),
                    //       child: SizedBox(
                    //         height: 45,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             // Container(
                    //             //   width: getWidth(context) / 6,
                    //             // ),
                    //             CountryCodePicker(
                    //               onChanged: (val) =>
                    //                   pro.setDialCode(val.dialCode!),
                    //               enabled: true,
                    //               showFlagMain: true,
                    //               showCountryOnly: true,
                    //               initialSelection: pro.code,
                    //               // showCountryOnly: true,
                    //               // showOnlyCountryWhenClosed: false,
                    //               alignLeft: false,
                    //               // showDropDownButton: true,
                    //               showOnlyCountryWhenClosed: true,
                    //             ),
                    //             // TextButton(onPressed: (){}, child: Text("edit"))
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Delivery Address",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "(No one can see your address,exept your country)",
                          style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(.9)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliveryAddress(isFromDob: false)));
                          },
                          child: Text(
                            "+ ADD MORE",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    TextFormField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: TextEditingController(
                        text: pro.deliTitle,
                      ),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Title",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: TextEditingController(
                        text: pro.work,
                      ),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "Title",
                        labelStyle: TextStyle(height: 0.8, color: Colors.grey.withOpacity(.9) // 0,1 - label will sit on top of border
                            ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                        ),
                        hintStyle: TextStyle(color: Colors.grey.withOpacity(.9)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(width: 1, color: Colors.grey.withOpacity(.9)),
                        ),
                      ),
                    ),

                    // Container(
                    //   height: 42,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Center(
                    //     child: Padding(
                    //         padding: const EdgeInsets.only(left: 8.0),
                    //         child: SizedBox(
                    //           height: 45,
                    //           // padding: const EdgeInsets.all(6),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Container(
                    //                 width: getWidth(context) / 6,
                    //               ),
                    //               Text(pro.deliTitle),
                    //               TextButton(
                    //                 onPressed: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (contxt) =>
                    //                               const DeliveryAddress(
                    //                                   isFromDob: false)));
                    //                 },
                    //                 child: Text("edit"),
                    //               ),
                    //             ],
                    //           ),
                    //         )),
                    //   ),
                    // ),
                    // MaterialButton(
                    //   color: Colors.blue,
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             DeliveryAddress(isFromDob: false)));
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Text(
                    //         "Add More Delivery Address",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Image.asset(
                    //         addBtn,
                    //         height: 20,
                    //         width: 20,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        pro.makeWaitingState();
                        pro.updateProfile(context);
                      },
                      child: Container(
                        child: Center(
                          child: pro.isWaitingCon
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : const Text(
                                  "Done",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    // MaterialButton(
                    //   minWidth: getWidth(context),
                    //   height: 50,
                    //   color: Colors.blue,
                    //   onPressed: () {
                    //     pro.makeWaitingState();
                    //     pro.updateProfile(context);
                    //   },
                    //   child: pro.isWaitingCon
                    //       ? const CircularProgressIndicator(
                    //           valueColor:
                    //               AlwaysStoppedAnimation<Color>(Colors.white),
                    //         )
                    //       : const Text(
                    //           "Done",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void disposeKeyboard() {
  return FocusManager.instance.primaryFocus?.unfocus();
}
