import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/course_model.dart';
import '../../models/jar_model.dart';
import '../../providers/courses_provider.dart';
import '../../providers/data_providers.dart';
import '../../providers/session_providers.dart';
import '../../providers/bootstrap_provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/result.dart';
import '../../widgets/course_quiz_dialog.dart';

class CoursesView extends ConsumerStatefulWidget {
  const CoursesView({super.key});

  @override
  ConsumerState<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends ConsumerState<CoursesView> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allCourses = ref.watch(allCoursesProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allCoursesProvider);
        ref.invalidate(userProfileProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Education Center',
            style: Responsive.scaleTextStyle(context, theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Text(
            'Invest in yourself to boost your earning potential. Each course increases your mindset multiplier.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),

          // Course Progress Bar
          profileAsync.when(
            data: (profile) {
              final completedCount = profile?.purchasedCourses.length ?? 0;
              final totalCount = allCourses.length;
              final progress = totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            height: 6,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                  theme.colorScheme.tertiary,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),

          // Stats Card
          profileAsync.when(
            data: (profile) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: _StatItem(
                        icon: Icons.psychology,
                        label: 'Mindset Level',
                        value: '${profile?.mindsetLevel.toStringAsFixed(1)}x',
                        color: Colors.purple,
                      ),
                    ),
                    Flexible(
                      child: _StatItem(
                        icon: Icons.school_outlined,
                        label: 'Courses Completed',
                        value: '${profile?.purchasedCourses.length ?? 0}',
                        color: Colors.blue,
                      ),
                    ),
                    Flexible(
                      child: _StatItem(
                        icon: Icons.account_balance_wallet,
                        label: 'EDU Jar Balance',
                        value: '',
                        color: Colors.green,
                        child: _EduBalance(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),

          // Category Filters
          Builder(
            builder: (context) {
              final categories = ref.watch(categoriesProvider);
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('All Courses'),
                            selected: _selectedCategory == null,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = null);
                            },
                          ),
                          ...categories.map((category) => FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = selected ? category : null);
                            },
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Courses Grid
          profileAsync.when(
            data: (profile) {
              final purchasedIds = profile?.purchasedCourses ?? [];
              
              // Filter courses by category
              final List<Course> filteredCourses;
              if (_selectedCategory == null) {
                filteredCourses = allCourses;
              } else {
                filteredCourses = allCourses.where((c) => c.category == _selectedCategory).toList();
              }
              
              final availableCourses = filteredCourses
                  .where((course) => !purchasedIds.contains(course.id))
                  .toList();
              
              final purchasedCourses = filteredCourses
                  .where((course) => purchasedIds.contains(course.id))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Courses
                  if (availableCourses.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available Courses',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text('${availableCourses.length} courses'),
                                  backgroundColor: Colors.blue.shade100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...availableCourses.map((course) => 
                              _CourseCard(course: course, isPurchased: false)
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Purchased Courses
                  if (purchasedCourses.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Completed Courses',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Chip(
                                  label: Text('${purchasedCourses.length} completed'),
                                  backgroundColor: Colors.green.shade100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...purchasedCourses.map((course) => 
                              _CourseCard(course: course, isPurchased: true)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (availableCourses.isEmpty && purchasedCourses.isEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No courses found in this category',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Error loading courses: $error',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.child,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        child ?? Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _EduBalance extends ConsumerWidget {
  const _EduBalance();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jarsAsync = ref.watch(jarsProvider);
    
    return jarsAsync.when(
      data: (jars) {
        final eduJar = jars.firstWhere(
          (jar) => jar.id.toUpperCase() == 'EDU',
          orElse: () => jars.first,
        );
        return Text(
          CurrencyFormatter.format(eduJar.balance),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        );
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => Text(
        '£0.00',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}

class _CourseCard extends ConsumerWidget {
  const _CourseCard({
    required this.course,
    required this.isPurchased,
  });

  final Course course;
  final bool isPurchased;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isPurchased ? 0 : 1,
      color: isPurchased ? Colors.grey.shade100 : null,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isPurchased ? Colors.grey.shade300 : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(course.category),
            color: isPurchased ? Colors.grey.shade600 : theme.colorScheme.primary,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                course.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: isPurchased ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (isPurchased)
              Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(course.description),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(course.category),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text('+${(course.mindsetIncrease * 100).toStringAsFixed(0)}% Mindset'),
                  backgroundColor: Colors.purple.shade50,
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                ),
                Chip(
                  label: Text(course.duration),
                  backgroundColor: Colors.orange.shade50,
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
        trailing: isPurchased
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(course.cost),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FilledButton.icon(
                    onPressed: () => _purchaseCourse(context, ref, course),
                    icon: const Icon(Icons.shopping_cart, size: 16),
                    label: const Text('Enroll'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'investment':
        return Icons.trending_up;
      case 'business':
        return Icons.business_center;
      case 'marketing':
        return Icons.campaign;
      case 'finance':
        return Icons.account_balance;
      case 'mindset':
        return Icons.psychology;
      case 'leadership':
        return Icons.groups;
      case 'technology':
        return Icons.computer;
      case 'sales':
        return Icons.handshake;
      default:
        return Icons.school;
    }
  }

  Future<void> _purchaseCourse(BuildContext context, WidgetRef ref, Course course) async {
    // First, check balance before showing anything
    final userId = ref.read(userIdProvider);
    final jarsAsync = await ref.read(jarsProvider.future);
    final eduJar = jarsAsync.firstWhere(
      (jar) => jar.id.toUpperCase() == 'EDU',
      orElse: () => jarsAsync.first,
    );

    // Check if sufficient balance
    if (eduJar.balance < course.cost) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Not enough yet! Work harder, smarter, longer. Build your EDU jar to ${CurrencyFormatter.format(course.cost)} to unlock this course.'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enroll in ${course.title}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost: ${CurrencyFormatter.format(course.cost)}'),
            const SizedBox(height: 8),
            Text('Mindset Increase: +${(course.mindsetIncrease * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 8),
            Text('Duration: ${course.duration}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.quiz_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'ll need to pass a quiz to complete this course!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will be deducted from your EDU jar balance.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Start Course'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Load quiz questions
    final questionService = ref.read(courseQuestionServiceProvider);
    final quiz = await questionService.loadCourseQuestions(course.id);
    
    if (quiz == null || quiz.questions.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Quiz not available for this course yet. Coming soon!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Show quiz dialog
    bool quizCompleted = false;
    if (context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CourseQuizDialog(
          quiz: quiz,
          courseTitle: course.title,
          onComplete: () {
            quizCompleted = true;
          },
        ),
      );
    }

    if (!quizCompleted || !context.mounted) return;

    final jarService = ref.read(jarServiceProvider);
    final userRepo = ref.read(userRepositoryProvider);

    // Withdraw from EDU jar
    final withdrawResult = await jarService.withdraw(
      userId: userId,
      jarId: eduJar.id,
      amount: course.cost,
      description: 'Purchased course: ${course.title}',
    );

    if (withdrawResult is Failure<Jar>) {
      if (context.mounted) {
        final message = withdrawResult.exception.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.contains('Insufficient') 
              ? 'Not enough yet! Keep building your EDU jar to invest in your education.'
              : message.replaceFirst('Exception: ', '')),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    // Get current profile
    final profileAsync = await ref.read(userProfileProvider.future);
    if (profileAsync == null) return;

    // Update profile with purchased course and increased mindset
    final updatedProfile = profileAsync.copyWith(
      purchasedCourses: [...profileAsync.purchasedCourses, course.id],
      mindsetLevel: profileAsync.mindsetLevel + course.mindsetIncrease,
    );

    try {
      await userRepo.saveProfile(updatedProfile);
      
      // Refresh providers
      ref.invalidate(userProfileProvider);
      ref.invalidate(jarsProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Successfully enrolled in ${course.title}! Mindset increased to ${updatedProfile.mindsetLevel.toStringAsFixed(1)}x'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
