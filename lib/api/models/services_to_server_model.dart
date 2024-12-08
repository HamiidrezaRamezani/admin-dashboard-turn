import 'dart:convert';

class OptionServices {
  String name;
  int price;

  OptionServices({required this.name, required this.price});

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };
}

class PicsAndServicesForServer {
  int id;

  PicsAndServicesForServer({required this.id});

  Map<String, dynamic> toJson() => {
    'id': id,
  };
}

