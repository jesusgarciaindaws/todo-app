import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:todo_app/models/references/city.dart';
import 'package:todo_app/models/references/country.dart';
import 'package:todo_app/models/references/state.dart';
import 'package:flutter/material.dart';
import '../primary/reference.dart';

class LocationModel extends Anxeb.Model<LocationModel> {
  LocationModel([data]) : super(data);

  @override
  void init() {
    field(() => country, (v) => country = v, 'country',
        instance: (data) => data != null ? CountryReference(data) : null);
    field(() => state, (v) => state = v, 'state',
        instance: (data) => data != null ? StateReference(data) : null);
    field(() => city, (v) => city = v, 'city',
        instance: (data) => data != null ? CityReference(data) : null);
    field(() => coordinates, (v) => coordinates = v, 'coordinates');
    field(() => address, (v) => address = v, 'address');
  }

  LocationModel.fromReferences(List<ReferenceModel> references) {
    for (final reference in references) {
      if (reference.type == ReferenceType.country) {
        country = CountryReference(reference.toObjects());
      } else if (reference.type == ReferenceType.country_state) {
        state = StateReference(reference.toObjects());
      } else if (reference.type == ReferenceType.state_city) {
        city = CityReference(reference.toObjects());
      }
    }
  }

  static Future<LocationModel> lookup(
      {Anxeb.Scope scope,
      IconData icon,
      String title,
      ReferenceType leaf,
      bool isPublic}) async {
    final references = await ReferenceModel.lookupBranch<ReferenceModel>(
      scope: scope,
      type: ReferenceType.country,
      icon: icon ?? Icons.location_on,
      dialogTitle: title ?? 'Localidad',
      rootTitle: 'País',
      leaf: leaf,
      instance: (data) => ReferenceModel(data),
      isPublic: isPublic,
    );

    return references != null ? LocationModel.fromReferences(references) : null;
  }

  CountryReference country;
  StateReference state;
  CityReference city;
  String address;
  dynamic coordinates;

  @override
  String toString() => (city ?? state ?? country)?.name;

  String get basic {
    final items = [city?.name, state?.name, country?.name];
    String result;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item != null) {
        if (result == null) {
          result = item;
        } else {
          result += ', $item';
          break;
        }
      }
    }

    return result;
  }

  String get caption => address ?? city?.name ?? state?.name ?? country?.name;
}
