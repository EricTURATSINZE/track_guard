import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:incident_tracker/components/loading_shimmer.dart';
import 'package:incident_tracker/utils/theme.dart';

class AuthenticatedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String token;
  final double radius;

  const AuthenticatedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.token,
    this.radius = 60,
  });

  Future<Uint8List> _loadImage() async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(imageUrl));
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    final response = await request.close();
    return await consolidateHttpClientResponseBytes(response);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: (radius + 10) * 2, // Adjust to match your padding
                height: (radius + 10) * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      splashColor.withOpacity(0.0),
                      primaryColor,
                    ],
                    stops: const [0.5, 1.0],
                    radius: 0.85,
                  ),
                ),
              ),
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.grey[200],
                child: const LoadingShimmer(
                  height: 180,
                  width: 140,
                  borderRadius: 100,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.error),
          );
        } else {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: (radius + 10) * 2, // Adjust to match your padding
                height: (radius + 10) * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      splashColor.withOpacity(0.0),
                      primaryColor,
                    ],
                    stops: const [0.5, 1.0],
                    radius: 0.85,
                  ),
                ),
              ),
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.white,
                backgroundImage: MemoryImage(snapshot.data!),
              ),
              Positioned(
                  bottom: 13,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: splashColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                  ))
            ],
          );
        }
      },
    );
  }
}
