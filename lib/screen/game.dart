// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ui;
import 'dart:math' as math;
import 'package:image_picker/image_picker.dart';
import 'package:jigsaw/screen/endpage.dart';
import 'package:jigsaw/screen/takephoto.dart';

class PuzzleWidget extends StatefulWidget {
  final File? image;
  final int grid;
  const PuzzleWidget({Key? key, this.image, required this.grid})
      : super(key: key);

  @override
  PuzzleWidgetState createState() => PuzzleWidgetState();
}

class PuzzleWidgetState extends State<PuzzleWidget> {
  // lets setup our puzzle 1st

  // add test button to check crop work
  // well done.. let put callback for success put piece & complete all

  GlobalKey<JigsawWidgetState> jigKey = GlobalKey<JigsawWidgetState>();
  File? _imageFile;
  int timercount = 0;
  late Timer stopwatch;

  void countTimer() {
    timercount = 0;
    stopwatch = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timercount++;
      });
    });
  }

  Future<dynamic> endDialog(time) {
    return showDialog(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .8 + 10,
                height: MediaQuery.of(context).size.height * .48 + 10,
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.pink[100],
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(50, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.games,
                                color: const Color.fromRGBO(228, 60, 137, 1),
                                size: MediaQuery.of(context).size.width * .08,
                              ),
                              const Padding(padding: EdgeInsets.only(left: 20)),
                              Text(
                                'Congratulation!',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .08,
                                  color: const Color.fromRGBO(228, 60, 137, 1),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'db',
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                'เวลาที่ทำได้ $time',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .06,
                                  color: const Color.fromRGBO(228, 60, 137, 1),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  fontFamily: 'db',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .3,
                              height: MediaQuery.of(context).size.height * .3,
                              decoration: BoxDecoration(
                                  color: Colors.pink[200],
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.pink,
                                  ),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text(
                                'เริ่มเกมใหม่',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * .06,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _imageFile = widget.image;
  }

  @override
  void dispose() {
    super.dispose();
    stopwatch.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final String minutes = (timercount ~/ 60).toString().padLeft(2, '0');
    final String seconds = (timercount % 60).toString().padLeft(2, '0');
    return Scaffold(
      body: Container(
        color: Colors.pink[50],
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                // let make base for our puzzle widget
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Time : $minutes:$seconds',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: JigsawWidget(
                    callbackFinish: () {
                      // check function
                      print("callbackFinish");

                      stopwatch.cancel();
                      endDialog('$minutes:$seconds');
                    },
                    callbackSuccess: () {
                      print("callbackSuccess");
                      // lets fix error size
                    },
                    key: jigKey,
                    // set container for our jigsaw image
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: _imageFile == null
                          ? const Image(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/logo.jpg"),
                            )
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text("Clear"),
                        onPressed: () {
                          jigKey.currentState!.resetJigsaw();
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => const AlertDialog(
                              backgroundColor: Colors.transparent,
                              title: SizedBox(
                                height: 200,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                          await jigKey.currentState!
                              .generaJigsawCropImage(widget.grid)
                              .then((value) {
                            setState(() {
                              Navigator.of(context).pop();
                              countTimer();
                            });
                          });
                          //endDialog('$minutes:$seconds');
                        },
                        child: const Text("Generate"),
                      ),
                      /*ElevatedButton(
                        onPressed: () {
                          takePicture();
                        },
                        child: const Text("Take Photo"),
                      ),*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JigsawWidget extends StatefulWidget {
  Widget child;
  Function() callbackSuccess;
  Function() callbackFinish;
  JigsawWidget(
      {Key? key,
      required this.child,
      required this.callbackFinish,
      required this.callbackSuccess})
      : super(key: key);

  @override
  JigsawWidgetState createState() => JigsawWidgetState();
}

class JigsawWidgetState extends State<JigsawWidget> {
  GlobalKey globalKey = GlobalKey();
  ui.Image? fullImage;
  Size? size;

  List<List<BlockClass>> images = <List<BlockClass>>[];
  ValueNotifier<List<BlockClass>> blocksNotifier =
      ValueNotifier<List<BlockClass>>(<BlockClass>[]);
  CarouselController? _carouselController;

  // to save current touch down offset & current index puzzle
  Offset _pos = Offset.zero;
  int? _index;

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();

    return ui.decodeImage(pngBytes);
  }

  resetJigsaw() {
    images.clear();
    blocksNotifier = ValueNotifier<List<BlockClass>>(<BlockClass>[]);
    // _carouselController = new CarouselController();
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> generaJigsawCropImage(grid) async {
    // 1st we need create a class for block image
    images = [[]];

    // get image from out boundary

    fullImage ??= await _getImageFromWidget();

    // split image using crop

    int xSplitCount = grid;
    int ySplitCount = grid;

    // i think i know what the problom width & height not correct!
    double widthPerBlock =
        fullImage!.width / xSplitCount; // change back to width
    double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      // temporary images
      final tempImages = <BlockClass>[];

      images.add(tempImages);
      for (var x = 0; x < xSplitCount; x++) {
        int randomPosRow = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;
        int randomPosCol = math.Random().nextInt(2) % 2 == 0 ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        // make random jigsaw pointer in or out

        ClassJigsawPos jigsawPosSide = ClassJigsawPos(
          bottom: y == ySplitCount - 1 ? 0 : randomPosCol,
          left: x == 0
              ? 0
              : -images[y][x - 1].jigsawBlockWidget.imageBox.posSide.right,
          right: x == xSplitCount - 1 ? 0 : randomPosRow,
          top: y == 0
              ? 0
              : -images[y - 1][x].jigsawBlockWidget.imageBox.posSide.bottom,
        );

        double xAxis = widthPerBlock * x;
        double yAxis = heightPerBlock * y; // this is culprit.. haha

        // size for pointing
        double minSize = math.min(widthPerBlock, heightPerBlock) / 15 * 4;

        offsetCenter = Offset(
          (widthPerBlock / 2) + (jigsawPosSide.left == 1 ? minSize : 0),
          (heightPerBlock / 2) + (jigsawPosSide.top == 1 ? minSize : 0),
        );

        // change axis for posSideEffect
        xAxis -= jigsawPosSide.left == 1 ? minSize : 0;
        yAxis -= jigsawPosSide.top == 1 ? minSize : 0;

        // get width & height after change Axis Side Effect
        double widthPerBlockTemp = widthPerBlock +
            (jigsawPosSide.left == 1 ? minSize : 0) +
            (jigsawPosSide.right == 1 ? minSize : 0);
        double heightPerBlockTemp = heightPerBlock +
            (jigsawPosSide.top == 1 ? minSize : 0) +
            (jigsawPosSide.bottom == 1 ? minSize : 0);

        // create crop image for each block
        ui.Image temp = ui.copyCrop(
          fullImage!,
          xAxis.round(),
          yAxis.round(),
          widthPerBlockTemp.round(),
          heightPerBlockTemp.round(),
        );

        // get offset for each block show on center base later
        Offset offset = Offset(size!.width / 2 - widthPerBlockTemp / 2,
            size!.height / 2 - heightPerBlockTemp / 2);

        ImageBox imageBox = ImageBox(
          image: Image.memory(
            Uint8List.fromList(ui.encodePng(temp)),
            fit: BoxFit.contain,
          ),
          isDone: false,
          offsetCenter: offsetCenter,
          posSide: jigsawPosSide,
          radiusPoint: minSize,
          size: Size(widthPerBlockTemp, heightPerBlockTemp),
        );

        images[y].add(
          BlockClass(
            jigsawBlockWidget: JigsawBlockWidget(
              imageBox: imageBox,
            ),
            offset: offset,
            offsetDefault: Offset(xAxis, yAxis),
          ),
        );
      }
    }

    blocksNotifier.value = images.expand((image) => image).toList();
    blocksNotifier.value.shuffle();
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  @override
  void initState() {
    _index = 0;
    _carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: blocksNotifier,
        builder: (context, List<BlockClass> blocks, child) {
          List<BlockClass> blockNotDone = blocks
              .where((block) => !block.jigsawBlockWidget.imageBox.isDone)
              .toList();
          List<BlockClass> blockDone = blocks
              .where((block) => block.jigsawBlockWidget.imageBox.isDone)
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Listener(
                    onPointerUp: (event) {
                      if (blockNotDone.isEmpty) {
                        resetJigsaw();
                        widget.callbackFinish.call();
                      }

                      if (_index == null) {
                        _carouselController?.nextPage(
                            duration: const Duration(microseconds: 600));
                        setState(() {});
                      }
                    },
                    onPointerMove: (event) {
                      if (_index == null) {
                        return;
                      }
                      if (blockNotDone.isEmpty) {
                        return;
                      }

                      final Offset offset = event.localPosition - _pos;

                      blockNotDone[_index!].offset = offset;

                      const minSensitivity = 0;
                      const maxSensitivity = 1;
                      const maxDistanceThreshold = 20;
                      const minDistanceThreshold = 1;

                      const sensitivity = 0.5;
                      const distanceThreshold = sensitivity *
                              (maxSensitivity - minSensitivity) *
                              (maxDistanceThreshold - minDistanceThreshold) +
                          minDistanceThreshold;

                      if ((blockNotDone[_index!].offset -
                                  blockNotDone[_index!].offsetDefault)
                              .distance <
                          distanceThreshold) {
                        blockNotDone[_index!]
                            .jigsawBlockWidget
                            .imageBox
                            .isDone = true;

                        blockNotDone[_index!].offset =
                            blockNotDone[_index!].offsetDefault;

                        _index = null;

                        blocksNotifier.notifyListeners();

                        widget.callbackSuccess.call();
                      }

                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        if (blocks.isEmpty) ...[
                          RepaintBoundary(
                            key: globalKey,
                            child: Container(
                              color: Colors.green,//image's background
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: widget.child,
                            ),
                          )
                        ],
                        Offstage(
                          offstage: blocks.isEmpty,
                          child: Container(
                            color: Colors.white,//jigsaw's background
                            width: size?.width,
                            height: size?.height,
                            child: CustomPaint(
                              painter: JigsawPainterBackground(
                                blocks,
                                outlineCanvas: true,
                              ),
                              child: Stack(
                                children: [
                                  if (blockDone.isNotEmpty)
                                    ...blockDone.map(
                                      (map) {
                                        return Positioned(
                                          left: map.offset.dx,
                                          top: map.offset.dy,
                                          child: Container(
                                            //block success
                                            child: map.jigsawBlockWidget,
                                          ),
                                        );
                                      },
                                    ),
                                  if (blockNotDone.isNotEmpty)
                                    ...blockNotDone.asMap().entries.map(
                                      (map) {
                                        return Positioned(
                                          left: map.value.offset.dx,
                                          top: map.value.offset.dy,
                                          child: Offstage(
                                            offstage: !(_index == map.key),
                                            child: GestureDetector(
                                              onTapDown: (details) {
                                                if (map.value.jigsawBlockWidget
                                                    .imageBox.isDone) {
                                                  return;
                                                }

                                                setState(() {
                                                  _pos = details.localPosition;
                                                  _index = map.key;
                                                });
                                              },
                                              child: Container(
                                                //block not success
                                                child:
                                                    map.value.jigsawBlockWidget,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  color: Colors.white,//background block bottom
                  height: 120,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      initialPage: _index ?? 0,
                      height: 80,
                      aspectRatio: 1,
                      viewportFraction: 0.3,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        _index = index;
                        setState(() {});
                      },
                    ),
                    items: blockNotDone.map((block) {
                      final Size sizeBlock =
                          block.jigsawBlockWidget.imageBox.size;
                      return FittedBox(
                        child: SizedBox(
                          width: sizeBlock.width,
                          height: sizeBlock.height,
                          child: block.jigsawBlockWidget,
                        ),
                      );
                    }).toList(),
                  ))
            ],
          );
        });
  }
}

class JigsawPainterBackground extends CustomPainter {
  List<BlockClass> blocks;
  bool outlineCanvas;

  JigsawPainterBackground(this.blocks, {required this.outlineCanvas});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    Path path = Path();

    // loop blocks so we can draw line at base
    for (var element in blocks) {
      Path pathTemp = getPiecePath(
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );

      path.addPath(pathTemp, element.offsetDefault);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BlockClass {
  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;

  BlockClass({
    required this.offset,
    required this.jigsawBlockWidget,
    required this.offsetDefault,
  });
}

class ImageBox {
  Widget image;
  ClassJigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;

  ImageBox({
    required this.image,
    required this.posSide,
    required this.isDone,
    required this.offsetCenter,
    required this.radiusPoint,
    required this.size,
  });
}

class ClassJigsawPos {
  int top, bottom, left, right;

  ClassJigsawPos({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
}

class JigsawBlockWidget extends StatefulWidget {
  ImageBox imageBox;
  JigsawBlockWidget({Key? key, required this.imageBox}) : super(key: key);

  @override
  JigsawBlockWidgetState createState() => JigsawBlockWidgetState();
}

class JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  // lets start clip crop image so show like jigsaw puzzle

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PuzzlePieceClipper(imageBox: widget.imageBox),
      child: CustomPaint(
        foregroundPainter: JigsawBlokPainter(imageBox: widget.imageBox),
        child: widget.imageBox.image,
      ),
    );
  }
}

class JigsawBlokPainter extends CustomPainter {
  ImageBox imageBox;

  JigsawBlokPainter({
    required this.imageBox,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // we make function so later custom painter can use same path
    // yeayyyy
    Paint paint = Paint()
      ..color = imageBox.isDone
          ? Colors.white.withOpacity(0.2)
          : Colors.black //will use later
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
        getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
            imageBox.posSide),
        paint);

    if (imageBox.isDone) {
      Paint paintDone = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
      canvas.drawPath(
          getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
              imageBox.posSide),
          paintDone);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  ImageBox imageBox;
  PuzzlePieceClipper({
    required this.imageBox,
  });
  @override
  Path getClip(Size size) {
    // we make function so later custom painter can use same path
    return getPiecePath(
        size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

getPiecePath(
  Size size,
  double radiusPoint,
  Offset offsetCenter,
  ClassJigsawPos posSide,
) {
  Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  // calculate top point on 4 point
  topLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
          (posSide.top > 0) ? radiusPoint : 0) +
      topLeft;
  topRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
          (posSide.top > 0) ? radiusPoint : 0) +
      topRight;
  bottomRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
          (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomRight;
  bottomLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
          (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomLeft;

  // calculate mid point for min & max
  double topMiddle = posSide.top == 0
      ? topRight.dy
      : (posSide.top > 0
          ? topRight.dy - radiusPoint
          : topRight.dy + radiusPoint);
  double bottomMiddle = posSide.bottom == 0
      ? bottomRight.dy
      : (posSide.bottom > 0
          ? bottomRight.dy + radiusPoint
          : bottomRight.dy - radiusPoint);
  double leftMiddle = posSide.left == 0
      ? topLeft.dx
      : (posSide.left > 0
          ? topLeft.dx - radiusPoint
          : topLeft.dx + radiusPoint);
  double rightMiddle = posSide.right == 0
      ? topRight.dx
      : (posSide.right > 0
          ? topRight.dx + radiusPoint
          : topRight.dx - radiusPoint);

  // solve.. wew

  path.moveTo(topLeft.dx, topLeft.dy);
  // top draw
  if (posSide.top != 0) {
    path.extendWithPath(
        calculatePoint(Axis.horizontal, topLeft.dy,
            Offset(offsetCenter.dx, topMiddle), radiusPoint),
        Offset.zero);
  }
  path.lineTo(topRight.dx, topRight.dy);
  // right draw
  if (posSide.right != 0) {
    path.extendWithPath(
        calculatePoint(Axis.vertical, topRight.dx,
            Offset(rightMiddle, offsetCenter.dy), radiusPoint),
        Offset.zero);
  }
  path.lineTo(bottomRight.dx, bottomRight.dy);
  if (posSide.bottom != 0) {
    path.extendWithPath(
        calculatePoint(Axis.horizontal, bottomRight.dy,
            Offset(offsetCenter.dx, bottomMiddle), -radiusPoint),
        Offset.zero);
  }
  path.lineTo(bottomLeft.dx, bottomLeft.dy);
  if (posSide.left != 0) {
    path.extendWithPath(
        calculatePoint(Axis.vertical, bottomLeft.dx,
            Offset(leftMiddle, offsetCenter.dy), -radiusPoint),
        Offset.zero);
  }
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}

// design each point shape
calculatePoint(Axis axis, double fromPoint, Offset point, double radiusPoint) {
  Path path = Path();

  if (axis == Axis.horizontal) {
    path.moveTo(point.dx - radiusPoint / 2, fromPoint);
    path.lineTo(point.dx - radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, fromPoint);
  } else if (axis == Axis.vertical) {
    path.moveTo(fromPoint, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy + radiusPoint / 2);
    path.lineTo(fromPoint, point.dy + radiusPoint / 2);
  }

  return path;
}
