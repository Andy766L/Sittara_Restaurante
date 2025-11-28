import 'package:flutter/material.dart';
import 'package:sittara_flutter/screens/restaurant_detail_screen.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../widgets/restaurant_card.dart';

enum _ExploreView { list, map }

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  _ExploreView _activeView = _ExploreView.list;
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> _filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = mockRestaurants;
    _searchController.addListener(_filterRestaurants);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRestaurants);
    _searchController.dispose();
    super.dispose();
  }

  void _filterRestaurants() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRestaurants = mockRestaurants.where((restaurant) {
        final nameMatches = restaurant.name.toLowerCase().contains(query);
        final cuisineMatches = restaurant.cuisine.toLowerCase().contains(query);
        return nameMatches || cuisineMatches;
      }).toList();
    });
  }

  void _onNavigateToDetail(Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildContent(),
          ],
        ),
      ),
      // Placeholder for BottomNavigation
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explorar',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar restaurantes...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
          const SizedBox(height: 16),
          ToggleButtons(
            isSelected: [_activeView == _ExploreView.list, _activeView == _ExploreView.map],
            onPressed: (index) {
              setState(() {
                _activeView = index == 0 ? _ExploreView.list : _ExploreView.map;
              });
            },
            borderRadius: BorderRadius.circular(30.0),
            selectedColor: Colors.white,
            fillColor: const Color(0xFF4C7BF3),
            color: Colors.grey.shade700,
            constraints: BoxConstraints(minHeight: 40.0, minWidth: (MediaQuery.of(context).size.width - 36) / 2),
            children: const [
              Text('Lista'),
              Text('Mapa'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _activeView == _ExploreView.list
            ? _buildListView()
            : _buildMapView(),
      ),
    );
  }

  Widget _buildListView() {
    if (_filteredRestaurants.isEmpty) {
      return const Center(child: Text('No se encontraron restaurantes.'));
    }
    return ListView.builder(
      key: const ValueKey('list'),
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = _filteredRestaurants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RestaurantCard(
            restaurant: restaurant,
            onTap: () => _onNavigateToDetail(restaurant),
          ),
        );
      },
    );
  }

  Widget _buildMapView() {
     return Stack(
      key: const ValueKey('map'),
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1694953592902-46d9b0d0c19d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyZXN0YXVyYW50JTIwbG9jYXRpb24lMjBtYXB8ZW58MXx8fHwxNjM4NTAxNzN8MA&ixlib=rb-4.1.0&q=80&w=1080',
          fit: BoxFit.cover,
           errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.map, size: 100, color: Colors.grey)),
        ),
        // Simulated map markers
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width * 0.2,
          child: _buildMapMarker(),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          right: MediaQuery.of(context).size.width * 0.25,
          child: _buildMapMarker(),
        ),
        // Floating restaurant card
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: _buildFloatingMapCard(mockRestaurants.first),
        )
      ],
    );
  }

  Widget _buildMapMarker() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color(0xFF4C7BF3),
      child: const Icon(Icons.location_on, color: Colors.white),
    );
  }
  
  Widget _buildFloatingMapCard(Restaurant restaurant) {
    return GestureDetector(
      onTap: () => _onNavigateToDetail(restaurant),
      child: Card(
         clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Row(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: Image.network(restaurant.image, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(restaurant.cuisine, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(restaurant.rating.toString(), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
