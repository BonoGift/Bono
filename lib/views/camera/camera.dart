import 'dart:typed_data';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/views/camera/uint8_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<FeedsProvider>(context,listen: false).getCamera();
    Provider.of<FeedsProvider>(context,listen: false).getPhotoGAllery();
  }
  @override
  void dispose() {
    super.dispose();
    Future.delayed(const Duration(seconds: 4),(){
      Provider.of<FeedsProvider>(context,listen: false).dispostCameraController();
    });

  }
  @override
  Widget build(BuildContext context) {
    final pro =  Provider.of<FeedsProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: pro.cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(pro.cameraController));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              // color: Colors.black,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: pro.imageList.length,
                      itemBuilder: (ctx,i){
                        return FutureBuilder<Uint8List?>(
                        future: pro.imageList[i].thumbDataWithSize(300, 300),
                        builder: (BuildContext context, snapshot) {
                          // Uint8List bytes = snapshot.data;
                          print(snapshot);
                        if (snapshot.connectionState == ConnectionState.done) {
                              return InkWell(
                                onTap: (){
                                  print(snapshot.data![i]);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Uint8ViewPage(bytes: snapshot.data!,)
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.memory(
                                    snapshot.data!,
                                    height: 80,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                          );
                      },
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            pro.flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => pro.onOFfFlash()),
                      GestureDetector(
                        onLongPress: () =>pro.recordVideo(),
                        onLongPressUp: () => pro.stopRecordVideo(context),
                        onTap: ()=> pro.takePhotoProvider(context),
                        child: pro.isRecoring
                            ? const Icon(
                          Icons.radio_button_on,
                          color: Colors.red,
                          size: 80,
                        )
                            : const Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                          icon: Transform.rotate(
                            angle: pro.transform,
                            child: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () => pro.flipCamera()),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}