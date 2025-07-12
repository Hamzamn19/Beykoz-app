# Dark Mode Implementation Guide

This guide explains how to implement dark mode across all pages in the Beykoz application.

## Overview

The dark mode implementation consists of:
1. **ThemeService** - Manages theme state and provides theme data
2. **ThemeAwareWidgets** - Reusable theme-aware widgets
3. **Provider Integration** - Global state management for theme
4. **Page Updates** - Individual page modifications
5. **Navigation Bar** - Theme-aware bottom navigation bar

## Files Created/Modified

### New Files:
- `lib/Services/theme_service.dart` - Theme management service
- `lib/Widgets/theme_aware_widgets.dart` - Reusable theme-aware widgets
- `DARK_MODE_IMPLEMENTATION_GUIDE.md` - This guide

### Modified Files:
- `lib/main.dart` - Added theme service provider
- `lib/Pages/ProfilePage.dart` - Added dark mode toggle and theme-aware UI
- `lib/Pages/AttendancePage.dart` - Made UI theme-aware
- `lib/Pages/HomePage.dart` - Made UI theme-aware including bottom navigation bar
- `lib/Pages/RootPage.dart` - Made custom navigation bar and portals theme-aware
- `lib/Pages/Otherpages.dart` - Made portals section theme-aware
- `lib/Pages/NewsPage.dart` - Partially updated (needs completion)
- `lib/Pages/AllFeaturesPage.dart` - Partially updated (needs completion)

## How to Implement Dark Mode on New Pages

### Step 1: Import Required Dependencies

Add these imports to your page:

```dart
import 'package:beykoz/Services/theme_service.dart';
import 'package:beykoz/Widgets/theme_aware_widgets.dart';
import 'package:provider/provider.dart';
```

### Step 2: Wrap Your Scaffold with Consumer

```dart
@override
Widget build(BuildContext context) {
  return Consumer<ThemeService>(
    builder: (context, themeService, child) {
      return Scaffold(
        backgroundColor: themeService.isDarkMode 
            ? ThemeService.darkBackgroundColor 
            : ThemeService.lightBackgroundColor,
        // ... rest of your scaffold
      );
    },
  );
}
```

### Step 3: Use Theme-Aware Widgets

Replace hardcoded colors with theme-aware alternatives:

#### For Cards:
```dart
// Instead of:
Card(color: Colors.white, child: ...)

// Use:
ThemeAwareWidgets.themedCard(child: ...)
```

#### For Text:
```dart
// Instead of:
Text('Hello', style: TextStyle(color: Colors.black))

// Use:
ThemeAwareWidgets.themedText('Hello')
```

#### For Buttons:
```dart
// Instead of:
ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF802629)),
  child: Text('Click me'),
)

// Use:
ThemeAwareWidgets.themedElevatedButton(
  text: 'Click me',
  onPressed: () {},
)
```

### Step 4: Handle Dynamic Colors

For colors that need to change based on theme:

```dart
Consumer<ThemeService>(
  builder: (context, themeService, child) {
    final primaryColor = themeService.isDarkMode 
        ? ThemeService.darkPrimaryColor 
        : ThemeService.lightPrimaryColor;
    
    return Container(
      color: primaryColor,
      child: ...,
    );
  },
)
```

## Available Theme Colors

### Light Theme Colors:
- `ThemeService.lightPrimaryColor` - #802629 (Burgundy)
- `ThemeService.lightSecondaryColor` - #B85A5E (Light Burgundy)
- `ThemeService.lightBackgroundColor` - #F5F5F5 (Light Gray)
- `ThemeService.lightSurfaceColor` - #FFFFFF (White)
- `ThemeService.lightCardColor` - #FFFFFF (White)
- `ThemeService.lightTextPrimaryColor` - #1A1A1A (Dark Gray)
- `ThemeService.lightTextSecondaryColor` - #666666 (Medium Gray)
- `ThemeService.lightDividerColor` - #E0E0E0 (Light Gray)

### Dark Theme Colors:
- `ThemeService.darkPrimaryColor` - #B85A5E (Light Burgundy)
- `ThemeService.darkSecondaryColor` - #802629 (Burgundy)
- `ThemeService.darkBackgroundColor` - #2C2C2C (Grayish Background)
- `ThemeService.darkSurfaceColor` - #3A3A3A (Lighter Gray)
- `ThemeService.darkCardColor` - #424242 (Medium Gray)
- `ThemeService.darkTextPrimaryColor` - #E0E0E0 (Light Gray)
- `ThemeService.darkTextSecondaryColor` - #B0B0B0 (Medium Light Gray)
- `ThemeService.darkDividerColor` - #555555 (Lighter Divider)

## Theme-Aware Widgets Available

### Basic Widgets:
- `ThemeAwareWidgets.themedCard()` - Theme-aware card
- `ThemeAwareWidgets.themedText()` - Theme-aware primary text
- `ThemeAwareWidgets.themedSecondaryText()` - Theme-aware secondary text
- `ThemeAwareWidgets.themedContainer()` - Theme-aware container
- `ThemeAwareWidgets.themedElevatedButton()` - Theme-aware button
- `ThemeAwareWidgets.themedIcon()` - Theme-aware icon
- `ThemeAwareWidgets.themedDivider()` - Theme-aware divider

### Helper Methods:
- `ThemeAwareWidgets.getScaffoldBackgroundColor(context)` - Get background color
- `ThemeAwareWidgets.getPrimaryColor(context)` - Get primary color
- `ThemeAwareWidgets.getTextPrimaryColor(context)` - Get text primary color
- `ThemeAwareWidgets.getTextSecondaryColor(context)` - Get text secondary color

## Adding Dark Mode Toggle

To add a dark mode toggle button to any page:

```dart
Widget _buildDarkModeToggle() {
  return Consumer<ThemeService>(
    builder: (context, themeService, child) {
      return ElevatedButton(
        onPressed: () => themeService.toggleTheme(),
        child: Row(
          children: [
            Icon(themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            SizedBox(width: 8),
            Text(themeService.isDarkMode ? 'Light Mode' : 'Dark Mode'),
          ],
        ),
      );
    },
  );
}
```

## Common Patterns

### 1. Conditional Styling:
```dart
Consumer<ThemeService>(
  builder: (context, themeService, child) {
    return Container(
      color: themeService.isDarkMode 
          ? ThemeService.darkCardColor 
          : ThemeService.lightCardColor,
      child: Text(
        'Hello',
        style: TextStyle(
          color: themeService.isDarkMode 
              ? ThemeService.darkTextPrimaryColor 
              : ThemeService.lightTextPrimaryColor,
        ),
      ),
    );
  },
)
```

### 2. Using Theme Data:
```dart
// Access theme data directly
final themeService = Provider.of<ThemeService>(context, listen: false);
final isDark = themeService.isDarkMode;
final primaryColor = isDark ? ThemeService.darkPrimaryColor : ThemeService.lightPrimaryColor;
```

### 3. AppBar Theming:
```dart
AppBar(
  backgroundColor: themeService.isDarkMode 
      ? ThemeService.darkPrimaryColor 
      : ThemeService.lightPrimaryColor,
  foregroundColor: Colors.white, // Always white for contrast
  // ... other properties
)
```

### 4. Bottom Navigation Bar Theming:
```dart
BottomNavigationBar(
  backgroundColor: themeService.isDarkMode 
      ? ThemeService.darkPrimaryColor 
      : ThemeService.lightPrimaryColor,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  // ... other properties
)
```

### 5. Custom Navigation Bar Theming:
```dart
// For custom navigation bars like in RootPage
Container(
  decoration: BoxDecoration(
    color: themeService.isDarkMode 
        ? ThemeService.darkCardColor 
        : Colors.white,
    borderRadius: BorderRadius.circular(32),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 24,
        spreadRadius: 2,
        offset: Offset(0, 8),
      ),
    ],
  ),
  child: // ... navigation items
)
```

## Testing Dark Mode

1. **Toggle Button**: Use the dark mode toggle in the Profile page
2. **Visual Check**: Verify all UI elements adapt to the theme
3. **Persistence**: Restart the app to verify theme preference is saved
4. **Accessibility**: Ensure sufficient contrast in both themes

## Troubleshooting

### Common Issues:

1. **Widget not updating**: Make sure to wrap with `Consumer<ThemeService>`
2. **Colors not changing**: Use theme-aware widgets or conditional styling
3. **Performance**: Avoid unnecessary rebuilds by using `Consumer` strategically
4. **Hardcoded colors**: Replace all hardcoded colors with theme-aware alternatives

### Best Practices:

1. **Consistent Colors**: Use theme service colors instead of hardcoded values
2. **Reusable Widgets**: Use `ThemeAwareWidgets` for common UI elements
3. **Performance**: Minimize `Consumer` usage to necessary areas
4. **Testing**: Test both themes thoroughly before deployment

## Next Steps

To complete dark mode implementation across the entire app:

1. **Update remaining pages** using the patterns above
2. **Test thoroughly** on different devices and screen sizes
3. **Optimize performance** by reducing unnecessary rebuilds
4. **Add animations** for smooth theme transitions (optional)
5. **Consider system theme** integration (optional)

## Files to Update Next

Based on the current codebase, these files should be updated next:

- `lib/Pages/LoginPage.dart`
- `lib/Pages/Transportation.dart`
- `lib/Pages/SettingsPage.dart`
- `lib/Pages/EditFavoritesPage.dart`
- `lib/Pages/AcademicStaffPage.dart`

## Partially Updated Files (Need Completion)

These files have been started but need completion:

- `lib/Pages/NewsPage.dart` - Scaffold and post cards updated, comments section needs completion
- `lib/Pages/AllFeaturesPage.dart` - Container background updated, feature sections need completion

Follow the same patterns established in `ProfilePage.dart` and `AttendancePage.dart` for consistency. 