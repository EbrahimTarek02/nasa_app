import 'dart:io';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late FilePickerResult result;
  // late var file;
  String fileName = '';

  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> messages = [
    'Hello, please pick a PDF'
  ];
  // List<String> recommendedMessages = ['Add New File'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Text(
            'STAR',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Color(0xff242424),
          centerTitle: true,
        ),

        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15),
                            child: Text(
                              messages[index],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff242424),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Spacer()
                        ],
                      );
                    }
                    else {
                      print('else');
                        return index % 2 != 0
                            ? Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15),
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          messages[index],
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          speed:
                                              const Duration(milliseconds: 100),
                                        ),
                                      ],
                                      totalRepeatCount: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff242424),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Spacer()
                                ],
                              )
                            : Row(
                                children: [
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15),
                                    child: Text(
                                      messages[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              );
                      }
                    },
                  separatorBuilder: (_, index) {return SizedBox(height: 10.0);},
                  itemCount: messages.length
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          if (messages.length < 2){
                            return 'Please upload a PDF first';
                          }
                          return null;
                        },
                        style: TextStyle(
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(Icons.file_upload),
                            color: Colors.white,
                            onPressed: ()async{

                              PlatformFile? pickedFile;
                              final result = await FilePicker.platform.pickFiles(
                                allowedExtensions: ['pdf'],
                                type: FileType.custom
                              );
                              if (result == null){
                                return;
                              }

                              setState(() {
                                pickedFile = result.files.first;
                              });

                              final path = 'files/${pickedFile!.name}';
                              final file = File(pickedFile!.path!);

                              final ref = FirebaseStorage.instance.ref().child(path);
                              var uploadTask = ref.putFile(file);

                              final snapshot = await uploadTask!.whenComplete((){});

                              final urlDownload = await snapshot.ref.getDownloadURL();
                              print('link: $urlDownload');

                              messages.add('File Uploaded Successfully');

                              print(messages);

                              setState(() {

                              });
                            },
                          ),
                          hintText: 'Please Enter a Question',
                          hintStyle: TextStyle(
                              color: Colors.grey
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.grey
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                        ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  FloatingActionButton(

                    onPressed: ()async{

                    final path = 'textFiles';
                    final textFile = controller.text;

                    final ref = FirebaseStorage.instance.ref().child(path);
                    ref.putData(textFile as Uint8List);

                    messages.add('File Uploaded Successfully');

                    print(messages);

                    setState(() {

                    });



                        messages.add(controller.text);
                        messages.add('response');
                        controller.clear();

                        setState(() {

                        });

                    },
                    child: Icon(Icons.send,color: Colors.white,size: 28,),
                    backgroundColor: Color(0xff5D5CDE),
                    elevation: 0,
                  ),
                ],
              ),
            ],
          )
        ),
    );
  }

  void openFile(PlatformFile file) async {
    OpenFile.open(file.path!);
  }
}