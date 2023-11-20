import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/current_user.dart';
import '../models/post_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;
import '../custom_widgets/recent_activity_card.dart';
import '../utilities/constants.dart' as c;

class RecentActivtiyController extends ChangeNotifier {
  BuildContext context;
  RecentActivtiyController({required this.context}) {
    init();
  }
  init() async {
    await locator<CurrentUser>().setNewActivity(false); //FIXME too much read
  }

  Future<PaginationGetterReturn> getActivity(dynamic time) async {
    final list = await locator<PostsHandling>().getNewActivity(time);

    return PaginationGetterReturn(
        end: (list.length < c.activitiesPerRequest), payload: list);
  }

  dynamic getNextQueryStart(dynamic lastActivity) {
    return (lastActivity as RecentActivityCard).time;
  }

  Widget recentActivityCardBuilder(dynamic data) {
    return ActivityCardWidget(card: data);
  }
}
