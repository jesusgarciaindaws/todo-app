import 'package:anxeb_flutter/anxeb.dart' as Anxeb;
import 'package:flutter/material.dart';

class ReferenceModel extends Anxeb.Model<ReferenceModel> {
  ReferenceModel([data]) : super(data);

  static Future<T> lookupLeaf<T>({
    Anxeb.Scope scope,
    ReferenceType type,
    IconData icon,
    String dialogTitle,
    String rootTitle,
    T Function(dynamic data) instance,
    ReferenceType leaf,
    bool isPublic,
  }) async {
    final result = await lookupBranch(
        scope: scope,
        type: type,
        icon: icon,
        dialogTitle: dialogTitle,
        rootTitle: rootTitle,
        instance: instance,
        leaf: leaf,
        isPublic: isPublic);
    return result?.isNotEmpty == true ? result.last : null;
  }

  static Future<List<T>> lookupBranch<T>({
    Anxeb.Scope scope,
    ReferenceType type,
    IconData icon,
    String dialogTitle,
    String rootTitle,
    T Function(dynamic data) instance,
    ReferenceType leaf,
    bool isPublic,
  }) async {
    final typeString = type.toString().split('.')[1];
    final result = await scope.dialogs
        .referencer<T>(dialogTitle,
            icon: icon,
            loader: (page, [parent]) async {
              final $reference = (parent as ReferenceModel);
              if (leaf != null && $reference?.type == leaf) {
                return null;
              }
              String uri;
              if (parent != null) {
                uri =
                    '/${(isPublic == true ? 'public/' : '')}references?parent=${$reference.id}';
              } else {
                uri =
                    '/${(isPublic == true ? 'public/' : '')}references?type=$typeString&childs=min';
              }

              final data = await scope.api.get(uri);
              if (data.length == 0) {
                return null;
              }
              return data.list<T>((e) => instance(e));
            },
            comparer: (a, b) => a == b,
            headerWidget: ($page) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: scope.application.settings.colors.separator,
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            ($page?.parent?.selected as ReferenceModel)?.name ??
                                rootTitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:
                                    scope.application.settings.colors.secudary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemWidget: ($page, $reference) {
              final isSelected = $page.isSelected($reference);
              return Anxeb.ListTitleBlock(
                scope: scope,
                iconTrail: Icons.keyboard_arrow_right,
                iconTrailScale: 0.4,
                busy: $page.isBusy($reference),
                iconScale: 0.6,
                titleStyle: TextStyle(
                    color: isSelected
                        ? scope.application.settings.colors.active
                        : Colors.white,
                    fontSize: 16,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w300),
                iconTrailColor: Colors.white,
                fillColor: isSelected
                    ? scope.application.settings.colors.secudary
                    : scope.application.settings.colors.primary,
                margin: const EdgeInsets.symmetric(vertical: 3),
                iconColor: scope.application.settings.colors.secudary,
                title: ($reference as ReferenceModel).name,
                onTap: () async {
                  if ($page.idle) {
                    try {
                      await $page.select($reference);
                    } catch (err) {
                      //ignore
                    }
                  }
                },
                padding: const EdgeInsets.only(
                    left: 12, top: 5, bottom: 5, right: 5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              );
            })
        .show();
    return result;
  }

  @override
  void init() {
    field(() => id, (v) => id = v, has('_id') ? '_id' : 'id', primary: true);
    field(() => name, (v) => name = v, 'name');
    field(() => type, (v) => type = v, 'type',
        enumValues: ReferenceType.values);
    field(() => parent, (v) => parent = v, 'parent',
        instance: (data) => ReferenceModel(data));
    field(() => root, (v) => root = v, 'root',
        instance: (data) => ReferenceModel(data));
    field(() => childs, (v) => childs = v, 'childs',
        defect: () => <ReferenceModel>[],
        instance: (data) => ReferenceModel(data));
  }

  String id;
  String name;
  ReferenceType type;
  ReferenceModel parent;
  ReferenceModel root;
  List<ReferenceModel> childs;

  @override
  String toString() => root != null ? '${root.name}: $name' : name;
}

enum ReferenceType {
  country,
  country_state,
  state_city,
  company_category,
  client_category,
  procedure_category,
  stage_category
}
