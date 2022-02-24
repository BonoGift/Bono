import 'dart:io';

import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/provider/feeds_provider.dart';
import 'package:bono_gifts/views/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isClicked = false;
  GlobalKey<FormState> keyy = GlobalKey<FormState>();
  String photoErro = '';
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<FeedsProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: keyy,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      Text("Add Post",style: TextStyle(fontSize: 22),),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text("Title of post"),
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
                              return "Title is Required";
                            }
                          },
                          onChanged: (val){
                            pro.setTitle(val);
                            // pro.setName(val);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write some title",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Description"),
                  const SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    height: 150,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextField(
                          maxLines: 5,
                          onChanged: (val){
                            // pro.setName(val);
                            pro.setDescription(val);
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write some about post",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  pro.bytesImage == null ? InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RotatedBox(
                            quarterTurns: 4,
                            child: Image.asset(photoIcon,height: 30,),
                          ),
                          const SizedBox(width: 10,),
                          const Text("Upload Photos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),)
                        ],
                      ),
                    ),
                  ):Image.memory(pro.bytesImage!,height: 220,fit: BoxFit.cover,width: double.infinity,),
                  Text(photoErro,style: TextStyle(color: Colors.red),),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: ()=>Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      MaterialButton(
                        color: Colors.blue,
                        onPressed: isClicked ? null :(){
                          if(keyy.currentState!.validate() || pro.image != null){
                            setState(() {
                              isClicked = true;
                            });
                            pro.uploadPost(context);
                          }else{
                            setState(() {
                              photoErro = "Please Select Photo";
                            });
                          }
                        },
                        child: isClicked ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),):const Text("Post",style: TextStyle(color: Colors.white),),
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
