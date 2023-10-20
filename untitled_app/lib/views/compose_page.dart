import 'package:flutter/material.dart';
import '../custom_widgets/login_text_feild.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/compose_controller.dart';
import '../utilities/constants.dart' as c;
import 'package:giphy_get/giphy_get.dart';

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
                IconButton(onPressed: ()async {
                  GiphyGif? gif = await GiphyGet.getGif(
  context: context, //Required
  apiKey: "SH2VZsffU75pLZDVETpR8wlC2Vv2t5J8", //Required.
  lang: GiphyLanguage.english, //Optional - Language for query.
  //randomID: "abcd", // Optional - An ID/proxy for a specific user.
  tabColor:Colors.teal, // Optional- default accent color.
  debounceTimeInMilliseconds: 350, // Optional- time to pause between search keystrokes
);
                }, icon: Icon(Icons.add)),
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
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      fillColor: Theme.of(context).colorScheme.onBackground,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onPrimary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
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
                    IconButton(
                      onPressed: () =>
                          Provider.of<ComposeController>(context, listen: false)
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
        ),);
      },
    );
  }
}
