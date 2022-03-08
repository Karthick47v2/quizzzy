import 'package:flutter/material.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    Color purpleBdr = Color.fromARGB(255, 93, 0, 155);
  
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/Quizzzy.png',
                width: 229,
                height: 278,
                fit: BoxFit.cover,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 139,
                  height: 59,
                  width: 197,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: purpleBdr,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      
                    ),
                    child: const Text(
                      "I'm a Teacher",
                      style: TextStyle(fontFamily: 'Heebo', fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                  )
                ),
                Positioned(
                  bottom: 40,
                  height: 59,
                  width: 197,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: purpleBdr,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Text(
                      "I'm a Student",
                      style: TextStyle(fontFamily: 'Heebo', fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                  )
                )
              ],
            )
          ],
        )
      )
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.cyan,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 textStyle: const TextStyle(fontSize: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//               child: const Text("Teacher"),
//                ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.cyan,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 textStyle: const TextStyle(fontSize: 30),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//               child: const Text("Student"),
//                ),
//           ],
//         ),)
//     );
//   }
// }