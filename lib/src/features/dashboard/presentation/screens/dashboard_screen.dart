import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../authentication/models/user_model.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../../members/models/member_model.dart';
import '../../../members/providers/members_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final membersAsync = ref.watch(membersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(signOutProvider.future);
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (currentUser) {
          if (currentUser == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return membersAsync.when(
            data: (members) {
              // Calculate statistics
              final totalMembers = members.length;
              final activeMembers = members.where((m) => m.isActive).length;
              final adminCount = members.where((m) => m.isAdmin).length;
              final treasurerCount = members.where((m) => m.isTreasurer).length;
              final secretaryCount = members.where((m) => m.isSecretary).length;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, ${currentUser.displayName}!',
                                style: AppTextStyles.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Role: ${currentUser.role.displayName}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Statistics section
                      Text(
                        'Statistics',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _StatCard(
                            title: 'Total Members',
                            value: totalMembers.toString(),
                            icon: Icons.people,
                            color: AppColors.primaryColor,
                          ),
                          _StatCard(
                            title: 'Active',
                            value: activeMembers.toString(),
                            icon: Icons.check_circle,
                            color: AppColors.successColor,
                          ),
                          _StatCard(
                            title: 'Admins',
                            value: adminCount.toString(),
                            icon: Icons.admin_panel_settings,
                            color: AppColors.adminColor,
                          ),
                          _StatCard(
                            title: 'Treasurers',
                            value: treasurerCount.toString(),
                            icon: Icons.account_balance_wallet,
                            color: AppColors.treasurerColor,
                          ),
                          _StatCard(
                            title: 'Secretaries',
                            value: secretaryCount.toString(),
                            icon: Icons.assignment,
                            color: AppColors.secretaryColor,
                          ),
                          _StatCard(
                            title: 'Regular Members',
                            value: (totalMembers - adminCount - treasurerCount - secretaryCount).toString(),
                            icon: Icons.person,
                            color: AppColors.memberColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Quick actions section
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('Manage Members'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          context.push('/members');
                        },
                      ),
                      const SizedBox(height: 16),
                      // Recent members section
                      Text(
                        'Recent Members',
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (members.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No members yet',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      else
                        ...members.take(5).map(
                          (member) => ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                member.displayName.isNotEmpty
                                    ? member.displayName[0].toUpperCase()
                                    : 'M',
                              ),
                            ),
                            title: Text(member.displayName),
                            subtitle: Text(member.role.displayName),
                            onTap: () {
                              context.push('/members/${member.id}');
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
