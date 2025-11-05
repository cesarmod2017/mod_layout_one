## 1.1.1
* Enhanced MenuItem model:
  * Added arguments parameter to support navigation with data passing
  * Allows passing dynamic data to routes using GetX navigation
  * Supports any data type (Map, List, custom objects, etc.)
  * Seamlessly integrates with Get.toNamed() for route navigation
  * Enhanced navigation flexibility for complex routing scenarios
  * Updated documentation with usage examples and best practices
* Fixed ModuleSelector overflow issue:
  * Resolved RenderFlex overflow error when menu is collapsed
  * Added LayoutBuilder for responsive content rendering
  * Implemented conditional rendering based on available width
  * Added maxLines and overflow handling to prevent text overflow
  * Fixed icon and text layout in collapsed menu state
  * Improved visual consistency across expanded and collapsed states
  * Enhanced menu toggle button behavior and responsiveness

## 1.1.0
* Enhanced ModColumn widget:
  * Added visible parameter to control column rendering
  * Column will not be rendered when visible is set to false
  * Default value is true to maintain backward compatibility
  * Returns SizedBox.shrink() when column is hidden
  * Improves conditional rendering control in grid layouts
  * Enables dynamic show/hide of columns based on application state

## 1.0.83
* Added no access screen functionality:
  * Created NoAccessScreen widget for users without any module permissions
  * Added loginRoute parameter to ModBaseLayout for custom login redirect
  * Added onNoAccessRedirect callback for custom logout handling
  * Implemented automatic detection when users have no accessible modules/groups
  * Added multi-language support with translations for English, Portuguese, and Spanish
  * Screen displays access restriction message with logout/login button
  * Seamless integration with existing claims validation system
  * Provides better user experience for permission-restricted scenarios

## 1.0.82
* Enhanced claims validation system:
  * Added claimName field to MenuItem for simplified claim validation
  * Added claimName field to MenuGroup for group-level claim control
  * Implemented improved validation logic with priority system:
    - First priority: claimName field validation
    - Second priority: type:value combination validation (legacy support)
    - If both are null and claims exist, item/group is hidden
  * Enhanced MenuGroup visibility based on claimName or item visibility
  * Applied validation improvements to both desktop sidebar and mobile drawer
  * Maintains backward compatibility with existing type/value validation
  * Improved security and flexibility for permission-based UI rendering

## 1.0.81
## 1.0.80

## 1.0.79
* Enhanced drawer functionality for tablet layouts:
  * Improved drawer responsiveness and tablet-specific layout optimizations
  * Enhanced drawer menu item organization and visual hierarchy
  * Added better tablet-specific drawer behavior and interaction patterns
  * Improved drawer performance on larger screen sizes
  * Enhanced drawer theming consistency across different device orientations

## 1.0.78
* Enhanced ModBarChart widget:
  * Added interactive footer with legend functionality for better data visualization control
  * Implemented item visibility toggle system allowing users to show/hide specific chart items
  * Enhanced legend customization with configurable border, container styling, and color themes
  * Added comprehensive zoom functionality with customizable zoom icons and range controls
  * Improved chart orientation support with both horizontal and vertical bar chart layouts
  * Enhanced empty state handling with customizable titles and icons when no data is visible
  * Added advanced color customization for action buttons in both light and dark themes
  * Implemented ChartActionButtonTheme for centralized button styling and theming
  * Enhanced chart container customization with configurable background colors and dimensions
  * Improved legend interaction with visual feedback for active/inactive items
  * Added support for custom chart width and height constraints for better responsive design
  * Enhanced chart padding and spacing controls for improved layout flexibility
  * Improved chart performance with optimized rendering for large datasets
  * Added comprehensive theme integration for seamless light/dark mode transitions

## 1.0.77
* Added ModToast widget system:
  * Implemented comprehensive toast notification system with ToastManager for centralized toast management
  * Added multiple toast types: success, error, warning, info, and custom with predefined styling
  * Enhanced toast positioning system with support for topCenter, topLeft, topRight, bottomCenter, bottomLeft, and bottomRight positions
  * Implemented configurable duration settings with different defaults per toast type (success: 4s, error: 6s, warning: 5s, info: 4s)
  * Added custom toast functionality with full control over icon, colors, dimensions, and styling
  * Enhanced toast appearance with customizable background colors, text colors, border radius, and shadows
  * Implemented toast dismissal with optional close button and automatic timeout functionality
  * Added margin and padding customization for flexible toast positioning and spacing
  * Enhanced toast display with icon support and consistent visual hierarchy
  * Implemented width and height constraints with maxWidth support for responsive design
* Enhanced ModDropdownSearch widget:
  * Improved floating label behavior and positioning accuracy
  * Enhanced label animation smoothness and timing
  * Fixed label background color issues in different themes
  * Improved dropdown overlay positioning and sizing
  * Enhanced search functionality with better text matching algorithms
  * Added better keyboard navigation support for dropdown items
  * Improved multiselect display and selection feedback
  * Enhanced dropdown item styling and hover effects

## 1.0.76
* ModChartDataItem fixes:
  * Fixed color property propagation in fromJson method to maintain custom item colors in charts
  * Improved color consistency for chart items when loading data via JSON
  * Enhanced custom color functionality for dynamic data loading


## 1.0.75
* Enhanced ModBarChart widget:
  * Added comprehensive horizontal bar chart functionality with customizable data visualization
  * Implemented support for static and dynamic data loading with async data fetching capabilities
  * Added interactive action buttons with period filtering and custom styling options
  * Enhanced chart customization with configurable bar height, spacing, and border radius
  * Implemented unit positioning support (left/right) with flexible value formatting
  * Added comprehensive theming support for light and dark modes with customizable colors
  * Enhanced user interaction with bar click callbacks and tooltip functionality
  * Implemented scroll support for charts with many data items using maxItemsBeforeScroll
  * Added error handling capabilities with custom error callbacks
  * Enhanced visual feedback with loading states and data update animations
  * Implemented comprehensive styling options for titles, labels, and chart elements
  * Added support for custom footer widgets and additional chart metadata display
  * Enhanced accessibility and responsive design for different screen sizes
  * Improved chart performance with optimized rendering and data handling

## 1.0.74
* Enhanced ModPopupButton widget:
  * Added comprehensive popup button functionality with customizable menu items
  * Implemented support for nested submenus with hover behavior on desktop platforms
  * Added automatic platform detection for optimal user experience (desktop vs mobile)
  * Enhanced popup positioning with intelligent overflow detection and adjustment
  * Implemented custom styling options including font sizes and padding for menus and submenus
  * Added support for icon and text combinations in menu items
  * Enhanced submenu positioning with configurable offset and spacing controls
  * Implemented timer-based hover behavior for smooth submenu interactions
  * Added support for custom widgets in menu items for advanced layouts
  * Improved accessibility and keyboard navigation for popup menu interactions
  * Enhanced visual feedback with proper styling for different button types
  * Added comprehensive customization options for popup appearance and behavior

## 1.0.73
* Enhanced ModDropdown widgets:
  * Improved ModDropdownSearch floating label functionality
  * Enhanced label positioning and animation system
  * Added better support for floating labels with background color customization
  * Improved visual feedback for active and inactive states
  * Enhanced dropdown item display and selection behavior
  * Added better support for multiselect functionality
  * Improved search functionality within dropdown items
  * Enhanced keyboard navigation and accessibility
  * Added better support for custom display strings
  * Improved overall dropdown user experience and responsiveness

## 1.0.72
* Enhanced ModDataTable widget:
  * Improved horizontal scroll functionality
  * Added enhanced support for scroll synchronization between header and table body
  * Implemented better scroll controller management
  * Enhanced scroll responsiveness for wide tables
  * Improved horizontal navigation experience for tables with many columns
  * Added more precise scroll positioning control
  * Implemented performance optimizations for scroll operations
  * Enhanced visual synchronization during horizontal scrolling
  * Improved scroll compatibility across different platforms
  * Added enhanced support for tables with fixed headers and horizontal scroll

## 1.0.71
* Enhanced ModCard widget:
  * Added disableModCard property for simplified card rendering
  * Improved card structure when disabling standard card behavior
  * Enhanced content-only display mode without header interactions
  * Added better support for direct content and footer rendering
  * Improved card flexibility with optional header functionality
  * Enhanced visual consistency when header interactions are disabled
  * Added seamless content display without accordion behavior
  * Improved performance for cards that don't need header interactions
  * Enhanced card customization with simplified rendering options
  * Added better support for content-focused card layouts

## 1.0.70
* Enhanced ModTabs widget:
  * Added icon support for ModTab
  * Improved tab visual design with optional icon display
  * Enhanced tab layout to accommodate icons alongside text
  * Added better icon positioning and spacing control
  * Improved tab accessibility with icon support
  * Enhanced visual hierarchy with icon and text combination
  * Added flexible icon widget support for custom icons
  * Improved tab rendering performance with icon elements
  * Enhanced overall tab appearance and user experience

## 1.0.69
* Enhanced ModDataTable widget:
  * Added custom horizontal scrollbar implementation
  * Improved horizontal scroll functionality with click-to-position feature
  * Enhanced continuous drag support for Windows platform
  * Added showHorizontalScrollbar property for enabling/disabling horizontal scrollbar
  * Improved horizontal scroll performance and responsiveness
  * Enhanced scrollbar visual design and customization
  * Added better support for wide tables with many columns
  * Improved scrollbar track interaction and navigation
  * Enhanced horizontal scroll experience across different platforms
  * Added seamless horizontal scrolling for better user experience

## 1.0.68
* Enhanced ModModal widget:
  * Enhanced modal positioning control
  * Added improved support for ModModalPosition (top, center, bottom)
  * Improved modal alignment system on screen
  * Enhanced modal positioning and alignment capabilities
  * Added better support for different screen sizes
  * Improved responsive behavior of modals
  * Enhanced visual consistency across different modal positions
  * Added better spacing and margin control
  * Improved automatic sizing system
  * Added padding property support for modal content
  * Enhanced overall modal presentation and user experience

## 1.0.67

* Enhanced ModColumn widget:
  * Added backgroundColor property support
  * Improved container styling capabilities
  * Enhanced visual customization options
  * Added better support for background color theming
  * Improved column background rendering
  * Enhanced color consistency across different screen sizes
  * Added better support for transparent backgrounds
  * Improved background color accessibility
  * Enhanced overall column appearance control

## 1.0.66

* Enhanced ModTextBox widget:
  * Added support for custom border width
  * Improved border color customization
  * Enhanced background color control
  * Added better border visibility control
  * Improved border radius consistency
  * Enhanced border state handling
  * Added better support for custom border styles
  * Improved border animation transitions
  * Enhanced border color contrast
  * Added better accessibility for border states

## 1.0.65

* Enhanced ModTextBox widget:
  * Improved multiline text input handling
  * Added better support for auto-height adjustment
  * Enhanced text input validation
  * Improved keyboard type handling
  * Added better support for custom input formatters
  * Enhanced floating label behavior
  * Improved suffix button integration
  * Added better support for custom styles
  * Enhanced text alignment control
  * Improved overall input field responsiveness


## 1.0.64

* Enhanced ModTextBox widget:
  * Improved padding adjustment with label
  * Enhanced label spacing and alignment
  * Added better padding control for different label positions
  * Improved vertical spacing between label and input
  * Enhanced horizontal padding consistency
  * Added better support for custom padding values
  * Improved padding behavior with floating labels
  * Enhanced padding adjustments for different input sizes
  * Added better padding control for error states
  * Improved overall layout consistency

## 1.0.63

* Enhanced ModDropDown widget:
  * Improved floating label behavior and positioning
  * Enhanced label animation transitions
  * Added better support for custom label backgrounds
  * Improved label text scaling
  * Enhanced focus state handling
  * Added smoother label transitions
  * Improved label color contrast
  * Enhanced accessibility for floating labels
  * Added better support for different label positions
  * Improved label alignment with input content

* Enhanced ModTextBox widget:
  * Improved floating label behavior and positioning
  * Enhanced label animation transitions
  * Added better support for custom label backgrounds
  * Improved label text scaling
  * Enhanced focus state handling
  * Added smoother label transitions
  * Improved label color contrast
  * Enhanced accessibility for floating labels
  * Added better support for different label positions
  * Improved label alignment with input content

## 1.0.62

* Enhanced ModTextBox widget:
  * Improved text input validation handling
  * Added support for custom input formatters
  * Enhanced keyboard type handling
  * Improved floating label behavior
  * Added auto-height adjustment option
  * Enhanced suffix button integration
  * Improved error message display
  * Added support for custom background colors
  * Enhanced text alignment options
  * Improved accessibility features

* Enhanced ModDropdownSearch widget:
  * Added support for custom icons in dropdown items
  * Improved search functionality with better filtering
  * Enhanced multi-select capabilities
  * Added support for custom item display formatting
  * Improved dropdown positioning
  * Enhanced keyboard navigation
  * Added support for custom item styling
  * Improved accessibility features
  * Enhanced error handling
  * Added support for custom validation

* Enhanced ModModal widget:
  * Improved modal positioning and sizing
  * Added support for custom animations
  * Enhanced backdrop handling
  * Improved content scrolling
  * Added support for custom header and footer
  * Enhanced close button behavior
  * Improved accessibility features
  * Added support for custom styling
  * Enhanced keyboard interaction
  * Improved mobile responsiveness

* Enhanced ModDialog widget:
  * Improved dialog positioning
  * Added support for custom animations
  * Enhanced button layout options
  * Improved content scrolling
  * Added support for custom styling
  * Enhanced keyboard interaction
  * Improved accessibility features
  * Added support for custom icons
  * Enhanced error handling
  * Improved mobile responsiveness

## 1.0.61

* Fixed ModTextBox widget:
  * Resolved issue with text input validation
  * Fixed floating label positioning
  * Improved keyboard type handling
  * Enhanced error message display
  * Fixed suffix button alignment

* Fixed ModDropdownSearch widget:
  * Resolved issue with search functionality
  * Fixed dropdown positioning
  * Improved item selection handling
  * Enhanced keyboard navigation
  * Fixed multi-select behavior

## 1.0.60

* Fixed ModModal widget:
  * Resolved issue with modal positioning
  * Fixed backdrop handling
  * Improved content scrolling
  * Enhanced close button behavior
  * Fixed mobile responsiveness

* Fixed ModDialog widget:
  * Resolved issue with dialog positioning
  * Fixed button layout
  * Improved content scrolling
  * Enhanced keyboard interaction
  * Fixed mobile responsiveness

## 1.0.59

* Enhanced ModButton widget:
  * Added support for different button sizes (lg, md, sm, xs)
  * Implemented customizable border radius for rounded corners
  * Added loading state with animated icon and custom loading text
  * Improved icon support with left and right icon positioning
  * Added multiple button types (primary, secondary, success, info, warning, danger, dark)
  * Implemented border type customization options
  * Added text alignment control for button labels
  * Enhanced button sizing with autosize property
  * Improved disabled state handling
  * Added custom text color support for better theming integration
## 1.0.58

* Enhanced ModTab widget:
  * Added `id` property to uniquely identify tabs
  * Improved tab management with unique identifiers
  * Better support for dynamic tab operations (add, remove, select)
  * Enhanced tab state persistence with identifiable tabs
  * Optimized tab selection by ID rather than index
  * Improved programmatic tab manipulation
  * Added support for tab data retrieval by ID
  * Enhanced tab event handling with ID-based references
  * Better integration with external state management
  * Improved tab lifecycle management with unique identifiers

## 1.0.57

* Enhanced ModTabs widget:
  * Implemented `selectedIndex` property for external tab control
  * Added support for programmatically changing the active tab
  * Improved state synchronization with external controllers
  * Fixed tab selection when controlled from parent widgets
  * Enhanced tab state management with GetX integration
  * Optimized tab rendering when selection changes externally
  * Added proper documentation for the new selection control feature
  * Implemented bidirectional communication for tab selection state
  * Fixed edge cases when selected index is out of bounds
  * Improved performance when switching between tabs programmatically

## 1.0.56

* Fixed ModTabs widget:
  * Resolved issue with tab selection persistence
  * Fixed tab content alignment problems
  * Improved tab scrolling behavior on smaller screens
  * Corrected tab width calculation for dynamic content
  * Enhanced tab close button responsiveness
  * Fixed memory leak when removing tabs dynamically
  * Improved tab rendering performance
  * Corrected tab indicator animation
  * Fixed tab overflow handling in horizontal orientation
  * Enhanced accessibility for keyboard navigation between tabs


## 1.0.55

* Fixed ModTabs widget:
  * Corrected tab addition functionality with GetX state management
  * Improved tab controller synchronization
  * Enhanced dynamic tab creation and management
  * Fixed state update issues when adding new tabs
  * Optimized tab rendering after dynamic changes
  * Better memory management for dynamically created tabs
  * Improved tab lifecycle handling
  * Enhanced tab content association with tab headers
  * Fixed tab selection after dynamic tab addition
  * Proper cleanup of removed tabs to prevent memory leaks

## 1.0.54

* Added ModCheckbox widget:
  * Customizable checkbox appearance and behavior
  * Support for different states (checked, unchecked, indeterminate)
  * Configurable size and color properties
  * Animated state transitions
  * Accessible design with proper semantics
  * Support for disabled state styling
  * Consistent look and feel with other form components
  * Touch-friendly hit areas for mobile interfaces
  * Keyboard navigation support
  * Integration with form validation systems

* Enhanced icon customization:
  * Added support for custom icons in creation mode
  * Improved editing mode with distinctive icon indicators
  * Synchronization status icons for better visual feedback
  * Consistent icon theming across the component library
  * Support for different icon sizes based on context
  * Color customization options for all icon states
  * Animation capabilities for state transitions
  * Better accessibility with proper icon labels
  * Optimized rendering performance for icon-heavy interfaces
  * Comprehensive documentation for icon customization options

## 1.0.53

* Added ModTreeView widget:
  * Hierarchical data visualization with expandable/collapsible nodes
  * Support for custom node styling and icons
  * Configurable indentation and connection lines
  * Lazy loading support for large data sets
  * Interactive node selection with callbacks
  * Drag and drop functionality for node reordering
  * Search and filtering capabilities
  * Keyboard navigation support
  * Customizable node templates
  * Optimized rendering for deep tree structures
  * Accessibility features for screen readers

## 1.0.52

* Enhanced ModTabs widget:
  * Added support for showing/hiding AppBar
  * Improved tab navigation and interaction
  * Better handling of tab content rendering
  * Optimized tab switching performance
  * More consistent tab styling and layout
  * Enhanced tab overflow behavior
  * Configurable tab header appearance
  * Smoother animations during tab transitions
  * Better support for dynamic tab content
  * Improved accessibility for tab navigation

## 1.0.51

* Enhanced ModuleSelector widget:
  * Added support for module grouping in popup menu
  * Improved organization of modules with category headers
  * Visual separation between different module groups
  * Consistent styling with the rest of the module selector
  * Better navigation for applications with many modules
  * Maintains existing module selection behavior
  * Supports both expanded and collapsed menu states
  * Compatible with icon and image-based module representations
  * Preserves module descriptions in grouped view
  * Optimized for both desktop and mobile interfaces

## 1.0.50

* Enhanced ModTextBox widget:
  * Added support for textInputAction property
  * Allows specifying keyboard action button behavior
  * Supports all standard TextInputAction values (next, done, search, etc.)
  * Improves form navigation and submission workflows
  * Enables better control over keyboard interaction
  * Maintains consistent behavior with Flutter's TextFormField
  * Seamless integration with existing form validation
  * Compatible with both single-line and multiline text inputs
  * Preserves all existing ModTextBox functionality
  * Improves user experience on mobile keyboards

## 1.0.49

* Enhanced ModLabel widget:
  * Added markdown-like formatting support for bold text using asterisks
  * Improved text rendering with RichText for mixed styling
  * Better handling of text styles and inheritance
  * Optimized parsing of formatted text
  * Consistent styling between normal and bold text segments
  * Maintains font characteristics across formatting
  * Seamless integration with existing text style properties
  * Preserves alignment and other text configurations
  * Compatible with existing theme integration
  * Simple syntax for content authors (e.g., "Hello *world*" renders "world" in bold)

## 1.0.48

* Added ModLabel widget:
  * New widget for displaying text with consistent styling
  * Supports customizable text styles and appearance
  * Configurable font size, weight, and color
  * Optional overflow handling with ellipsis
  * Supports text alignment options
  * Integrates with theme for automatic light/dark mode adaptation
  * Maintains consistent styling with other Mod widgets
  * Accessible text rendering
  * Supports both single and multi-line text
  * Optimized for performance in lists and grids

## 1.0.47

* Added ModTextCopy widget:
  * New widget for displaying copyable text with a copy button
  * Supports customizable copy button icon and tooltip
  * Visual feedback on successful copy action
  * Configurable text styles and button appearance
  * Automatic clipboard integration
  * Responsive layout that adapts to content width
  * Accessible copy functionality
  * Optional read-only mode
  * Supports both single and multi-line text
  * Maintains consistent styling with other Mod widgets

## 1.0.46

* Added ModFooter widget:
  * New widget to create a footer layout with customizable height and border.
  * Supports custom background color and border.
  * Integrates seamlessly with existing ModBaseLayout features.
  * Maintains backwards compatibility with default transparent background and no border.

## 1.0.45

* Added ModHeader color customization options:
  * Added lightBackgroundColor parameter for light theme header background
  * Added lightForegroundColor parameter for light theme header text/icons
  * Added darkBackgroundColor parameter for dark theme header background
  * Added darkForegroundColor parameter for dark theme header text/icons
  * Supports dynamic color changes based on theme mode
  * Allows consistent header styling across theme changes
  * Improves header visual customization flexibility
  * Better theme integration capabilities
  * Enhanced branding possibilities
  * More control over header appearance

## 1.0.44

* Fixed column width calculation in ModDataTable:
  * Corrected width calculation logic for fixed and percentage-based columns
  * Fixed issue with column widths not properly scaling with container size
  * Improved handling of remaining width distribution for percentage columns
  * Ensured consistent column sizing across table updates
  * Maintains proper column proportions during resizing
  * Better respects minimum width constraints
  * More accurate total width calculations
  * Enhanced layout stability
  * Fixed width preservation during sorting/filtering
  * Improved overall table appearance and usability

## 1.0.43

* Added column resize functionality to ModDataTable:
  * Introduced enableColumnResize parameter to enable/disable column resizing
  * Added drag handles to column headers for width adjustment
  * Implemented smooth drag-based column width modification
  * Added onColumnWidthChanged callback to track width changes
  * Maintains minimum column width constraint of 50px
  * Preserves column widths during table updates
  * Cursor changes to indicate resizable columns
  * Supports both fixed and percentage width columns
  * Improves table customization capabilities
  * Enhanced user control over column dimensions

## 1.0.42

* Added mounted check to prevent state updates after unmounting:
  * Introduced mounted flag to track component lifecycle state
  * Prevents setState calls after component unmounting
  * Reduces memory leaks and React warnings
  * Improves component cleanup and disposal
  * Better handling of asynchronous operations
  * Enhanced component lifecycle management
  * Prevents unnecessary state updates
  * Follows React best practices
  * Improves application stability
  * More robust error prevention

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
