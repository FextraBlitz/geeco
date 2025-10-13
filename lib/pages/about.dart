import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Increase these to make photo and card bigger
    final photoSize = width * 0.34; // was 0.28 — increase to make photo bigger
    final cardWidth = width * 0.62;
    const cardRadius = 12.0;

    Widget memberCard({
      required String name,
      required String desc,
      required bool photoRight,
      // NEW: when true, align text to the right side of the green card
      bool alignTextRight = false,
    }) {
      // Make the info card vertically wider. You can set a multiplier or a fixed value.
      final infoCardHeight =
          photoSize * 0.95; // was 0.78 — increase to make green box taller

      // Move the photo down/up relative to the card (adjust after changing sizes)
      final double photoDownOffset = photoSize * 0.40;

      // adjust padding depending on text alignment so text isn't under the overlapping photo
      final EdgeInsets infoPadding = alignTextRight
          ? const EdgeInsets.fromLTRB(24, 16, 16, 16)
          : const EdgeInsets.all(16);

      final infoCard = SizedBox(
        width: cardWidth,
        height: infoCardHeight, // increased height for the green box
        child: Container(
          padding: infoPadding, // use adjusted padding
          decoration: BoxDecoration(
            color: const Color(0xFF8FD85F),
            borderRadius: BorderRadius.circular(cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: alignTextRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start, // align text
            children: [
              Text(
                name,
                textAlign: alignTextRight ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                desc,
                textAlign: alignTextRight ? TextAlign.right : TextAlign.left,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      );

      final photo = Container(
        width: photoSize, // uses updated photoSize
        height: photoSize,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'member\nphoto',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );

      // Ensure the Stack has enough width so the photo can overlap the info card.
      final overlapFactor = 0.6;
      final stackWidth = cardWidth + photoSize * overlapFactor;

      // stackHeight must accommodate the photo moved down to avoid clipping
      final stackHeight = photoSize + photoDownOffset;

      // center the shorter infoCard vertically relative to photo
      final verticalOffset = (stackHeight - infoCardHeight) / 2;

      // Build children so photo is always added last (drawn on top)
      final List<Widget> stackChildren = [];

      if (photoRight) {
        stackChildren.add(
          Positioned(left: 0, top: verticalOffset, child: infoCard),
        );
        // add photo last so it overlays the card — moved down using positive top
        stackChildren.add(
          Positioned(right: 0, top: photoDownOffset, child: photo),
        );
      } else {
        stackChildren.add(
          Positioned(right: 0, top: verticalOffset, child: infoCard),
        );
        stackChildren.add(
          Positioned(left: 0, top: photoDownOffset, child: photo),
        );
      }

      return SizedBox(
        height: stackHeight,
        child: SizedBox(
          width: stackWidth,
          child: Stack(clipBehavior: Clip.none, children: stackChildren),
        ),
      );
    }

    // Wrap page content in a white container so background is always white
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/images/aboutus_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                children: [
                  memberCard(
                    name: 'Member Name',
                    desc: 'member description',
                    photoRight: true,
                  ),
                  const SizedBox(height: 28),
                  // SECOND MEMBER: align text to the right so it isn't covered by the photo
                  memberCard(
                    name: 'Member Name',
                    desc: 'member description',
                    photoRight: false,
                    alignTextRight: true,
                  ),
                  const SizedBox(height: 28),
                  memberCard(
                    name: 'Member Name',
                    desc: 'member description',
                    photoRight: true,
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
