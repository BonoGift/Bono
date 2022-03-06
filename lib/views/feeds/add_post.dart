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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffeef9ff),
      appBar: AppBar(
        backgroundColor: const Color(0xffeef9ff),
        elevation: 0,
        title: const Text(
          "Post Something",
          style: TextStyle(
            fontSize: 50,
            fontFamily: 'EdwardianScriptITC',
            color: Colors.black,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: Form(
            key: keyy,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Title",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      shadowColor: Colors.grey,
                      margin: const EdgeInsets.all(0),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Title is Required";
                          }
                        },
                        onChanged: (val) {
                          pro.setTitle(val);
                          // pro.setName(val);
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 16),
                          hintText: "My birthday party!",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Description ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: ' (optional)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 6,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    height: 150,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      shadowColor: Colors.grey,
                      margin: const EdgeInsets.all(0),
                      child: TextField(
                        maxLines: 5,
                        textInputAction: TextInputAction.done,
                        onChanged: (val) {
                          // pro.setName(val);
                          pro.setDescription(val);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 16, top: 16),
                          hintText: "Leave a description of your post",
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/camera_icon.png',
                        width: 24,
                        height: 24,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Add photos',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CameraScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                          color: Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              Image.asset(
                                'assets/images/icons/post_camera_icon.jpeg',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Add',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (pro.bytesImage != null)
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.memory(
                              pro.bytesImage!,
                              height: 75,
                              fit: BoxFit.cover,
                              width: 75,
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: InkWell(
                                onTap: () {
                                  pro.bytesImage = null;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    photoErro,
                    style: const TextStyle(color: Colors.red),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        color: const Color(0xff3a3839),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                        onPressed: isClicked
                            ? null
                            : () {
                                if (keyy.currentState!.validate() || pro.image != null) {
                                  setState(() {
                                    isClicked = true;
                                  });
                                  pro.uploadPost(context);
                                } else {
                                  setState(() {
                                    photoErro = "Please Select Photo";
                                  });
                                }
                              },
                        child: isClicked
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                "Post",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
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
