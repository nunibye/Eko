import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../controllers/download_page_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import "../utilities/constants.dart" as c;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    return ChangeNotifierProvider(
      create: (context) => DownloadPageController(),
      builder: (context, child) {
        Provider.of<DownloadPageController>(context, listen: true);
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => context.go("/"),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () => context.go("/"),
              ),
              title: Text(AppLocalizations.of(context)!.download),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.8,
                    child: QrImageView(
                      gapless: false,
                      data: "${c.appURL}/download",
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      dataModuleStyle: QrDataModuleStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      eyeStyle: QrEyeStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          eyeShape: QrEyeShape.square),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => Provider.of<DownloadPageController>(context,
                            listen: false)
                        .launchPlayStore(),
                    child: SvgPicture.asset(
                      'images/playStoreButton.svg',
                      width: width * 0.45,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => Provider.of<DownloadPageController>(context,
                            listen: false)
                        .launchAppStore(),
                    child: SvgPicture.asset(
                      'images/appStoreButton.svg',
                      width: width * 0.45,
                    ),
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
