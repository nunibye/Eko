import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'controllers/pagination_controller.dart';

class PaginationPage extends StatelessWidget {
  final Future<PaginationGetterReturn> Function(dynamic) getter;
  final dynamic Function(dynamic) startAfterQuery;
  final Function()? extraRefresh;
  final Widget Function(dynamic) card;
  final Widget? header;
  final Widget? emptySetNotice;
  final Widget? loadingWidget;
  final Widget? initialLoadingWidget;
  const PaginationPage(
      {super.key,
      required this.getter,
      required this.card,
      this.extraRefresh,
      this.header,
      required this.startAfterQuery,
      this.emptySetNotice,
      this.initialLoadingWidget,
      this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PaginationController(
          extraRefresh: extraRefresh,
          getter: getter,
          context: context,
          startAfterQuery: startAfterQuery),
      builder: (context, child) {
        return RefreshIndicator(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const AlwaysScrollableScrollPhysics(),
            controller:
                Provider.of<PaginationController>(context, listen: false)
                    .scrollController,
            itemCount: Provider.of<PaginationController>(context, listen: true)
                    .items
                    .length +
                2,
            itemBuilder: (BuildContext context, int index) {
              //print(index);
              if (index == 0) {
                //build header
                return header ?? const SizedBox();
              } else if (Provider.of<PaginationController>(context, listen: true)
                      .items
                      .isNotEmpty &&
                  index <
                      Provider.of<PaginationController>(context, listen: true)
                              .items
                              .length +
                          1) {
                //normal case put cards

                return card(
                    Provider.of<PaginationController>(context, listen: true)
                        .items[index - 1]);
              } else if (Provider.of<PaginationController>(context, listen: true)
                      .end &&
                  Provider.of<PaginationController>(context, listen: true)
                      .items
                      .isEmpty) {
                //what to return if dataset is empty
                return emptySetNotice ??
                    Center(child:Text(AppLocalizations.of(context)!.nothingToSeeHere));
              } else if ((!Provider.of<PaginationController>(context,
                          listen: true)
                      .end) &&
                  Provider.of<PaginationController>(context, listen: true)
                      .items
                      .isEmpty) {
                //what to return if dataset is under initial load sequence
                return initialLoadingWidget ??
                    const Center(child: CircularProgressIndicator());
              } else if (Provider.of<PaginationController>(context,
                          listen: true)
                      .end &&
                  Provider.of<PaginationController>(context, listen: true)
                      .items
                      .isNotEmpty) {
                //end of feed
                return const SizedBox();
              } else {
                // new posts are loading
                return loadingWidget ??
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    );
              }
            },
          ),
          onRefresh: () =>
              Provider.of<PaginationController>(context, listen: false)
                  .onRefresh(),
        );
      },
    );
  }
}
