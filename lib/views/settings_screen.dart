import 'package:flutter/material.dart';
import 'package:incident_tracker/components/loading_shimmer.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        packageInfo = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: packageInfo == null
          ? const Column(
              children: [
                LoadingShimmer(
                  width: double.infinity,
                  height: 100,
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 40),
                const Text("Settings",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 250,
                  height: height * 0.15,
                  child: Image.asset(
                    'assets/images/logo.png',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "App Name",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(packageInfo!.appName,
                        style:
                            const TextStyle(fontSize: 18, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "App Version",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(packageInfo!.version,
                        style:
                            const TextStyle(fontSize: 18, color: primaryColor)),
                  ],
                ),
              ],
            ),
    );
  }
}
