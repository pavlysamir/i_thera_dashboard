// lib/features/notifications/presentation/wallet_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/core/widgets/web_image_display.dart';
import 'package:i_thera_dashboard/features/notification/data/models/wallet_request_model.dart';
import 'package:i_thera_dashboard/features/notification/managers/wallet_request_cubit/cubit/wallet_request_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/wallet_request_cubit/cubit/wallet_request_state.dart';

class WalletRequestScreen extends StatefulWidget {
  final int doctorId;
  final int walletRequestId;

  const WalletRequestScreen({
    super.key,
    required this.doctorId,
    required this.walletRequestId,
  });

  @override
  State<WalletRequestScreen> createState() => _WalletRequestScreenState();
}

class _WalletRequestScreenState extends State<WalletRequestScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletRequestCubit>().loadWalletRequestDetails(
      doctorId: widget.doctorId,
      walletRequestId: widget.walletRequestId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1E88E5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<WalletRequestCubit, WalletRequestState>(
        listener: (context, state) {
          if (state is WalletRequestReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.isApproved ? 'تم قبول الطلب بنجاح' : 'تم رفض الطلب',
                ),
                backgroundColor: state.isApproved ? Colors.green : Colors.red,
              ),
            );
            Navigator.pop(context, true);
          }

          if (state is WalletRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is WalletRequestReviewSuccess) {
            context.read<WalletRequestCubit>().sendValidationNotification(
              state.isApproved ? 1 : 3,
              widget.doctorId,
              widget.walletRequestId,
            );
          }
        },
        builder: (context, state) {
          if (state is WalletRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletRequestError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WalletRequestCubit>()
                          .loadWalletRequestDetails(
                            doctorId: widget.doctorId,
                            walletRequestId: widget.walletRequestId,
                          );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is WalletRequestLoaded ||
              state is WalletRequestReviewLoading) {
            WalletRequestModel? walletRequest;

            if (state is WalletRequestLoaded) {
              walletRequest = state.walletRequest;
            } else {
              final previousState = context.read<WalletRequestCubit>().state;
              if (previousState is WalletRequestLoaded) {
                walletRequest = previousState.walletRequest;
              }
            }

            if (walletRequest == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final isLoading = state is WalletRequestReviewLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Form
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              walletRequest.requestTypeText,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E88E5),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildInfoRow(
                              'البوابة',
                              walletRequest.walletProviderText,
                            ),
                            const SizedBox(height: 24),
                            _buildInfoRow(
                              'رقم الموبيل',
                              walletRequest.mobileNumber,
                            ),
                            const SizedBox(height: 24),
                            _buildInfoRow(
                              'المبلغ',
                              '${walletRequest.amount} جنيه',
                            ),
                            if (walletRequest.withdrawalReason != null) ...[
                              const SizedBox(height: 24),
                              _buildInfoRow(
                                'السبب',
                                walletRequest.withdrawalReason!,
                              ),
                            ],
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<WalletRequestCubit>()
                                            .reviewWalletRequest(
                                              requestId: walletRequest!.id,
                                              isApproved: true,
                                              requestType:
                                                  walletRequest.requestType,
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E88E5),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'اضافة رصيد',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Right side - Receipt Image
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child:
                            walletRequest.imageURL != null &&
                                walletRequest.imageURL!.isNotEmpty
                            ? WebImageDisplay(
                                imageUrl: walletRequest.imageURL!,
                                fit: BoxFit.cover,
                                errorWidget: _buildNoImageWidget(),
                              )
                            : _buildNoImageWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoImageWidget() {
    return Container(
      height: 600,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'لا توجد صورة إيصال',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
