import 'dart:async';

import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/routes/routes_names.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);
  static String defaultDialCode = '+1';

  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Completer<GoogleMapController> completer = Completer();
  static LatLng latLng = const LatLng(25.2048493, 55.2707828);

  LatLng initPosition = latLng;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  LatLng? markerPosition;

  onCameraMove(CameraPosition position) {
    initPosition = position.target;
  }

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    //addMarker();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SignUpProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Let's verify your phone number",
                  style: TextStyle(fontSize: 22, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please enter your phone number below, we will send you an SMS message to verify your number",
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (val) {
                          pro.setDialCode(val.dialCode!);
                          getLatLng(val.name.toString());
                        },
                        onInit: (val) {
                          pro.setDialCode(PhoneAuthentication.defaultDialCode);
                          pro.setDialCode(val!.dialCode!);
                        },
                        initialSelection: PhoneAuthentication.defaultDialCode,
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please Enter your phone";
                            }
                          },
                          onChanged: (val) {
                            pro.setPhoneNum(val);
                          },
                          controller: pro.phoneNumber,
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                        if (key.currentState!.validate()) {
                          pro.authUserWithPhone();
                          Navigator.pushNamed(context, verifyOTP);
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                // Expanded(
                //   child: GoogleMap(
                //     mapType: MapType.normal,
                //     initialCameraPosition:
                //         CameraPosition(target: latLng, zoom: 40.0),
                //     onMapCreated: onMapCreated,
                //     myLocationEnabled: true,
                //     tiltGesturesEnabled: true,
                //     compassEnabled: true,
                //     scrollGesturesEnabled: true,
                //     zoomGesturesEnabled: true,
                //     markers: Set<Marker>.of(pro.markers.values),
                //     // polylines: Set<Polyline>.of(_polylines.values),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void animateCamera(LatLng latLng) {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, tilt: 45, zoom: 13.12, bearing: 12.0)));
  }

  onMapCreated(GoogleMapController controller) {
    completer.complete(controller);
    _controller = controller;
  }

  Future<Position> getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  addMarker() {
    markers.clear();
    getUserCurrentLocation().then((value) {
      getDialCode(value);
      final MarkerId markerId = MarkerId(value.latitude.toString());
      print('this is marker function');
      print(value);
      final marker = Marker(markerId: MarkerId(value.latitude.toString()), position: LatLng(value.latitude, value.latitude), icon: BitmapDescriptor.defaultMarkerWithHue(12));
      setState(() {
        markers[markerId] = marker;
      });
      animateCamera(LatLng(value.latitude, value.longitude));
    });
  }

  getDialCode(Position position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    PhoneAuthentication.defaultDialCode = placeMarks[0].isoCountryCode.toString();
    final String location = placeMarks[0].street.toString() + ' ' + placeMarks[0].administrativeArea.toString() + ' ' + placeMarks[0].country.toString();
    storeLocation(location);
    print('--------this is code');
    print(PhoneAuthentication.defaultDialCode);
  }

  storeLocation(String loc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', loc);
  }

  getLatLng(String address) async {
    List<Location> location = await locationFromAddress(address);
    latLng = LatLng(location[0].latitude, location[0].longitude);
    animateCamera(latLng);
  }
}
