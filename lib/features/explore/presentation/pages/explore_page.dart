import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/config/app_router.dart';
import '../../../../data/models/destination_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<DestinationModel> _allDestinations = [];
  List<DestinationModel> _filteredDestinations = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/destinations.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final destinationsData = DestinationsData.fromJson(jsonData);
      
      setState(() {
        _allDestinations = destinationsData.destinations;
        _filteredDestinations = _allDestinations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading destinations: $e')),
        );
      }
    }
  }

  void _filterDestinations(String query) {
    setState(() {
      if (query.isEmpty && _selectedCategory == 'All') {
        _filteredDestinations = _allDestinations;
      } else {
        _filteredDestinations = _allDestinations.where((destination) {
          final matchesSearch = query.isEmpty ||
              destination.name.toLowerCase().contains(query.toLowerCase()) ||
              destination.roomNumber.toLowerCase().contains(query.toLowerCase());
          final matchesCategory = _selectedCategory == 'All' ||
              destination.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterDestinations(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search rooms, labs, offices...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterDestinations('');
                        },
                      )
                    : null,
              ),
              onChanged: _filterDestinations,
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All'),
                ...AppConstants.destinationCategories.map(_buildCategoryChip),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Destinations List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDestinations.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredDestinations.length,
                        itemBuilder: (context, index) {
                          return _buildDestinationCard(_filteredDestinations[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) => _selectCategory(category),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDestinationCard(DestinationModel destination) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showDestinationDetails(destination);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(destination.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(destination.category),
                  color: _getCategoryColor(destination.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Destination Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.roomNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(destination.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        destination.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getCategoryColor(destination.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Favorite Icon
              IconButton(
                icon: const Icon(Icons.star_outline),
                onPressed: () {
                  // TODO: Toggle favorite
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No destinations found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  void _showDestinationDetails(DestinationModel destination) {
    // Navigate to destination details page
    context.push(
      '${AppRouter.destinationDetails}?name=${Uri.encodeComponent(destination.name)}'
      '&floor=${Uri.encodeComponent(destination.roomNumber)}'
      '&description=${Uri.encodeComponent(destination.description)}'
      '&category=${Uri.encodeComponent(destination.category)}',
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Classroom':
        return Icons.school;
      case 'Laboratory':
        return Icons.science;
      case 'Office':
        return Icons.business_center;
      case 'Facility':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Classroom':
        return AppColors.categoryClassroom;
      case 'Laboratory':
        return AppColors.categoryLaboratory;
      case 'Office':
        return AppColors.categoryOffice;
      case 'Facility':
        return AppColors.categoryFacility;
      default:
        return AppColors.primary;
    }
  }
}

