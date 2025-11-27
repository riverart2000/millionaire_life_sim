import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/affirmation_model.dart';
import '../services/affirmations_service.dart';

final affirmationsServiceProvider = Provider<AffirmationsService>((ref) {
  return AffirmationsService();
});

final affirmationsLoadProvider = FutureProvider<void>((ref) async {
  final service = ref.read(affirmationsServiceProvider);
  await service.loadAffirmations();
});

final allAffirmationsProvider = Provider<List<AffirmationModel>>((ref) {
  ref.watch(affirmationsLoadProvider);
  final service = ref.read(affirmationsServiceProvider);
  return service.getAffirmations();
});

class AffirmationState {
  final AffirmationModel? currentAffirmation;
  final int currentBlankIndex;
  final List<String> userAnswers;
  final AffirmationProgress progress;

  const AffirmationState({
    this.currentAffirmation,
    this.currentBlankIndex = 0,
    this.userAnswers = const [],
    this.progress = const AffirmationProgress(),
  });

  AffirmationState copyWith({
    AffirmationModel? currentAffirmation,
    int? currentBlankIndex,
    List<String>? userAnswers,
    AffirmationProgress? progress,
  }) {
    return AffirmationState(
      currentAffirmation: currentAffirmation ?? this.currentAffirmation,
      currentBlankIndex: currentBlankIndex ?? this.currentBlankIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      progress: progress ?? this.progress,
    );
  }
}

class AffirmationNotifier extends Notifier<AffirmationState> {
  @override
  AffirmationState build() {
    return const AffirmationState();
  }

  void setCurrentAffirmation(AffirmationModel affirmation) {
    state = state.copyWith(
      currentAffirmation: affirmation,
      currentBlankIndex: 0,
      userAnswers: [],
    );
  }

  void addAnswer(String answer) {
    final newAnswers = [...state.userAnswers, answer];
    state = state.copyWith(
      userAnswers: newAnswers,
      currentBlankIndex: state.currentBlankIndex + 1,
    );
  }

  void markCompleted(String affirmationId) {
    final updatedCompleted = {...state.progress.completedIds};
    updatedCompleted[affirmationId] = true;
    
    final newProgress = state.progress.copyWith(
      completedIds: updatedCompleted,
      completedAffirmations: updatedCompleted.length,
      lastPracticeDate: DateTime.now(),
    );
    
    state = state.copyWith(progress: newProgress);
  }

  void setTotalAffirmations(int total) {
    final newProgress = state.progress.copyWith(totalAffirmations: total);
    state = state.copyWith(progress: newProgress);
  }

  void reset() {
    state = const AffirmationState();
  }

  void resetCurrentAffirmation() {
    state = state.copyWith(
      currentBlankIndex: 0,
      userAnswers: [],
    );
  }
}

final affirmationProvider = NotifierProvider<AffirmationNotifier, AffirmationState>(() {
  return AffirmationNotifier();
});
