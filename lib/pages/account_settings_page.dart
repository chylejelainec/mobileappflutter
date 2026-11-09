import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState
    extends State<AccountSettingsPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool loading = false;
  bool hideCurrentPassword = true;
  bool hideNewPassword = true;

  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) return;

    final currentPassword =
        currentPasswordController.text;

    final newPassword = newPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both password fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'New password must be at least 6 characters.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (currentPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'New password must be different from current password.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      currentPasswordController.clear();
      newPasswordController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Password update failed.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1976D2);
    const darkText = Color(0xFF172B4D);
    const secondaryText = Color(0xFF64748B);

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F1FF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.account_circle_rounded,
                        color: blue,
                        size: 52,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Center(
                    child: Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      user?.email ?? 'Unknown Account',
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFE6EDF5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Current Password',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: currentPasswordController,
                          obscureText: hideCurrentPassword,
                          decoration: InputDecoration(
                            hintText: 'Enter current password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideCurrentPassword =
                                      !hideCurrentPassword;
                                });
                              },
                              icon: Icon(
                                hideCurrentPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 9),

                        TextField(
                          controller: newPasswordController,
                          obscureText: hideNewPassword,
                          decoration: InputDecoration(
                            hintText: 'Enter new password',
                            prefixIcon: const Icon(
                              Icons.lock_reset_rounded,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideNewPassword =
                                      !hideNewPassword;
                                });
                              },
                              icon: Icon(
                                hideNewPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                loading ? null : changePassword,
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Update Password'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        side: const BorderSide(
                          color: Color(0xFFF0CACA),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
