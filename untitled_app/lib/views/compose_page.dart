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
    return ChangeNotifierProvider(
      create: (context) => ComposeController(context: context),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => Provider.of<ComposeController>(context, listen: false)
              .hideKeyboard(),
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02),
              child: ListView(
                children: [
                  IconButton(
                      onPressed: () =>
                          Provider.of<ComposeController>(context, listen: false)
                              .addGifPressed(),
                      icon: Icon(Icons.add)),
                      IconButton(
                      onPressed: () =>
                          Provider.of<ComposeController>(context, listen: false)
                              .removeGifPressed(),
                      icon: Icon(Icons.remove)),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5),
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
                        fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background)),
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
                  if (Provider.of<ComposeController>(context, listen: true)
                          .gif !=
                      null)
                    Image.network(
                        Provider.of<ComposeController>(context, listen: true)
                            .gif!
                            .images!
                            .fixedWidth
                            .url),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Provider.of<ComposeController>(context,
                                listen: false)
                            .postPressed(),
                        icon: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.postButton,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.arrow_right_sharp)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
