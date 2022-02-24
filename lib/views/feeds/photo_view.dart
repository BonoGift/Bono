import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Uint8FeedsViewPage extends StatelessWidget {
  const Uint8FeedsViewPage({Key? key, required this.bytes}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.memory(
                bytes,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: (){},
                  child: const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.blue,
                      child:  Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                )
              // Container(
              //   color: Colors.black38,
              //   width: MediaQuery.of(context).size.width,
              //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              //   child: TextFormField(
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 17,
              //     ),
              //     maxLines: 6,
              //     minLines: 1,
              //     decoration: InputDecoration(
              //         border: InputBorder.none,
              //         hintText: "Add Caption....",
              //         prefixIcon: Icon(
              //           Icons.add_photo_alternate,
              //           color: Colors.white,
              //           size: 27,
              //         ),
              //         hintStyle: TextStyle(
              //           color: Colors.white,
              //           fontSize: 17,
              //         ),
              //         ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}