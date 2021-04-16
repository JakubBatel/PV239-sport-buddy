import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';

import '../profil_page.dart';

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

  Widget _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => BlocProvider.value(
                    value: BlocProvider.of<UserCubit>(context),
                    child: ProfilPage())));
      }, // TODO add action
    );
  }

  void _showProfile(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilPage()));
  }

  Widget _buildGpsButton() {
    return FloatingActionButton(
      heroTag: "btn1",
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
      heroTag: "btn2",
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
            )),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return GradientAppBar(
      leading: _buildMenuButton(),
      title: _buildSearchBar(),
      actions: [
        _buildFilterButton(),
        _buildProfileButton(context),
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
      stream:
          Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high),
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
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildMap(),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
