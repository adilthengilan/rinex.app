import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ╔══════════════════════════════════════════════════════════════╗
// ║                      DESIGN TOKENS                          ║
// ╚══════════════════════════════════════════════════════════════╝
const kSkyBlue = Color(0xFF38BDF8);
const kSkyDark = Color(0xFF0EA5E9);
const kSkyDeep = Color(0xFF0284C7);
const kSkyDarkest = Color(0xFF0369A1);
const kSkyLight = Color(0xFFE0F2FE);
const kSkyPale = Color(0xFFF0F9FF);
const kWhite = Color(0xFFFFFFFF);
const kBg = Color(0xFFF8FBFF);
const kInk = Color(0xFF0C1A2E);
const kInkMid = Color(0xFF334155);
const kMuted = Color(0xFF94A3B8);
const kLine = Color(0xFFE2EEF7);
const kGreen = Color(0xFF10B981);
const kGreenLight = Color(0xFFD1FAE5);
const kAmber = Color(0xFFF59E0B);
const kAmberLight = Color(0xFFFEF3C7);
const kRose = Color(0xFFF43F5E);
const kRoseLight = Color(0xFFFFE4E6);

List<BoxShadow> elevate({
  double spread = 0,
  double blur = 20,
  double opacity = 0.08,
}) => [
  BoxShadow(
    color: kSkyDeep.withOpacity(opacity),
    blurRadius: blur,
    spreadRadius: spread,
    offset: const Offset(0, 6),
  ),
];

List<BoxShadow> floatShadow() => [
  BoxShadow(
    color: kSkyDeep.withOpacity(0.18),
    blurRadius: 32,
    offset: const Offset(0, 12),
  ),
  BoxShadow(
    color: kSkyBlue.withOpacity(0.08),
    blurRadius: 8,
    offset: const Offset(0, 2),
  ),
];

// ╔══════════════════════════════════════════════════════════════╗
// ║                        APP ROOT                             ║
// ╚══════════════════════════════════════════════════════════════╝

// ╔══════════════════════════════════════════════════════════════╗
// ║                      SHELL + NAV                            ║
// ╚══════════════════════════════════════════════════════════════╝
class TenantShell extends StatefulWidget {
  const TenantShell({super.key});
  @override
  State<TenantShell> createState() => _TenantShellState();
}

class _TenantShellState extends State<TenantShell> {
  int _idx = 0;

  final _screens = const [
    RentScreen(),
    MaintenanceScreen(),
    ComplaintsScreen(),
    MyPropertyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(index: _idx, children: _screens),
      bottomNavigationBar: _LuxNav(
        current: _idx,
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}

class _LuxNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _LuxNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (Icons.credit_card_rounded, Icons.credit_card_outlined, 'Rent'),
      (Icons.construction_rounded, Icons.construction_outlined, 'Maintain'),
      (
        Icons.mark_chat_read_rounded,
        Icons.mark_chat_unread_outlined,
        'Complaints',
      ),
      (Icons.apartment_rounded, Icons.apartment_outlined, 'My Place'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        border: Border(top: BorderSide(color: kLine, width: 1)),
        boxShadow: [
          BoxShadow(
            color: kSkyDeep.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final sel = i == current;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: sel ? 48 : 36,
                        height: sel ? 32 : 32,
                        decoration: BoxDecoration(
                          color: sel ? kSkyLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          sel ? tabs[i].$1 : tabs[i].$2,
                          color: sel ? kSkyDeep : kMuted,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tabs[i].$3,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? kSkyDeep : kMuted,
                          letterSpacing: sel ? 0.3 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║                    SHARED COMPONENTS                        ║
// ╚══════════════════════════════════════════════════════════════╝

/// Luxurious page header — gradient band with title + subtitle
class _PageHeader extends StatelessWidget {
  final String title, subtitle;
  final List<Widget>? actions;
  const _PageHeader({
    required this.title,
    required this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kSkyDarkest, kSkyDeep, kSkyDark, kSkyBlue],
          stops: [0.0, 0.35, 0.70, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (actions != null) Row(children: [const Spacer(), ...actions!]),
              if (actions != null) const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: kWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: kWhite.withOpacity(0.75),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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

/// Pill-style status tag
class _Tag extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Tag({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// White card with luxury shadow
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double radius;
  const _Card({
    required this.child,
    this.padding,
    this.onTap,
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: elevate(),
        ),
        padding: padding ?? const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}

Widget _sectionLabel(String text) => Padding(
  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: kInk,
      letterSpacing: 0.8,
    ),
  ),
);

// ╔══════════════════════════════════════════════════════════════╗
// ║                     1. RENT SCREEN                          ║
// ╚══════════════════════════════════════════════════════════════╝
class RentScreen extends StatefulWidget {
  const RentScreen({super.key});
  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  bool _paying = false;
  bool _paid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageHeader(
              title: 'Rent & Payments',
              subtitle: 'Skyline Apt · Unit 204',
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kWhite.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        color: kWhite,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Reminders On',
                        style: TextStyle(
                          color: kWhite.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Due Card ──────────────────────────────────────
                  _DueCard(paid: _paid, onPay: () => _openPaySheet()),

                  _sectionLabel('PAYMENT HISTORY'),
                  ..._rentRecords.map((r) => _RentHistoryRow(record: r)),

                  _sectionLabel('UPCOMING SCHEDULE'),
                  _UpcomingSchedule(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPaySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaySheet(
        onConfirm: () {
          Navigator.pop(context);
          setState(() => _paid = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: kWhite),
                  SizedBox(width: 10),
                  Text(
                    'Payment Successful! 🎉',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              backgroundColor: kGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}

class _DueCard extends StatelessWidget {
  final bool paid;
  final VoidCallback onPay;
  const _DueCard({required this.paid, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: paid
              ? [kGreen, const Color(0xFF059669)]
              : [kSkyDeep, kSkyDarkest],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: floatShadow(),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  paid ? '✓  PAID' : '⏰  DUE IN 5 DAYS',
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'April 2025',
                style: TextStyle(
                  color: kWhite.withOpacity(0.75),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '\$1,600',
            style: TextStyle(
              color: kWhite,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            paid ? 'Paid on Apr 3, 2025' : 'Due by April 15, 2025',
            style: TextStyle(color: kWhite.withOpacity(0.75), fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: paid ? null : onPay,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        paid ? '✓  Rent Paid' : 'Pay Now',
                        style: TextStyle(
                          color: paid ? kGreen : kSkyDeep,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kWhite.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: kWhite,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kWhite.withOpacity(0.3)),
                ),
                child: const Icon(Icons.share_rounded, color: kWhite, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RentHistoryRow extends StatelessWidget {
  final _RentRecord record;
  const _RentHistoryRow({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: elevate(opacity: 0.06, blur: 12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: record.paid ? kGreenLight : kRoseLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                record.paid ? Icons.check_rounded : Icons.close_rounded,
                color: record.paid ? kGreen : kRose,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.month,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: kInk,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    record.paid ? 'Paid · ${record.date}' : 'Overdue',
                    style: TextStyle(
                      color: record.paid ? kMuted : kRose,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${record.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: record.paid ? kInk : kRose,
                  ),
                ),
                _Tag(
                  label: record.paid ? 'Paid' : 'Overdue',
                  bg: record.paid ? kGreenLight : kRoseLight,
                  fg: record.paid ? kGreen : kRose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingSchedule extends StatelessWidget {
  final upcomingMonths = const [
    ('May 2025', 'Apr 28 — May 15'),
    ('June 2025', 'May 28 — Jun 15'),
    ('July 2025', 'Jun 28 — Jul 15'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: upcomingMonths.asMap().entries.map((e) {
          final isLast = e.key == upcomingMonths.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kSkyLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.event_rounded,
                      color: kSkyDeep,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.value.$1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: kInk,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          e.value.$2,
                          style: const TextStyle(color: kMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$1,600',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kSkyDeep,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
                  child: Row(
                    children: [Container(width: 1, height: 18, color: kLine)],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Pay Sheet ─────────────────────────────────────────────────
class _PaySheet extends StatefulWidget {
  final VoidCallback onConfirm;
  const _PaySheet({required this.onConfirm});
  @override
  State<_PaySheet> createState() => _PaySheetState();
}

class _PaySheetState extends State<_PaySheet> {
  int _selectedMethod = 0;

  final methods = [
    (Icons.credit_card_rounded, 'Visa •••• 4242', 'Credit Card'),
    (Icons.account_balance_rounded, 'HDFC Bank ••7890', 'Bank Transfer'),
    (Icons.phone_android_rounded, 'Google Pay', 'UPI'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kLine,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pay Rent',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: kInk,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'April 2025 · Skyline Apt Unit 204',
            style: TextStyle(color: kMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Amount display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kSkyPale,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kLine),
            ),
            child: Row(
              children: [
                const Text(
                  'Amount Due',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Text(
                  '\$1,600',
                  style: TextStyle(
                    color: kInk,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInkMid,
            ),
          ),
          const SizedBox(height: 10),
          ...methods.asMap().entries.map((e) {
            final sel = e.key == _selectedMethod;
            return GestureDetector(
              onTap: () => setState(() => _selectedMethod = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: sel ? kSkyLight : kWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: sel ? kSkyDark : kLine,
                    width: sel ? 1.5 : 1,
                  ),
                  boxShadow: sel ? elevate(opacity: 0.08) : [],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: sel ? kSkyDeep : kLine,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        e.value.$1,
                        color: sel ? kWhite : kMuted,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.value.$2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kInk,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            e.value.$3,
                            style: const TextStyle(color: kMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    if (sel)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: kSkyDeep,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: kSkyDeep,
                foregroundColor: kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Confirm Payment · \$1,600',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║                  2. MAINTENANCE SCREEN                      ║
// ╚══════════════════════════════════════════════════════════════╝
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});
  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final _requests = List<_MRequest>.from(_mockRequests);

  @override
  Widget build(BuildContext context) {
    final open = _requests.where((r) => r.status == MStatus.open).length;
    final progress = _requests
        .where((r) => r.status == MStatus.inProgress)
        .length;
    final done = _requests.where((r) => r.status == MStatus.resolved).length;

    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageHeader(
              title: 'Maintenance',
              subtitle: 'Request repairs & track progress',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _MiniStat(count: open, label: 'Open', color: kAmber),
                      const SizedBox(width: 10),
                      _MiniStat(
                        count: progress,
                        label: 'In Progress',
                        color: kSkyDeep,
                      ),
                      const SizedBox(width: 10),
                      _MiniStat(count: done, label: 'Resolved', color: kGreen),
                    ],
                  ),
                  _sectionLabel('YOUR REQUESTS'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _MaintenanceCard(request: _requests[i]),
                childCount: _requests.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewRequest(context),
        backgroundColor: kSkyDeep,
        foregroundColor: kWhite,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Request',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _openNewRequest(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewRequestSheet(
        onSubmit: (title, category, desc) {
          setState(() {
            _requests.insert(
              0,
              _MRequest(
                title: title,
                category: category,
                description: desc,
                status: MStatus.open,
                date: 'Just now',
                icon: _categoryIcon(category),
              ),
            );
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Request submitted!',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: kSkyDeep,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _MiniStat({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: elevate(opacity: 0.06),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: kMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final _MRequest request;
  const _MaintenanceCard({required this.request});

  Color get _statusColor => switch (request.status) {
    MStatus.open => kAmber,
    MStatus.inProgress => kSkyDeep,
    MStatus.resolved => kGreen,
  };

  Color get _statusBg => switch (request.status) {
    MStatus.open => kAmberLight,
    MStatus.inProgress => kSkyLight,
    MStatus.resolved => kGreenLight,
  };

  String get _statusLabel => switch (request.status) {
    MStatus.open => 'Open',
    MStatus.inProgress => 'In Progress',
    MStatus.resolved => 'Resolved',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: elevate(),
        border: Border(left: BorderSide(color: _statusColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kSkyLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(request.icon, color: kSkyDeep, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: kInk,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        request.category,
                        style: const TextStyle(color: kMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                _Tag(label: _statusLabel, bg: _statusBg, fg: _statusColor),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              request.description,
              style: const TextStyle(color: kInkMid, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 13, color: kMuted),
                const SizedBox(width: 4),
                Text(
                  request.date,
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
                if (request.status == MStatus.inProgress) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: kSkyLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Technician Assigned',
                      style: TextStyle(
                        color: kSkyDeep,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NewRequestSheet extends StatefulWidget {
  final void Function(String title, String category, String desc) onSubmit;
  const _NewRequestSheet({required this.onSubmit});
  @override
  State<_NewRequestSheet> createState() => _NewRequestSheetState();
}

class _NewRequestSheetState extends State<_NewRequestSheet> {
  int _catIdx = 0;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _categories = [
    (Icons.plumbing_rounded, 'Plumbing'),
    (Icons.electrical_services_rounded, 'Electrical'),
    (Icons.ac_unit_rounded, 'HVAC'),
    (Icons.format_paint_rounded, 'Painting'),
    (Icons.window_rounded, 'Windows'),
    (Icons.pest_control_rounded, 'Pest'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kLine,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'New Maintenance Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: kInk,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInkMid,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final sel = i == _catIdx;
                return GestureDetector(
                  onTap: () => setState(() => _catIdx = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 72,
                    decoration: BoxDecoration(
                      color: sel ? kSkyDeep : kSkyPale,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? kSkyDeep : kLine),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _categories[i].$1,
                          color: sel ? kWhite : kSkyDeep,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _categories[i].$2,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: sel ? kWhite : kSkyDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _LuxField(
            controller: _titleCtrl,
            hint: 'Brief title (e.g. Leaking pipe)',
            label: 'Issue Title',
          ),
          const SizedBox(height: 12),
          _LuxField(
            controller: _descCtrl,
            hint: 'Describe the problem in detail...',
            label: 'Description',
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) return;
                widget.onSubmit(
                  _titleCtrl.text.trim(),
                  _categories[_catIdx].$2,
                  _descCtrl.text.trim().isEmpty
                      ? 'No additional details provided.'
                      : _descCtrl.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSkyDeep,
                foregroundColor: kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Submit Request',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _LuxField({
  required TextEditingController controller,
  required String hint,
  required String label,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: kInkMid,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: kInk, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kMuted, fontSize: 14),
          filled: true,
          fillColor: kSkyPale,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kLine),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kSkyDeep, width: 1.5),
          ),
        ),
      ),
    ],
  );
}

// ╔══════════════════════════════════════════════════════════════╗
// ║                   3. COMPLAINTS SCREEN                      ║
// ╚══════════════════════════════════════════════════════════════╝
class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});
  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _complaints = List<_Complaint>.from(_mockComplaints);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageHeader(
              title: 'Complaints',
              subtitle: 'Raise issues directly with management',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ComplaintBanner(),
                  _sectionLabel('YOUR COMPLAINTS'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _complaints.isEmpty
                ? SliverToBoxAdapter(child: _EmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _ComplaintCard(complaint: _complaints[i]),
                      childCount: _complaints.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFileComplaint(context),
        backgroundColor: kRose,
        foregroundColor: kWhite,
        elevation: 4,
        icon: const Icon(Icons.edit_rounded),
        label: const Text(
          'File Complaint',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _openFileComplaint(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FileComplaintSheet(
        onSubmit: (title, type, desc) {
          setState(() {
            _complaints.insert(
              0,
              _Complaint(
                title: title,
                type: type,
                description: desc,
                status: CStatus.open,
                date: 'Just now',
              ),
            );
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Complaint submitted!',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: kRose,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}

class _ComplaintBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kRose.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kRose.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: kRose,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your complaints are private',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kInk,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Only you and property management can view these.',
                  style: TextStyle(color: kMuted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  final _Complaint complaint;
  const _ComplaintCard({required this.complaint});

  Color get _statusColor => switch (complaint.status) {
    CStatus.open => kRose,
    CStatus.inReview => kAmber,
    CStatus.resolved => kGreen,
  };

  Color get _statusBg => switch (complaint.status) {
    CStatus.open => kRoseLight,
    CStatus.inReview => kAmberLight,
    CStatus.resolved => kGreenLight,
  };

  String get _statusLabel => switch (complaint.status) {
    CStatus.open => 'Open',
    CStatus.inReview => 'In Review',
    CStatus.resolved => 'Resolved',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: elevate(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _complaintTypeIcon(complaint.type),
                    color: _statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: kInk,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _Tag(label: complaint.type, bg: kSkyLight, fg: kSkyDeep),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _Tag(label: _statusLabel, bg: _statusBg, fg: _statusColor),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                complaint.description,
                style: const TextStyle(
                  color: kInkMid,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 13, color: kMuted),
                const SizedBox(width: 4),
                Text(
                  complaint.date,
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
                if (complaint.status == CStatus.resolved) ...[
                  const Spacer(),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: kGreen,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Issue Resolved',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: kSkyLight, shape: BoxShape.circle),
            child: const Icon(
              Icons.sentiment_satisfied_rounded,
              color: kSkyDeep,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Complaints Yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kInk,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'File a complaint if you have any issues.',
            style: TextStyle(color: kMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _FileComplaintSheet extends StatefulWidget {
  final void Function(String title, String type, String desc) onSubmit;
  const _FileComplaintSheet({required this.onSubmit});
  @override
  State<_FileComplaintSheet> createState() => _FileComplaintSheetState();
}

class _FileComplaintSheetState extends State<_FileComplaintSheet> {
  int _typeIdx = 0;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _types = ['Noise', 'Safety', 'Cleanliness', 'Harassment', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kLine,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: kRoseLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_rounded, color: kRose, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'File a Complaint',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Type',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kInkMid,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _types.asMap().entries.map((e) {
              final sel = e.key == _typeIdx;
              return GestureDetector(
                onTap: () => setState(() => _typeIdx = e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? kRose : kRoseLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color: sel ? kWhite : kRose,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _LuxField(
            controller: _titleCtrl,
            hint: 'e.g. Loud music after midnight',
            label: 'Subject',
          ),
          const SizedBox(height: 12),
          _LuxField(
            controller: _descCtrl,
            hint: 'Explain what happened and when...',
            label: 'Details',
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) return;
                widget.onSubmit(
                  _titleCtrl.text.trim(),
                  _types[_typeIdx],
                  _descCtrl.text.trim().isEmpty
                      ? 'No additional details.'
                      : _descCtrl.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kRose,
                foregroundColor: kWhite,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Submit Complaint',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║                 4. MY PROPERTY SCREEN                       ║
// ╚══════════════════════════════════════════════════════════════╝
class MyPropertyScreen extends StatelessWidget {
  const MyPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _PageHeader(
              title: 'My Property',
              subtitle: 'Lease details & contacts',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Hero
                  _PropertyHero(),
                  _sectionLabel('PROPERTY DETAILS'),
                  _PropertyDetailsGrid(),
                  _sectionLabel('LEASE INFORMATION'),
                  _LeaseCard(),
                  _sectionLabel('CONTACTS'),
                  _ContactCard(
                    role: 'Property Agent',
                    name: 'Sarah Mitchell',
                    phone: '+1 (555) 234-5678',
                    email: 'sarah.m@realty.com',
                    avatar: 'SM',
                    avatarColor: kSkyDeep,
                  ),
                  const SizedBox(height: 10),
                  _ContactCard(
                    role: 'Landlord',
                    name: 'Robert Chen',
                    phone: '+1 (555) 876-5432',
                    email: 'r.chen@properties.com',
                    avatar: 'RC',
                    avatarColor: kSkyDarkest,
                  ),
                  _sectionLabel('DOCUMENTS'),
                  _DocumentsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kSkyDeep, kSkyBlue],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: floatShadow(),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhite.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhite.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: kWhite,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skyline Apartments',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                          ),
                          Text(
                            'Unit 204 · 2nd Floor',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: kWhite,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '204 Blue Ridge Ave, New York, NY 10001',
                      style: TextStyle(
                        color: kWhite.withOpacity(0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kWhite.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fiber_manual_record, color: kGreen, size: 10),
                      SizedBox(width: 6),
                      Text(
                        'Active Lease',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyDetailsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.king_bed_rounded, '2', 'Bedrooms'),
      (Icons.bathtub_rounded, '1', 'Bathrooms'),
      (Icons.square_foot_rounded, '850', 'Sq. Ft.'),
      (Icons.local_parking_rounded, '1 Spot', 'Parking'),
      (Icons.ac_unit_rounded, 'Central', 'AC/Heat'),
      (Icons.pets_rounded, 'Allowed', 'Pets'),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.05,
      children: items
          .map(
            (item) => Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(14),
                boxShadow: elevate(opacity: 0.06),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kSkyLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.$1, color: kSkyDeep, size: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kInk,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    item.$3,
                    style: const TextStyle(color: kMuted, fontSize: 10),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _LeaseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          _LeaseRow(
            'Start Date',
            'Jan 1, 2025',
            Icons.play_circle_outline_rounded,
          ),
          const Divider(color: kLine, height: 20),
          _LeaseRow('End Date', 'Dec 31, 2025', Icons.stop_circle_outlined),
          const Divider(color: kLine, height: 20),
          _LeaseRow('Monthly Rent', '\$1,600 / mo', Icons.attach_money_rounded),
          const Divider(color: kLine, height: 20),
          _LeaseRow('Security Deposit', '\$3,200', Icons.lock_outline_rounded),
          const Divider(color: kLine, height: 20),
          _LeaseRow(
            'Due Date',
            '15th of each month',
            Icons.event_available_rounded,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kSkyPale, kSkyLight]),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kLine),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: kSkyDeep, size: 18),
                const SizedBox(width: 8),
                const Text(
                  '273 days remaining on your lease',
                  style: TextStyle(
                    color: kSkyDeep,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaseRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _LeaseRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kSkyDeep),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: kMuted, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: kInk,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String role, name, phone, email, avatar;
  final Color avatarColor;
  const _ContactCard({
    required this.role,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: elevate(),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(
                  color: kWhite,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Tag(label: role, bg: kSkyLight, fg: kSkyDeep),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: kInk,
                    fontSize: 15,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _CircleAction(icon: Icons.phone_rounded, color: kGreen),
              const SizedBox(height: 8),
              _CircleAction(icon: Icons.chat_rounded, color: kSkyDeep),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _CircleAction({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _DocumentsList extends StatelessWidget {
  final docs = const [
    (Icons.description_rounded, 'Lease Agreement', 'PDF · 2.4 MB'),
    (Icons.receipt_rounded, 'Payment Receipts', 'PDF · Last updated Apr 3'),
    (Icons.home_work_rounded, 'Property Inventory', 'PDF · 1.8 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Column(
        children: docs.asMap().entries.map((e) {
          final isLast = e.key == docs.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kSkyLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(e.value.$1, color: kSkyDeep, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.value.$2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kInk,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            e.value.$3,
                            style: const TextStyle(color: kMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: kSkyLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: kSkyDeep,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(color: kLine, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║                      DATA MODELS                            ║
// ╚══════════════════════════════════════════════════════════════╝

// ── Rent ─────────────────────────────────────────────────────
class _RentRecord {
  final String month, date;
  final int amount;
  final bool paid;
  const _RentRecord({
    required this.month,
    required this.date,
    required this.amount,
    required this.paid,
  });
}

final _rentRecords = [
  const _RentRecord(
    month: 'March 2025',
    date: 'Mar 3, 2025',
    amount: 1600,
    paid: true,
  ),
  const _RentRecord(
    month: 'February 2025',
    date: 'Feb 5, 2025',
    amount: 1600,
    paid: true,
  ),
  const _RentRecord(
    month: 'January 2025',
    date: 'Jan 4, 2025',
    amount: 1600,
    paid: true,
  ),
  const _RentRecord(
    month: 'December 2024',
    date: '',
    amount: 1600,
    paid: false,
  ),
  const _RentRecord(
    month: 'November 2024',
    date: 'Nov 3, 2024',
    amount: 1600,
    paid: true,
  ),
];

// ── Maintenance ───────────────────────────────────────────────
enum MStatus { open, inProgress, resolved }

class _MRequest {
  final String title, category, description, date;
  final MStatus status;
  final IconData icon;
  const _MRequest({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.status,
    required this.icon,
  });
}

IconData _categoryIcon(String cat) => switch (cat) {
  'Plumbing' => Icons.plumbing_rounded,
  'Electrical' => Icons.electrical_services_rounded,
  'HVAC' => Icons.ac_unit_rounded,
  'Painting' => Icons.format_paint_rounded,
  'Windows' => Icons.window_rounded,
  _ => Icons.build_rounded,
};

final _mockRequests = [
  const _MRequest(
    title: 'Leaking Kitchen Faucet',
    category: 'Plumbing',
    description:
        'Kitchen faucet has been dripping constantly for 3 days causing water waste.',
    date: 'Mar 1, 2025',
    status: MStatus.inProgress,
    icon: Icons.plumbing_rounded,
  ),
  const _MRequest(
    title: 'AC Not Cooling Properly',
    category: 'HVAC',
    description:
        'The air conditioning unit runs but room temperature stays above 80°F.',
    date: 'Feb 26, 2025',
    status: MStatus.open,
    icon: Icons.ac_unit_rounded,
  ),
  const _MRequest(
    title: 'Broken Bedroom Window',
    category: 'Windows',
    description:
        'Window latch in the main bedroom is broken and won\'t lock securely.',
    date: 'Feb 10, 2025',
    status: MStatus.resolved,
    icon: Icons.window_rounded,
  ),
];

// ── Complaints ────────────────────────────────────────────────
enum CStatus { open, inReview, resolved }

class _Complaint {
  final String title, type, description, date;
  final CStatus status;
  const _Complaint({
    required this.title,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
  });
}

IconData _complaintTypeIcon(String type) => switch (type) {
  'Noise' => Icons.volume_up_rounded,
  'Safety' => Icons.security_rounded,
  'Cleanliness' => Icons.cleaning_services_rounded,
  'Harassment' => Icons.report_rounded,
  _ => Icons.chat_bubble_rounded,
};

final _mockComplaints = [
  const _Complaint(
    title: 'Loud Neighbors — Late Night',
    type: 'Noise',
    description:
        'Upstairs neighbors consistently play loud music after midnight, making it impossible to sleep.',
    date: 'Mar 2, 2025',
    status: CStatus.inReview,
  ),
  const _Complaint(
    title: 'Hallway Lighting Out',
    type: 'Safety',
    description:
        'The hallway between units 202–206 has had no lighting for over a week. It\'s a safety hazard.',
    date: 'Feb 14, 2025',
    status: CStatus.resolved,
  ),
];
