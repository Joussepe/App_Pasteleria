import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pasteleria_v2/theme/app_theme.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Coordenadas de la panadería Dolce Estella
  static const double _bakeryLatitude = -12.0234182;
  static const double _bakeryLongitude = -75.2318583;
  static const String _bakeryName = 'Dolce Estella';
  
  double? _distance;
  String? _estimatedTime;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Permisos de ubicación denegados';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Los permisos de ubicación están permanentemente denegados';
          _isLoading = false;
        });
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      
      // Calcular distancia a la panadería
      _calculateDistanceToBakery();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener la ubicación: $e';
        _isLoading = false;
      });
    }
  }

  void _calculateDistanceToBakery() {
    if (_currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _bakeryLatitude,
        _bakeryLongitude,
      );
      
      setState(() {
        _distance = distanceInMeters;
        // Estimación de tiempo (aproximadamente 5 minutos por km)
        double timeInMinutes = (distanceInMeters / 1000) * 5;
        _estimatedTime = timeInMinutes.toStringAsFixed(0);
      });
    }
  }

  void _openGoogleMaps() async {
    if (_currentPosition != null) {
      String origin = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
      String destination = '$_bakeryLatitude,$_bakeryLongitude';
      String url = 'https://www.google.com/maps/dir/$origin/$destination';
      
      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir Google Maps'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir Google Maps: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ubicación'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubicación Actual',
                  style: AppTheme.headingStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Obteniendo ubicación...'),
                      ],
                    ),
                  )
                else if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Error',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_errorMessage),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _getCurrentLocation,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                else if (_currentPosition != null)
                  Column(
                    children: [
                      // Tarjeta de información de ubicación
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppTheme.primaryColor, size: 28),
                                const SizedBox(width: 8),
                                Text(
                                  'Coordenadas',
                                  style: AppTheme.headingStyle.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow('Latitud', '${_currentPosition!.latitude.toStringAsFixed(6)}°'),
                            const SizedBox(height: 8),
                            _buildInfoRow('Longitud', '${_currentPosition!.longitude.toStringAsFixed(6)}°'),
                            const SizedBox(height: 8),
                            _buildInfoRow('Precisión', '±${_currentPosition!.accuracy.toStringAsFixed(1)} metros'),
                            const SizedBox(height: 8),
                            _buildInfoRow('Altitud', '${_currentPosition!.altitude.toStringAsFixed(1)} metros'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Mapa simple (placeholder)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 48,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mapa de Ubicación',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: AppTheme.primaryColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: AppTheme.primaryColor.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Información de la panadería
                      if (_distance != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.store, color: AppTheme.accentColor, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    _bakeryName,
                                    style: AppTheme.headingStyle.copyWith(
                                      fontSize: 18,
                                      color: AppTheme.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Distancia', '${(_distance! / 1000).toStringAsFixed(1)} km'),
                              const SizedBox(height: 8),
                              _buildInfoRow('Tiempo estimado', '$_estimatedTime minutos'),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _openGoogleMaps,
                                  icon: const Icon(Icons.directions),
                                  label: const Text('Cómo llegar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accentColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Botón para actualizar ubicación
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Actualizar Ubicación'),
                          style: AppTheme.primaryButtonStyle,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyStyle.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 