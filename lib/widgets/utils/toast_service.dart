import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();

  void showToast(
    BuildContext context,
    String message, {
    required ToastificationType type,
    String? description,
  }) {
    toastification.show(
      context: context,
      title: Text(message),
      description: description != null ? Text(description) : null,
      type: type,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: true,
      style: ToastificationStyle.flatColored,
    );
  }
}
