## 1.0.22

* Added searchHint to ModDropdownSearch:
  * New property to customize the hint text displayed in the search box
  * Allows for better user guidance and improved UX
  * Supports dynamic hint text based on context
  * Seamless integration with existing search functionality
  * Maintains backwards compatibility with default 'Search...' hint
  * Customizable through widget properties
  * Consistent behavior across single and multi-select modes

## 1.0.21

* Added displayStringForOption to ModDropdownSearch:
  * New property to customize string representation of selected items
  * Supports both widget-level and item-level customization
  * Allows dynamic string formatting based on item properties
  * Improves display flexibility for complex objects
  * Maintains backwards compatibility with toString() fallback
  * Seamless integration with existing dropdown features
  * Enhanced type safety with generic support
  * Consistent behavior across single and multi-select modes

## 1.0.20

* Added ModDropdownSearch widget:
  * Customizable dropdown with search functionality
  * Supports single and multi-select modes
  * Built-in search filtering with customizable search box
  * Supports icons and images for dropdown items
  * Configurable dropdown height and max height
  * Custom styling options for background, text and borders
  * Supports disabled state and validation
  * Prefix and suffix icons with customizable colors
  * Error text display with validation support
  * Responsive overlay positioning
  * Smooth animations for dropdown open/close
  * Customizable item rendering and selection indicators
  * Supports keyboard navigation and accessibility
  * Flexible label positioning (top or inside)
  * Multiple size options (lg, md, sm, xs)
  * Support for custom objects with toString override
  * Built-in clear button in search box
  * Optional close button for multi-select mode
  * Maintains selected items state
  * Seamless integration with form validation

## 1.0.19

* Added ModDropDown widget:
  * Customizable dropdown with various sizes (lg, md, sm, xs)
  * Supports custom label positions (top, left)
  * Includes prefix and suffix icons
  * Provides validation and error text display
  * Allows for custom border radius and width
  * Supports read-only mode and focus management
  * Integrates seamlessly with existing form widgets
  * Enhanced accessibility features and keyboard navigation
  * Improved responsive behavior on different screen sizes

* Adjusted ModTextBox widget:
  * Added support for custom styles and border radius
  * Enhanced validation and error text display
  * Improved keyboard type handling and input formatters
  * Added support for read-only mode
  * Enhanced accessibility features and keyboard navigation
  * Improved responsive behavior on different screen sizes
  * Added support for suffix buttons with custom actions
  * Enhanced integration with form validation and state management

## 1.0.18

* ModDataTable improvements:
  * Added support for custom row click handlers
  * Enhanced sorting functionality with multiple column support
  * Improved pagination performance and memory usage
  * Added row selection capability with checkbox support
  * Enhanced accessibility features and keyboard navigation
  * Added support for frozen columns
  * Improved responsive behavior on different screen sizes
  * Added support for custom cell renderers
  * Enhanced search and filtering capabilities
  * Added support for row expansion/collapse
  * Improved header styling customization options
  * Added support for column resizing
  * Enhanced data loading states and indicators
  * Added support for CSV/Excel export
  * Improved scrolling performance for large datasets

## 1.0.17

* Added ModDataTable widget:
  * Customizable data table with pagination support
  * Configurable column headers with sorting capability
  * Flexible column width control (fixed or percentage based)
  * Alternating row colors for better readability
  * Built-in pagination controls with rows per page selection
  * Support for custom border styles
  * Dynamic page number generation and navigation
  * Sortable columns with direction indicators
  * Responsive layout adaptation
  * Customizable pagination text and styling
  * Efficient data source handling
  * Flexible row height and header styling options
  * Support for custom cell content rendering
  * Maintains consistent table styling and behavior

## 1.0.16

* Added ModIconButton widget:
  * Provides an icon button with loading state
  * Supports customizable icons, colors, and sizes
  * Includes rotation animation for loading state
  * Allows for asynchronous operations with loading feedback
  * Maintains consistent button styling and behavior
  * Supports optional tooltip and feedback options
  * Integrates seamlessly with existing button widgets

## 1.0.15

* ModTextBox validation improvements:
  * Fixed validation error handling and display
  * Added proper error state management
  * Improved validation feedback timing
  * Enhanced error message formatting
  * Ensured consistent validation behavior across form fields
  * Fixed validator callback execution
  * Added proper error state clearing on valid input

## 1.0.14

* ModTextBox error message improvements:
  * Added error message tooltip when field has validation error
  * Improved error message visibility and styling
  * Added red background to error tooltip
  * Enhanced error state visual feedback
  * Maintains consistent error handling across form fields

## 1.0.13

* Changed padding in ModModal:
  * Replaced double padding parameter with EdgeInsetsGeometry
  * Provides more flexible padding control
  * Allows directional padding customization
  * Maintains consistent padding API across widgets

## 1.0.12

* Adjusted padding in ModContainer:
  * Added optional padding parameter for flexible spacing control
  * Maintains responsive container behavior
  * Allows customization of container content spacing
  * Implemented via EdgeInsetsGeometry padding parameter

## 1.0.11

* Added padding support to ModColumn:
  * Enables custom padding around column content
  * Improves spacing control in grid layouts
  * Maintains responsive behavior with padding
  * Implemented via optional padding parameter in ModColumn widget

## 1.0.10

* Added ColumnSize.none to grid system:
  * Allows columns to be hidden at specific screen sizes
  * Enables responsive layouts with conditional column visibility
  * Improves flexibility in grid system layouts
  * Implemented in ModColumn widget with null width handling

## 1.0.9

* ModButton improvements:
  * Added loading state with customizable loading icon and text
  * Added right icon support
  * Added text alignment control
  * Improved size consistency across different button types
  * Enhanced button padding and spacing

* ModTextBox improvements:
  * Added support for different sizes (lg, md, sm, xs) matching button sizes
  * Added support for suffix buttons
  * Added label position control (top/left)
  * Added floating label behavior control
  * Improved text and icon sizing consistency
  * Enhanced input decoration and padding
  * Added support for prefix and suffix icons with proper sizing
## 1.0.8

* Correction of language translation, set to English.

## 1.0.7

* Updated LanguageSelector widget to use PopupMenuButton for language selection.
* Improved language flag display in LanguageSelector widget.

## 1.0.6

* Added footerHeight parameter to ModBaseLayout to allow customization of footer height.

## 1.0.5

* Added onTap parameter to MenuItem in sidebar.

## 1.0.4

* Added new examples to ButtonsPage.
* Improved documentation in README.md.

## 1.0.3

* Added ModTextDivider widget.

## 1.0.2

* Improvement in the button.

## 1.0.1

* Initial release with basic features.

## 1.0.0

* Initial release with basic features.
