import 'dart:async';

import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Provider.of<SignUpProvider>(context, listen: false)
          .setLocation(_controller!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Add a Delivery Address",
                        style: TextStyle(fontSize: 22, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: FittedBox(
                          child: Text("Don't worry no one can see your address",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Title"),
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onChanged: (val) {},
                        controller: pro.deliTitleContr,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Address Title"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: getHeight(context) / 3,
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: latLng, zoom: 40.0),
                      onMapCreated: onMapCreated,
                      myLocationEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: Set<Marker>.of(pro.markers.values),
                      // polylines: Set<Polyline>.of(_polylines.values),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Room / Villa no"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: pro.room,
                        onChanged: (val) {
                          pro.setRoom(val);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Room No"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Building Name"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: pro.buildingName,
                        onChanged: (val) {
                          pro.setBuild(val);
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Building Name"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Area"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onChanged: (val) {
                          pro.setArea(val);
                        },
                        controller: pro.area,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Area"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Street"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onChanged: (val) {
                          pro.setStreet(val);
                        },
                        controller: pro.street,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Street"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("City"),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onChanged: (val) {
                          pro.setCity(val);
                        },
                        controller: pro.city,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "City"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: () {
                          // pro.setLocation();
                          Navigator.pushNamed(context, createProfile);
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
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
