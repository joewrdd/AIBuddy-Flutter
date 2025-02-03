import 'package:ai_buddy/core/config/assets_constants.dart';
import 'package:ai_buddy/core/extension/context.dart';
import 'package:ai_buddy/feature/home/widgets/background_curves_painter.dart';
import 'package:ai_buddy/feature/welcome/widgets/api_key_bottom_sheet.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Positioned(
                left: -200,
                top: -100,
                child: Container(
                  height: 400,
                  width: 500,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        context.colorScheme.primary.withOpacity(0.15),
                        context.colorScheme.background.withOpacity(0.05),
                      ],
                      radius: 1.2,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: BackgroundCurvesPainter(),
                size: Size.infinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  context.colorScheme.primary.withOpacity(0.1),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Personal AI Buddy',
                              style: TextStyle(
                                color: context.colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              AssetConstants.aiStarLogo,
                              width: 20,
                              height: 20,
                              color: context.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Center(
                          child: Image.asset(
                            AssetConstants.iconLogo,
                            height: 250,
                          ),
                        ),
                      ),
                      Text(
                        'Chat with PDF & Images!',
                        style: context.textTheme.headlineMedium!.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color:
                              context.colorScheme.onBackground.withOpacity(0.9),
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          final TextEditingController apiKeyController =
                              TextEditingController();

                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return APIKeyBottomSheet(
                                apiKeyController: apiKeyController,
                                isCalledFromHomePage: false,
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              context.colorScheme.surface.withOpacity(0.8),
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 56),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color:
                                  context.colorScheme.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: context.textTheme.titleMedium!.copyWith(
                            color: context.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
