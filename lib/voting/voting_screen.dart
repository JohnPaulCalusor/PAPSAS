import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'voting_provider.dart';
import '../common/models.dart';

class VotingScreen extends StatelessWidget {
  final List<Color> domainColors = Colors.primaries.sublist(0, 18);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final votingProvider = Provider.of<VotingProvider>(context);
    final userEmail = authService.currentUser?.email ?? '';

    if (votingProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Voting')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Voting')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voting Form
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Candidate'),
                items: votingProvider.candidates
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (candidateId) async {
                  if (candidateId != null) {
                    await votingProvider.vote(userEmail, candidateId);
                    if (votingProvider.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(votingProvider.errorMessage!)),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              // Error Message
              if (votingProvider.errorMessage != null)
                Text(votingProvider.errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              // Bar Chart
              Text('Vote Analytics', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: VoteChart(
                  voteCounts: votingProvider.getVoteCounts(),
                  domains: votingProvider.domains,
                  candidates: votingProvider.candidates,
                  domainColors: domainColors,
                ),
              ),
              SizedBox(height: 20),
              // Legend
              Text('Legend', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 10,
                children: votingProvider.domains.map((domain) {
                  int index = votingProvider.domains.indexOf(domain);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 10, height: 10, color: domainColors[index]),
                      SizedBox(width: 5),
                      Text(domain),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VoteChart extends StatelessWidget {
  final Map<String, Map<String, int>> voteCounts;
  final List<String> domains;
  final List<Candidate> candidates;
  final List<Color> domainColors;

  VoteChart({required this.voteCounts, required this.domains, required this.candidates, required this.domainColors});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < candidates.length; i++) {
      String candidateId = candidates[i].id;
      List<BarChartRodStackItem> stackItems = [];
      double total = 0;
      for (int j = 0; j < domains.length; j++) {
        int count = voteCounts[candidateId]?[domains[j]] ?? 0;
        stackItems.add(BarChartRodStackItem(total, total + count, domainColors[j]));
        total += count;
      }
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(toY: total, rodStackItems: stackItems, width: 20)],
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: candidates.length * 50.0 < 300 ? 300 : candidates.length * 50.0,
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < candidates.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(candidates[index].name, style: TextStyle(fontSize: 12)),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
} 