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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  SizedBox(height: height * 0.025),
                  CustomInputFeild(
                      onChanged: (s) =>
                          Provider.of<ComposeController>(context, listen: false)
                              .updateCountsTitle(s),
                      focus:
                          Provider.of<ComposeController>(context, listen: false)
                              .titleFocus,
                      label: AppLocalizations.of(context)!.postTitle,
                      controller:
                          Provider.of<ComposeController>(context, listen: false)
                              .titleController),
                  Consumer<ComposeController>(
                    builder: (context, composeController, _) => Text(
                        "${composeController.titleChars}/${c.maxTittleChars} ${AppLocalizations.of(context)!.characters}"),
                  ),
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    height: height * 0.2,
                    width: double.infinity,
                    child: Provider.of<ComposeController>(context, listen: true)
                                .gif !=
                            null
                        ? Image.network(
                            Provider.of<ComposeController>(context,
                                    listen: true)
                                .gif!
                                .images!
                                .fixedWidth
                                .url,
                          )
                        : FloatingActionButton.large(
                            onPressed: () => Provider.of<ComposeController>(
                                    context,
                                    listen: false)
                                .addGifPressed(),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(Icons.add,
                                size: height * 0.075,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                  ),
                  SizedBox(
                      height: height * 0.05,
                      child:
                          Provider.of<ComposeController>(context, listen: true)
                                      .gif !=
                                  null
                              ? IconButton(
                                  onPressed: () =>
                                      Provider.of<ComposeController>(context,
                                              listen: false)
                                          .removeGifPressed(),
                                  icon: Icon(Icons.remove),
                                )
                              : null),
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
                        labelText: AppLocalizations.of(context)!.postBody,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        fillColor: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.background)),
                      ),
                    ),
                  ),
                  Consumer<ComposeController>(
                    builder: (context, composeController, _) => Row(
                      children: [
                        Text(
                            "${composeController.bodyChars}/${c.maxPostChars} ${AppLocalizations.of(context)!.characters}"),
                        const Spacer(),
                        Text(
                            "${composeController.newLines}/${c.maxPostLines} ${AppLocalizations.of(context)!.newLines}"),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.large(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        onPressed: () => Provider.of<ComposeController>(context,
                                listen: false)
                            .showPostDialog(context, Provider.of<ComposeController>(context, listen: false).postPressed),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.postButton,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
