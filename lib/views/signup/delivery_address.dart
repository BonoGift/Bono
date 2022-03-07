import 'dart:async';

import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:bono_gifts/views/profile/edit_profiel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DeliveryAddress extends StatefulWidget {
  final bool isFromDob;

  const DeliveryAddress({Key? key, required this.isFromDob}) : super(key: key);

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Completer<GoogleMapController> completer = Completer();
  static LatLng latLng = const LatLng(24.24354, 67.062513);

  LatLng initPosition = latLng;

  onCameraMove(CameraPosition position) {
    initPosition = position.target;
  }

  GoogleMapController? _controller;

  onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
    _controller = controller;
  }

  bool isSearchTextFiled = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Provider.of<SignUpProvider>(context, listen: false).setLocation(_controller!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    // return Scaffold(
    //   body: Form(
    //     key: key,
    //     child: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: const [
    //                 Text(
    //                   "Add a Delivery Address",
    //                   style: TextStyle(fontSize: 22, color: Colors.blue),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: const [
    //                 Expanded(
    //                   child: FittedBox(
    //                     child: Text("Don't worry no one can see your address",
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(fontSize: 18)),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             const Text("Title"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   onChanged: (val) {},
    //                   controller: pro.deliTitleContr,
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "Address Title"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             SizedBox(
    //               height: getHeight(context) / 3,
    //               child: GoogleMap(
    //                 initialCameraPosition:
    //                     CameraPosition(target: latLng, zoom: 40.0),
    //                 onMapCreated: onMapCreated,
    //                 myLocationEnabled: true, myLocationButtonEnabled: false,
    //                 tiltGesturesEnabled: true,
    //                 compassEnabled: true,
    //                 scrollGesturesEnabled: true, zoomControlsEnabled: false,
    //                 zoomGesturesEnabled: true,
    //                 markers: Set<Marker>.of(pro.markers.values),
    //                 // polylines: Set<Polyline>.of(_polylines.values),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text("Room / Villa no"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   controller: pro.room,
    //                   onChanged: (val) {
    //                     pro.setRoom(val);
    //                   },
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "Room No"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text("Building Name"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   controller: pro.buildingName,
    //                   onChanged: (val) {
    //                     pro.setBuild(val);
    //                   },
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "Building Name"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text("Area"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   onChanged: (val) {
    //                     pro.setArea(val);
    //                   },
    //                   controller: pro.area,
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "Area"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text("Street"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   onChanged: (val) {
    //                     pro.setStreet(val);
    //                   },
    //                   controller: pro.street,
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "Street"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const Text("City"),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Container(
    //               decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: TextFormField(
    //                   onChanged: (val) {
    //                     pro.setCity(val);
    //                   },
    //                   controller: pro.city,
    //                   decoration: const InputDecoration(
    //                       border: InputBorder.none, hintText: "City"),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 TextButton(
    //                   onPressed: () => Navigator.pop(context),
    //                   child: const Text("Cancel"),
    //                 ),
    //                 MaterialButton(
    //                   color: Colors.blue,
    //                   onPressed: () {
    //                     // pro.setLocation();
    //                     Navigator.pushNamed(context, createProfile);
    //                   },
    //                   child: const Text(
    //                     "Done",
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 )
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      resizeToAvoidBottomInset: isSearchTextFiled,
      body: GestureDetector(
        onTap: () {
          disposeKeyboard();
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 500,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: latLng, zoom: 40.0),
                    onMapCreated: onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    markers: Set<Marker>.of(pro.markers.values),
                    // polylines: Set<Polyline>.of(_polylines.values),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                )
              ],
            ),
            Container(
              height: 350,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Add a delivery Address",
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
                              "(You will receive gifts in this address)",
                              style: TextStyle(fontSize: 13, color: Colors.grey.withOpacity(.9)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: pro.deliTitleContr,
                          onTap: () {
                            setState(() {});
                            isSearchTextFiled = true;
                          },
                          decoration: InputDecoration(
                            // label: Text("Your Centered Label Text"),
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
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: pro.buildingName,
                                onTap: () {
                                  setState(() {});
                                  isSearchTextFiled = true;
                                },
                                onChanged: (val) {
                                  pro.setBuild(val);
                                },
                                decoration: InputDecoration(
                                  // label: Text("Your Centered Label Text"),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "Building",
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: pro.room,
                                onTap: () {
                                  setState(() {});
                                  isSearchTextFiled = true;
                                },
                                onChanged: (val) {
                                  pro.setRoom(val);
                                },
                                decoration: InputDecoration(
                                  // label: Text("Your Centered Label Text"),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "Room No.",
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onTap: () {
                                  setState(() {});
                                  isSearchTextFiled = true;
                                },
                                onChanged: (val) {
                                  pro.setArea(val);
                                },
                                controller: pro.area,
                                decoration: InputDecoration(
                                  // label: Text("Your Centered Label Text"),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "Area",
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onTap: () {
                                  setState(() {});
                                  isSearchTextFiled = true;
                                },
                                onChanged: (val) {
                                  pro.setCity(val);
                                },
                                controller: pro.city,
                                decoration: InputDecoration(
                                  // label: Text("Your Centered Label Text"),
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: "City",
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          onTap: () {
                            setState(() {});
                            isSearchTextFiled = true;
                          },
                          decoration: InputDecoration(
                            // label: Text("Your Centered Label Text"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Location",
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
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 45,
                                  child: const Center(
                                      child: Text(
                                    "Cancle",
                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                  )),
                                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(50)), border: Border.all(color: Colors.grey.withOpacity(.9)), color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, profilePage);
                                },
                                child: Container(
                                  height: 45,
                                  child: const Center(
                                    child: Text(
                                      "Done",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: TextFormField(
                onTap: () {
                  setState(() {});
                  isSearchTextFiled = false;
                },
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: "Search",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: Colors.white)),
                    prefixIcon: Icon(Icons.search)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
