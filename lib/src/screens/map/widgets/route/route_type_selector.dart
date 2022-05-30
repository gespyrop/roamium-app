import 'package:flutter/material.dart';
import 'package:roamium_app/src/models/route.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RouteTypeSelector extends StatefulWidget {
  final void Function(RouteType? routeType)? onChanged;

  const RouteTypeSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  State<RouteTypeSelector> createState() => _RouteTypeSelectorState();
}

class _RouteTypeSelectorState extends State<RouteTypeSelector> {
  RouteType? selected = RouteType.walking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: DropdownButton<RouteType>(
        value: selected,
        items: [
          DropdownMenuItem(
            child: Row(
              children: [
                const Icon(Icons.directions_walk, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(AppLocalizations.of(context).walking),
              ],
            ),
            value: RouteType.walking,
          ),
          DropdownMenuItem(
            child: Row(
              children: [
                const Icon(Icons.hiking, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(AppLocalizations.of(context).hiking),
              ],
            ),
            value: RouteType.hiking,
          ),
          DropdownMenuItem(
            child: Row(
              children: [
                const Icon(Icons.directions_bike, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(AppLocalizations.of(context).bike),
              ],
            ),
            value: RouteType.bike,
          ),
          DropdownMenuItem(
            child: Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(AppLocalizations.of(context).car),
              ],
            ),
            value: RouteType.car,
          ),
          DropdownMenuItem(
            child: Row(
              children: [
                const Icon(Icons.accessible, color: Colors.black54),
                const SizedBox(width: 8.0),
                Text(AppLocalizations.of(context).wheelchair),
              ],
            ),
            value: RouteType.wheelchair,
          ),
        ],
        onChanged: (routeType) {
          setState(() => selected = routeType);

          if (widget.onChanged != null) widget.onChanged!(routeType);
        },
      ),
    );
  }
}
