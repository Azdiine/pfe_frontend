// Base UseCase Interface
// This is a placeholder for use case contracts

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
