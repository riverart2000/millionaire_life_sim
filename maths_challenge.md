GOAL
Add a new "Adaptive Math Trainer" feature with:
- Math questions generated on the fly (no static list)
- Difficulty adapts to user performance (harder when correct, easier when wrong)
- Gamification: XP, player level, session streaks, daily streaks, stats
- Integration with the existing PLAY money JAR:
  - Correct answers: reward the user with money
  - Wrong answers: penalise the user by debiting some money (with safe clamping so balance never goes negative)

Please follow these requirements exactly and generate clean, production-ready code.

==================================================
1. FILE STRUCTURE
==================================================
Create the following files under lib/math_trainer/ (create the folder if needed):

- lib/math_trainer/math_user_state.dart
- lib/math_trainer/math_question_generator.dart
- lib/math_trainer/math_game_engine.dart
- lib/math_trainer/math_quiz_page.dart
- lib/math_trainer/math_result_page.dart

If needed, also add:
- lib/math_trainer/hive_adapters.dart (for registering Hive adapters)

Keep code modular and easy to test.

==================================================
2. HIVE USER STATE MODEL
==================================================
Create a Hive-backed user state model representing the math trainer user meta (NOT individual questions).

In math_user_state.dart:

- Define a @HiveType class MathUserState with:
  - @HiveField(0) int skillLevel;          // 1–10, initial 3
  - @HiveField(1) int correctStreak;       // in-session streak
  - @HiveField(2) int wrongStreak;         // in-session wrong streak
  - @HiveField(3) int xp;                  // accumulated XP for math trainer
  - @HiveField(4) int level;               // player level for math trainer
  - @HiveField(5) int dailyStreak;         // days in a row user has played
  - @HiveField(6) int longestDailyStreak;  // record streak
  - @HiveField(7) int highestSkillReached; // highest difficulty user reached

- Provide a constructor with sensible defaults:
  - skillLevel = 3
  - correctStreak = 0
  - wrongStreak = 0
  - xp = 0
  - level = 1
  - dailyStreak = 0
  - longestDailyStreak = 0
  - highestSkillReached = 3

- Make MathUserState extend HiveObject so we can call .save().
- Generate the *.g.dart file and register the adapter somewhere central (e.g. in main or hive_adapters.dart).

Also:
- Open a Hive box named "math_user_state".
- Store a single record under key "user". If not present, create a new MathUserState and put it there.

==================================================
3. QUESTION GENERATOR (ADAPTIVE)
==================================================
In math_question_generator.dart:

- Create a MathQuestion class with:
  - final String text;
  - final num correctAnswer;
  - final int difficulty;

- Implement a MathQuestionGenerator class with a Random instance and a method:
  - MathQuestion generate(int difficulty)

The generator should pick question types based on difficulty bands:

- difficulty 1–2:
  - single-digit addition / subtraction (0–10)
- difficulty 3–4:
  - two-digit addition / subtraction (10–99)
  - occasional 1-digit multiplication (2×–9×)
- difficulty 5–6:
  - two-digit multiplication (e.g. 12×7)
  - simple integer division with no remainder (e.g. 56 ÷ 7)
- difficulty 7–8:
  - two-step expressions like: a + b × c or (a + b) - c using integers
- difficulty 9–10:
  - slightly more complex expressions, but still solvable in-head or with short working

Implementation notes:
- Return MathQuestion with the expression as text and correctAnswer as a num.
- Keep it deterministic enough for testing but randomised for each question.

==================================================
4. INTEGRATE WITH EXISTING WALLET
==================================================
Assume there is already a wallet feature implemented using Hive.

- Create an abstraction in math_game_engine.dart:

  abstract class WalletRepository {
    int get balance;
    Future<void> credit(int amount);
    Future<void> debit(int amount);
  }

- Implement a concrete WalletRepository that wraps the existing wallet Hive box / model:
  - Read the balance from the existing wallet model.
  - credit(amount): increase the stored balance.
  - debit(amount): decrease the stored balance but never let it go below zero (clamp at 0).

Adapt this repository to the existing wallet structure instead of inventing a new wallet model.

==================================================
5. GAME ENGINE (ADAPTIVE + GAMIFIED + WALLET)
==================================================
In math_game_engine.dart:

- Create a MathGameEngine class with:

  - final MathQuestionGenerator generator;
  - final WalletRepository wallet;
  - final Box<MathUserState> stateBox;
  - late MathUserState user;

- In the constructor:
  - Load user from stateBox.get('user').
  - If null, create a new MathUserState and put it under 'user'.
  - Assign user and ensure it’s persisted.

- Implement:

  MathQuestion nextQuestion() {
    - Update user.highestSkillReached = max(current, skillLevel).
    - Save user.
    - Generate and return a MathQuestion based on user.skillLevel.
  }

  Future<bool> answer(MathQuestion question, num userAnswer) {
    - Compare userAnswer with question.correctAnswer.
    - If correct → call _onCorrect(question.difficulty)
    - If wrong → call _onWrong(question.difficulty)
    - Save user.
    - Return true/false depending on correctness.
  }

- Implement the adaptive difficulty logic:

  - On correct:
    - user.correctStreak += 1
    - user.wrongStreak = 0
    - If user.correctStreak >= 3:
      - user.skillLevel = min(user.skillLevel + 1, 10)
      - reset user.correctStreak to 0 OR keep it (choose the simpler logic and comment it)
  - On wrong:
    - user.wrongStreak += 1
    - user.correctStreak = 0
    - If user.wrongStreak >= 2:
      - user.skillLevel = max(user.skillLevel - 1, 1)
      - reset user.wrongStreak to 0

- Implement XP and level logic:

  - xpForAnswer(baseXp, correctStreak):
    - baseXp = 10 + question.difficulty
    - If correctStreak >= 10 → 3x multiplier
    - Else if correctStreak >= 5 → 2x
    - Else if correctStreak >= 3 → 1.5x
    - Else → 1x

  - addXp(int amount):
    - user.xp += amount
    - while user.xp >= xpNeededForLevel(user.level), increase user.level by 1
  - xpNeededForLevel(level):
    - simple formula: 100 + (level - 1) * 50

- Integrate the wallet:

  - On correct answer:
    - Reward the user by calling wallet.credit(rewardAmount)
    - Example: rewardAmount = 1 + (question.difficulty ~/ 2)
  - On wrong answer:
    - Penalise the user by calling wallet.debit(penaltyAmount)
    - Example: penaltyAmount = 1 (or slightly higher at higher difficulty)
    - Ensure WalletRepository.debit internally clamps balance to >= 0

==================================================
6. FLUTTER UI: QUIZ PAGE
==================================================
In math_quiz_page.dart:

- Create a StatefulWidget: MathQuizPage
  - Takes MathGameEngine as a dependency (inject via constructor or a provider).

- State fields:
  - MathQuestion? currentQuestion;
  - TextEditingController answerController;
  - bool? lastCorrect; // null at start
  - int questionsAnsweredInSession;
  - int correctInSession;

- On initState:
  - request a new question via engine.nextQuestion() and store in currentQuestion.

- UI layout (simple but responsive):
  - AppBar: "Math Trainer"
  - Body:
    - Show current skillLevel, XP, player level, and wallet balance at the top.
    - Show the current question.text in a big, clear font.
    - TextField or Number input for the user’s answer.
    - "Submit" button.
    - On submit:
      - Parse the user’s answer to num.
      - Call engine.answer(currentQuestion, userAnswer).
      - Update:
        - lastCorrect
        - questionsAnsweredInSession++
        - correctInSession if correct
      - Show immediate feedback (e.g. green check or red cross, plus a small text like “+15 XP, +2 coins” or “-1 coin”).
      - Then load the next question via engine.nextQuestion().

- When the user has answered e.g. 10–20 questions, show a "Finish Session" button that navigates to MathResultPage with the session stats.

==================================================
7. FLUTTER UI: RESULT PAGE
==================================================
In math_result_page.dart:

- Create a StatelessWidget: MathResultPage
  - Accepts:
    - int totalQuestions
    - int totalCorrect
    - MathUserState user (for latest xp, level, skill stats)
    - Maybe the wallet balance

- Display:
  - Accuracy = totalCorrect / totalQuestions
  - Highest skillLevel reached (from user.highestSkillReached)
  - XP gained this session (pass in or compute)
  - Current player level (user.level)
  - Current wallet balance
  - Daily streak and longestDailyStreak (you can add daily streak logic later; for now just show stored values)

- Add a "Play Again" button that pops back to MathQuizPage.

==================================================
8. INTEGRATION POINTS
==================================================
- Ensure Hive adapters for MathUserState are registered at app startup.
- Ensure WalletRepository is wired to the existing wallet box/model.
- Add navigation to MathQuizPage from whatever menu or dashboard exists (e.g. “Math Trainer” tile/button).
- Keep naming consistent and code idiomatic Dart/Flutter.

VERY IMPORTANT:
- Use null-safety and sound Dart.
- Keep logic pure where possible (no direct UI references inside the engine).
- Comment the core parts of the adaptive logic and wallet penalty/reward logic so it’s easy to tweak later.

Start by creating the models and engine, then wire up the UI pages, then hook into the navigation.

