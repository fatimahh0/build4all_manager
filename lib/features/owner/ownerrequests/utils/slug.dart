String slugify(String input) {
  final s = input.trim().toLowerCase();
  final normalized = s
      .replaceAll(RegExp(r"['’`]+"), '') // drop quotes
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-') // non-word -> -
      .replaceAll(RegExp(r'-+'), '-') // collapse dashes
      .replaceAll(RegExp(r'^-+|-+$'), ''); // trim leading/trailing -
  return normalized.isEmpty ? 'app' : normalized;
}
