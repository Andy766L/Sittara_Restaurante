import 'package:flutter/material.dart';
import 'package:sittara_flutter/screens/restaurant_detail_screen.dart';
import '../data/mock_data.dart';
import '../models.dart';
import '../widgets/restaurant_card.dart';

enum _ExploreView { list, map }

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  ExploreScreenState createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildHeader(), _buildContent()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explora', style: theme.textTheme.displaySmall),
          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Busca tu proximo restaurante...',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (255 * 0.5).round(),
                ),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ToggleButtons(
            isSelected: [
              _activeView == _ExploreView.list,
              _activeView == _ExploreView.map,
            ],
            onPressed: (index) {
              setState(() {
                _activeView = index == 0 ? _ExploreView.list : _ExploreView.map;
              });
            },
            borderRadius: BorderRadius.circular(30.0),
            selectedColor: Colors.white,
            fillColor: theme.colorScheme.primary,
            color: theme.colorScheme.primary,
            splashColor: theme.colorScheme.primary.withAlpha(
              (255 * 0.12).round(),
            ),
            constraints: BoxConstraints(
              minHeight: 50.0,
              minWidth: (MediaQuery.of(context).size.width - 52) / 2,
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.list),
                  SizedBox(width: 8),
                  Text('Lista'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.map_outlined),
                  SizedBox(width: 8),
                  Text('Mapa'),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = _filteredRestaurants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
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
          'https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=14&size=600x800&maptype=roadmap&style=feature:all|element:labels|visibility:off&style=feature:road|element:geometry|color:0x000000&style=feature:water|element:geometry|color:0x333333&key=YOUR_API_KEY',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey),
            ),
          ),
        ),
        // Simulated map markers
        ...mockRestaurants
            .take(3)
            .map(
              (r) => Positioned(
                top: (r.id.hashCode % 50) + 10,
                left: (r.id.hashCode % 60) + 10,
                child: _buildMapMarker(r),
              ),
            ),
        // Floating restaurant card
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: _buildFloatingMapCard(mockRestaurants.first),
        ),
      ],
    );
  }

  Widget _buildMapMarker(Restaurant restaurant) {
    return FloatingActionButton(
      onPressed: () => _onNavigateToDetail(restaurant),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.location_on, color: Colors.white),
    );
  }

  Widget _buildFloatingMapCard(Restaurant restaurant) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _onNavigateToDetail(restaurant),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 12,
        shadowColor: Colors.black.withAlpha((255 * 0.3).round()),
        child: Row(
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: Image.network(restaurant.image, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(restaurant.cuisine, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
