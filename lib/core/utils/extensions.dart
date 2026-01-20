// Extensões úteis para o projeto
// 
// TODO: Adicionar extensões conforme necessário durante o desenvolvimento
// Exemplos:
// - String extensions (capitalize, truncate, etc.)
// - DateTime extensions (format, etc.)
// - BuildContext extensions (theme, mediaQuery, etc.)

// Exemplo de extensão (pode ser removida se não for usada)
extension StringExtensions on String {
  /// Capitaliza a primeira letra da string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
