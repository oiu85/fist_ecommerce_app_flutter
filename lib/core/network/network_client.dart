import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../config/api_config.dart';
import '../storage/app_storage_service.dart';


class NetworkFailure {
  final String message;
  final int? statusCode;
  final DioExceptionType? errorType;

  const NetworkFailure({
    required this.message,
    this.statusCode,
    this.errorType,
  });

  @override
  String toString() => message;
}

@singleton
class NetworkClient {
  final Dio _dio;
  final AppStorageService _storageService;

  NetworkClient(this._storageService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    // Add authentication interceptor to include token in headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from storage
          final token = await _storageService.getAccessToken();
          
          // Add Authorization header if token exists
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized - token might be expired
          if (error.response?.statusCode == 401) {
            // Could trigger logout or token refresh here
            if (kDebugMode) {
              debugPrint('Unauthorized: Token may be expired or invalid');
            }
          }
          return handler.next(error);
        },
      ),
    );

    //! Add pretty_dio_logger interceptor for network logging
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
          enabled: kDebugMode,
          // Limit response body to 500 characters
          logPrint: (object) {
            final logString = object.toString();
            if (logString.length > 1000) {
              debugPrint('${logString.substring(0, 500)}... [TRUNCATED - ${logString.length} chars total]');
            } else {
              debugPrint(logString);
            }
          },
        ),
      );
    }
  }

  //* Performs a GET request
  Future<Either<NetworkFailure, Response>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final urlValidation = _validateUrl(url);
    if (urlValidation != null) {
      return Left(urlValidation);
    }

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  //* Performs a POST request
  Future<Either<NetworkFailure, Response>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final urlValidation = _validateUrl(url);
    if (urlValidation != null) {
      return Left(urlValidation);
    }

    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  //* Performs a PUT request
  Future<Either<NetworkFailure, Response>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final urlValidation = _validateUrl(url);
    if (urlValidation != null) {
      return Left(urlValidation);
    }

    try {
      final response = await _dio.put(url, data: data, queryParameters: queryParameters);
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  //* Performs a PATCH request
  Future<Either<NetworkFailure, Response>> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final urlValidation = _validateUrl(url);
    if (urlValidation != null) {
      return Left(urlValidation);
    }

    try {
      final response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  //* Performs a DELETE request
  Future<Either<NetworkFailure, Response>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final urlValidation = _validateUrl(url);
    if (urlValidation != null) {
      return Left(urlValidation);
    }

    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(NetworkFailure(
        message: 'Unexpected error: ${e.toString()}',
      ));
    }
  }

  NetworkFailure? _validateUrl(String url) {
    if (url.isEmpty) {
      return const NetworkFailure(message: 'URL cannot be empty');
    }
    return null;
  }

  NetworkFailure _handleDioError(DioException error) {
    if (kDebugMode) {
      debugPrint('Network Error: ${error.message}');
      debugPrint('Error Type: ${error.type}');
      debugPrint('Status Code: ${error.response?.statusCode}');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
          errorType: error.type,
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection available.',
          errorType: error.type,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        // Extract error message from response
        String errorMessage = 'Unknown error';
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] as String? ?? 
                        responseData['error'] as String? ?? 
                        'Server error occurred';
        } else if (responseData is String) {
          errorMessage = responseData;
        }
        
        return NetworkFailure(
          message: 'Server error: $statusCode - $errorMessage',
          statusCode: statusCode,
          errorType: error.type,
        );
      default:
        return NetworkFailure(
          message: error.message ?? 'An unknown network error occurred',
          errorType: error.type,
        );
    }
  }
}
