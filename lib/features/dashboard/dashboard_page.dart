import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../theme/clay_colors.dart';
import '../../widgets/clay_card.dart';
import '../../widgets/clay_fade_slide.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.watch<TransactionProvider>();

    if (tx.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tx.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text('Gagal memuat data: ${tx.error}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => tx.loadTransactions(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    final todayTotal = tx.todayTotal;
    final monthTotal = tx.monthTotal;
    final last7Days = tx.last7Days;
    final transactions = tx.transactions;
    final has7DaysData = last7Days.any((e) => e.value > 0);

    return RefreshIndicator(
      onRefresh: () => tx.loadTransactions(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Summary Cards ──
          Row(
            children: [
              Expanded(
                child: ClayFadeSlide(
                  index: 0,
                  child: _StatCard(
                    icon: Icons.today_rounded,
                    title: 'Hari Ini',
                    value: formatRupiah(todayTotal),
                    color: ClayColors.warning,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClayFadeSlide(
                  index: 1,
                  child: _StatCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'Bulan Ini',
                    value: formatRupiah(monthTotal),
                    color: ClayColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── 7 Hari Terakhir ──
          ClayFadeSlide(
            index: 2,
            child: ClayCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.bar_chart_rounded,
                    title: '7 Hari Terakhir',
                    color: ClayColors.primary,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: has7DaysData
                        ? _BarChart7Days(data: last7Days)
                        : const _EmptyChart(
                            icon: Icons.bar_chart_rounded,
                            message: 'Belum ada transaksi\n7 hari terakhir',
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Grafik Keuntungan Tahun Ini (per bulan) ──
          ClayFadeSlide(
            index: 3,
            child: ClayCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.trending_up_rounded,
                    title: 'Keuntungan Tahun ${tx.selectedYear}',
                    color: ClayColors.secondary,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: tx.yearlyMonthTotals.any((v) => v > 0)
                        ? _YearlyBarChart(
                            totals: tx.yearlyMonthTotals,
                            selectedMonth: tx.selectedMonth - 1,
                          )
                        : const _EmptyChart(
                            icon: Icons.trending_up_rounded,
                            message: 'Belum ada data tahun ini',
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Grafik Detail Bulan (with month filter) ──
          ClayFadeSlide(
            index: 4,
            child: ClayCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.show_chart_rounded,
                          color: ClayColors.success, size: 18),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Grafik Detail Bulan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Month filter dropdown
                      _MonthDropdown(
                        selectedMonth: tx.selectedMonth,
                        selectedYear: tx.selectedYear,
                        onChanged: (m, y) => tx.setMonthFilter(m, y),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: ${formatRupiah(tx.filteredMonthTotal)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ClayColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: tx.filteredMonthDays.any((e) => e.value > 0)
                        ? _LineChartMonth(data: tx.filteredMonthDays)
                        : const _EmptyChart(
                            icon: Icons.show_chart_rounded,
                            message: 'Belum ada transaksi\npada bulan ini',
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Recent Transactions ──
          ClayFadeSlide(
            index: 5,
            child: ClayCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.receipt_long_rounded,
                    title: 'Transaksi Terbaru',
                    color: ClayColors.secondary,
                  ),
                  const SizedBox(height: 8),
                  if (transactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Belum ada transaksi',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...transactions
                        .take(10)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final t = entry.value;
                      final date = t.createdAt != null
                          ? '${t.createdAt!.day}/${t.createdAt!.month} '
                              '${t.createdAt!.hour.toString().padLeft(2, '0')}:'
                              '${t.createdAt!.minute.toString().padLeft(2, '0')}'
                          : '-';
                      return ClayFadeSlide(
                        index: entry.key,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: ClayColors.success.withAlpha(30),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.check_rounded,
                                    size: 18, color: ClayColors.success),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(date,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                              Text(
                                formatRupiah(t.total),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ClayColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Month Dropdown ───────────────────────────────────────────────────────────
class _MonthDropdown extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final void Function(int month, int year) onChanged;

  const _MonthDropdown({
    required this.selectedMonth,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: ClayColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedMonth,
          isDense: true,
          style: TextStyle(
            fontSize: 12,
            color: ClayColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          items: List.generate(12, (i) {
            final m = i + 1;
            return DropdownMenuItem(
              value: m,
              child: Text(TransactionProvider.monthNames[i]),
            );
          }),
          onChanged: (m) {
            if (m != null) onChanged(m, now.year);
          },
        ),
      ),
    );
  }
}

// ─── Bar Chart 7 Days ─────────────────────────────────────────────────────────
class _BarChart7Days extends StatelessWidget {
  final List<MapEntry<DateTime, double>> data;
  const _BarChart7Days({required this.data});

  String _abbrevRupiah(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}rb';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final yInterval = _niceInterval(maxY);

    return BarChart(
      BarChartData(
        maxY: (maxY * 1.25).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.black.withAlpha(15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _abbrevRupiah(value),
                    style: TextStyle(
                      fontSize: 9,
                      color: ClayColors.textMuted,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    formatDateShort(data[index].key),
                    style: TextStyle(
                      fontSize: 9,
                      color: ClayColors.textMuted,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => ClayColors.primary.withAlpha(220),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                formatRupiah(rod.toY),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            },
          ),
        ),
        barGroups: List.generate(data.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i].value,
                color: ClayColors.primary,
                width: 18,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

// ─── Yearly Monthly Bar Chart ─────────────────────────────────────────────────
class _YearlyBarChart extends StatelessWidget {
  final List<double> totals; // length = 12
  final int selectedMonth; // 0-based

  const _YearlyBarChart({
    required this.totals,
    required this.selectedMonth,
  });

  String _abbrevRupiah(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}rb';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final maxY = totals.reduce((a, b) => a > b ? a : b);
    final yInterval = _niceInterval(maxY);

    return BarChart(
      BarChartData(
        maxY: (maxY * 1.25).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.black.withAlpha(15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _abbrevRupiah(value),
                    style: TextStyle(fontSize: 9, color: ClayColors.textMuted),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= 12) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    TransactionProvider.monthNames[idx],
                    style: TextStyle(
                      fontSize: 9,
                      color: idx == selectedMonth
                          ? ClayColors.secondary
                          : ClayColors.textMuted,
                      fontWeight: idx == selectedMonth
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => ClayColors.secondary.withAlpha(220),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${TransactionProvider.monthNames[group.x]}\n${formatRupiah(rod.toY)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            },
          ),
        ),
        barGroups: List.generate(12, (i) {
          final isSelected = i == selectedMonth;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: totals[i],
                color: isSelected
                    ? ClayColors.secondary
                    : ClayColors.secondary.withAlpha(100),
                width: 16,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          );
        }),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

// ─── Line Chart Monthly ───────────────────────────────────────────────────────
class _LineChartMonth extends StatelessWidget {
  final List<MapEntry<DateTime, double>> data;
  const _LineChartMonth({required this.data});

  String _abbrevRupiah(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}rb';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final yInterval = _niceInterval(maxY);

    return LineChart(
      LineChartData(
        maxY: (maxY * 1.3).ceilToDouble(),
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.black.withAlpha(15),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => ClayColors.success.withAlpha(220),
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final date = data[spot.x.toInt()].key;
                return LineTooltipItem(
                  '${date.day} ${TransactionProvider.monthNames[date.month - 1]}\n${formatRupiah(spot.y)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 46,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _abbrevRupiah(value),
                    style: TextStyle(
                      fontSize: 9,
                      color: ClayColors.textMuted,
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: (data.length / 5).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${data[idx].key.day}',
                    style: TextStyle(
                      fontSize: 9,
                      color: ClayColors.textMuted,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: ClayColors.success,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: spot.y > 0 ? 3 : 0,
                  color: ClayColors.success,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: ClayColors.success.withAlpha(30),
            ),
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i].value),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
double _niceInterval(double maxY) {
  if (maxY <= 0) return 1;
  final raw = maxY / 4;
  final magnitude = (raw == 0)
      ? 1
      : (10 * (1 << (raw.toString().split('.')[0].length - 1)));
  return (raw / magnitude).ceil() * magnitude.toDouble();
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _SectionHeader(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Flexible(
          child: Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyChart({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
