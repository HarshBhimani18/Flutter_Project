import 'package:flutter/material.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AdduserState();
}

class _AdduserState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          print("About us");
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
            Icon(Icons.account_circle,size: 50,color: Colors.white,),
            SizedBox(
              height: 8,
            ),
            Text(
              "About Us",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ));
  }
}
