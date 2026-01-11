import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class PermissionFailure extends Failure {}
class AudioQueryFailure extends Failure {
    final String message;
    AudioQueryFailure(this.message);
    
    @override
    List<Object> get props => [message];
}
