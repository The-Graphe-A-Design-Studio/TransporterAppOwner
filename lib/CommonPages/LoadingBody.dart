import 'package:flutter/material.dart';

class LoadingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Fetching Data...",
            style: TextStyle(color: Colors.black87, fontSize: 26.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: 260.0,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
            ),
          )
        ],
      ),
    );
  }
}
