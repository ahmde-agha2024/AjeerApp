import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../constants/utils.dart';
import '../../../controllers/customer/home/customer_home_page_provider.dart';
import '../../../models/customer/service_provider_model.dart';
import '../../screens/provider_details_screen.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({super.key});

  @override
  State<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  String _searchQuery = '';
  List<ServiceProvider> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _performSearch(String query) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final fetchedData =
        await Provider.of<CustomerHomeProvider>(context, listen: false)
            .searchProviders(query);

    if (fetchedData.status == ResponseStatus.success) {
      setState(() {
        _searchResults = fetchedData.response!;
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Find what you want ...'.tr(),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isSearching) const Center(child: CircularProgressIndicator()),
          if (_searchResults.isNotEmpty && !_isSearching)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final provider = _searchResults[index];
                    return ListTile(
                      title: Text(provider.name),
                      subtitle: Text(provider.category?.subCategories
                              ?.map((element) => element.title)
                              .join(' - ') ??
                          ''),
                      leading:
                          CachedNetworkImage(imageUrl: provider.image ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderDetailsScreen(
                              providerId: provider.id!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          if (!_isSearching &&
              _searchQuery.isNotEmpty &&
              _searchResults.isEmpty)
            Center(
              child: Text(
                'لا توجد نتائج'.tr(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
