## 1.0.41

* Added enableSimplePagination property to ModDataTable:
  * Introduced new enableSimplePagination parameter for simplified pagination controls
  * Provides basic previous/next navigation buttons for page traversal
  * Reduces visual complexity compared to full pagination controls
  * Ideal for scenarios requiring minimal pagination interface
  * Maintains current page indicator for user reference
  * Streamlines user interaction with paginated data
  * Offers lightweight alternative to standard pagination
  * Improves usability for simple data sets
  * Reduces screen space usage for pagination controls
  * Better suited for mobile and space-constrained interfaces

## 1.0.40

* Added minWidthTabs property to ModTabs:
  * Introduced new minWidthTabs parameter to control minimum tab width
  * Allows setting consistent tab widths across the component
  * Improves layout control for both horizontal and vertical orientations
  * Works seamlessly with TabAlignment.justify for equal width distribution
  * Enables better space utilization in tab layouts
  * Provides more flexibility in tab sizing and spacing
  * Maintains responsive behavior while enforcing minimum widths
  * Enhances visual consistency across different screen sizes
  * Better handling of tabs with varying content lengths
  * Improved overall tab layout customization options

## 1.0.39

* Improved ModDataTable header functionality:
  * Enhanced header alignment and positioning
  * Fixed header width calculation issues
  * Improved header cell padding consistency
  * Better handling of sortable column indicators
  * Optimized header rendering performance
  * Fixed header text overflow issues
  * Enhanced header border styling
  * Improved header click response for sorting
  * Better visual feedback on header interactions
  * More consistent header appearance across themes

## 1.0.38

* Adjusted spacing between label and input fields:
  * Increased vertical spacing between label and ModTextBox from 2px to 8px
  * Increased vertical spacing between label and ModDropDown from 2px to 8px
  * Increased vertical spacing between label and ModDropdownSearch from 2px to 8px
  * Improved visual hierarchy and readability of form elements
  * Enhanced overall form layout consistency
  * Better alignment with material design spacing guidelines
  * Standardized spacing across all input components
  * Improved visual separation between label and input fields
  * Better visual balance in form layouts
  * Enhanced accessibility with clearer visual grouping

## 1.0.37

* Changed hint text fontWeight in ModTextBox:
  * Updated hint text style to use FontWeight.w400 for better readability
  * Improved visual consistency with other form elements
  * Enhanced text appearance in input fields
  * Standardized hint text presentation across the widget

## 1.0.36

* Fixed issues with ModDataTable fixed header:
  * Resolved header alignment problems when scrolling horizontally
  * Fixed z-index stacking issues with fixed header
  * Improved header shadow rendering during scroll
  * Enhanced header positioning calculation
  * Fixed header width synchronization with table columns
  * Resolved flickering issues during rapid scrolling
  * Improved performance of fixed header rendering
  * Fixed header background color consistency
  * Enhanced scroll event handling for smoother experience
  * Resolved edge cases with dynamic column resizing

## 1.0.35

* Added fixed header support to ModDataTable:
  * Implemented sticky header functionality for better table navigation
  * Header remains visible while scrolling through table content
  * Improved user experience when viewing large datasets
  * Maintains column alignment when scrolling horizontally
  * Added fixedHeader property to control header behavior
  * Enhanced performance for large tables with fixed headers
  * Proper handling of header styles and colors in fixed position
  * Seamless integration with existing table features
  * Maintains responsive behavior with fixed header
  * Compatible with all table customization options

## 1.0.34

* Enhanced language handling and localization:
  * Improved language switching mechanism for smoother transitions
  * Added support for dynamic language updates without app restart
  * Enhanced fallback language handling when preferred locale is unavailable
  * Optimized language resource loading and caching
  * Better handling of regional variants for languages
  * Improved persistence of language preferences
  * Added support for RTL languages and layouts
  * Enhanced accessibility for language selection controls
  * Better integration with system locale changes
  * Improved error handling for missing translations

## 1.0.33

* Fixed ModLoading to use Get.context for better context handling
  * Ensures that the loading indicator is displayed correctly in the overlay
  * Improved error handling when no overlay context is found

## 1.0.32

* Created ModLoading widget:
  * A customizable loading indicator for Flutter applications
  * Supports various loading positions (center, left, right, etc.)
  * Allows for custom icons and images
  * Provides animation options for a smooth loading experience
  * Configurable background color and border radius
  * Integrates with Overlay for displaying loading indicators on top of other widgets
  * Supports both vertical and horizontal orientations
  * Enhanced accessibility features for better user experience

## 1.0.31

* Added ModRow widget:
  * New widget to create a row layout with ModColumn children
  * Supports custom alignment with MainAxisAlignment and CrossAxisAlignment
  * Optional height property to set the row height
  * Automatically wraps columns within the available width
  * Integrates seamlessly with ModContainer for flexible layouts
  * Ensures consistent behavior across different screen sizes
  * Enhanced accessibility for row and column layouts

## 1.0.30

* Adjusted pagination in ModDataTable:
  * Improved page navigation logic for better user experience
  * Enhanced visibility of page numbers on different screen sizes
  * Optimized layout for mobile and desktop views
  * Ensured consistent behavior across various devices
  * Fixed issues with page number generation and display
  * Improved accessibility for pagination controls

* Maintained menu open state for submenus:
  * Enhanced _ExpandableMenuItem to keep submenus open
  * Improved user experience by preserving submenu state
  * Ensured consistent behavior across navigation interactions
  * Optimized layout and transitions for submenu items
  * Enhanced accessibility for nested menu items
  * Better handling of submenu state across screen sizes
  * Improved integration with existing menu functionality

## 1.0.29

* Changed MenuGroup title property to widget:
  * Replaced title string property with Widget type
  * Allows for more flexible title customization
  * Supports rich text, icons, and custom widgets
  * Maintains backwards compatibility through Text widget
  * Enhanced visual customization options
  * Better integration with design systems
  * Consistent with other widget-based components
  * Improved flexibility for menu headers

## 1.0.28

* Enhanced menu functionality and responsiveness:
  * Improved mobile drawer behavior and animations
  * Added automatic menu collapse on mobile devices
  * Enhanced theme switching controls in mobile drawer
  * Optimized sidebar layout and spacing
  * Better handling of menu state across screen sizes
  * Improved menu expansion/collapse transitions
  * More consistent menu behavior across platforms
  * Enhanced accessibility for navigation elements

## 1.0.27

* Added initiallyExpanded property to ModExpansionPanel:
  * New property to control initial expansion state of panels
  * Allows panels to be expanded by default when rendered
  * Seamless integration with existing expansion behavior
  * Maintains backwards compatibility with default collapsed state
  * Customizable through widget properties
  * Consistent behavior across panel instances
  * Enhanced user experience with configurable initial states
  * Useful for displaying important content immediately

## 1.0.26

* Added multiline property to ModTextBox:
  * New property to enable multi-line text input
  * Supports dynamic height adjustment with autoHeight property
  * Allows for longer text entries and text areas
  * Seamless integration with existing ModTextBox features
  * Maintains backwards compatibility with single-line mode
  * Customizable through widget properties
  * Consistent behavior across different screen sizes
  * Enhanced text input flexibility for various use cases

## 1.0.25

* Added maxHeight property to ModContainer:
  * New property to set the maximum height of the container
  * Supports dynamic height adjustments based on content
  * Allows for better layout control and flexibility
  * Seamless integration with existing ModContainer features
  * Maintains backwards compatibility with default unlimited height
  * Customizable through widget properties
  * Consistent behavior across different screen sizes and orientations
  * Enhanced visual appeal with flexible height options

## 1.0.24

* Added claims property to ModBaseLayout:
  * New property to manage user claims and permissions
  * Supports dynamic claim-based UI rendering
  * Allows for conditional display of menu items and actions
  * Seamless integration with existing ModBaseLayout features
  * Maintains backwards compatibility with default null claims
  * Customizable through widget properties
  * Consistent behavior across different screen sizes and orientations
  * Enhanced security with claim-based access control

## 1.0.23

* Added background property to ModContainer:
  * New property to customize the background color of the container
  * Supports solid colors, gradients, and images
  * Allows for dynamic background changes based on state
  * Seamless integration with existing ModContainer features
  * Maintains backwards compatibility with default transparent background
  * Customizable through widget properties
  * Consistent behavior across different screen sizes and orientations
  * Enhanced visual appeal with flexible styling options

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
