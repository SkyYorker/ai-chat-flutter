import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../services/database_service.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('График расходов'),
        backgroundColor: const Color(0xFF262626),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            key: ValueKey(chatProvider.dataVersion),
            future: DatabaseService().getDailyExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Нет данных о расходах',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final expenses = snapshot.data!;
              final spots = expenses.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final day = data['day'] as String;
                final cost = (data['total_cost'] as num?)?.toDouble() ?? 0.0;
                return FlSpot(index.toDouble(), cost);
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Расходы по дням',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < expenses.length) {
                                    return Text(
                                      expenses[index]['day'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<ChatProvider>(
                      builder: (context, chatProvider, child) {
                        final freeModelIds = chatProvider.availableModels
                            .where((model) {
                              final promptPrice =
                                  double.tryParse(
                                    model['pricing']['prompt'] ?? '0',
                                  ) ??
                                  0.0;
                              final completionPrice =
                                  double.tryParse(
                                    model['pricing']['completion'] ?? '0',
                                  ) ??
                                  0.0;
                              return promptPrice == 0.0 &&
                                  completionPrice == 0.0;
                            })
                            .map((model) => model['id'] as String)
                            .toList();
                        return FutureBuilder<Map<String, dynamic>>(
                          key: ValueKey(chatProvider.dataVersion),
                          future: DatabaseService().getFreeUsage(freeModelIds),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError || !snapshot.hasData) {
                              return const Text(
                                'Нет данных о бесплатных моделях',
                                style: TextStyle(color: Colors.white70),
                              );
                            }
                            final data = snapshot.data!;
                            return Card(
                              color: const Color(0xFF333333),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Использование бесплатных моделей',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Сообщений: ${data['message_count']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      'Токенов: ${data['total_tokens']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      'Стоимость: 0.00\$',
                                      style: const TextStyle(
                                        color: Color(0xFF33CC33),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
