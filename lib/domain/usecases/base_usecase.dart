// Base UseCase Interface
// This is a placeholder for use case contracts

abstract class UseCase<Output, Params> {
  Future<Output> call(Params params);
}

class NoParams {}
