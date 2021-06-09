import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:package_chatbot/core/config/palettes.dart';

class MessageTile extends StatelessWidget {
  final String? message;
  final bool? sendByMe;

  const MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sendByMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            margin:
            sendByMe! ? const EdgeInsets.only(left: 10) : const EdgeInsets.only(right: 10),
            padding: sendByMe! ?const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20):const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 20),
            decoration: BoxDecoration(
                borderRadius: sendByMe!
                    ? const BorderRadius.all(Radius.circular(10))
                    : const BorderRadius.all(Radius.circular(10)),
                color: sendByMe! ? Palettes.messColor.withOpacity(0.8):  Colors.white,
                // gradient: LinearGradient(
                //   colors: sendByMe
                //       ? [const Color(0xff007EF5).withOpacity(0.8), const Color(0xff2A75BC)]
                //       : [
                //     const Color.fromARGB(255, 225, 255, 125),
                //     const Color.fromARGB(255, 225, 255, 199)
                //   ],
                // )
            ),
            child: Text(message!,
                style: TextStyle(
                  color: sendByMe! ? Colors.white : Colors.black,fontSize: 16)),
          ),
          // !sendByMe ?Positioned(
          //   right: 10,
          //   bottom: 0,
          //   child: Icon(
          //     Icons.volume_down,
          //     size: 25,
          //   ),
          // ):Positioned(
          //   left: 10,
          //   bottom: 0,
          //   child: Transform.rotate(
          //       angle: -math.pi / 1,
          //       child: const Icon(
          //         Icons.volume_down,
          //         size: 25,
          //       )),
          // ),
        ],
      ),
    );
  }
}

class MessageTiles extends StatelessWidget {
  final String? message;
  final Widget? child;

  const MessageTiles({ this.message,  @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 225, 255, 125),
                Color.fromARGB(255, 225, 255, 199)
              ],
            )),
        child: child,
      ),
    );
  }
}
