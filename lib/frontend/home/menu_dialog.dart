import 'package:connect_ed_2/classes/menu_section.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final List<MenuSection> menuSections;

  const MenuPage({super.key, required this.menuSections});

  @override
  MenuPageState createState() => MenuPageState();
}

// Keep old name for backward compatibility if needed
class MenuDialog extends MenuPage {
  const MenuDialog({super.key, required super.menuSections});
}

class MenuPageState extends State<MenuPage> {
  // Track expanded state for each section
  late Map<int, bool> _expandedSections;

  @override
  void initState() {
    super.initState();
    // Initialize all sections as expanded
    _expandedSections = {};
    for (int i = 0; i < widget.menuSections.length; i++) {
      _expandedSections[i] = true;
    }
  }

  // Toggle section expanded state
  void _toggleSection(int index) {
    setState(() {
      _expandedSections[index] = !(_expandedSections[index] ?? true);
    });
  }

  // Format section titles with proper capitalization
  String _formatSectionTitle(String title) {
    if (title.isEmpty) return '';

    // Split by spaces, capitalize each word, rejoin
    return title
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
        )
        .join(' ');
  }

  // Properly format food items text
  String _formatFoodItems(String text) {
    // Replace literal "\n" sequences with actual newlines
    String processed = text.replaceAll('\\n', '\n');

    // Trim extra whitespace around lines
    processed = processed.split('\n').map((line) => line.trim()).join('\n');

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, size: 26),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Today's Menu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: widget.menuSections.length,
        itemBuilder: (context, index) {
          final menuSection = widget.menuSections[index];
          if (menuSection.isEmpty) return SizedBox.shrink();

          final isExpanded = _expandedSections[index] ?? true;
          final formattedTitle = _formatSectionTitle(menuSection.sectionTitle);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header with toggle button - minimal design, no splash
              GestureDetector(
                onTap: () => _toggleSection(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0 : 0.5,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.expand_less,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expandable content with smooth animation
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child:
                    isExpanded
                        ? Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                            right: 4.0,
                            bottom: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                menuSection.courses.map((course) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatSectionTitle(course[0]),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          _formatFoodItems(course[1]),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.65),
                                            height: 1.6,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}
