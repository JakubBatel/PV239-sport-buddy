import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:sport_buddy/bloc/event_cubit.dart';
import 'package:sport_buddy/bloc/map_data_cubit.dart';
import 'package:sport_buddy/bloc/user_cubit.dart';
import 'package:sport_buddy/components/event_marker_icon_button.dart';
import 'package:sport_buddy/components/gradient_app_bar.dart';
import 'package:sport_buddy/views/create_event.dart';
import 'package:sport_buddy/model/location_model.dart';
import 'package:sport_buddy/model/map_data_model.dart';
import 'package:sport_buddy/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  final mapController = MapController();

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
      onPressed: () {}, // TODO add action
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      onPressed: () => _showProfile(context),
    );
  }

  void _showProfile(BuildContext context) async {
    // TODO: this user setting must be somewhere else - probably before launching first screen
    final userCubit = context.read<UserCubit>();
    userCubit.setUser(FirebaseAuth.instance.currentUser.uid);
    //userCubit.updateUserName(FirebaseAuth.instance.currentUser.displayName);
    await userCubit.setPicture();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  Widget _buildGpsButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn1",
      child: Icon(
        Icons.gps_fixed,
        size: 30,
        color: Colors.red,
      ),
      backgroundColor: Colors.white,
      onPressed: () {
        context.read<MapDataCubit>().setToCurrentLocation();
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn2",
      child: Icon(
        Icons.add,
        size: 40,
      ),
      onPressed: () {
        // TODO: this user setting must be somewhere else - probably before launching first screen
        final userCubit = context.read<UserCubit>();
        userCubit.updateUserName(FirebaseAuth.instance.currentUser.displayName);
        userCubit.setUser(FirebaseAuth.instance.currentUser.uid);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BlocProvider<EventCubit>(
              create: (context) => EventCubit(),
              child: CreateEvent(),
            ),
          ),
        );
      },
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
          ),
        ),
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

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGpsButton(context),
        SizedBox(height: 15),
        _buildAddButton(context),
      ],
    );
  }

  List<LayerOptions> _buildMapLayers(MapDataModel state) {
    return [
      TileLayerOptions(
        urlTemplate: 'https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
        subdomains: ['a', 'b', 'c'],
      ),
      MarkerLayerOptions(
        markers: state.events
            .map(
              (event) => Marker(
                point: LatLng(
                  event.location.latitude,
                  event.location.longitude,
                ),
                builder: (context) => Container(
                  child: EventMarkerIconButton(event: event),
                ),
              ),
            )
            .toList(),
      ),
    ];
  }

  Widget _buildMap() {
    return BlocBuilder<MapDataCubit, MapDataModel>(
      builder: (context, state) {
        if (state.center == null) {
          return Center(
            child: Text('Locating...'),
          );
        }

        mapController.onReady.then((result) {
          mapController.move(
            LatLng(state.center.latitude, state.center.longitude),
            mapController.zoom,
          );
        });

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(state.center.latitude, state.center.longitude),
            zoom: 15.0,
            onPositionChanged: (pos, _) {
              final mapDataCubit = context.read<MapDataCubit>();
              mapDataCubit.setToLocation(
                LocationModel(
                  latitude: pos.center.latitude,
                  longitude: pos.center.longitude,
                ),
              );
            },
          ),
          layers: _buildMapLayers(state),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildMap(),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }
}
