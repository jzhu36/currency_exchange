# Currency Exchange App - UI Design Specification

**Version:** 1.0
**Date:** December 11, 2025
**Design Goal:** Professional UX Improvements with Corporate Aesthetic

---

## 1. Executive Summary

This specification outlines the UI redesign for the Currency Exchange mobile application. The primary focus is on **UX improvements** while maintaining a **professional, corporate visual style** with **light mode** support. The redesign emphasizes clearer interactions, better feedback mechanisms, and improved accessibility for system navigation.

### Key Design Principles
- **Professional & Trustworthy:** Corporate aesthetic suitable for financial applications
- **Clear Interactions:** Enhanced visual feedback for drag-and-drop operations
- **Accessibility First:** Proper safe area handling for gesture navigation
- **Data Clarity:** Improved number formatting with thousand separators

---

## 2. Overall Layout Structure

### 2.1 Screen Hierarchy
```
┌─────────────────────────────────┐
│ App Bar                         │
├─────────────────────────────────┤
│ Instructions Text               │
├─────────────────────────────────┤
│                                 │
│ Scrollable Currency List        │
│  ┌─────────────────────────┐   │
│  │ Currency Row 1          │   │
│  ├─────────────────────────┤   │
│  │ Currency Row 2          │   │
│  ├─────────────────────────┤   │
│  │ ...                     │   │
│  ├─────────────────────────┤   │
│  │ + Add Currency Card     │   │
│  └─────────────────────────┘   │
│                                 │
├─────────────────────────────────┤
│ Bottom Rate Information         │
│ - Last Updated Time             │
│ - Sample Exchange Rates         │
│ - Manual Refresh Button         │
├─────────────────────────────────┤
│ Safe Area Padding (System Nav)  │
└─────────────────────────────────┘
```

### 2.2 Component Retention
- **Keep:** App bar, instructions text, scrollable list structure
- **Modify:** Bottom section (add refresh button), Add currency mechanism
- **Add:** Safe area padding, haptic feedback, animated drop previews

---

## 3. Currency List Item Design

### 3.1 Layout (Compact Single-Line Row)
**Current implementation to maintain with enhancements:**

```
┌────────────────────────────────────────────┐
│ Card                                       │
│ ┌────────────────────────────────────────┐│
│ │[≡] 🇺🇸 USD          1,234.56          ││
│ └────────────────────────────────────────┘│
└────────────────────────────────────────────┘
 ↑    ↑   ↑             ↑
 │    │   │             └─ Amount (with thousand separators)
 │    │   └─────────────── Currency Code (Bold, Blue)
 │    └───────────────────── Flag Emoji
 └────────────────────────── Drag Handle Icon
```

### 3.2 Visual Specifications

**Card Component:**
- Elevation: 2 (current)
- Border Radius: 12px (current)
- Horizontal Padding: 12px (current)
- Vertical Padding: 6px (current)
- Bottom Margin: 12px between cards (current)

**Flag Display:**
- Type: Emoji flags (maintain current)
- Size: 32px (current)
- Right Margin: 12px

**Currency Code:**
- Font Size: 18px
- Font Weight: Bold
- Color: Blue (#2196F3 or theme primary)
- Left Margin: 12px from flag

**Amount Input Field:**
- Font Size: 24px
- Font Weight: 500
- Number Format: **Thousand separators** (NEW)
  - Examples: "1,234.56", "10,000", "1,234,567.89"
- Input Type: Number keyboard with decimal
- Border: None (borderless input, current)
- Hint Text: "0"

**Drag Handle Icon:**
- Icon: `Icons.drag_handle` (≡)
- Color: Grey[400]
- Size: 24px
- Right Margin: 8px

### 3.3 Amount Formatting (NEW)

**Implementation Requirements:**
- Add thousand separators for all amounts
- Respect currency-specific decimal places:
  - JPY, KRW: No decimals (e.g., "1,234")
  - Most currencies: 2 decimals (e.g., "1,234.56")
  - BHD, KWD: 3 decimals (e.g., "1,234.567")
- Format updates as user types (with proper cursor positioning)
- Parse formatted input correctly when converting

**Example Formatting:**
```
Input: 1234567.89 USD → Display: "1,234,567.89"
Input: 500000 JPY     → Display: "500,000"
Input: 99.99 EUR      → Display: "99.99"
Input: 10000.5 GBP    → Display: "10,000.50"
```

---

## 4. Drag and Drop Interactions

### 4.1 Initiation
- **Trigger:** Long-press on entire card (maintain current behavior)
- **No visible drag handle required** - entire card is draggable
- **Haptic Feedback:** (NEW) Trigger haptic vibration on drag start
  - Platform: `HapticFeedback.mediumImpact()`
  - Timing: Immediately when drag begins

### 4.2 Visual Feedback During Drag

**Dragged Item:**
- Opacity: 0.8 (current)
- Elevation: 8 (current - maintain elevated appearance)
- Width: Full screen width minus padding

**Original Position (childWhenDragging):**
- Opacity: 0.3 (current - shows gap)

**Drop Preview Animation:** (NEW)
- As dragged item moves over other items, animate surrounding items to show potential drop position
- Implementation: Use implicit animations in ReorderableListView
- Gap Animation: Items smoothly slide apart to show where drop will occur
- Duration: 200ms
- Curve: `Curves.easeInOut`

### 4.3 Delete Bin Design

**Position:** (CHANGED)
- Location: **Bottom-center** of screen (changed from bottom-right)
- Positioning: Horizontally centered
- Bottom Offset: 20px + safe area padding

**Visual Treatment:**
- Shape: Circle
- Size: 60x60px (current)
- Color:
  - Default: Red[400] (#EF5350)
  - On Hover: Red[700] (#D32F2F)
- Icon: `Icons.delete_forever`
- Icon Size: 30px default, 36px on hover
- Icon Color: White
- Shadow: Black with 30% opacity, 10px blur, 2px spread

**Interaction States:**
```
┌─────────────────────────────────┐
│                                 │
│         Currency List           │
│                                 │
│     (dragging in progress)      │
│                                 │
│          ┌──────┐              │
│          │ 🗑️   │  ← Delete Bin │
│          └──────┘              │
│             ↑                   │
│        Bottom-Center            │
└─────────────────────────────────┘
         Safe Area Padding
```

**Hover State:**
- Detection: When dragged item overlaps delete target
- Visual: Darker red background, larger icon
- Haptic: No haptic on hover (user requested only drag start haptic)
- Animation Duration: 200ms

### 4.4 Reorder Animation
- Flutter's `ReorderableListView` handles basic reordering
- Enhanced with gap animation showing drop position
- Smooth transition when item is dropped

---

## 5. Bottom Rate Information Section

### 5.1 Layout (ENHANCED)

**Current Structure:**
```
Last updated: X min ago
1 USD = 0.92 EUR | 157.34 JPY | ...
```

**New Structure:**
```
┌─────────────────────────────────────┐
│  Last updated: 5 min ago    🔄      │ ← Last update + Refresh button
├─────────────────────────────────────┤
│  1 USD = 0.92 EUR | 157.34 JPY | ...│ ← Exchange rates
└─────────────────────────────────────┘
     Safe Area Padding (20px + bottom inset)
```

### 5.2 Components

**Last Update Time:**
- Text Style: bodySmall
- Color: Grey[600]
- Font Weight: 500
- Format: Relative time (current)
  - "Just now"
  - "5 min ago"
  - "2 hours ago"
  - "MMM d, yyyy HH:mm" (for older)

**Manual Refresh Button:** (NEW)
- Icon: `Icons.refresh`
- Size: 20px
- Color: Grey[600]
- Position: Right-aligned on same line as "Last updated"
- Interaction:
  - Tap to manually refresh exchange rates
  - Show loading indicator during refresh (rotating icon)
  - On error: Show toast notification with retry option

**Exchange Rates Display:**
- Text Style: bodySmall
- Color: Grey[500]
- Font Size: 11px
- Format: "1 USD = [rate] [currency code]" separated by " | "
- Max Lines: 5
- Overflow: Ellipsis
- Center-aligned

**Safe Area Padding:** (NEW)
- Bottom Padding: `MediaQuery.of(context).padding.bottom + 20`
- Purpose: Ensure content doesn't overlap with Android gesture navigation

---

## 6. Add Currency Mechanism

### 6.1 Button Type (CHANGED)

**From:** Mini FAB below currency list
**To:** "+ Add Currency" card at end of list

### 6.2 Design Specification

**Card Layout:**
```
┌────────────────────────────────────────────┐
│                                            │
│        ┌────┐                              │
│        │ +  │  Add Currency                │
│        └────┘                              │
│                                            │
└────────────────────────────────────────────┘
```

**Visual Treatment:**
- Same card styling as currency rows (elevation 2, border radius 12)
- Height: Match currency row height
- Border: Dashed border (2px, Grey[400]) - indicates action
- Background: Grey[50] or very light background
- Center-aligned content

**Content:**
- Icon: `Icons.add_circle_outline`
- Icon Size: 32px
- Icon Color: Blue (theme primary)
- Text: "Add Currency"
- Text Style: 16px, Medium weight, Blue

**Interaction:**
- Tap anywhere on card to open Add Currency screen
- Max limit enforcement: Hide card when 20 currencies reached
- Ripple effect on tap

**Position:**
- Always last item in ReorderableListView (use footer or last index)
- Non-draggable (key: `ValueKey('add_currency_button')`)

---

## 7. Input Field Behavior

### 7.1 Current Behavior (Maintain)
- Real-time conversion: Editing any field immediately updates all others
- Clear propagation: Clearing a field clears all fields
- Focus tracking: Remembers last edited currency
- No debounce delay (immediate response preferred)

### 7.2 Enhancements
**No changes requested** - current input behavior is satisfactory

### 7.3 Keyboard Behavior
- Type: Number keyboard with decimal option
- Auto-scroll: Ensure active field visible when keyboard opens
- Dismiss: Tap outside to dismiss keyboard

---

## 8. Error Handling & Edge Cases

### 8.1 Exchange Rate Errors (NEW)

**Strategy:** Auto-retry with toast notification

**Implementation:**
1. **Initial Load Failure:**
   - Show loading indicator
   - Attempt 3 retries with exponential backoff (1s, 2s, 4s)
   - If all fail: Show toast message "Unable to load exchange rates. Retrying..."
   - Continue retrying in background every 30 seconds

2. **Refresh Failure:**
   - When manual refresh fails
   - Show toast: "Failed to refresh rates. Will retry automatically."
   - Keep displaying existing/stale rates
   - Continue auto-retry in background

3. **Toast Specification:**
   - Position: Bottom (above safe area padding)
   - Duration: 3 seconds
   - Background: Orange/Warning color
   - Text: Clear error message with reassurance
   - Action: Optional "Retry Now" button

**Visual State:**
- Keep showing stale rates (don't blank out the UI)
- Update "Last updated" timestamp to show staleness
- Optional: Small warning indicator next to timestamp

### 8.2 Empty State
- Minimum currencies: 1 (don't allow deleting all)
- If somehow all deleted: Show empty state prompt to add currency

### 8.3 Maximum Limit (20 currencies)
- **From:** Show SnackBar when FAB tapped at limit
- **To:** Hide "+ Add Currency" card when limit reached
- Clear communication: No confusion about why button is missing

---

## 9. Platform & Navigation Considerations

### 9.1 Android Gesture Navigation (NEW)

**Safe Area Handling:**
- Bottom safe area padding: `MediaQuery.of(context).padding.bottom`
- Applied to:
  1. Bottom rate information section
  2. Delete bin positioning (ensure it doesn't overlap gesture area)

**Delete Bin Adjustment:**
- Bottom position: `20px + MediaQuery.of(context).padding.bottom`
- Ensures bin is always above gesture bar
- Centered horizontally for easy thumb access

**Implementation:**
```dart
Positioned(
  bottom: 20 + MediaQuery.of(context).padding.bottom,
  left: 0,
  right: 0,
  child: Center(
    child: DragTarget<String>(...), // Delete bin
  ),
)
```

### 9.2 iOS Considerations
- Honor home indicator safe area
- Same safe area padding approach works for both platforms
- Test on notched devices (iPhone X and later)

---

## 10. Color Palette & Typography

### 10.1 Color Scheme (Light Mode Only)

**Primary Colors:**
- **Primary:** Blue (#2196F3) - Currency code, action buttons
- **Background:** White (#FFFFFF)
- **Surface:** White (#FFFFFF) - Card backgrounds
- **Error:** Red (#EF5350) - Delete bin

**Text Colors:**
- **Primary Text:** Grey[900] / Black[87%]
- **Secondary Text:** Grey[700] - Instructions
- **Tertiary Text:** Grey[600] - Last updated
- **Quaternary Text:** Grey[500] - Exchange rates
- **Input Text:** Black - Amount inputs

**Interactive Elements:**
- **Drag Handle:** Grey[400]
- **Add Button:** Blue (primary)
- **Borders:** Grey[300]
- **Card Shadow:** Black[12%]

### 10.2 Typography

**App Bar Title:**
- Font: System default
- Size: 20px
- Weight: 500 (Medium)

**Instructions:**
- Font: System default
- Size: titleMedium (16px)
- Color: Grey[700]

**Currency Code:**
- Font: System default
- Size: 18px
- Weight: Bold
- Color: Blue

**Amount Input:**
- Font: System default (or consider tabular numbers for alignment)
- Size: 24px
- Weight: 500

**Bottom Section:**
- Last Updated: bodySmall, Grey[600], 500 weight
- Exchange Rates: bodySmall (11px), Grey[500]

**Add Currency Card:**
- Font: System default
- Size: 16px
- Weight: 500

---

## 11. Spacing & Layout Metrics

### 11.1 Spacing (Current - Maintain)
- Top margin after AppBar: 20px
- Bottom margin after instructions: 20px
- Card horizontal margin: 16px (from screen edge)
- Card bottom margin: 12px (between cards)
- Card internal padding: 12px horizontal, 6px vertical
- Element spacing within card: 8-12px

### 11.2 Responsive Behavior
- Full-width cards with 16px margin
- No maximum width constraint
- Scales naturally on tablets
- Maintain touch target sizes (minimum 48x48dp)

---

## 12. Animations & Transitions

### 12.1 List Reordering
- **Drop Preview:** 200ms, `Curves.easeInOut`
- **Item Sliding:** Implicit animations in ReorderableListView
- **Gap Creation:** Smooth expansion/collapse as item drags over

### 12.2 Delete Bin
- **Appearance:** Fade in + scale up when drag starts (200ms)
- **Hover State:** Color/size change (200ms)
- **Disappearance:** Fade out when drag ends (200ms)

### 12.3 Card States
- **Dragging Feedback:** Instant opacity change
- **Drop Animation:** 200ms settling animation

### 12.4 Refresh Button
- **Loading State:** Rotate icon continuously (500ms per rotation)
- **Success:** Brief checkmark overlay (optional)
- **Error:** Brief shake animation (optional)

---

## 13. Haptic Feedback

### 13.1 Implemented Feedback
**Drag Start:** (NEW)
- Trigger: When long-press initiates drag
- Type: `HapticFeedback.mediumImpact()`
- Purpose: Confirms drag has begun

### 13.2 Not Implemented
- No haptic on delete hover (user preference)
- No haptic on drop completion (keep it simple)

---

## 14. Accessibility

### 14.1 Touch Targets
- Minimum size: 48x48dp for all interactive elements
- Currency cards: Full height is tappable for drag
- Delete bin: 60x60px (exceeds minimum)
- Refresh button: Adequate padding

### 14.2 Screen Reader Support
- Semantic labels for all interactive elements
- Announce drag start/end
- Describe delete action
- Read currency and amount values

### 14.3 Visual Accessibility
- Sufficient color contrast ratios
- Don't rely solely on color for feedback
- Clear visual hierarchy
- Large enough text sizes

---

## 15. Implementation Checklist

### Phase 1: Core UX Improvements
- [ ] Add thousand separators to amount formatting
- [ ] Implement haptic feedback on drag start
- [ ] Add animated drop preview during reordering
- [ ] Move delete bin to bottom-center
- [ ] Add safe area padding to bottom section and delete bin

### Phase 2: Bottom Section Enhancements
- [ ] Add manual refresh button next to "Last updated"
- [ ] Implement refresh loading state (rotating icon)
- [ ] Add auto-retry logic for failed rate fetches
- [ ] Implement toast notifications for errors
- [ ] Ensure safe area padding on all platforms

### Phase 3: Add Currency Redesign
- [ ] Remove mini FAB
- [ ] Create "+ Add Currency" card component
- [ ] Add card to end of currency list
- [ ] Implement dashed border and styling
- [ ] Hide card when 20 currency limit reached

### Phase 4: Polish & Testing
- [ ] Test on Android devices with gesture navigation
- [ ] Test on iOS devices with notch/home indicator
- [ ] Verify thousand separator formatting across locales
- [ ] Test drag and drop on various screen sizes
- [ ] Verify haptic feedback works on physical devices
- [ ] Test auto-retry mechanism with network offline
- [ ] Validate all animations are smooth (60fps)

---

## 16. Design Rationale

### 16.1 Why Professional & Corporate Style?
- **Trust:** Financial apps benefit from refined, professional aesthetics
- **Clarity:** Structured layout improves data readability
- **Consistency:** Corporate style aligns with business/finance user expectations

### 16.2 Why UX Improvements Focus?
- **User Feedback:** Addressing practical usability issues
- **Interaction Clarity:** Better feedback mechanisms improve confidence
- **Error Handling:** Robust error recovery reduces frustration

### 16.3 Key UX Decisions

**Thousand Separators:**
- Improves readability of large numbers
- Standard in financial applications
- Reduces cognitive load

**Bottom-Center Delete Bin:**
- More accessible for one-handed use
- Centered position is ergonomic for both left and right thumbs
- Symmetrical layout feels more balanced

**+ Add Currency Card:**
- Discoverable: Always visible in the list
- Consistent: Same visual pattern as currency items
- Clear limitation: Disappears at max capacity

**Auto-Retry with Toast:**
- Non-blocking: User can continue working with stale rates
- Reassuring: Clear communication about what's happening
- Resilient: Automatically recovers from temporary issues

**Safe Area Padding:**
- Essential for modern Android gesture navigation
- Prevents accidental triggers of system gestures
- Future-proof for evolving navigation patterns

---

## 17. Future Considerations

### Potential Enhancements (Not in Current Scope)
- Dark mode support (if user needs change)
- Tablet-optimized multi-column layout
- Swipe-to-delete as alternative to drag-to-bin
- Favorites/pinning currencies to top
- Currency symbols next to amounts
- Historical rate charts
- Offline mode with cached rates
- Customizable base currency

---

## 18. Files to Modify

### Primary Files:
1. **`lib/screens/converter_screen.dart`**
   - Add haptic feedback on drag start
   - Move delete bin to bottom-center with safe area padding
   - Replace FAB with + Add Currency card
   - Add manual refresh button
   - Implement auto-retry error handling
   - Add toast notifications

2. **`lib/widgets/currency_input_field.dart`**
   - Implement thousand separator formatting
   - Update input formatters to handle formatted input
   - Maintain cursor position during format updates

3. **`lib/models/currency_converter.dart`** (if needed)
   - Add utility methods for number formatting with thousand separators
   - Parse formatted strings correctly

### New Files (if needed):
- **`lib/widgets/add_currency_card.dart`** - Separate widget for + Add Currency card
- **`lib/utils/number_formatter.dart`** - Utility for thousand separator formatting

### Configuration:
- **`pubspec.yaml`** - Ensure `intl` package is included for number formatting

---

## 19. Success Metrics

### How to Measure Success:
1. **Usability:**
   - Users can easily reorder currencies without confusion
   - Delete action is clear and accessible
   - Number formatting improves readability (user feedback)

2. **Reliability:**
   - App handles network errors gracefully
   - Auto-retry reduces manual intervention
   - Safe area padding eliminates navigation conflicts

3. **Visual Quality:**
   - Professional appearance meets expectations
   - Consistent styling across all components
   - Smooth animations (60fps)

4. **Accessibility:**
   - All interactive elements meet minimum touch target sizes
   - Safe areas properly honored on all devices
   - Screen reader compatibility maintained

---

## Conclusion

This specification provides a comprehensive blueprint for redesigning the Currency Exchange app UI with a focus on professional aesthetics and improved user experience. The changes are intentional, measurable, and aligned with user needs while maintaining the core functionality that works well.

**Next Steps:**
1. Review and approve this specification
2. Proceed with implementation following the checklist
3. Test on multiple devices and screen sizes
4. Gather user feedback and iterate

---

**Document Owner:** Design Team
**Technical Owner:** Development Team
**Last Updated:** December 11, 2025
