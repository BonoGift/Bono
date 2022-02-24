import 'dart:io';
import 'dart:typed_data';

import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Uint8ViewPage extends StatelessWidget {
  const Uint8ViewPage({Key? key, required this.bytes}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<FeedsProvider>(context);
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
                fit: BoxFit.cover,
              ),
            ),
             Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  pro.assignImage(bytes);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
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
            ),
          ],
        ),
      ),
    );
  }
}