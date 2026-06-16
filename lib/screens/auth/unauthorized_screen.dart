import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authBlocs/user_changed_bloc.dart';
import '../../bloc/authBlocs/user_logout_bloc.dart';
import '../../reusable/loader.dart';

class UnAuthorizedScreen extends StatelessWidget {
  const UnAuthorizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<UserLogoutBloc, UserLogoutState>(
      builder: (context, uls) {
        if (uls is UserLogoutSuccess) {
          context.read<UserAuthChangesBloc>().add(StartUserChangeListener());
        }
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: uls is UserLogoutProgress
                  ? LoaderContainerWithMessage(message: "Logging Out..")
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline, size: 84, color: theme.colorScheme.primary),
                            const SizedBox(height: 18),
                            Text('Access denied', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            Text(
                              "You are not authorized to access this resource. Please login with an account that has the required permissions.",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<UserLogoutBloc>().add(UserLogoutListener(context: context));
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text('Logout'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(140, 44),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Need help?'),
                                        content: const Text('Contact your administrator or support team if you believe this is an error.'),
                                        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.help_outline),
                                  label: const Text('Help'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(120, 44),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
