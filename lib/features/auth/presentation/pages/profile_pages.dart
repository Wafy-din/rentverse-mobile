import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/common/colors/custom_color.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/auth/domain/usecase/logout_usecase.dart';
import 'package:rentverse/features/auth/presentation/screen/edit_profile_screen.dart';
import 'package:rentverse/common/bloc/auth/auth_cubit.dart';
import 'package:rentverse/features/auth/presentation/cubit/profile/cubit.dart';
import 'package:rentverse/features/auth/presentation/cubit/profile/state.dart';
import 'package:rentverse/features/auth/presentation/pages/trust_index_page.dart';
import 'package:rentverse/features/wallet/presentation/pages/my_wallet.dart';
import 'package:rentverse/features/disputes/presentation/pages/my_disputes_page.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rentverse/core/utils/pop_up_unauthorized.dart';
import 'package:rentverse/core/utils/image_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ProfileCubit(sl())..loadProfile(),
        child: const _ProfileView());
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.failure && state.statusCode == 401) {
          showUnauthorizedDialog(context);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
        // Check for Unauthorized (401)
        if (state.status == ProfileStatus.failure && state.statusCode == 401) {
          return const _ProfileSkeleton();
        }

        if (state.status == ProfileStatus.loading) {
          return const _ProfileSkeleton(); // Use skeleton for loading too, looks better? Or keep spinner? Use Skeleton as it matches "loading" generally. User said "unauthorized berbentuk skeleton", let's stick to that. But loading skeleton is nice. I'll stick to just 401 as requested.
          // Actually, usually "Skeleton Page" is used for loading.
          // User request: "kalau dia unauthorized berbentuk skeleton page"
          // Let's keep existing loading (CircularProgressIndicator) unless user asked to change it, to be precise.
          // But usually 401 isn't meaningful to show skeleton.
          // Maybe the user treating 401 as "Not logged in" or "Guest" view?
          // Wait, if I am unauthorized, I don't have data. So "Skeleton" implies "Data is missing/loading".
          // It makes sense.
        }

        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ProfileStatus.failure) {
          return Center(child: Text(state.errorMessage ?? 'Error'));
        }
        final user = state.user;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }

        final displayName = user.name?.isNotEmpty == true ? user.name! : 'User';
        final roleLabel = user.roles
                ?.map((r) => r.role?.name)
                .whereType<String>()
                .join(', ') ??
            '';

        return SafeArea(
            child: Stack(children: [
          Container(color: Colors.white),
          SizedBox(
              height: 260,
              width: double.infinity,
              child: const _HeaderBackground()),
          RefreshIndicator(
              onRefresh: () async {
                await context.read<ProfileCubit>().loadProfile();
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 140, 16, 24),
                  child: Column(children: [
                    _ProfileHeader(
                        name: displayName,
                        role: roleLabel,
                        avatarUrl: user.avatarUrl,
                        isVerified: user.isVerified),
                    const SizedBox(height: 20),
                    _ProfileMenuCard(items: [
                      _ProfileMenuItem(
                          icon: LucideIcons.edit,
                          label: 'Edit Profile',
                          badgeCount: 3,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const EditProfileScreen()));
                          }),
                      _ProfileMenuItem(
                          icon: LucideIcons.star,
                          label: 'Trust Index',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const TrustIndexPage()));
                          }),
                      _ProfileMenuItem(
                          icon: LucideIcons.fileText,
                          label: 'Disputes',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const MyDisputesPage()));
                          }),
                      _ProfileMenuItem(
                          icon: LucideIcons.wallet,
                          label: 'My Wallet',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const MyWalletPage()));
                          })
                    ]),
                    const SizedBox(height: 12),
                    _ProfileMenuCard(items: [
                      const _ProfileMenuItem(
                          icon: LucideIcons.bell, label: 'Notifications'),
                      const _ProfileMenuItem(
                          icon: LucideIcons.lock, label: 'Security'),
                      const _ProfileMenuItem(
                          icon: LucideIcons.globe, label: 'Language'),
                      _ProfileMenuItem(
                          icon: LucideIcons.logOut,
                          label: 'Logout',
                          iconColor: Colors.red,
                          valueColor: Colors.red,
                          onTap: () async {
                            await sl<LogoutUseCase>()();

                            context.read<AuthCubit>().checkAuthStatus();
                          })
                    ])
                  ])))
        ]));
      }),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      Container(color: Colors.white),
      SizedBox(
          height: 260,
          width: double.infinity,
          child: const _HeaderBackground()),
      RefreshIndicator(
          onRefresh: () async {
            await context.read<ProfileCubit>().loadProfile();
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 140, 16, 24),
              child: Column(children: [
                // Skeleton Header
                Column(children: [
                  Stack(children: [
                    CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 44, backgroundColor: Colors.grey.shade300)),
                  ]),
                  const SizedBox(height: 8),
                  Container(
                    height: 18,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ]),
                const SizedBox(height: 20),

                // Skeleton Menu 1
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      for (int i = 0; i < 4; i++) ...[
                        ListTile(
                          leading: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle)),
                          title: Container(
                              height: 14,
                              width: 100,
                              color: Colors.grey.shade300),
                          trailing: Icon(LucideIcons.chevronRight,
                              color: Colors.grey.shade300),
                        ),
                        if (i != 3)
                          Divider(height: 1, color: Colors.grey.shade200)
                      ]
                    ])),

                const SizedBox(height: 12),

                // Skeleton Menu 2 with real Logout
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      for (int i = 0; i < 3; i++) ...[
                        ListTile(
                          leading: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle)),
                          title: Container(
                              height: 14,
                              width: 100,
                              color: Colors.grey.shade300),
                          trailing: Icon(LucideIcons.chevronRight,
                              color: Colors.grey.shade300),
                        ),
                        Divider(height: 1, color: Colors.grey.shade200)
                      ],
                      // Real Logout Button
                      _ProfileMenuTile(
                          item: _ProfileMenuItem(
                              icon: LucideIcons.logOut,
                              label: 'Logout',
                              iconColor: Colors.red,
                              valueColor: Colors.red,
                              onTap: () async {
                                await sl<LogoutUseCase>()();
                                if (context.mounted) {
                                  context.read<AuthCubit>().checkAuthStatus();
                                }
                              }))
                    ])),
              ])))
    ]));
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      const Image(
          image: AssetImage('assets/background_profile.png'),
          fit: BoxFit.cover),
      Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              height: 48,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.8),
                    Colors.white
                  ]))))
    ]);
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String? avatarUrl;
  final bool isVerified;

  const _ProfileHeader({
    required this.name,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Column(children: [
        Stack(children: [
          CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                  radius: 44,
                  backgroundImage: avatarUrl != null
                      ? buildNetworkImageProvider(avatarUrl!)
                      : null,
                  child: avatarUrl == null
                      ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold))
                      : null)),
          Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(LucideIcons.edit,
                      size: 16, color: appSecondaryColor)))
        ]),
        const SizedBox(height: 8),
        Text(name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        if (role.isNotEmpty)
          Text(role,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 6),
        Row(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const EditProfileScreen()));

                if (context.mounted) {
                  final cubit = context.read<ProfileCubit>();
                  cubit.loadProfile();
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(LucideIcons.edit,
                      size: 14, color: appSecondaryColor))),
          const SizedBox(width: 8),
          Icon(isVerified ? LucideIcons.badgeCheck : LucideIcons.alertCircle,
              size: 14,
              color:
                  isVerified ? Colors.green.shade600 : Colors.orange.shade700),
          const SizedBox(width: 6),
          Text(isVerified ? 'Verified' : 'Not verified',
              style: TextStyle(
                  fontSize: 12,
                  color: isVerified
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  fontWeight: FontWeight.w600))
        ])
      ])
    ]);
  }
}

class _ProfileMenuCard extends StatelessWidget {
  final List<_ProfileMenuItem> items;

  const _ProfileMenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          for (int i = 0; i < items.length; i++) ...[
            _ProfileMenuTile(item: items[i]),
            if (i != items.length - 1)
              Divider(height: 1, color: Colors.grey.shade200)
          ]
        ]));
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final int? badgeCount;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.badgeCount,
    this.iconColor,
    this.valueColor,
    this.onTap,
  });
}

class _ProfileMenuTile extends StatelessWidget {
  final _ProfileMenuItem item;
  const _ProfileMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(item.icon, color: item.iconColor ?? appPrimaryColor),
        title: Text(item.label,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          if (item.badgeCount != null)
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: item.valueColor ?? Colors.red,
                    borderRadius: BorderRadius.circular(12)),
                child: Text('${item.badgeCount}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600))),
          Icon(LucideIcons.chevronRight, color: Colors.grey)
        ]),
        onTap: item.onTap);
  }
}
