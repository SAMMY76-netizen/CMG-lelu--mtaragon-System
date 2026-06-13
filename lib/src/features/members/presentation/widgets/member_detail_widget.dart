import 'package:flutter/material.dart';
import '../../models/member_model.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

class MemberDetailWidget extends StatelessWidget {
  final MemberModel member;

  const MemberDetailWidget({
    Key? key,
    required this.member,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: member.photoUrl != null
                      ? NetworkImage(member.photoUrl!)
                      : null,
                  child: member.photoUrl == null
                      ? Text(
                          member.displayName.isNotEmpty
                              ? member.displayName[0].toUpperCase()
                              : 'M',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  member.displayName,
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    member.role.displayName,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: _getRoleColor(member.role),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Contact Information
          _SectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _DetailRow('Email', member.email),
          if (member.phoneNumber != null)
            _DetailRow('Phone', member.phoneNumber!),
          if (member.emergencyContact != null) ...
            [
              const SizedBox(height: 16),
              _SectionTitle('Emergency Contact'),
              const SizedBox(height: 12),
              _DetailRow('Contact Name', member.emergencyContact!),
              if (member.emergencyPhone != null)
                _DetailRow('Contact Phone', member.emergencyPhone!),
            ],
          // Address Information
          if (member.address != null || member.city != null) ...
            [
              const SizedBox(height: 16),
              _SectionTitle('Address'),
              const SizedBox(height: 12),
              if (member.address != null)
                _DetailRow('Street', member.address!),
              if (member.city != null)
                _DetailRow('City', member.city!),
              if (member.state != null)
                _DetailRow('State', member.state!),
              if (member.zipCode != null)
                _DetailRow('Zip Code', member.zipCode!),
            ],
          // Membership Information
          const SizedBox(height: 16),
          _SectionTitle('Membership Information'),
          const SizedBox(height: 12),
          _DetailRow('Status', member.membershipStatus),
          if (member.membershipDate != null)
            _DetailRow(
              'Member Since',
              member.membershipDate.toString().split(' ')[0],
            ),
          _DetailRow(
            'Joined',
            member.createdAt.toString().split(' ')[0],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleMedium,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
