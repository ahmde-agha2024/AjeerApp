import 'package:ajeer/constants/utils.dart';
import 'package:ajeer/controllers/general/on_boarding_provider.dart';
import 'package:ajeer/models/auth/address_model.dart';
import 'package:ajeer/models/common/region_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../controllers/common/address_provider.dart';
import '../../../models/customer/provider/service_provider_account.dart';
import '../../widgets/appbar_title.dart';
import '../../widgets/button_styles.dart';
import '../../widgets/input_decoration.dart';
import '../../widgets/input_label.dart';
import '../../widgets/sized_box.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? existingAddress;

  const AddAddressScreen({Key? key, this.existingAddress}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  LatLng? _selectedLocation;
  TextEditingController _addressController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  City? _selectedCity;
  Region? _selectedCityRegion;
  bool _isCitiesFetched = false;
  bool _isRegionsFetched = false;
  ResponseHandler<List<Region>>? cityRegions;
  ResponseHandler<List<City>>? cities;
  Location location = Location();
  GoogleMapController? _mapController;

  // إضافة إحداثيات طرابلس
  static const LatLng TRIPOLI_CENTER = LatLng(32.8872, 13.1913);
  
  // إضافة حدود الخريطة لمنطقة طرابلس
  static  LatLngBounds TRIPOLI_BOUNDS = LatLngBounds(
    southwest: LatLng(32.8072, 13.0913), // جنوب غرب طرابلس
    northeast: LatLng(32.9672, 13.2913), // شمال شرق طرابلس
  );

  // إضافة نمط مخصص للخريطة
  static final mapStyle = [
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#e9e9e9"
        },
        {
          "lightness": 17
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f5f5"
        },
        {
          "lightness": 20
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#ffffff"
        },
        {
          "lightness": 17
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f5f5"
        },
        {
          "lightness": 21
        }
      ]
    }
  ];

  // تعديل مستوى التكبير الافتراضي ليكون أقرب
  static const double DEFAULT_ZOOM = 20.0; // زيادة مستوى التكبير

  @override
  void initState() {
    super.initState();
    if (widget.existingAddress != null) {
      _addressController.text = widget.existingAddress!.address!;
      _titleController.text = widget.existingAddress!.title!;
      _selectedLocation = LatLng(
        double.parse(widget.existingAddress!.lat!),
        double.parse(widget.existingAddress!.lng!),
      );
      _preloadCityAndRegion();
    } else {
      _initializeTripoliLocation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isCitiesFetched) {
      Provider.of<OnBoardingProvider>(context, listen: false)
          .fetchProviderCities()
          .then((response) {
        setState(() {
          cities = response;
          _isCitiesFetched = true;
        });

        if (widget.existingAddress != null) {
          _preloadCityAndRegion();
        }
      });
    }
  }

  Future<void> _preloadCityAndRegion() async {
    if (widget.existingAddress != null) {
      final cityId = widget.existingAddress!.cityId;
      final regionId = widget.existingAddress!.regionId;

      final city = cities?.response?.firstWhere(
        (c) => c.id == cityId,
      );

      if (city != null) {
        setState(() {
          _selectedCity = city;
        });

        cityRegions = await _fetchCityRegions(city.id!);

        final region = cityRegions?.response?.firstWhere(
          (r) => r.id == regionId,
        );

        setState(() {
          _selectedCityRegion = region;
          _isRegionsFetched = true;
        });
      }
    }
  }

  void _initializeTripoliLocation() {
    setState(() {
      _selectedLocation = TRIPOLI_CENTER;
    });
  }

  Future<ResponseHandler<List<Region>>> _fetchCityRegions(int cityId) async {
    return await Provider.of<OnBoardingProvider>(context, listen: false)
        .fetchCityRegions(cityId: cityId);
  }

  Future<void> _saveAddress() async {
    if (_selectedLocation == null ||
        _titleController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedCity == null ||
        _selectedCityRegion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تأكد من إدخال كل البيانات واختيار الموقع')),
      );
      return;
    }

    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    bool status = false;
    if (widget.existingAddress != null) {
      status = await addressProvider.updateAddress(
        id: widget.existingAddress!.id!,
        title: _titleController.text,
        address: _addressController.text,
        lat: _selectedLocation!.latitude.toString(),
        lng: _selectedLocation!.longitude.toString(),
        cityId: _selectedCity!.id.toString(),
        regionId: _selectedCityRegion!.id.toString(),
      );
    } else {
      status = await addressProvider.addAddress(
        title: _titleController.text,
        address: _addressController.text,
        lat: _selectedLocation!.latitude.toString(),
        lng: _selectedLocation!.longitude.toString(),
        cityId: _selectedCity!.id.toString(),
        regionId: _selectedCityRegion!.id.toString(),
      );
    }

    if (status) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء حفظ العنوان')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTitle(
          title: widget.existingAddress == null
              ? 'إضافة عنوان جديد'
              : 'تعديل العنوان'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.1),
                thickness: 10,
              ),
              SizedBoxedH16,
              LabelText(text: 'عنوان'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: buildInputDecoration(hintText: 'عنوان'),
              ),
              const SizedBox(height: 16),
              LabelText(text: 'العنوان'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: buildInputDecoration(hintText: 'العنوان (أقرب نقطة دالة)'),
              ),
              const SizedBox(height: 16),
              LabelText(text: 'المدينة'),
              const SizedBox(height: 8),
              !_isCitiesFetched
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButtonFormField<City>(
                      value: _selectedCity,
                      decoration: buildInputDecoration(hintText: 'City'.tr()),
                      items: cities!.response!
                          .map((city) => DropdownMenuItem<City>(
                              value: city,
                              child: Text(city.title ?? 'UNKNOWN')))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _isRegionsFetched = false;
                          cityRegions = null;
                          _selectedCityRegion = null;
                        });
                        _fetchCityRegions(value!.id!).then((response) {
                          setState(() {
                            cityRegions = response;
                            _isRegionsFetched = true;
                          });
                        });
                      },
                    ),
              const SizedBox(height: 12),
              LabelText(text: 'المنطقة'.tr()),
              const SizedBox(height: 8),
              if (_selectedCity != null && _isRegionsFetched)
                cityRegions!.status == ResponseStatus.success
                    ? DropdownButtonFormField<Region>(
                        value: _selectedCityRegion,
                        decoration:
                            buildInputDecoration(hintText: 'Region'.tr()),
                        items: cityRegions!.response!
                            .map((region) => DropdownMenuItem<Region>(
                                value: region,
                                child: Text(region.title ?? 'UNKNOWN')))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCityRegion = value;
                          });
                        },
                      )
                    : const Center(child: Text('Error fetching regions')),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 300,
                    child: _buildMap(),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: FloatingActionButton(
                      onPressed: _getUserLocation,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBoxedH16,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                    style: flatButtonPrimaryStyle,
                    onPressed: _saveAddress,
                    child: Text(
                      widget.existingAddress == null
                          ? 'حفظ العنوان'
                          : 'تعديل العنوان',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ?? TRIPOLI_CENTER,
                zoom: DEFAULT_ZOOM, // استخدام التكبير الجديد
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              compassEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;
                await controller.setMapStyle(jsonEncode(mapStyle));
                
                // تعديل التكبير عند إنشاء الخريطة
                await controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    _selectedLocation ?? TRIPOLI_CENTER,
                    DEFAULT_ZOOM,
                  ),
                );
              },
              onTap: (LatLng position) {
                if (TRIPOLI_BOUNDS.contains(position)) {
                  setState(() {
                    _selectedLocation = position;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('الرجاء اختيار موقع داخل منطقة طرابلس'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              markers: _selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: MarkerId('selected_location'),
                        position: _selectedLocation!,
                        draggable: true,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                        infoWindow: InfoWindow(
                          title: 'الموقع المحدد',
                          snippet: 'اسحب لتغيير الموقع',
                        ),
                        onDragEnd: (LatLng newPosition) {
                          if (TRIPOLI_BOUNDS.contains(newPosition)) {
                            setState(() {
                              _selectedLocation = newPosition;
                            });
                          } else {
                            setState(() {
                              _selectedLocation = TRIPOLI_CENTER;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('الرجاء البقاء ضمن حدود منطقة طرابلس'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                    },
            ),
            // إضافة زر تحديد الموقع مع تصميم محسن
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: _getUserLocation,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                  ),
                  mini: true,
                ),
              ),
            ),
            // إضافة مؤشر المنطقة المسموحة
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'منطقة طرابلس',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserLocation() async {
    try {
      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('يرجى السماح بالوصول إلى الموقع')),
        );
        return;
      }

      final currentLocation = await location.getLocation();
      final currentLatLng = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );

      if (!TRIPOLI_BOUNDS.contains(currentLatLng)) {
        setState(() {
          _selectedLocation = TRIPOLI_CENTER;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('موقعك خارج منطقة طرابلس. تم تحديد وسط المدينة')),
        );
      } else {
        setState(() {
          _selectedLocation = currentLatLng;
        });
      }

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _selectedLocation!,
              zoom: DEFAULT_ZOOM, // استخدام التكبير الأكبر
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في تحديد الموقع')),
      );
    }
  }

  Future<bool> _requestLocationPermission() async {
    final permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      final requestResult = await location.requestPermission();
      return requestResult == PermissionStatus.granted;
    }
    return permissionGranted == PermissionStatus.granted;
  }
}
