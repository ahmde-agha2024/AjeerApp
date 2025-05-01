import 'package:ajeer/constants/my_colors.dart';
import 'package:flutter/material.dart';

class StatusTrackerWidget extends StatelessWidget {
  final String? currentStatus;
  final Map<String, int> statusOrder = {
    'NEW_OFFER': 0,
    'onWay': 1,
    'Work_Now': 2,
    'done_Work': 3,
  };
  final Map<String, Map<String, dynamic>> steps = {
    'NEW_OFFER': {'icon': Icons.thumb_up_alt, 'text': 'تم القبول'},
    'onWay': {'icon': Icons.directions_car, 'text': 'في الطريق'},
    'Work_Now': {'icon': Icons.build, 'text': 'قيد التنفيذ'},
    'done_Work': {'icon': Icons.check_circle, 'text': 'تم الإنجاز'},
  };

  StatusTrackerWidget({Key? key, required this.currentStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentStatusIndex = statusOrder[currentStatus ?? ''] ?? -1;
    List<String> orderedStatuses = statusOrder.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: List.generate(orderedStatuses.length * 2 - 1, (index) {
          if (index % 2 == 0) {
            // Step Icon and Text
            int stepIndex = index ~/ 2;
            String stepStatus = orderedStatuses[stepIndex];
            int thisStepOrder = statusOrder[stepStatus]!;
            bool isCompleted = currentStatusIndex >= thisStepOrder;
            bool isCurrent = currentStatusIndex == thisStepOrder;

            return _buildStep(
              context,
              steps[stepStatus]!['icon'],
              steps[stepStatus]!['text'],
              isCompleted,
              isCurrent,
            );
          } else {
            // Connector Line
            int prevStepIndex = (index - 1) ~/ 2;
            String prevStepStatus = orderedStatuses[prevStepIndex];
            int prevStepOrder = statusOrder[prevStepStatus]!;
            bool isCompleted = currentStatusIndex > prevStepOrder;
            return _buildConnector(isCompleted);
          }
        }),
      ),
    );
  }

  Widget _buildStep(BuildContext context, IconData icon, String text, bool isCompleted, bool isCurrent) {
    Color activeColor = MyColors.MainPrimary;
    Color inactiveColor = Colors.grey.shade400;
    Color iconColor = isCompleted ? activeColor : inactiveColor;
    Color textColor = isCompleted ? Colors.black87 : inactiveColor;
    double iconSize = isCurrent ? 30.0 : 24.0;
    FontWeight textWeight = isCompleted ? FontWeight.bold : FontWeight.normal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(fontSize: 10, color: textColor, fontWeight: textWeight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConnector(bool isCompleted) {
    Color activeColor = MyColors.MainPrimary;
    Color inactiveColor = Colors.grey.shade400;
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? activeColor : inactiveColor,
        margin: EdgeInsets.symmetric(horizontal: 2), // Adjust margin for spacing
      ),
    );
  }
} 