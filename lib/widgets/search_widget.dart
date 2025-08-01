import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// SearchWidget - A modern search bar for filtering medicines
/// 
/// This widget provides:
/// - Clean, modern design with proper theming
/// - Real-time search functionality
/// - Search by medicine name or brand name
/// - Clear button to reset search
/// - Proper keyboard handling and focus management
/// - Responsive design with proper spacing
class SearchWidget extends StatefulWidget {
  /// Callback function called when search query changes
  final Function(String) onSearchChanged;
  
  /// Initial search query
  final String initialQuery;

  const SearchWidget({
    super.key,
    required this.onSearchChanged,
    this.initialQuery = '',
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Clears the search field and notifies parent
  void _clearSearch() {
    _searchController.clear();
    widget.onSearchChanged('');
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: widget.onSearchChanged,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          // Search icon
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
          
          // Clear button (only show when there's text)
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                )
              : null,
          
          // Hint text
          hintText: 'Search medicines or brands...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          
          // Remove default borders
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          
          // Content padding
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          
          // Ensure proper alignment
          isDense: false,
        ),
        
        // Keyboard configuration
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        
        // Handle search submission
        onSubmitted: (value) {
          widget.onSearchChanged(value);
          _focusNode.unfocus();
        },
      ),
    );
  }
}

/// SearchSuggestions - Optional widget to show search suggestions
/// 
/// This can be used to show popular searches or recent searches
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Popular Searches',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          // Suggestions list
          ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return InkWell(
      onTap: () => onSuggestionTap(suggestion),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(
              Icons.north_west,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
