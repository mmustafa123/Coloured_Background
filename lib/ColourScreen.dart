import 'dart:io';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CropScreen extends StatefulWidget {
  final path;
  CropScreen({@required this.path});

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  var flag=0;

  Color currentColor = Colors.deepPurpleAccent;
  void changeColor(Color color) => setState(() => currentColor = color);

  Widget build(BuildContext context) =>
      Container(
       child: Scaffold(
        backgroundColor: currentColor,
        appBar: AppBar(title: Text('Coloured Background'), centerTitle: true, leading: GestureDetector(onTap: (){
         Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
        },
            child: Icon(Icons.arrow_back)) ,),

        body: Column(
            children: <Widget>[

              Container(
                //margin: EdgeInsets.all(3),
                padding: EdgeInsets.only(top:3, bottom: 3),
                margin: EdgeInsets.only (left:4,right:4),
                width: 400,
                height: 612,
                child: Image.file(File(widget.path),),

              ),

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [

                  Container(
                    //padding: EdgeInsets.only(left: 80),
                    margin: EdgeInsets.all(5),
                    child: IconButton(
                        icon: Icon(Icons.color_lens_rounded),
                        focusColor: Colors.greenAccent,
                        iconSize: 50,
                        onPressed:  () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding: const EdgeInsets.all(0.0),
                                contentPadding: const EdgeInsets.all(0.0),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: currentColor,
                                    onColorChanged: changeColor,
                                    colorPickerWidth: 300.0,
                                    pickerAreaHeightPercent: 0.7,
                                    enableAlpha: true,
                                    displayThumbColor: true,
                                    showLabel: true,
                                    paletteType: PaletteType.hsv,
                                    pickerAreaBorderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(2.0),
                                      topRight: Radius.circular(2.0),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                    ),
                  ),
                ],
              )
            ]
        ),
      ),
  );
}

