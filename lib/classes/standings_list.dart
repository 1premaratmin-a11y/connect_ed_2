import 'package:connect_ed_2/classes/standings_item.dart';
import 'package:connect_ed_2/classes/team.dart';
import 'package:flutter/material.dart';

class StandingsList {
  final String sportsName;
  final List<StandingsItem> standings;
  final Team applebyTeam; // Appleby College team is required

  StandingsList({
    required this.sportsName,
    required this.standings,
    required this.applebyTeam, // No longer optional
  });

  // Helper function to get const IconData from identifier string
  static IconData _getIconFromIdentifier(String? identifier) {
    switch (identifier) {
      case 'sports_football':
        return Icons.sports_football;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'sports_volleyball':
        return Icons.sports_volleyball;
      case 'sports_baseball':
        return Icons.sports_baseball;
      case 'sports_hockey':
        return Icons.sports_hockey;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'golf_course':
        return Icons.golf_course;
      case 'pool':
        return Icons.pool;
      case 'directions_run':
        return Icons.directions_run;
      case 'sports_cricket':
        return Icons.sports_cricket;
      case 'sports_rugby':
        return Icons.sports_rugby;
      case 'sports_handball':
        return Icons.sports_handball;
      case 'emoji_events':
        return Icons.emoji_events;
      default:
        return Icons.sports;
    }
  }

  // Helper function to get identifier string from IconData
  static String _getIdentifierFromIcon(IconData icon) {
    if (icon == Icons.sports_football) return 'sports_football';
    if (icon == Icons.sports_soccer) return 'sports_soccer';
    if (icon == Icons.sports_basketball) return 'sports_basketball';
    if (icon == Icons.sports_volleyball) return 'sports_volleyball';
    if (icon == Icons.sports_baseball) return 'sports_baseball';
    if (icon == Icons.sports_hockey) return 'sports_hockey';
    if (icon == Icons.sports_tennis) return 'sports_tennis';
    if (icon == Icons.golf_course) return 'golf_course';
    if (icon == Icons.pool) return 'pool';
    if (icon == Icons.directions_run) return 'directions_run';
    if (icon == Icons.sports_cricket) return 'sports_cricket';
    if (icon == Icons.sports_rugby) return 'sports_rugby';
    if (icon == Icons.sports_handball) return 'sports_handball';
    if (icon == Icons.emoji_events) return 'emoji_events';
    return 'sports'; // default
  }

  // Create StandingsList from a Map for deserialization
  factory StandingsList.fromMap(Map<String, dynamic> map) {
    // Parse standings items
    final List<dynamic> standingsData = map['standings_data'] ?? [];
    final List<StandingsItem> standingsList = [];

    for (var item in standingsData) {
      if (item is Map<String, dynamic>) {
        standingsList.add(
          StandingsItem(
            teamName: item['teamName'] as String? ?? '',
            teamAbbreviation: item['teamAbbr'] as String? ?? '',
            rank: item['rank'] as int? ?? 0,
            points: item['points'] as int? ?? 0,
            matchesPlayed: item['gamesPlayed'] as int? ?? 0,
            wins: item['wins'] as int? ?? 0,
            losses: item['losses'] as int? ?? 0,
            ties: item['ties'] as int? ?? 0,
          ),
        );
      }
    }

    // Parse appleby team data - now it's always present
    final teamData = map['appleby_team'] as Map<String, dynamic>;
    final applebyTeam = Team(
      name: teamData['name'] as String? ?? 'Appleby College',
      rank: teamData['rank'] as int? ?? 0,
      record: teamData['record'] as String? ?? '0-0-0',
      sportIcon: _getIconFromIdentifier(
        teamData['sportIconIdentifier'] as String?,
      ),
      leagueCode: teamData['leagueCode'] as String? ?? '',
    );

    return StandingsList(
      sportsName: map['sports_name'] as String? ?? '',
      standings: standingsList,
      applebyTeam: applebyTeam,
    );
  }

  // Convert StandingsList to a Map for serialization
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {
      'sports_name': sportsName,
      'standings_data':
          standings
              .map(
                (item) => {
                  'teamName': item.teamName,
                  'teamAbbr': item.teamAbbreviation,
                  'rank': item.rank,
                  'points': item.points,
                  'gamesPlayed': item.matchesPlayed,
                  'wins': item.wins,
                  'losses': item.losses,
                  'ties': item.ties,
                },
              )
              .toList(),
      // Always include Appleby team data
      'appleby_team': {
        'name': applebyTeam.name,
        'rank': applebyTeam.rank,
        'record': applebyTeam.record,
        'sportIconIdentifier': _getIdentifierFromIcon(applebyTeam.sportIcon),
      },
    };

    return result;
  }
}
