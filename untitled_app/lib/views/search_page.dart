import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/search_page_controller.dart';
import '../custom_widgets/searched_user_card.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => SearchPageController(),
      builder: (context, child) {
        return GestureDetector(
            onTap: () =>
                Provider.of<SearchPageController>(context, listen: false)
                    .hideKeyboard(),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(height * 0.01),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.008,
                    ),
                    SizedBox(
                      height: height * 0.06,
                      child: TextField(
                        onChanged: (s) => Provider.of<SearchPageController>(
                                context,
                                listen: false)
                            .onSearchTextChanged(s),
                        controller: Provider.of<SearchPageController>(context,
                                listen: false)
                            .searchTextController,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              AppLocalizations.of(context)!.searchUsername,
                          prefix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: width * 0.03),
                                child: Image.asset('images/algolia_logo.png',
                                    width: width * 0.05, height: width * 0.05),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Provider.of<SearchPageController>(context,
                                  listen: true)
                              .isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Provider.of<SearchPageController>(context,
                                      listen: true)
                                  .hits
                                  .isEmpty
                              ? Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .noResultsFound,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: Provider.of<SearchPageController>(
                                          context,
                                          listen: true)
                                      .hits
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return UserCard(
                                        user: Provider.of<SearchPageController>(
                                                context,
                                                listen: true)
                                            .hits[index]);
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
