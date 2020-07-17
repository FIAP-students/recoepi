import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:teachable_ml/controller/camera_helper.dart';
import 'package:teachable_ml/controller/tflite_helper.dart';
import 'package:teachable_ml/model/tflite_result.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reconhecimento de EPI'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: _pickImage,
      ),
      
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildImage(),
            _buildResult(),
          ],
        ),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: _image == null
                ? Text('Tire uma foto no botão flutuante para verificarmos sua EPI')
                : Image.file(
                    _image,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Container(
        height: 100.0,
        
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    var situacao;
    var textositu;
    

    if (_outputs.isEmpty) {
      return Center(
        
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        itemBuilder: (BuildContext context, int index) {
          print("O valor é ${_outputs[index].label}");
          if(_outputs[index].label == "0 ComEPI"){
            situacao = Colors.greenAccent;
            textositu = Text("Parabéns, está liberado");
          }else{
            situacao = Colors.redAccent;
            textositu = Text("Barrado, coloque a API imediatamente");
          }
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label} ( ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.0,
              ),
              LinearPercentIndicator(
                lineHeight: 100.0,
                progressColor: situacao,
                percent: _outputs[index].confidence,
                center: textositu
              ),
            ],
          );
        },
      ),
    );
  }
}
