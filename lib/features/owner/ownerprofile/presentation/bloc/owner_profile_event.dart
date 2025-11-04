import 'package:equatable/equatable.dart';

abstract class OwnerProfileEvent extends Equatable {
  const OwnerProfileEvent();
  @override
  List<Object?> get props => [];
}

class OwnerProfileStarted extends OwnerProfileEvent {
  final int? adminId;
  const OwnerProfileStarted({this.adminId});
}

class OwnerProfileRefreshed extends OwnerProfileEvent {}
