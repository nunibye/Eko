import "package:flutter/material.dart"

class GetAppFabWrapper extends StatelessWidget {
final Widget? child;
  const GetAppFabWrapper({ super.key, this.child });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child, floatingActionButton: OutlinedButton(
      // Set the button style
      style: ButtonStyle(
        // Set the background color
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        // Set the border color and width
        side: MaterialStateProperty.all(BorderSide(color: Colors.white, width: 2)),
        // Set the shape of the button
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      // Set the button label
      child: Text('Get the App', style: TextStyle(color: Colors.white)),
      // Set the button action
      onPressed: (){},
    ));
  }
}

