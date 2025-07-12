import 'package:flutter/material.dart';
import 'package:beykoz/data/features_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:beykoz/Services/theme_service.dart';
import 'package:provider/provider.dart';

class EditFavoritesPage extends StatefulWidget {
  const EditFavoritesPage({super.key});

  @override
  State<EditFavoritesPage> createState() => _EditFavoritesPageState();
}

class _EditFavoritesPageState extends State<EditFavoritesPage> {
  // Durum Değişkenleri
  List<Map<String, dynamic>> _selectedItems = [];
  bool _isLoading = true;

  // Alttaki bölümlerin katlanma durumunu tutan değişkenler
  bool _isDersExpanded = true;
  bool _isBelgelerExpanded = true;
  bool _isDigerExpanded = true;


  @override
  void initState() {
    super.initState();
    _loadSelectedItems();
  }

  Future<void> _loadSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final allFeatures = FeaturesData.getAllFeatures();
    final favoriteLabels = prefs.getStringList('user_favorites');

    List<Map<String, dynamic>> loadedSelected = [];

    if (favoriteLabels != null && favoriteLabels.isNotEmpty) {
      for (var label in favoriteLabels) {
        final foundItem = allFeatures.firstWhere(
              (item) => item['label'] == label,
          orElse: () => {},
        );
        if (foundItem.isNotEmpty) {
          loadedSelected.add(foundItem);
        }
      }
    } else {
      loadedSelected = [...FeaturesData.belgelerFeatures.take(8)];
    }

    setState(() {
      _selectedItems = loadedSelected;
      _isLoading = false;
    });
  }

  void _selectItem(Map<String, dynamic> item) {
    if (_selectedItems.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favori alanı dolu! Önce bir öğe çıkarın.')),
      );
      return;
    }
    setState(() {
      _selectedItems.add(item);
    });
  }

  void _deselectItem(int index) {
    setState(() {
      _selectedItems.removeAt(index);
    });
  }

  Future<void> _saveFavorites() async {
    if (_selectedItems.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tam olarak 8 favori öğesi seçin.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final selectedLabels = _selectedItems.map((item) => item['label'] as String).toList();
    await prefs.setStringList('user_favorites', selectedLabels);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabelsSet = _selectedItems.map((e) => e['label'] as String).toSet();

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Favorileri Düzenle (${_selectedItems.length}/8)'),
            backgroundColor: themeService.isDarkMode 
                ? ThemeService.darkPrimaryColor 
                : const Color(0xFF802629),
            foregroundColor: Colors.white,
            actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveFavorites)],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(
                  [
                    Text(
                      'Seçili Favoriler (Sürükleyerek Sırala)',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextPrimaryColor 
                            : Color(0xFF802629)
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSelectedItemsGrid(),
                    const SizedBox(height: 30),

                    Text(
                      'Eklenebilecek Diğer Özellikler',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextPrimaryColor 
                            : Color(0xFF802629)
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildAvailableFeatureSection(
                      title: 'Ders İşlemleri',
                      features: FeaturesData.dersIslemleriFeatures.where((item) => !selectedLabelsSet.contains(item['label'])).toList(),
                      isExpanded: _isDersExpanded,
                      onToggle: () => setState(() => _isDersExpanded = !_isDersExpanded),
                    ),
                    const SizedBox(height: 16),
                    _buildAvailableFeatureSection(
                      title: 'Belgeler',
                      features: FeaturesData.belgelerFeatures.where((item) => !selectedLabelsSet.contains(item['label'])).toList(),
                      isExpanded: _isBelgelerExpanded,
                      onToggle: () => setState(() => _isBelgelerExpanded = !_isBelgelerExpanded),
                    ),
                    const SizedBox(height: 16),
                    _buildAvailableFeatureSection(
                      title: 'Diğer İşlemler',
                      features: FeaturesData.digerIslemlerFeatures.where((item) => !selectedLabelsSet.contains(item['label'])).toList(),
                      isExpanded: _isDigerExpanded,
                      onToggle: () => setState(() => _isDigerExpanded = !_isDigerExpanded),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }

  // GÜNCELLENMİŞ METOT
  Widget _buildSelectedItemsGrid() {
    return ReorderableGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      dragWidgetBuilder: (index, child) {
        final item = _selectedItems[index];
        final dragWidget = _buildGridItem(
          item,
          isSelected: true,
          onTap: () {},
          isDragging: true,
        );

        return Card(
          elevation: 8.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: dragWidget,
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < _selectedItems.length && newIndex < _selectedItems.length) {
          setState(() {
            final item = _selectedItems.removeAt(oldIndex);
            _selectedItems.insert(newIndex, item);
          });
        }
      },
      itemBuilder: (context, index) {
        if (index < _selectedItems.length) {
          final item = _selectedItems[index];
          return ReorderableDragStartListener(
            key: ValueKey(item['label']),
            index: index,
            child: _buildGridItem(item, isSelected: true, onTap: () => _deselectItem(index)),
          );
        } else {
          return _buildPlaceholderItem(key: ValueKey('placeholder_$index'));
        }
      },
    );
  }

  Widget _buildAvailableFeatureSection({
    required String title,
    required List<Map<String, dynamic>> features,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool canExpand = features.length > 4;

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: themeService.isDarkMode 
                    ? ThemeService.darkSurfaceColor 
                    : const Color(0xFFECECEC),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: themeService.isDarkMode 
                            ? ThemeService.darkTextPrimaryColor 
                            : Color(0xFF802629), 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
              AnimationLimiter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8,
                  ),
                  itemCount: isExpanded ? features.length : (canExpand ? 4 : features.length),
                  itemBuilder: (context, index) {
                    final item = features[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 4,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _buildGridItem(item, isSelected: false, onTap: () => _selectItem(item)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (canExpand)
                Center(
                  child: IconButton(
                    icon: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
                      color: themeService.isDarkMode 
                          ? ThemeService.darkTextPrimaryColor 
                          : const Color(0xFF802629)
                    ),
                    onPressed: onToggle,
                  ),
                ),
            ],
          ),
        ),
      ),
        );
      },
    );
  }

  // GÜNCELLENMİŞ METOT
  Widget _buildGridItem(Map<String, dynamic> item, {required bool isSelected, required VoidCallback onTap, bool isDragging = false}) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      width: 56.75,
                      height: 56.75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF802629), Color(0xFFB2453C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(item['icon'], color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        item['label']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeService.isDarkMode 
                              ? ThemeService.darkTextPrimaryColor 
                              : Color(0xFF802629),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
          if (isSelected && !isDragging)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Icon(
                  Icons.cancel, 
                  color: themeService.isDarkMode 
                      ? ThemeService.darkPrimaryColor 
                      : Color(0xFF802629), 
                  size: 22
                ),
              ),
            ),
          if (!isSelected)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: const Icon(Icons.add_circle, color: Colors.green, size: 22),
              ),
            ),
        ],
      ),
        );
      },
    );
  }

  Widget _buildPlaceholderItem({required Key key}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2, style: BorderStyle.solid),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.grey, size: 30),
      ),
    );
  }
}