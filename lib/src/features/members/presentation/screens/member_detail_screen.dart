import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../models/member_model.dart';
import '../../providers/members_providers.dart';
import '../widgets/member_detail_widget.dart';

class MemberDetailScreen extends ConsumerWidget {
  final String memberId;

  const MemberDetailScreen({
    Key? key,
    required this.memberId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberStreamProvider(memberId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
      ),
      body: memberAsync.when(
        data: (member) {
          if (member == null) {
            return Center(
              child: Text(
                'Member not found',
                style: AppTextStyles.titleMedium,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: MemberDetailWidget(member: member),
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
