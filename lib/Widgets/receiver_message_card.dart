import 'package:chat_app/Widgets/audio_file.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'Audio Component/audio_player.dart';
import 'package:just_audio/just_audio.dart' as ap;

import 'Video Component/video_player.dart';

class ReceiverMessageCard extends StatefulWidget {
  const ReceiverMessageCard(this.fileName, this.msgType, this.msg, this.time,
      {Key? key})
      : super(key: key);
  final String msg;
  final String time;
  final String msgType;
  final String fileName;

  @override
  State<ReceiverMessageCard> createState() => _ReceiverMessageCardState();
}

class _ReceiverMessageCardState extends State<ReceiverMessageCard> {
  // late VideoPlayerController _videoPlayerController;
  // ChewieController? _chewieController;
  // int? bufferDelay;

  Widget messageBuilder(context) {
    Widget body = Container();
    if (widget.msgType == "image") {
      body = Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300,
            // minHeight: 200,
            maxWidth: 290,
            // minWidth: 200
          ),
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: InteractiveViewer(
                        panEnabled: false,
                        boundaryMargin: const EdgeInsets.all(50),
                        minScale: 0.5,
                        maxScale: 2,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/Fading lines.gif',
                          placeholderCacheHeight: 10,
                          placeholderCacheWidth: 10,
                          image: widget.msg,
                        ),
                      ),
                    );
                  });
            },
            child: PhysicalModel(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/Fading lines.gif',
                // placeholderScale: 1,
                image: widget.msg,
              ),
            ),
          ),
        ),
      );
    } else if (widget.msgType == "text") {
      body = Padding(
        padding: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            // maxHeight: 300,
            // minHeight: 200,
            maxWidth: 280,
            // minWidth: 200
          ),
          child: SelectableText(
            widget.msg,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    } else if (widget.msgType == "video") {
      body = InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return VideoViewPage(path: widget.msg);
            },
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          width: MediaQuery.of(context).size.width * .5,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: PhysicalModel(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.black54,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              child: const Icon(Icons.play_circle_outline_rounded,
                  color: Colors.white, size: 100),
            ),
            // Column(
            //   children: <Widget>[
            //     Expanded(
            //       child: _chewieController != null &&
            //               _chewieController!
            //                   .videoPlayerController.value.isInitialized
            //           ? Chewie(
            //               controller: _chewieController!,
            //             )
            //           : Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: const [
            //                 CircularProgressIndicator(color: Colors.black),
            //                 SizedBox(height: 20),
            //                 Text('Loading Video'),
            //               ],
            //             ),
            //     ),
            //   ],
            // ),
          ),
        ),
      );
    } else if (widget.msgType == "document") {
      body = Padding(
        padding: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
        child: SelectableText(
          widget.fileName,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else if (widget.msgType == "audio") {
      body = SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
            child: AudioPlayer(
              source: ap.AudioSource.uri(Uri.parse(widget.msg)),
              // onDelete: () {
              //   setState(() => showPlayer = false);
              // },
            ),
            // VoiceMessage(voiceUrl: widget.msg, voiceName: widget.fileName),
            // ),
          ));
    } else if (widget.msgType == "voice message") {
      body = SizedBox(
          width: MediaQuery.of(context).size.width * .7,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
            child: AudioPlayer(
              source: ap.AudioSource.uri(Uri.parse(widget.msg)),
              // onDelete: () {
              //   setState(() => showPlayer = false);
              // },
            ),
            // VoiceMessage(voiceUrl: widget.msg, voiceName: widget.fileName),
            // ),
          ));
    }
    return body;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   initializePlayer(widget.msg);
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   _chewieController?.dispose();
  //   super.dispose();
  // }

  // Future<void> initializePlayer(videoUrl) async {
  //   _videoPlayerController = VideoPlayerController.network(videoUrl);
  //   Future.wait([
  //     _videoPlayerController.initialize(),
  //   ]);
  //   _createChewieController();
  //   setState(() {});
  // }

  // void _createChewieController() {
  //   _chewieController = ChewieController(
  //     videoPlayerController: _videoPlayerController,
  //     autoPlay: false,
  //     looping: true,
  //     progressIndicatorDelay:
  //         bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
  //     hideControlsTimer: const Duration(seconds: 1),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Card(
          color: Colors.white30,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Colors.purple[200],
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            messageBuilder(context),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(widget.time,
                  style: const TextStyle(fontSize: 13, color: Colors.white)),
            )
          ]),
        ));
  }
}
