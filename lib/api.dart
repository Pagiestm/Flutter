import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future fetchPosts() async {
  var response = await http.get(Uri.parse('https://api.thecompaniesapi.com/v1/locations/countries'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Échec de la récupération des données.');
  }
}

class Country {
  final String name;
  final String nameFr;
  final int population;
  final Map<String, dynamic> continent;

  Country({required this.name, required this.nameFr, required this.population, required this.continent});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      nameFr: json['nameFr'],
      population: json['population'],
      continent: json['continent'],
    );
  }
}