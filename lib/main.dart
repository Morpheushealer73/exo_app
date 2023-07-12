import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_d2go/flutter_d2go.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';

List<CameraDescription> cameras = [];
String finalDesc = '';
String plantName = '';
String isEdible = '';
String plantUsage = '';
String others = '';
String? _filePath = '';
String dropdownvalue = 'Mask-RCNN - Wild Plants';
String _finalPath = 'assets/models/wep_mask_rcnn_fbnetv3_v2.ptl';
Color edibilityColor = Colors.green;
double computedConfidenceLevel = 0.0;
var f = NumberFormat("###.0#", "en_US");

class WildPlants {
  String plantName;
  String plantDesc;
  String usage;
  String edibility;
  String others;
  WildPlants(
      this.plantName, this.plantDesc, this.usage, this.edibility, this.others);
}

List<WildPlants> wildPlants = [
  WildPlants(
      'Asparagus',
      'Wild asparagus, also known as "sparrow grass" or "garden asparagus," is a perennial plant that is native to Europe, Asia and Africa. It is similar in appearance to cultivated asparagus, but it grows wild and has a more intense flavor. Wild asparagus is typically thinner and more delicate than cultivated asparagus and has a slightly more bitter taste.',
      'Wild asparagus can be eaten cooked or raw, it is commonly sautéed, steamed, grilled or eaten raw in salads. It can also be pickled or preserved as a condiment.',
      'edible',
      '- Wild asparagus is a foraged food, and it is typically harvested in the spring.\n- It is considered a delicacy in some cultures and is often served in high-end restaurants.\n- Wild asparagus is a good source of vitamins A, C, and K, as well as folate, potassium, and iron.\n- Wild asparagus is also believed to have diuretic properties, which can help flush out excess fluids from the body.'),
  WildPlants(
      'Chickweed',
      'Chickweed is an annual or perennial herb that belongs to the carnation family. It is characterized by its small, white flowers and pointed, oval leaves. Chickweed is a common weed that grows in gardens and fields, and is often considered a nuisance. However, it is also edible and has been used for medicinal purposes.',
      'Chickweed leaves and stems can be eaten raw or cooked. It has a delicate, mild flavor and is often used as a salad green or added to sandwiches and soups. The plant can also be made into a tea or used as a poultice for skin irritations.',
      'edible',
      '- Chickweed is a good source of vitamins A, C, and D, as well as minerals such as iron, calcium, and potassium.\n- Chickweed has been used traditionally to soothe skin irritations and itching.\n- Chickweed is also believed to have anti-inflammatory and diuretic properties.\n- Chickweed is usually collected in the wild, and it is best to pick it when it is young and tender.\n- Chickweed is very invasive and can quickly take over a garden if not controlled.'),
  WildPlants(
      'Common Sow Thistle',
      'Common sow thistle, also known as prickly sow thistle, is a herbaceous perennial plant that belongs to the Asteraceae family. It is characterized by its tall stem, spiky leaves, and yellow flowers. Common sow thistle is considered a weed and is often found in cultivated fields, gardens, and along roadsides.',
      'Young leaves of common sow thistle can be eaten raw or cooked, it has a slightly bitter taste, the leaves are rich in vitamins and minerals. It can be used in salads, sandwiches or cooked as a vegetable. The plant\'s root can also be used to make a tea.',
      'edible',
      '- Common sow thistle is a good source of vitamins A, C, and K, as well as minerals such as potassium and iron.\n- The plant has been used traditionally as a diuretic, laxative and to treat skin conditions\n- Common sow thistle can grow to be quite tall, reaching up to 6 feet in height\n- The plant can spread rapidly and is considered an invasive species in some areas\n- It is important to note that common sow thistle may be confused with other plants that are poisonous, so it is essential to correctly identify it before consuming it.'),
  WildPlants(
      'Peppergrass',
      'Peppergrass, also known as Lepidium, is a genus of plants that belongs to the Brassicaceae family. It is characterized by its small, white or pink flowers, and delicate, lacy leaves. Peppergrass is an annual or perennial herb that is commonly found in cultivated fields, gardens, and along roadsides.',
      'The leaves and seeds of peppergrass can be eaten raw or cooked. The leaves have a slightly spicy, pepper-like flavor, and can be used in salads, sandwiches or as a garnish. The seeds can be used as a spice or as a condiment. The plant can also be made into a tea.',
      'edible',
      '- Peppergrass is a good source of vitamins A, C, and K, as well as minerals such as potassium and iron.\n- Peppergrass has been traditionally used as a diuretic and as a treatment for respiratory conditions.\n- Peppergrass can grow to be quite tall, reaching up to 2 feet in height.\n- The plant can spread rapidly and is considered an invasive species in some areas.\n- Peppergrass may be confused with other plants that are poisonous, so it is essential to correctly identify it before consuming it.'),
  WildPlants(
      'Wild Leek',
      'Wild leek, also known as ramps, is a perennial herb that belongs to the lily family. It is characterized by its broad, smooth leaves, and small, white flowers. Wild leek is native to North America and is commonly found in the eastern United States, particularly in the Appalachian region.',
      'Wild leek leaves, bulbs, and stalks can all be eaten. The leaves have a strong, garlicky flavor, and are commonly used in soups, stews, and omelets. The bulbs are similar to onions in flavor and can be used as a substitute in cooking. The stalks can also be eaten raw or cooked and have a milder flavor than the leaves.',
      'edible',
      '- Wild leek is a good source of vitamins A, C, and K, as well as minerals such as potassium and iron.\n- Wild leek is considered a delicacy in some cultures and is often served in high-end restaurants.\n- Wild leek is a foraged food, and it is typically harvested in the spring.\n- Wild leek is an indicator species of a healthy hardwood forest ecosystem.\n- Wild leek populations are considered threatened due to overharvesting and destruction of its habitat, it is important to sustainably forage and only take a small portion of the plant.'),
  WildPlants(
      'Red Clover',
      'Red clover is a perennial herb that is commonly found in fields, meadows, and roadsides throughout Europe, Asia, and North America. It has small, reddish-pink flowers that bloom in clusters.',
      'Red clover is often used as a supplement for its potential health benefits, which include reducing the risk of certain cancers, improving bone health, and relieving symptoms of menopause. It is also used as a natural remedy for skin conditions and as a blood purifier.',
      'edible',
      '- Red clover contains a variety of nutrients, including calcium, chromium, magnesium, niacin, phosphorus, potassium, thiamine, and vitamin C.\n- It is a source of isoflavones, which are a type of phytoestrogen that may mimic the effects of estrogen in the body.\n- Red clover has been traditionally used to treat a variety of health conditions, including asthma, bronchitis, cancer, and gout.\n- It is also used as a cover crop in agriculture, as it can fix nitrogen in the soil and improve soil health.\n- The safety of red clover supplements is not clear, and it can interact with certain medications, so it is important to speak with a healthcare professional before using it.')
];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error: ${e.code}, Message: ${e.description}');
  }
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<RecognitionModel>? _recognitions;
  File? _selectedImage;
  final List<String> _imageList = ['image1.png'];
  int _index = 0;
  int? _imageWidth;
  int? _imageHeight;
  final ImagePicker _picker = ImagePicker();

  CameraController? controller;
  bool _isDetecting = false;
  bool _isLiveModeOn = false;

  @override
  void initState() {
    super.initState();
    String modelPath = 'assets/models/WEP-MASK-v3-v2.ptl';
    String labelPath = 'assets/models/classes_new.txt';
    loadModel(modelPath, labelPath);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future loadModel(String model, String label) async {
    String modelPath = model;
    String labelPath = label;
    try {
      await FlutterD2go.loadModel(
        modelPath: modelPath,
        labelPath: labelPath,
      );
      setState(() {});
    } on PlatformException {
      debugPrint('Load model or label file failed.');
    }
  }

  Future detect() async {
    final image = _selectedImage ??
        await getImageFileFromAssets('assets/images/${_imageList[_index]}');
    final decodedImage = await decodeImageFromList(image.readAsBytesSync());
    final predictions = await FlutterD2go.getImagePrediction(
      image: image,
      minScore: 0.9,
    );
    List<RecognitionModel>? recognitions;
    if (predictions.isNotEmpty) {
      recognitions = predictions.map(
        (e) {
          return RecognitionModel(
              Rectangle(
                e['rect']['left'],
                e['rect']['top'],
                e['rect']['right'],
                e['rect']['bottom'],
              ),
              e['mask'],
              e['keypoints'] != null
                  ? (e['keypoints'] as List)
                      .map((k) => Keypoint(k[0], k[1]))
                      .toList()
                  : null,
              e['confidenceInClass'],
              e['detectedClass']);
        },
      ).toList();
    }

    setState(
      () {
        _imageWidth = decodedImage.width;
        _imageHeight = decodedImage.height;
        _recognitions = recognitions;
      },
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      _filePath = result?.files.single.path;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final fileName = path.split('/').last;
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 1.5;
    List<Widget> stackChildren = [];
    stackChildren.add(
      Container(
        width: screenWidth,
        child: _selectedImage == null
            ? Image.asset(
                'assets/images/${_imageList[_index]}',
              )
            : Image.file(_selectedImage!),
      ),
    );

    if (_recognitions != null) {
      final aspectRatio = _imageHeight! / _imageWidth! * screenWidth;
      final widthScale = screenWidth / _imageWidth!;
      final heightScale = aspectRatio / _imageHeight!;

      if (_recognitions!.first.mask != null) {
        stackChildren.addAll(_recognitions!.map(
          (recognition) {
            return RenderSegments(
              imageWidthScale: widthScale,
              imageHeightScale: heightScale,
              recognition: recognition,
            );
          },
        ).toList());
      }

      if (_recognitions!.first.keypoints != null) {
        RecognitionModel? recognition = _recognitions?.first;
        List<Widget> keypointChildren = [];
        if (recognition != null) {
          for (Keypoint keypoint in recognition.keypoints!) {
            keypointChildren.add(
              RenderKeypoints(
                keypoint: keypoint,
                imageWidthScale: widthScale,
                imageHeightScale: heightScale,
              ),
            );

            stackChildren.addAll(keypointChildren);
          }
        }
      }

      stackChildren.addAll(_recognitions!.map(
        (recognition) {
          return RenderBoxes(
            imageWidthScale: widthScale,
            imageHeightScale: heightScale,
            recognition: recognition,
          );
        },
      ).toList());
    }
    int indexChecker = 0;
    double? confidenceLevel = 0.0;

    if (_filePath != '') {
      _finalPath = _filePath!;
    } else {
      _finalPath = 'assets/models/wep_mask_rcnn_fbnetv3_v2.ptl';
    }

    if (wildPlants.indexWhere((plant) =>
            plant.plantName ==
            '${_recognitions?.first.detectedClass!.toString()}') !=
        -1) {
      finalDesc = wildPlants[wildPlants.indexWhere((plant) =>
              plant.plantName ==
              '${_recognitions?.first.detectedClass!.toString()}')]
          .plantDesc;
      isEdible = wildPlants[wildPlants.indexWhere((plant) =>
              plant.plantName ==
              '${_recognitions?.first.detectedClass!.toString()}')]
          .edibility;
      edibilityColor = Colors.greenAccent;
      confidenceLevel = _recognitions?.first.confidenceInClass;
      plantName = wildPlants[wildPlants.indexWhere((plant) =>
              plant.plantName ==
              '${_recognitions?.first.detectedClass!.toString()}')]
          .plantName;
      plantUsage = wildPlants[wildPlants.indexWhere((plant) =>
              plant.plantName ==
              '${_recognitions?.first.detectedClass!.toString()}')]
          .usage;
      others = wildPlants[wildPlants.indexWhere((plant) =>
              plant.plantName ==
              '${_recognitions?.first.detectedClass!.toString()}')]
          .others;
      computedConfidenceLevel = (confidenceLevel! * 100.0);
    } else {
      plantName = 'No Edible Plant Detected!';
      finalDesc = 'Undetermined';
      isEdible = 'Undetermined';
      plantUsage = 'Undetermined';
      others = 'Undeterminded';
      edibilityColor = Colors.redAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXO'),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 30),
        elevation: 0,
      ),
      body: Container(
          child: Center(
              child: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Colors.green),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Stack(
                  children: stackChildren,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    plantName.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent),
                    minFontSize: 15,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: edibilityColor),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Align(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      isEdible,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      minFontSize: 15,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Column(children: [
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
                color: Colors.green[200]),
            child: DropdownButton<String>(
              // Step 3.
              value: dropdownvalue,
              // Step 4.
              items: <String>[
                'Mask-RCNN - Wild Plants',
                'Faster-RCNN - Wild Plants',
                'Mask-RCNN - COCO',
                'Faster-RCNN - COCO'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
              // Step 5.
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                  if (dropdownvalue == 'Mask-RCNN - Wild Plants') {
                    String modelPath = 'assets/models/WEP-MASK-v3-v2.ptl';
                    String labelPath = 'assets/models/classes_new.txt';
                    loadModel(modelPath, labelPath);
                  } else if (dropdownvalue == 'Faster-RCNN - Wild Plants') {
                    String modelPath = 'assets/models/WEP-FASTER-v3_v2.ptl';
                    String labelPath = 'assets/models/classes_new.txt';
                    loadModel(modelPath, labelPath);
                  } else if (dropdownvalue == 'Mask-RCNN - COCO') {
                    String modelPath = 'assets/models/d2go_mask.ptl';
                    String labelPath = 'assets/models/classes.txt';
                    loadModel(modelPath, labelPath);
                  } else if (dropdownvalue == 'Faster-RCNN - COCO') {
                    String modelPath = 'assets/models/d2go.ptl';
                    String labelPath = 'assets/models/classes.txt';
                    loadModel(modelPath, labelPath);
                  }
                });
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: edibilityColor),
            child: ExpansionTile(
              title: Text('Description'),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  child: AutoSizeText(
                    finalDesc,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    minFontSize: 15,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: edibilityColor),
            child: ExpansionTile(
              title: Text('Usage'),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  child: AutoSizeText(
                    plantUsage,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    minFontSize: 15,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: edibilityColor),
            child: ExpansionTile(
              title: Text('Others'),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  child: AutoSizeText(
                    others,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    minFontSize: 15,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.25),
        ]),
      ]))),
      floatingActionButton: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 75.0,
            width: 75.0,
            child: FloatingActionButton(
              onPressed: () async {
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile == null) return;
                setState(
                  () {
                    _recognitions = null;
                    _selectedImage = File(pickedFile.path);
                  },
                );
              },
              child: const Icon(Icons.photo),
              backgroundColor: Colors.green,
            ),
          ),
          SizedBox(width: 10),
          FloatingActionButton.large(
            onPressed: !_isLiveModeOn ? detect : null,
            child: const Icon(Icons.eco),
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 10),
          SizedBox(
            height: 75.0,
            width: 75.0,
            child: FloatingActionButton(
              onPressed: () async {
                final XFile? pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile == null) return;
                setState(
                  () {
                    _recognitions = null;
                    _selectedImage = File(pickedFile.path);
                  },
                );
              },
              child: const Icon(Icons.add_a_photo),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: SizedBox(height: 70),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class RenderBoxes extends StatelessWidget {
  const RenderBoxes({
    Key? key,
    required this.recognition,
    required this.imageWidthScale,
    required this.imageHeightScale,
  }) : super(key: key);

  final RecognitionModel recognition;
  final double imageWidthScale;
  final double imageHeightScale;

  @override
  Widget build(BuildContext context) {
    final left = recognition.rect.left * imageWidthScale;
    final top = recognition.rect.top * imageHeightScale;
    final right = recognition.rect.right * imageWidthScale;
    final bottom = recognition.rect.bottom * imageHeightScale;
    return Positioned(
      left: left,
      top: top,
      width: right - left,
      height: bottom - top,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
        ),
        child: Text(
          "${recognition.detectedClass} ${(recognition.confidenceInClass * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            background: Paint()..color = Colors.greenAccent,
            color: Colors.brown,
            fontSize: 15.0,
          ),
        ),
      ),
    );
  }
}

class RenderSegments extends StatelessWidget {
  const RenderSegments({
    Key? key,
    required this.recognition,
    required this.imageWidthScale,
    required this.imageHeightScale,
  }) : super(key: key);

  final RecognitionModel recognition;
  final double imageWidthScale;
  final double imageHeightScale;

  @override
  Widget build(BuildContext context) {
    final left = recognition.rect.left * imageWidthScale;
    final top = recognition.rect.top * imageHeightScale;
    final right = recognition.rect.right * imageWidthScale;
    final bottom = recognition.rect.bottom * imageHeightScale;
    final mask = recognition.mask!;
    return Positioned(
      left: left,
      top: top,
      width: right - left,
      height: bottom - top,
      child: Image.memory(
        mask,
        fit: BoxFit.fill,
      ),
    );
  }
}

class RenderKeypoints extends StatelessWidget {
  const RenderKeypoints({
    Key? key,
    required this.keypoint,
    required this.imageWidthScale,
    required this.imageHeightScale,
  }) : super(key: key);

  final Keypoint keypoint;
  final double imageWidthScale;
  final double imageHeightScale;

  @override
  Widget build(BuildContext context) {
    final x = keypoint.x * imageWidthScale;
    final y = keypoint.y * imageHeightScale;
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class RecognitionModel {
  RecognitionModel(
    this.rect,
    this.mask,
    this.keypoints,
    this.confidenceInClass,
    this.detectedClass,
  );
  Rectangle rect;
  Uint8List? mask;
  List<Keypoint>? keypoints;
  double confidenceInClass;
  String detectedClass;
}

class Rectangle {
  Rectangle(this.left, this.top, this.right, this.bottom);
  double left;
  double top;
  double right;
  double bottom;
}

class Keypoint {
  Keypoint(this.x, this.y);
  double x;
  double y;
}
