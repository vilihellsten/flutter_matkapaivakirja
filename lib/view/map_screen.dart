import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsScreen extends StatefulWidget {
  final LatLng? initialLocation; // Optional initial location
  final bool readOnly; // New parameter to enable read-only mode

  const MapsScreen({
    Key? key,
    this.initialLocation,
    this.readOnly = false, // Default is false (editable mode)
  }) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _selectedLocation;
  late LatLng _initialPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      // Use the provided initial location
      _initialPosition = widget.initialLocation!;
      _isLoading = false;
    } else {
      // Fetch the user's current location
      _getUserLocation();
    }
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.readOnly
            ? const Text("Näytä sijainti") // Title for read-only mode
            : const Text("Valitse sijainti"), // Title for editable mode
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 15,
              ),
              onTap: widget.readOnly
                  ? null // Disable onTap if readOnly is true
                  : (LatLng location) {
                      setState(() {
                        _selectedLocation = location;
                      });
                    },
              markers: {
                if (_selectedLocation != null && !widget.readOnly)
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: _selectedLocation!,
                  ),
                if (widget.initialLocation != null)
                  Marker(
                    markerId: const MarkerId("initial"),
                    position: widget.initialLocation!,
                  ),
              },
            ),
      floatingActionButton: widget.readOnly
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Close the map without changes
              },
              child: const Icon(Icons.close),
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.pop(
                    context, _selectedLocation ?? widget.initialLocation);
              },
              child: const Icon(Icons.check),
            ),
    );
  }
}
