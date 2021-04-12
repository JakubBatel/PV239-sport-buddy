import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';

class MainScreen extends StatelessWidget {

  Widget _buildMenuButton() {
    return IconButton(
      icon: Icon(
        Icons.menu,
        color: Colors.white,
      ),
      onPressed: () {}, // TODO add action
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
        icon: Icon(
          Icons.filter_alt,
          color: Colors.white,
        ),
        onPressed: () {} // TODO add action
    );
  }

  Widget _buildProfileButton() {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      onPressed: () {}, // TODO add action
    );
  }

  Widget _buildGpsButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.gps_fixed,
        size: 30,
        color: Colors.red,
      ),
      backgroundColor: Colors.white,
      onPressed: () {}, // TODO add action
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        size: 40,
      ),
      onPressed: () {}, // TODO add action
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          )
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return GradientAppBar(
      leading: _buildMenuButton(),
      title: _buildSearchBar(),
      actions: [
        _buildFilterButton(),
        _buildProfileButton(),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGpsButton(),
        SizedBox(height: 15),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildMap() {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high
      ),
      builder: (context, snapshot) {

        if (snapshot.data == null) {
          return Center(
            child: Text('Locating...'),
          );
        }

        return FlutterMap(
          options: MapOptions(
            center: LatLng(snapshot.data.latitude, snapshot.data.longitude),
            zoom: 15.0,
          ),
          layers: [
            new TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']
            ),
          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildMap(),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
