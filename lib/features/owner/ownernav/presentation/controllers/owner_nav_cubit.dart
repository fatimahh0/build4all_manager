import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerNavState {
  final int index;
  const OwnerNavState(this.index);
}

class OwnerNavCubit extends Cubit<OwnerNavState> {
  OwnerNavCubit({int initialIndex = 0}) : super(OwnerNavState(initialIndex));
  void setIndex(int i) => emit(OwnerNavState(i));
}
