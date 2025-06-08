import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incident_tracker/components/authenticated_network_image.dart';
import 'package:incident_tracker/components/button.dart';
import 'package:incident_tracker/controllers/user_controller.dart';
import 'package:incident_tracker/models/user.dart';
import 'package:incident_tracker/router/index.dart';
import 'package:incident_tracker/utils/theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  logOutHandler(BuildContext context) async {
    final navigator = GoRouter.of(context);
    await Provider.of<AuthController>(context, listen: false).logout();
    navigator.pushReplacement(AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    User? profile = Provider.of<AuthController>(context).user;
    String? token = Provider.of<AuthController>(context).token;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              color: primaryGrey2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),

              // radial Gradient from top right to bottom Left
              // gradient: RadialGradient(
              //   center: Alignment.bottomLeft,
              //   radius: 1.8,
              //   colors: [
              //     splashColor,
              //     primaryColor,
              //   ],
              // ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.manage_accounts_outlined,
                      size: 32,
                      color: primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthenticatedNetworkImage(
                      imageUrl:
                          "http://197.243.1.84:3020/uploads//users/profilePicture-1748607340320-742478406.jpg",
                      token: token ?? "",
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          profileDetailsItem(
              Icons.email_outlined, "Email", profile?.email ?? "N/A"),
          profileDetailsItem(
              Icons.smartphone, "Phone", profile?.phone ?? "N/A"),
          profileDetailsItem(
              Icons.female_outlined, "Gender", profile?.gender ?? "N/A"),
          profileDetailsItem(Icons.person_outline_outlined, "Account Type",
              profile?.accountType ?? "N/A",
              isLast: true),
          const Spacer(),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
            child: Button(
              "Sign Out",
              () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Confirm Sign Out"),
                        content:
                            const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                logOutHandler(context);
                              },
                              child: const Text("Confirm"))
                        ],
                      );
                    });
              },
              context,
              backgroundColor: splashColor,
              hasIcon: true,
              icon: Icons.logout,
              hasBorder: true,
              color: Colors.white,
              radius: 15,
            ),
          ),
        ],
      ),
    );
  }

  Container profileDetailsItem(IconData icon, String title, String value,
      {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryGrey2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(icon, color: splashColor, size: 19)),
              const SizedBox(width: 2),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
