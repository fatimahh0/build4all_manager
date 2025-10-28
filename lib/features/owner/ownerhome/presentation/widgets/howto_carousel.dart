import 'package:flutter/material.dart';

class HowToPage {
  final String emoji;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  HowToPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });
}

class HowToCarousel extends StatefulWidget {
  final List<HowToPage> pages;
  const HowToCarousel({super.key, required this.pages});

  @override
  State<HowToCarousel> createState() => _HowToCarouselState();
}

class _HowToCarouselState extends State<HowToCarousel> {
  late final PageController _pc;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pc = PageController(viewportFraction: .92);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pages;

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pc,
            itemCount: pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => _Card(page: pages[i]),
          ),
        ),
        const SizedBox(height: 12),
        _Dots(count: pages.length, index: _index),
        const SizedBox(height: 8),
        if (pages[_index].actionLabel != null && pages[_index].onAction != null)
          TextButton.icon(
            onPressed: pages[_index].onAction,
            icon: const Icon(Icons.bolt_rounded),
            label: Text(pages[_index].actionLabel!),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final HowToPage page;
  const _Card({required this.page});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .98, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(page.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(page.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              page.subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurface.withOpacity(.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.outlineVariant.withOpacity(.7),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
