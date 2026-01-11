import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class LoadAudioFiles extends AudioEvent {}

class SearchAudioEvent extends AudioEvent {
  final String query;

  const SearchAudioEvent(this.query);

  @override
  List<Object> get props => [query];
}
