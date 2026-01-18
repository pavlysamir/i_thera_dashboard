import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/notification/data/models/wallet_request_model.dart';

abstract class WalletRequestState extends Equatable {
  const WalletRequestState();

  @override
  List<Object?> get props => [];
}

class WalletRequestInitial extends WalletRequestState {}

class WalletRequestLoading extends WalletRequestState {}

class WalletRequestLoaded extends WalletRequestState {
  final WalletRequestModel walletRequest;

  const WalletRequestLoaded({required this.walletRequest});

  @override
  List<Object?> get props => [walletRequest];
}

class WalletRequestError extends WalletRequestState {
  final String message;

  const WalletRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

class WalletRequestReviewLoading extends WalletRequestState {}

class WalletRequestReviewSuccess extends WalletRequestState {
  final bool isApproved;

  const WalletRequestReviewSuccess({required this.isApproved});

  @override
  List<Object?> get props => [isApproved];
}
