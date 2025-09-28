class AppError implements Exception {
  final String message;

  AppError(this.message);

  @override
  String toString() => message;
}

class RateLimitError extends AppError {
  RateLimitError(super.message);
}

class RepoNotFoundError extends AppError {
  RepoNotFoundError(super.message);
}
