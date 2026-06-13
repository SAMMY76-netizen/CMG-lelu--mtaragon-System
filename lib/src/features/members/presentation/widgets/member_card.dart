import 'package:flutter/material.dart';
import '../../models/member_model.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  final VoidCallback onTap;

  const MemberCard({
    Key? key,
    required this.member,
    required this.onTap,
  }) : super(key: key);

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.adminColor;
      case UserRole.treasurer:
        return AppColors.treasurerColor;
      case UserRole.secretary:
        return AppColors.secretaryColor;
      case UserRole.member:
        return AppColors.memberColor;
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.successColor;
      case UserStatus.inactive:
        return AppColors.warningColor;
      case UserStatus.suspended:
        return AppColors.errorColor;
      case UserStatus.deleted:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: member.photoUrl != null
                        ? NetworkImage(member.photoUrl!)
                        : null,
                    child: member.photoUrl == null
                        ? Text(
                            member.displayName.isNotEmpty
                                ? member.displayName[0].toUpperCase()
                                : 'M',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.displayName,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          member.email,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(
                      member.role.displayName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getRoleColor(member.role),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      member.membershipStatus,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getStatusColor(member.status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
