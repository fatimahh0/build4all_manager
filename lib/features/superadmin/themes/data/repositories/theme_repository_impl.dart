import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';

import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/i_theme_repository.dart';
import '../models/theme_dto.dart';
import '../services/theme_api.dart';

class ThemeRepositoryImpl implements IThemeRepository {
  final ThemeApi api;
  ThemeRepositoryImpl(this.api);

  @override
  Future<List<ThemeEntity>> getAll() async {
    final r = await api.getAll();
    final list = (r.data as List).cast<Map<String, dynamic>>();
    return list.map((e) => ThemeDto.fromJson(e).toEntity()).toList();
  }

  @override
  Future<ThemeEntity?> getActive() async {
    final r = await api.getActive(); // validateStatus <500 (no throw on 404)
    if (r.statusCode == 404) return null;
    return ThemeDto.fromJson(Map<String, dynamic>.from(r.data)).toEntity();
  }

  @override
  Future<ThemeEntity> create(Map<String, dynamic> body) async {
    final payload = _buildApiBody(body, isUpdate: false);
    final r = await api.create(payload);
    final dto = Map<String, dynamic>.from(r.data['theme'] ?? r.data);
    return ThemeDto.fromJson(dto).toEntity();
  }

  @override
  Future<ThemeEntity> update(int id, Map<String, dynamic> body) async {
    final payload = _buildApiBody(body, isUpdate: true);
    final r = await api.update(id, payload);
    return ThemeDto.fromJson(Map<String, dynamic>.from(r.data)).toEntity();
  }

  @override
  Future<void> delete(int id) => api.delete(id).then((_) {});

  @override
  Future<void> setActive(int id) => api.setActive(id).then((_) {});

  @override
  Future<void> setMenuType(int id, String menuType) =>
      api.setMenuType(id, menuType).then((_) {});

  @override
  Future<int> deactivateAll() async {
    final r = await api.deactivateAll();
    final m = Map<String, dynamic>.from(r.data);
    final n = m['updatedCount'];
    return n is int ? n : int.tryParse('$n') ?? 0;
  }

  // ----------------- helpers -----------------

  /// Build body in a way the current backend accepts:
  /// - name/menuType/isActive as usual
  /// - valuesMobile **as a JSON string** (not a map)
  Map<String, dynamic> _buildApiBody(Map<String, dynamic> body,
      {required bool isUpdate}) {
    final dynamic directVm = body['valuesMobile'];

    final String? name = _str(body['name']);
    final String? menu = _str(body['menuType'])?.toLowerCase();
    final bool? isActive = _boolOrNull(body['isActive']);

    final int? primary = _intOrNull(body['primary']);
    final int? secondary = _intOrNull(body['secondary']);
    final int? success = _intOrNull(body['success']);
    final int? warning = _intOrNull(body['warning']);
    final int? error = _intOrNull(body['error']);

    final dynamic accent = body['accentColor'];
    final dynamic background = body['backgroundColor'];
    final dynamic text = body['textColor'];
    final dynamic buttonRadius = body['buttonRadius'];
    final dynamic navOverride = body['nav'];

    // Start from provided valuesMobile or empty
    final Map<String, dynamic> vm = (directVm is Map<String, dynamic>)
        ? Map<String, dynamic>.from(directVm)
        : <String, dynamic>{};

    // put colors (prefer top-level ints)
    _maybePutHex(vm, 'primaryColor', primary);
    _maybePutHex(vm, 'secondaryColor', secondary);
    _maybePutHex(vm, 'successColor', success);
    _maybePutHex(vm, 'warningColor', warning);
    _maybePutHex(vm, 'errorColor', error);

    // optional extras (strings like "#rrggbb" also accepted)
    _maybePutHexDyn(vm, 'accentColor', accent);
    _maybePutHexDyn(vm, 'backgroundColor', background);
    _maybePutHexDyn(vm, 'textColor', text);

    if (buttonRadius != null) {
      final num? br = _numOrNull(buttonRadius);
      if (br != null) vm['buttonRadius'] = br;
    }

    final String? nav = _str(navOverride) ?? menu;
    if (nav != null && nav.isNotEmpty) vm['nav'] = nav;

    // finally build payload
    final Map<String, dynamic> payload = {};
    if (!isUpdate || name != null) payload['name'] = name ?? '';
    if (!isUpdate || menu != null) payload['menuType'] = menu ?? 'bottom';
    if (!isUpdate || isActive != null) payload['isActive'] = isActive ?? false;

    // *** IMPORTANT: send valuesMobile as STRING ***
    if (!isUpdate || vm.isNotEmpty) payload['valuesMobile'] = jsonEncode(vm);

    return payload;
  }

  static String? _str(dynamic x) => x == null ? null : x.toString();
  static bool? _boolOrNull(dynamic x) {
    if (x == null) return null;
    if (x is bool) return x;
    final s = x.toString().toLowerCase();
    if (s == 'true') return true;
    if (s == 'false') return false;
    return null;
  }

  static int? _intOrNull(dynamic x) {
    if (x == null) return null;
    if (x is int) return x;
    try {
      return int.parse('$x');
    } catch (_) {
      return null;
    }
  }

  static num? _numOrNull(dynamic x) {
    if (x == null) return null;
    if (x is num) return x;
    return num.tryParse(x.toString());
  }

  static void _maybePutHex(Map<String, dynamic> dst, String key, int? argb) {
    if (argb == null) return;
    dst[key] = _hexRgb(argb);
  }

  static void _maybePutHexDyn(Map<String, dynamic> dst, String key, dynamic v) {
    if (v == null) return;
    if (v is int) {
      dst[key] = _hexRgb(v);
      return;
    }
    final s = v.toString().trim();
    if (s.isEmpty) return;
    dst[key] = _normalizeHex6(s);
  }

  static String _hexRgb(int argb) {
    final c = Color(argb);
    final r = c.red.toRadixString(16).padLeft(2, '0');
    final g = c.green.toRadixString(16).padLeft(2, '0');
    final b = c.blue.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toLowerCase(); // server stores #rrggbb
    // (alpha is discarded in server scheme)
  }

  static String _normalizeHex6(String x) {
    var s = x.startsWith('#') ? x.substring(1) : x;
    s = s.toLowerCase();
    if (s.length == 3) {
      s = '${s[0]}${s[0]}${s[1]}${s[1]}${s[2]}${s[2]}';
    } else if (s.length == 8) {
      s = s.substring(2); // drop alpha
    }
    if (s.length != 6) return '#$x';
    return '#$s';
  }
}
