import 'package:flutter/material.dart';

class PlaylistItem {
  final String suraNumber;
  final String suraName;
  final String reciterName;

  PlaylistItem({
    required this.suraNumber,
    required this.suraName,
    required this.reciterName,
  });
}

/// Custom painter for the brown "arrow" under the popup
class ArrowPainter extends CustomPainter {
  final Color color;

  ArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    // Start at top left
    path.moveTo(0, 0);
    // Draw to top right (vertical right edge)
    path.lineTo(size.width, 0);
    // Draw straight down to bottom right (vertical edge)
    path.lineTo(size.width, size.height * 2);
    // Draw to bottom left (arrow tip)
    path.lineTo(0, 0);
    // Back to top left
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) => false;
}

OverlayEntry? _currentPlaylistPopup;

void showPlaylistPopupMenuOverlay(
  BuildContext context,
  List<PlaylistItem> items,
  VoidCallback onClear,
  Offset position, // button position (from GestureDetector)
) {
  // 🧼 Clean up any existing popup before creating a new one
  _currentPlaylistPopup?.remove();
  _currentPlaylistPopup = null;

  final overlay = Overlay.of(context);

  _currentPlaylistPopup = OverlayEntry(
    builder: (_) => Stack(
      children: [
        // Background overlay to detect taps outside and dismiss
        GestureDetector(
          onTap: () {
            _currentPlaylistPopup?.remove();
            _currentPlaylistPopup = null;
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: Colors.transparent, // ensures full-screen detection
          ),
        ),
        Positioned(
          left: position.dx + 120, // Adjust horizontal alignment as needed
          top: position.dy - 440, // Adjust to appear above the button
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main white card
                  _QueueList(items),
                  //the Floating footer row
                  _FloatingFooterRow(items, onClear),
                  // the arrow
                  Positioned(
                    bottom: -10,
                    right: 12,
                    child: CustomPaint(
                      painter: ArrowPainter(color: const Color(0xFF8D6320)),
                      size: const Size(32, 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(_currentPlaylistPopup!);
}

Widget _QueueList(List<PlaylistItem> items) {
  return Container(
    width: 250,
    height: 400,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(2, 4),
        ),
      ],
    ),
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text('${item.suraNumber}\t\t${item.suraName}'),
          subtitle:
              Text(item.reciterName, style: TextStyle(color: Colors.grey[700])),
          onTap: () {
            _currentPlaylistPopup?.remove();
          },
        );
      },
    ),
  );
}

Widget _FloatingFooterRow(List<PlaylistItem> items, VoidCallback onClear) {
  return Positioned(
    bottom: 0,
    right: 0,
    left: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF8D6320),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'قائمة الاستماع',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          IconButton(
            tooltip: 'مسح القائمة',
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () {
              items.clear();
              onClear();
            },
          ),
        ],
      ),
    ),
  );
}
