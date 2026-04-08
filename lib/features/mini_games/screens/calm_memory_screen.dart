import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/calm_memory_controller.dart';
import '../widgets/memory_card_widget.dart';

class CalmMemoryScreen extends StatelessWidget {
  const CalmMemoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalmMemoryController(),
      child: const _CalmMemoryView(),
    );
  }
}

class _CalmMemoryView extends StatefulWidget {
  const _CalmMemoryView({Key? key}) : super(key: key);

  @override
  State<_CalmMemoryView> createState() => _CalmMemoryViewState();
}

class _CalmMemoryViewState extends State<_CalmMemoryView> {
  late CalmMemoryController _controller;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<CalmMemoryController>();
    _controller.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    if (_controller.isGameOver && !_hasShownDialog) {
      _hasShownDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVictoryDialog();
      });
    } else if (!_controller.isGameOver) {
      _hasShownDialog = false;
    }
  }

  void _showVictoryDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: theme.colorScheme.surface,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, color: theme.colorScheme.primary, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Mindful Victory!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You completed the board with focus.', textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDialogStat(Icons.swap_horiz_rounded, '${_controller.moves}', 'Moves', theme),
                  Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  _buildDialogStat(Icons.timer_rounded, '${_controller.timeInSeconds}s', 'Time', theme),
                ],
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: Text('Exit', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _controller.resetGame();
              },
              child: const Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogStat(IconData icon, String value, String label, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Calm Memory', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [theme.colorScheme.surface, Colors.black87]
                : [theme.colorScheme.primary.withValues(alpha: 0.05), theme.colorScheme.surface],
          ),
        ),
        child: Consumer<CalmMemoryController>(
          builder: (context, controller, child) {
            return SafeArea(
              // ✅ LayoutBuilder intelligently decides the layout based on available space, not just rotation
              child: LayoutBuilder(
                  builder: (context, constraints) {
                    // If the screen is wider than it is tall, use Landscape mode
                    final isLandscape = constraints.maxWidth > constraints.maxHeight;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: isLandscape
                          ? _buildLandscapeLayout(context, controller, constraints, key: const ValueKey('landscape'))
                          : _buildPortraitLayout(context, controller, constraints, key: const ValueKey('portrait')),
                    );
                  }
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, CalmMemoryController controller, BoxConstraints constraints, {Key? key}) {
    return Column(
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBadge(context, Icons.swap_horiz_rounded, 'Moves', '${controller.moves}'),
              _buildStatBadge(context, Icons.timer_outlined, 'Time', '${controller.timeInSeconds}s'),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              // ✅ Constrain the grid so it doesn't get massively huge on iPads in portrait
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _buildGrid(controller),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, CalmMemoryController controller, BoxConstraints constraints, {Key? key}) {
    return Row(
      key: key,
      children: [
        // ✅ Wrap stats in a Flexible container so they don't overflow on small landscape screens (like iPhone SE)
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatBadge(context, Icons.swap_horiz_rounded, 'Moves', '${controller.moves}'),
                const SizedBox(height: 24),
                _buildStatBadge(context, Icons.timer_outlined, 'Time', '${controller.timeInSeconds}s'),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // ✅ Constrain the grid so it doesn't get comically huge on large desktop monitors
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _buildGrid(controller),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(CalmMemoryController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.0,
      ),
      itemCount: controller.cards.length,
      itemBuilder: (context, index) {
        return MemoryCardWidget(
          card: controller.cards[index],
          onTap: () => controller.flipCard(controller.cards[index]),
        );
      },
    );
  }

  Widget _buildStatBadge(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}