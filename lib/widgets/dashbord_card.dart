import 'package:flutter/material.dart';

class DashBordCard extends StatelessWidget {
  final String? text;
  final IconData? icon;
  const DashBordCard({super.key,this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration:  BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon( icon ?? Icons.edit, color: Colors.white, size: 30,),
            Text(text.toString(), style: const TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
      ),
    );

  }
}
