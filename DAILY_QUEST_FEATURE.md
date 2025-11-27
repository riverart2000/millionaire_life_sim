# Daily Affirmation Quest Feature

## Overview
The Daily Affirmation Quest is a gamification feature that encourages users to practice positive affirmations daily by presenting them with a random affirmation challenge before they can perform certain key actions in the app.

## Implementation Details

### 1. Data Model Updates
**File:** `lib/models/affirmation_model.dart`

Added three new fields to `AffirmationProgress`:
- `dailyStreak`: Tracks consecutive days of quest completion
- `lastQuestDate`: Records the last time a quest was completed
- `todayQuestCompleted`: Boolean flag for today's completion status

### 2. Provider Methods
**File:** `lib/providers/affirmations_provider.dart`

#### `completeDailyQuest()`
- Records quest completion for the current day
- Calculates and updates the daily streak:
  - Continues streak if completed yesterday
  - Starts new streak (1 day) if not consecutive
  - Preserves existing streak if completed earlier today
- Updates `lastQuestDate` and `todayQuestCompleted`

#### `shouldShowDailyQuest()`
- Returns `true` if quest hasn't been completed today
- Returns `false` if already completed today
- Compares dates at day-level granularity (ignores time)

### 3. Quest Dialog Widget
**File:** `lib/widgets/daily_affirmation_quest_dialog.dart`

Features:
- **Random Affirmation Selection**: Shows one random MMI affirmation per day
- **Inline Input**: Fill-in-the-blank with TextField directly in text flow
- **Auto-Focus**: Automatically moves cursor to next blank on correct answer
- **Progress Tracking**: Shows completion percentage and progress bar
- **Fireworks Celebration**: Confetti animation on successful completion
- **Streak Display**: Badge showing current daily streak count
- **Skip Option**: TextButton to skip the quest if needed
- **Auto-Close**: Dialog closes automatically after completion
- **Callback Execution**: Calls `onComplete()` callback to proceed with original action

Widget accepts:
- `actionName`: String describing what action triggered the quest (e.g., "Simulate Next Day")
- `onComplete`: Callback function to execute after quest completion

### 4. Integration Points

#### Simulate Next Day Button
**File:** `lib/views/dashboard/dashboard_view.dart` (`_NextDayButton` class)

Before executing day simulation:
1. Checks `shouldShowDailyQuest()`
2. If `true`, shows `DailyAffirmationQuestDialog` with `actionName: 'Simulate Next Day'`
3. Quest completion triggers `completeDailyQuest()` and then `_executeSimulation()`
4. If `false`, executes simulation directly without quest

#### Regenerate Money Button
**File:** `lib/widgets/money_drag_drop.dart` (`MoneyDragDropWidget` class)

Implementation:
- Added optional `onRegenerateRequested` callback parameter of type `Future<bool> Function()?`
- Callback returns `true` to allow regeneration, `false` to cancel
- Dashboard passes callback that:
  1. Checks `shouldShowDailyQuest()`
  2. Shows quest dialog if needed
  3. Returns `true` after quest completion to allow regeneration

**File:** `lib/views/dashboard/dashboard_view.dart` (`_DragDropAllocationWidget` class)

Passes `onRegenerateRequested` callback to `MoneyDragDropWidget`:
```dart
onRegenerateRequested: () async {
  final shouldShow = ref.read(affirmationProvider.notifier).shouldShowDailyQuest();
  if (shouldShow) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DailyAffirmationQuestDialog(
        actionName: 'Regenerate Money',
        onComplete: () { },
      ),
    );
    return true; // Quest completed, allow regeneration
  }
  return true; // No quest needed, allow regeneration
},
```

### 5. User Experience Flow

1. **First Quest of the Day**:
   - User clicks "Simulate Next Day" or "Regenerate Money" button
   - Quest dialog appears with a random affirmation
   - User fills in the blanks correctly
   - Fireworks celebration plays
   - Dialog auto-closes
   - Original action executes (day simulates or money regenerates)
   - Daily streak increments by 1

2. **Subsequent Actions Same Day**:
   - Quest dialog doesn't appear
   - Actions execute immediately
   - No additional affirmations required until next day

3. **Streak Tracking**:
   - Badge shows "🔥 X day streak"
   - Consecutive daily completions increase streak
   - Missing a day resets streak to 1 on next completion
   - Streak persists across app sessions

4. **Skip Option**:
   - User can click "Skip for Now" button
   - Quest marked as complete for the day
   - Streak resets to 0
   - Original action proceeds

## Technical Notes

### Date Comparison Logic
```dart
final now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
final lastQuest = state.progress.lastQuestDate;
final lastQuestDay = lastQuest != null 
    ? DateTime(lastQuest.year, lastQuest.month, lastQuest.day)
    : null;
```

This ensures day-level comparison ignoring hours/minutes/seconds.

### Streak Calculation
```dart
// Check if streak continues (completed yesterday)
final yesterday = today.subtract(const Duration(days: 1));
if (lastQuestDay != null && lastQuestDay.isAtSameMomentAs(yesterday)) {
  newStreak += 1; // Continue streak
} else if (lastQuestDay == null || !lastQuestDay.isAtSameMomentAs(today)) {
  newStreak = 1; // Start new streak
}
```

### Freezed Code Generation
After modifying `affirmation_model.dart`, regenerate freezed files:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Future Enhancements
Potential improvements for future iterations:

1. **Streak Rewards**: Grant in-game currency bonuses for milestone streaks (7, 30, 100 days)
2. **Quest Variety**: Multiple quest types beyond fill-in-the-blank (matching, ordering, etc.)
3. **Streak Freeze**: Allow users to maintain streak with a "freeze" power-up
4. **Social Sharing**: Share streak achievements on social media
5. **Analytics Dashboard**: Track quest completion rates, average streaks, most skipped affirmations
6. **Customization**: Let users choose quest difficulty or affirmation categories
7. **Reminders**: Push notifications for users who haven't completed daily quest
8. **Leaderboard**: Compare streaks with friends or global community
