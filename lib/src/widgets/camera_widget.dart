import 'dart:io';

import 'package:camera/camera.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../blocs/reporter_bloc.dart';
import '../blocs/reporter_events.dart';
import '../blocs/reporter_states.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  final logger = Logger('CameraWidget');

  late final CameraDescription _camera;
  late final CameraController _controller;
  late final Future<void> _controllerInitialized;
  bool isCameraPermissionGranted = false;

  Future<void> _initController() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      logger.info('Camera Permission: DENIED');
      isCameraPermissionGranted = false;
      return;
    }
    logger.info('Camera Permission: GRANTED');
    isCameraPermissionGranted = true;
    final cameras = await availableCameras();
    _camera = cameras.first;
    _controller = CameraController(
      _camera,
      ResolutionPreset.max,
    );
    await _controller.initialize();
  }

  @override
  initState() {
    logger.info('initState start');
    super.initState();
    _controllerInitialized = _initController();
  }

  @override
  void dispose() {
    logger.info('dispose start');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('build start');
    final screenOrientation = MediaQuery.of(context).orientation;
    logger.info('screenOrientation: $screenOrientation');
    final reporterBloc = BlocProvider.of<ReporterBloc>(context);

    return FutureBuilder<void>(
      future: _controllerInitialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BlocBuilder<ReporterBloc, ReporterState>(
            builder: (context, state) {
              logger.info(state);
              logger.info(state.toString());

              return Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: screenOrientation == Orientation.portrait
                        ? Column(
                            children:
                                createViewfinder(reporterBloc: reporterBloc),
                          )
                        : Row(
                            children:
                                createViewfinder(reporterBloc: reporterBloc),
                          ),
                  ),
                  Visibility(
                    visible: (state as ReporterCameraState)
                        .imageProcessingInProgress,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)?.txtProcessingImage ??
                              'Processing image...',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<Widget> createViewfinder({required ReporterBloc reporterBloc}) {
    return [
      Flexible(
        child: Center(
          child: isCameraPermissionGranted
              ? CameraPreview(
                  _controller,
                )
              : Text(
                  AppLocalizations.of(context)?.txtCameraPermissionDenied ??
                      'Permission to use camera not granted',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
      Container(
        color: Colors.black,
        child: Center(
          child: createSnapButton(reporterBloc: reporterBloc),
        ),
      ),
    ];
  }

  Widget createSnapButton({required ReporterBloc reporterBloc}) {
    return IconButton(
      onPressed:
          isCameraPermissionGranted ? () => _processImage(reporterBloc) : null,
      icon: const Icon(
        Icons.photo_camera, //camera,
        color: Colors.white,
      ),
      tooltip:
          AppLocalizations.of(context)?.btnShutter_Tooltip ?? 'Take Picture',
      iconSize: 72.0,
    );
  }

  _processImage(ReporterBloc bloc) async {
    try {
      bloc.add(ImageProcessingInProgress());

      final imageFile = await _controller.takePicture();
      logger.info('imageFile.path = ${imageFile.path}');

      final imageBytes = await File(imageFile.path).readAsBytes();
      final reportPhoto = Photo(fileName: imageFile.name, bytes: imageBytes);
      bloc.add(PhotoPrepared(reportPhoto: reportPhoto));

      await File(imageFile.path).delete();
    } catch (e) {
      logger.shout(e);
    }
  }
}
