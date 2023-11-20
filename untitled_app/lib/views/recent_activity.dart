import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/recent_activity_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/pagination.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => RecentActivtiyController(context: context),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.onBackground),
              onPressed: () => context.pop("poped"),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              AppLocalizations.of(context)!.recentActivity,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Lato',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          body: PaginationPage(
              getter:
                  Provider.of<RecentActivtiyController>(context, listen: false)
                      .getActivity,
              card:
                  Provider.of<RecentActivtiyController>(context, listen: false)
                      .recentActivityCardBuilder,
              startAfterQuery:
                  Provider.of<RecentActivtiyController>(context, listen: false)
                      .getNextQueryStart),
        );
      },
    );
  }
}
