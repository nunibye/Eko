import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/group_handler.dart';
import '../custom_widgets/time_stamp.dart';
import '../utilities/constants.dart' as c;

Widget groupCardBuilder(dynamic group) {
  return GroupCard(
    group: group,
  );
}

class GroupCard extends StatelessWidget {
  final Group group;
  final void Function(Group)? onPressedSearched;
  const GroupCard({super.key, required this.group, this.onPressedSearched});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return InkWell(
        onTap: () => (onPressedSearched == null)
            ? context.push("/groups/sub_group/${group.id}", extra: group)
            : onPressedSearched!(group),
        child: Column(
          children: [
            Divider(
              color: Theme.of(context).colorScheme.outline,
              height: c.dividerWidth,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.05,
                  ),
                  (group.icon != '')
                      ? SizedBox(
                          width: width * 0.18,
                          height: width * 0.18,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(group.icon,
                                  style: TextStyle(fontSize: width * 0.15))),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          width: width * 0.18,
                          height: width * 0.18,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              group.name[0],
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: width * 0.15),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 19),
                      text: group.name,
                      children: [
                        TextSpan(
                            style: TextStyle(fontSize: 15),
                            text: "\n${group.description}"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (onPressedSearched == null)
                    TimeStamp(
                      time: group.lastActivity,
                    ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
