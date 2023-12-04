import 'package:flutter/material.dart';
import '../custom_widgets/login_text_feild.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/compose_controller.dart';
import '../utilities/constants.dart' as c;

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => ComposeController(context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<ComposeController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        Provider.of<ComposeController>(context, listen: false)
                            .clearPressed(),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    child: Text(
                      AppLocalizations.of(context)!.clear,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Provider.of<ComposeController>(context, listen: false)
                            .postPressed(context),
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.background),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.postButton,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  SizedBox(height: height * 0.025),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * 0.2),
                    child: TextField(
                      cursorColor: Theme.of(context).colorScheme.onBackground,
                      focusNode:
                          Provider.of<ComposeController>(context, listen: false)
                              .titleFocus,
                      onChanged: (s) =>
                          Provider.of<ComposeController>(context, listen: false)
                              .updateCountsTitle(s),
                      maxLines: null,
                      controller:
                          Provider.of<ComposeController>(context, listen: false)
                              .titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.addTitle,
                        labelText: AppLocalizations.of(context)!.postTitle,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                    ),
                  ),
                  Provider.of<ComposeController>(context, listen: false)
                          .titleFocus
                          .hasFocus
                      ? Consumer<ComposeController>(
                          builder: (context, composeController, _) => Text(
                              "${composeController.titleChars}/${c.maxTitleChars} ${AppLocalizations.of(context)!.characters}"),
                        )
                      : Container(),
                  Provider.of<ComposeController>(context, listen: true).gif !=
                          null
                      ? Column(
                          children: [
                            SizedBox(height: height * 0.025),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    Provider.of<ComposeController>(context,
                                            listen: true)
                                        .gif!
                                        .images!
                                        .fixedWidth
                                        .url,
                                  ),
                                ),
                                Positioned(
                                    top: -10,
                                    left: -10,
                                    child: IconButton(
                                      onPressed: () =>
                                          Provider.of<ComposeController>(
                                                  context,
                                                  listen: false)
                                              .removeGifPressed(),
                                      icon: const Icon(Icons.cancel_outlined),
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ))
                              ],
                            ),
                            SizedBox(height: height * 0.025),
                          ],
                        )
                      : IconButton(
                          onPressed: () => Provider.of<ComposeController>(
                                  context,
                                  listen: false)
                              .addGifPressed(),
                          icon: const Icon(Icons.add_box_outlined),
                          color: Theme.of(context).colorScheme.onBackground,
                          iconSize: 230,
                        ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * 0.5),
                    child: TextField(
                      cursorColor: Theme.of(context).colorScheme.onBackground,
                      focusNode:
                          Provider.of<ComposeController>(context, listen: false)
                              .bodyFocus,
                      onChanged: (s) =>
                          Provider.of<ComposeController>(context, listen: false)
                              .updateCountsBody(s),
                      maxLines: null,
                      controller:
                          Provider.of<ComposeController>(context, listen: false)
                              .bodyController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.addText,
                        labelText: AppLocalizations.of(context)!.postBody,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline)),
                      ),
                    ),
                  ),
                  Provider.of<ComposeController>(context, listen: false)
                          .bodyFocus
                          .hasFocus
                      ? Consumer<ComposeController>(
                          builder: (context, composeController, _) => Row(
                            children: [
                              Text(
                                  "${composeController.bodyChars}/${c.maxPostChars} ${AppLocalizations.of(context)!.characters}"),
                              const Spacer(),
                              Text(
                                  "${composeController.newLines}/${c.maxPostLines} ${AppLocalizations.of(context)!.newLines}"),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
