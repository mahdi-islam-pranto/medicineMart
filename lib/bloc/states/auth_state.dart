import 'package:equatable/equatable.dart';
import '../../models/models.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking if user is already logged in
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when user is authenticated and approved
class AuthAuthenticated extends AuthState {
  final User user;
  final String? token;

  const AuthAuthenticated({
    required this.user,
    this.token,
  });

  @override
  List<Object?> get props => [user, token];
}

/// State when user is registered but waiting for admin approval
class AuthPendingApproval extends AuthState {
  final User user;

  const AuthPendingApproval({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user account has been rejected
class AuthRejected extends AuthState {
  final User user;
  final String? reason;

  const AuthRejected({
    required this.user,
    this.reason,
  });

  @override
  List<Object?> get props => [user, reason];
}

/// State when user account has been suspended
class AuthSuspended extends AuthState {
  final User user;
  final String? reason;

  const AuthSuspended({
    required this.user,
    this.reason,
  });

  @override
  List<Object?> get props => [user, reason];
}

/// State when login is in progress
class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

/// State when registration is in progress
class AuthRegistrationLoading extends AuthState {
  const AuthRegistrationLoading();
}

/// State when login fails
class AuthLoginError extends AuthState {
  final String message;

  const AuthLoginError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when registration fails
class AuthRegistrationError extends AuthState {
  final String message;
  final List<String>? validationErrors;

  const AuthRegistrationError({
    required this.message,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [message, validationErrors];
}

/// State when registration is successful
class AuthRegistrationSuccess extends AuthState {
  final User user;
  final String message;

  const AuthRegistrationSuccess({
    required this.user,
    required this.message,
  });

  @override
  List<Object?> get props => [user, message];
}

/// State when logout is in progress
class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();
}

/// Extension to provide helper methods for auth states
extension AuthStateExtension on AuthState {
  /// Returns true if the user is authenticated and can access the app
  bool get isAuthenticated {
    return this is AuthAuthenticated;
  }

  /// Returns true if the user is waiting for approval
  bool get isPendingApproval {
    return this is AuthPendingApproval;
  }

  /// Returns true if the user is rejected or suspended
  bool get isBlocked {
    return this is AuthRejected || this is AuthSuspended;
  }

  /// Returns true if any loading state is active
  bool get isLoading {
    return this is AuthLoading || 
           this is AuthLoginLoading || 
           this is AuthRegistrationLoading ||
           this is AuthLogoutLoading;
  }

  /// Returns true if there's an error state
  bool get hasError {
    return this is AuthLoginError || this is AuthRegistrationError;
  }

  /// Returns the current user if available
  User? get user {
    if (this is AuthAuthenticated) {
      return (this as AuthAuthenticated).user;
    } else if (this is AuthPendingApproval) {
      return (this as AuthPendingApproval).user;
    } else if (this is AuthRejected) {
      return (this as AuthRejected).user;
    } else if (this is AuthSuspended) {
      return (this as AuthSuspended).user;
    } else if (this is AuthRegistrationSuccess) {
      return (this as AuthRegistrationSuccess).user;
    }
    return null;
  }

  /// Returns error message if in error state
  String? get errorMessage {
    if (this is AuthLoginError) {
      return (this as AuthLoginError).message;
    } else if (this is AuthRegistrationError) {
      return (this as AuthRegistrationError).message;
    }
    return null;
  }
}
