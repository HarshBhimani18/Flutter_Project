import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Userfavourite extends StatefulWidget {
  const Userfavourite({super.key});

  @override
  State<Userfavourite> createState() => _AdduserState();
}

class _AdduserState extends State<Userfavourite> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          print("user favourite");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.heart_fill,size: 50,color: Colors.white,),
            SizedBox(
              height: 8,
            ),
            Text(
              "Favourite",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ));
  }
}
