import 'dart:async';

import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/views/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../routes/routes_names.dart';

class DeliveryAddress extends StatefulWidget {
  final bool isFromDob;

  const DeliveryAddress({Key? key, required this.isFromDob}) : super(key: key);

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  GlobalKey<FormState> customLocationKey = GlobalKey<FormState>();

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
  bool isHomeSelected = true;
  bool isWorkSelected = false;
  bool isStoreSelected = false;
  bool isCustomSelected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final pro = Provider.of<SignUpProvider>(context, listen: false);
      pro.setLocation(_controller!);
      isHomeSelected = pro.deliTitleContr.text == 'Home' ? true : false;
      isWorkSelected = pro.deliTitleContr.text == 'Work' ? true : false;
      isStoreSelected = pro.deliTitleContr.text == 'Store' ? true : false;
      if (!isHomeSelected && !isWorkSelected && !isStoreSelected) {
        isCustomSelected = true;
      }
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
                  height: getHeight(context),
                  width: getWidth(context),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(target: latLng, zoom: 16.5),
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
            /*Container(
              height: 350,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 3),
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
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
                            const SizedBox(width: 20),
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
                                  Navigator.pushNamed(context, editProfile);
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
            ),*/
            _getDraggableScrollableSheetWidget(pro),
            /*Positioned(
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
            )*/
          ],
        ),
      ),
    );
  }

  Widget _getDraggableScrollableSheetWidget(SignUpProvider pro) => NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          return true;
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.11,
          maxChildSize: 0.65,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Form(
                  key: key,
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on_sharp,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pro.city.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pro.area.text,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _getDividerWidget(thickness: 12),
                      _getFlatOrVillaWidget(pro),
                      _getDividerWidget(thickness: 2),
                      _getBuildingNameWidget(pro),
                      _getDividerWidget(thickness: 2),
                      _getStreetWidget(pro),
                      _getDividerWidget(thickness: 2),
                      _getAreaWidget(pro),
                      _getDividerWidget(thickness: 2),
                      _getOptionalWidget(pro),
                      _getDividerWidget(thickness: 2),
                      _getCityWidget(pro),
                      _getLocationTitlesWidget(pro),
                      _getButtonWidget()
                    ],
                  ),
                ),
              ),
            );
            /*return Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      _getBottomSheetHeaderIndicatorWidget(),
                      StreamBuilder(
                          stream: _mapController.mapPlaceMarListStream.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return _loadingWidget();
                            } else if (snapshot.hasData) {
                              List<Map<String, dynamic>?> mapPlaceMarkList = snapshot.data as List<Map<String, dynamic>?>;
                              if (mapPlaceMarkList.isNotEmpty) {
                                _isMoved = false;
                                if (_isFirstLoad) {
                                  _setCameraPosition(mapPlaceMarkList.first!['Latitude'], mapPlaceMarkList.first!['Longitude']);
                                }
                              }
                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                primary: false,
                                itemCount: mapPlaceMarkList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return _getAddressItemWidget(mapPlaceMarkList[index]);
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 16,
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: Text(
                                'Something Wrong !!!!!',
                                style: TextStyle(fontSize: 32, color: Colors.black),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            );*/
          },
        ),
      );

  Widget _getButtonWidget() {
    return InkWell(
      onTap: () {
        if (key.currentState!.validate()) {
          Navigator.pushNamed(context, createProfile);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(
          left: 40,
          right: 40,
          top: 30,
          bottom: 40,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          color: Colors.green,
        ),
        child: const Center(
          child: Text(
            'Save address',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLocationTitlesWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (isHomeSelected) return;
              isHomeSelected = !isHomeSelected;
              isWorkSelected = false;
              isStoreSelected = false;
              isCustomSelected = false;
              setState(() {
                pro.setTitle('Home');
              });
            },
            child: _getLocationNameWidget(
              iconName: 'Home',
              icon: Icons.home,
              isSelected: isHomeSelected,
            ),
          ),
          InkWell(
            onTap: () {
              if (isWorkSelected) return;
              isWorkSelected = !isWorkSelected;
              isHomeSelected = false;
              isStoreSelected = false;
              isCustomSelected = false;
              setState(() {
                pro.setTitle('Work');
              });
            },
            child: _getLocationNameWidget(
              iconName: 'Work',
              icon: Icons.work,
              isSelected: isWorkSelected,
            ),
          ),
          InkWell(
            onTap: () {
              if (isStoreSelected) return;
              isStoreSelected = !isStoreSelected;
              isHomeSelected = false;
              isWorkSelected = false;
              isCustomSelected = false;
              setState(() {
                pro.setTitle('Store');
              });
            },
            child: _getLocationNameWidget(
              iconName: 'Store',
              icon: Icons.store,
              isSelected: isStoreSelected,
            ),
          ),
          InkWell(
            onTap: () {
              isCustomSelected = true;
              isHomeSelected = false;
              isWorkSelected = false;
              isStoreSelected = false;
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return StatefulBuilder(builder: (
                      BuildContext context,
                      void Function(void Function()) setState,
                    ) {
                      return Dialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 200,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Form(
                                    key: customLocationKey,
                                    child: TextFormField(
                                      controller: pro.custom,
                                      validator: (val) {
                                        if (val?.isEmpty ?? true) {
                                          return "Location title is required";
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Enter you custom title for this location',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (customLocationKey.currentState!.validate()) {
                                      setState(() {
                                        pro.setTitle(pro.custom.text);
                                      });
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
            },
            child: _getLocationNameWidget(
              iconName: pro.custom.text.isEmpty ? 'Custom' : pro.custom.text,
              icon: Icons.location_on_sharp,
              isSelected: isCustomSelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCityWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'City',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.city,
              maxLines: null,
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'City',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setCity(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getOptionalWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Direction',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.direction,
              maxLines: null,
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Optional',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setOptional(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAreaWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Area',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 0),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.area,
              maxLines: null,
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Area',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setArea(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStreetWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Street',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 0),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.street,
              maxLines: null,
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Street',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setStreet(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBuildingNameWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Building/Villa',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.buildingName,
              maxLines: null,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Building name is required";
                }
              },
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Required',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setBuild(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFlatOrVillaWidget(SignUpProvider pro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Flat/Villa No.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: pro.room,
              maxLines: null,
              validator: (val) {
                if (val!.isEmpty) {
                  return "Flat/Villa No. is required";
                }
              },
              onTap: () {
                setState(() {});
                isSearchTextFiled = true;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Required',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                pro.setRoom(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLocationNameWidget({
    required String iconName,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.black.withOpacity(0.6),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            iconName,
            style: const TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _getDividerWidget({required double thickness}) {
    return Divider(
      thickness: thickness,
      color: Colors.grey.withOpacity(0.1),
    );
  }

  Widget _getAddressInfoWidget({
    required String title,
    required String info,
    required TextEditingController textEditingController,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 0),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: textEditingController,
              onChanged: (value) {},
            ) /*Text(
              info,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 18,
              ),
            )*/
            ,
          ),
        ],
      ),
    );
  }
}
