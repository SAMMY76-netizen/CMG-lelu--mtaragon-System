import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../models/member_model.dart';
import '../../providers/members_providers.dart';
import '../widgets/member_card.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  String _searchQuery = '';
  UserRole? _selectedRole;
  UserStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: membersAsync.when(
        data: (members) {
          // Filter members
          var filteredMembers = members;

          if (_searchQuery.isNotEmpty) {
            filteredMembers = filteredMembers
                .where((member) =>
                    member.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    member.email.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
          }

          if (_selectedRole != null) {
            filteredMembers =
                filteredMembers.where((member) => member.role == _selectedRole).toList();
          }

          if (_selectedStatus != null) {
            filteredMembers =
                filteredMembers.where((member) => member.status == _selectedStatus).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search members...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Role filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: const Text('All Roles'),
                              selected: _selectedRole == null,
                              onSelected: (selected) {
                                setState(() => _selectedRole = null);
                              },
                            ),
                          ),
                          ...UserRole.values.map(
                            (role) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(role.displayName),
                                selected: _selectedRole == role,
                                onSelected: (selected) {
                                  setState(() => _selectedRole = selected ? role : null);
                                },
                              ),
                            ),
                          ),
                          // Status filter
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: const Text('All Status'),
                              selected: _selectedStatus == null,
                              onSelected: (selected) {
                                setState(() => _selectedStatus = null);
                              },
                            ),
                          ),
                          ...UserStatus.values.map(
                            (status) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(status.displayName),
                                selected: _selectedStatus == status,
                                onSelected: (selected) {
                                  setState(() => _selectedStatus = selected ? status : null);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredMembers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No members found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) {
                          final member = filteredMembers[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MemberCard(
                              member: member,
                              onTap: () {
                                context.push('/members/${member.id}');
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
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
