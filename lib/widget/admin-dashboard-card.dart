import 'package:flutter/material.dart';

  Widget buildDashboardCard(String title, String count, Color lineColor) {
    return Container(
      //width: (MediaQuery.of(context).size.width / 2) - 24,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          SizedBox(height: 8),
          Row(
            children: [
              Text(count, style: TextStyle(color: Colors.white, fontSize: 24)),
              Spacer(),
              Container(
                height: 4,
                width: 50,
                color: lineColor,
              )
            ],
          ),
        ],
      ),
    );
  }