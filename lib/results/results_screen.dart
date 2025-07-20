import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/models.dart';
import 'package:flutter_application_1/home/drawer_layout.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Future<Map<String, Map<String, int>>> getVoteResults() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('votes').get();
      final votes = <Vote>[];
      for (var doc in snapshot.docs) {
        try {
          print('Raw document data: ${doc.data()}'); // Debug log
          votes.add(Vote.fromMap(doc.data()));
        } catch (e) {
          print('Error parsing vote from ${doc.id}: $e');
          // Skip invalid documents but log the error
        }
      }
      final results = <String, Map<String, int>>{};

      for (var candidate in candidates) {
        results[candidate.id] = {};
        for (var region in List.generate(18, (index) => 'Region ${index + 1}')) {
          results[candidate.id]![region] = 0;
        }
      }

      final uniqueVotes = <String, Vote>{};
      for (var vote in votes) {
        final key = '${vote.userId}_${vote.candidateId}';
        if (!uniqueVotes.containsKey(key)) {
          uniqueVotes[key] = vote;
        }
      }

      for (var vote in uniqueVotes.values) {
        if (results.containsKey(vote.candidateId)) {
          results[vote.candidateId]![vote.region] =
              results[vote.candidateId]![vote.region]! + 1;
        }
      }

      return results;
    } catch (e) {
      print('Error fetching vote results: $e');
      return <String, Map<String, int>>{}; // Return empty map on error
    }
  }

  Widget _buildTotalVotesCard(Map<String, Map<String, int>> results) {
    final totalVotes = results.values
        .map((regionVotes) => regionVotes.values.reduce((a, b) => a + b))
        .reduce((a, b) => a + b);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8.0,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFD32F2F),
                Color(0xFF8B0000),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.how_to_vote,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Total Votes Cast',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  totalVotes.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const Text(
                    'Live Results',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegionBreakdownTable(Map<String, Map<String, int>> results) {
    final candidateIds = results.keys.toList();
    if (candidateIds.isEmpty) {
      return Container();
    }
    
    final regions = results[candidateIds.first]!.keys.toList()
      ..sort((a, b) => int.parse(a.split(' ').last).compareTo(int.parse(b.split(' ').last)));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8.0,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Regional Breakdown',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                      headingTextStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                      dataTextStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      columnSpacing: 12.0,
                      horizontalMargin: 16.0,
                      dividerThickness: 1.0,
                      columns: [
                        const DataColumn(
                          label: SizedBox(
                            width: 80,
                            child: Text(
                              'Candidate',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        ...regions.map((region) => DataColumn(
                          label: SizedBox(
                            width: 60,
                            child: Text(
                              region.replaceAll('Region ', 'R'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        )),
                      ],
                      rows: candidateIds.map((candidateId) {
                        final candidate = candidates.firstWhere((c) => c.id == candidateId);
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: Text(
                                  candidate.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            ...regions.map((region) => DataCell(
                              Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: results[candidateId]![region]! > 0 
                                      ? const Color(0xFFD32F2F).withOpacity(0.1)
                                      : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Text(
                                    results[candidateId]![region].toString(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      fontWeight: results[candidateId]![region]! > 0 
                                        ? FontWeight.w600 
                                        : FontWeight.normal,
                                      color: results[candidateId]![region]! > 0 
                                        ? const Color(0xFFD32F2F)
                                        : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPositionPieChart(String position, Map<String, Map<String, int>> results) {
    final positionCandidates = candidates.where((c) => c.description == position).toList();
    final candidateIds = positionCandidates.map((c) => c.id).toList();
    final filteredResults = Map.fromEntries(
      results.entries.where((entry) => candidateIds.contains(entry.key)),
    );

    if (filteredResults.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'No data available for this position',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Calculate total votes for each candidate
    final candidateVotes = <String, int>{};
    for (var candidateId in candidateIds) {
      final votes = filteredResults[candidateId]!;
      candidateVotes[candidateId] = votes.values.fold(0, (sum, vote) => sum + vote);
    }

    // Remove candidates with 0 votes
    candidateVotes.removeWhere((key, value) => value == 0);

    if (candidateVotes.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: const Center(
              child: Text(
                'No votes recorded for this position',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final totalVotes = candidateVotes.values.fold(0, (sum, votes) => sum + votes);

    // Create pie chart sections
    final pieChartSections = <PieChartSectionData>[];
    final colors = [
      const Color(0xFFD32F2F),
      const Color(0xFF8B0000),
      const Color(0xFFFF5722),
      const Color(0xFFF44336),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
    ];

    int colorIndex = 0;
    for (var entry in candidateVotes.entries) {
      final candidateId = entry.key;
      final votes = entry.value;
      final percentage = (votes / totalVotes * 100);
      final candidate = candidates.firstWhere((c) => c.id == candidateId);
      
      pieChartSections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: votes.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 80,
          titleStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: colors[colorIndex % colors.length],
              shape: BoxShape.circle,
            ),
            child: Text(
              votes.toString(),
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          badgePositionPercentageOffset: 1.3,
        ),
      );
      colorIndex++;
    }

    // Create legend
    final legendItems = <Widget>[];
    colorIndex = 0;
    for (var entry in candidateVotes.entries) {
      final candidateId = entry.key;
      final votes = entry.value;
      final candidate = candidates.firstWhere((c) => c.id == candidateId);
      final percentage = (votes / totalVotes * 100);
      
      legendItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[colorIndex % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  '${candidate.name} - $votes votes (${percentage.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      colorIndex++;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8.0,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$position Results',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                  ),
                ),
                const SizedBox(height: 20.0),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    
                    if (isWide) {
                      // Wide layout: pie chart and legend side by side
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pie Chart
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 300,
                              child: PieChart(
                                PieChartData(
                                  sections: pieChartSections,
                                  centerSpaceRadius: 40,
                                  sectionsSpace: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          // Legend
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Legend',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                ...legendItems,
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Narrow layout: pie chart on top, legend below
                      return Column(
                        children: [
                          // Pie Chart
                          Container(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: pieChartSections,
                                centerSpaceRadius: 30,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          // Legend
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vote Distribution',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              ...legendItems,
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Total votes for $position: $totalVotes',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/papsas_logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.red,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PAPSAS INC',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const DrawerLayout(),
      body: FutureBuilder<Map<String, Map<String, int>>>(
        future: getVoteResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
                    strokeWidth: 3.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Loading election results...',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Error loading results',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Please check your connection and try again',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          final results = snapshot.data!;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  _buildTotalVotesCard(results),
                  _buildRegionBreakdownTable(results),
                  _buildPositionPieChart('Director', results),
                  _buildPositionPieChart('Adviser', results),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}