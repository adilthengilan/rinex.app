import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
const _bg = Color(0xFF0F0F0F);
const _surface = Color(0xFF1C1C1E);
const _surfaceHigh = Color(0xFF2C2C2E);
const _blue = Color(0xFF2979FF);
const _blueGlow = Color(0x332979FF);
const _white = Colors.white;
const _white70 = Colors.white70;
const _white38 = Colors.white38;
const _divider = Color(0xFF3A3A3C);

TextStyle get _headingStyle => const TextStyle(
  color: _white,
  fontSize: 30,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.5,
  height: 1.2,
);

TextStyle get _subStyle => const TextStyle(
  color: _white70,
  fontSize: 15,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

InputDecoration _inputDeco(String hint, {Widget? suffix, Widget? prefix}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _white38, fontSize: 15),
      filled: true,
      fillColor: _surface,
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _divider, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: _blue, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
    );

Widget _primaryButton({
  required String label,
  required VoidCallback? onTap,
  bool loading = false,
}) => SizedBox(
  width: double.infinity,
  height: 56,
  child: ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: _blue,
      disabledBackgroundColor: _blue.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
    ),
    child: loading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(color: _white, strokeWidth: 2.5),
          )
        : Text(
            label,
            style: const TextStyle(
              color: _white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
  ),
);

Widget _socialButton({
  required String label,
  required Widget icon,
  required VoidCallback? onTap,
}) => SizedBox(
  width: double.infinity,
  height: 52,
  child: OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: _divider, width: 1.2),
      backgroundColor: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: _white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  ),
);

Widget _dividerRow() => Row(
  children: [
    const Expanded(child: Divider(color: _divider)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'OR',
        style: TextStyle(
          color: _white38,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),
    const Expanded(child: Divider(color: _divider)),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// AUTH SERVICE (thin wrapper — wire real Firebase logic here)
// ─────────────────────────────────────────────────────────────────────────────
class _AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Returns true if a user document exists in Firestore for this identifier.
  static Future<bool> userExists(String identifier) async {
    final q = await _db
        .collection('users')
        .where('identifier', isEqualTo: identifier.trim().toLowerCase())
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  /// Create user doc after successful auth.
  static Future<void> createUserDoc({
    required String uid,
    required String name,
    required String identifier,
    required String method, // 'email' | 'phone' | 'google' | 'apple'
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'identifier': identifier.trim().toLowerCase(),
      'method': method,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Google Sign-In
  static Future<UserCredential?> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. LOGIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _checkingUser = false;
  // null = not checked, true = exists, false = not found
  bool? _userExists;
  String _errorMsg = '';
  // 'phone' or 'email'
  String _mode = 'email';

  bool get _isPhone =>
      _mode == 'phone' ||
      RegExp(r'^\+?[0-9\s\-]{7,}$').hasMatch(_identifierCtrl.text.trim());

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkUser() async {
    final val = _identifierCtrl.text.trim();
    if (val.isEmpty) return;
    setState(() {
      _checkingUser = true;
      _errorMsg = '';
      _userExists = null;
    });
    final exists = await _AuthService.userExists(val);
    setState(() {
      _userExists = exists;
      _checkingUser = false;
      if (!exists) {
        _errorMsg = 'No account found. Please sign up first.';
      }
    });
  }

  Future<void> _login() async {
    final id = _identifierCtrl.text.trim();
    final pass = _passCtrl.text;
    if (id.isEmpty || pass.isEmpty) {
      setState(() => _errorMsg = 'Please fill all fields.');
      return;
    }
    setState(() {
      _loading = true;
      _errorMsg = '';
    });
    try {
      // Phone login → send OTP, then verify
      if (_isPhone) {
        _navigateToOtp(phone: id, isLogin: true, name: '', password: pass);
        return;
      }
      // Email login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/navigation', (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMsg = _friendlyError(e.code));
    } catch (e) {
      setState(() => _errorMsg = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _navigateToOtp({
    required String phone,
    required bool isLogin,
    required String name,
    required String password,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          phone: phone,
          isLogin: isLogin,
          name: name,
          password: password,
        ),
      ),
    );
  }

  Future<void> _googleLogin() async {
    setState(() => _loading = true);
    try {
      final cred = await _AuthService.googleSignIn();
      if (cred == null) return;
      final user = cred.user!;
      final exists = await _AuthService.userExists(user.email ?? user.uid);
      if (!exists) {
        // Auto-create doc for Google users
        await _AuthService.createUserDoc(
          uid: user.uid,
          name: user.displayName ?? 'User',
          identifier: user.email ?? user.uid,
          method: 'google',
        );
      }
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/navigation', (r) => false);
      }
    } catch (e) {
      setState(() => _errorMsg = 'Google sign-in failed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Logo / Brand
              _BrandMark(),

              const SizedBox(height: 36),

              Text('Welcome back', style: _headingStyle),
              const SizedBox(height: 8),
              Text('Sign in to continue to Rinex', style: _subStyle),

              const SizedBox(height: 36),

              // Toggle: Email / Phone
              _SegmentToggle(
                selected: _mode,
                onChanged: (v) {
                  setState(() {
                    _mode = v;
                    _identifierCtrl.clear();
                    _userExists = null;
                    _errorMsg = '';
                  });
                },
              ),

              const SizedBox(height: 20),

              // Identifier field
              TextField(
                controller: _identifierCtrl,
                keyboardType: _mode == 'phone'
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                style: const TextStyle(color: _white, fontSize: 15),
                onSubmitted: (_) => _checkUser(),
                onChanged: (_) {
                  if (_userExists != null) {
                    setState(() {
                      _userExists = null;
                      _errorMsg = '';
                    });
                  }
                },
                decoration: _inputDeco(
                  _mode == 'phone' ? '+971 50 000 0000' : 'email@example.com',
                  prefix: Icon(
                    _mode == 'phone'
                        ? Icons.phone_android
                        : Icons.email_outlined,
                    color: _white38,
                    size: 20,
                  ),
                  suffix: _checkingUser
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: _blue,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : _userExists == null
                      ? null
                      : Icon(
                          _userExists! ? Icons.check_circle : Icons.cancel,
                          color: _userExists! ? Colors.green : Colors.redAccent,
                          size: 22,
                        ),
                ),
              ),

              // Password field (shown after identifier confirmed to exist)
              if (_userExists == true) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: _white, fontSize: 15),
                  decoration: _inputDeco(
                    'Password',
                    prefix: const Icon(
                      Icons.lock_outline,
                      color: _white38,
                      size: 20,
                    ),
                    suffix: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _white38,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
              ],

              if (_errorMsg.isNotEmpty) ...[
                const SizedBox(height: 12),
                _ErrorBanner(message: _errorMsg, isInfo: _userExists == false),
              ],

              const SizedBox(height: 24),

              // Action button
              _userExists == null
                  ? _primaryButton(
                      label: 'Continue',
                      onTap: _loading ? null : _checkUser,
                      loading: _loading,
                    )
                  : _userExists!
                  ? _primaryButton(
                      label: _isPhone ? 'Send OTP' : 'Login',
                      onTap: _loading ? null : _login,
                      loading: _loading,
                    )
                  : _primaryButton(
                      label: 'Create Account',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignUpScreen(
                            prefill: _identifierCtrl.text.trim(),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 28),
              _dividerRow(),
              const SizedBox(height: 24),

              // Social buttons
              _socialButton(
                label: 'Continue with Google',
                icon: _GoogleIcon(),
                onTap: _loading ? null : _googleLogin,
              ),
              const SizedBox(height: 12),
              _socialButton(
                label: 'Continue with Apple',
                icon: const Icon(Icons.apple, color: _white, size: 22),
                onTap: () {
                  // Wire Apple Sign In here
                },
              ),

              const SizedBox(height: 32),

              // Sign up prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: _subStyle),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: _blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Terms
              Center(
                child: Text(
                  'By continuing you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _white38, fontSize: 12, height: 1.5),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. SIGN UP SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class SignUpScreen extends StatefulWidget {
  final String prefill;
  const SignUpScreen({Key? key, this.prefill = ''}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _identifierCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String _errorMsg = '';
  String _mode = 'email';

  bool get _isPhone =>
      _mode == 'phone' ||
      RegExp(r'^\+?[0-9\s\-]{7,}$').hasMatch(_identifierCtrl.text.trim());

  @override
  void initState() {
    super.initState();
    _identifierCtrl.text = widget.prefill;
    // Auto-detect mode from prefill
    if (widget.prefill.isNotEmpty && !widget.prefill.contains('@')) {
      _mode = 'phone';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _identifierCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_nameCtrl.text.trim().isEmpty) return 'Please enter your name.';
    if (_nameCtrl.text.trim().length < 2) return 'Name is too short.';
    final id = _identifierCtrl.text.trim();
    if (id.isEmpty) return 'Please enter your email or phone.';
    if (!_isPhone && !id.contains('@')) return 'Enter a valid email address.';
    if (_passCtrl.text.length < 6)
      return 'Password must be at least 6 characters.';
    if (_passCtrl.text != _confirmPassCtrl.text)
      return 'Passwords do not match.';
    return null;
  }

  Future<void> _proceed() async {
    final err = _validate();
    if (err != null) {
      setState(() => _errorMsg = err);
      return;
    }

    final id = _identifierCtrl.text.trim();
    final alreadyExists = await _AuthService.userExists(id);
    if (alreadyExists) {
      setState(
        () => _errorMsg = 'An account already exists. Please log in instead.',
      );
      return;
    }

    if (_isPhone) {
      // Go to OTP for phone sign-up
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            phone: id,
            isLogin: false,
            name: _nameCtrl.text.trim(),
            password: _passCtrl.text,
          ),
        ),
      );
    } else {
      // Email sign-up
      setState(() {
        _loading = true;
        _errorMsg = '';
      });
      try {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: id,
          password: _passCtrl.text,
        );
        await cred.user!.updateDisplayName(_nameCtrl.text.trim());
        await _AuthService.createUserDoc(
          uid: cred.user!.uid,
          name: _nameCtrl.text.trim(),
          identifier: id,
          method: 'email',
        );
        // Send verification email (optional)
        await cred.user!.sendEmailVerification();
        if (mounted) {
          _showVerifyEmailDialog();
        }
      } on FirebaseAuthException catch (e) {
        setState(() => _errorMsg = _friendlyError(e.code));
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Verify your email',
          style: TextStyle(color: _white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'A verification link has been sent to ${_identifierCtrl.text.trim()}. '
          'You can proceed to the app — verify at your convenience.',
          style: _subStyle,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/navigation', (r) => false);
            },
            child: const Text('Continue', style: TextStyle(color: _white)),
          ),
        ],
      ),
    );
  }

  Future<void> _googleSignUp() async {
    setState(() => _loading = true);
    try {
      final cred = await _AuthService.googleSignIn();
      if (cred == null) return;
      final user = cred.user!;
      await _AuthService.createUserDoc(
        uid: user.uid,
        name: user.displayName ?? 'User',
        identifier: user.email ?? user.uid,
        method: 'google',
      );
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/navigation', (r) => false);
      }
    } catch (e) {
      setState(() => _errorMsg = 'Google sign-up failed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      default:
        return 'Sign-up failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Text('Create account', style: _headingStyle),
              const SizedBox(height: 8),
              Text('Join the Rinex community today', style: _subStyle),

              const SizedBox(height: 32),

              // Name
              TextField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: _white, fontSize: 15),
                decoration: _inputDeco(
                  'Full Name',
                  prefix: const Icon(
                    Icons.person_outline_rounded,
                    color: _white38,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Mode toggle
              _SegmentToggle(
                selected: _mode,
                onChanged: (v) => setState(() {
                  _mode = v;
                  _identifierCtrl.clear();
                  _errorMsg = '';
                }),
              ),

              const SizedBox(height: 14),

              // Identifier
              TextField(
                controller: _identifierCtrl,
                keyboardType: _mode == 'phone'
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
                style: const TextStyle(color: _white, fontSize: 15),
                decoration: _inputDeco(
                  _mode == 'phone' ? '+971 50 000 0000' : 'email@example.com',
                  prefix: Icon(
                    _mode == 'phone'
                        ? Icons.phone_android
                        : Icons.email_outlined,
                    color: _white38,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Password
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                style: const TextStyle(color: _white, fontSize: 15),
                decoration: _inputDeco(
                  'Password (min. 6 characters)',
                  prefix: const Icon(
                    Icons.lock_outline,
                    color: _white38,
                    size: 20,
                  ),
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _white38,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Confirm password
              TextField(
                controller: _confirmPassCtrl,
                obscureText: _obscureConfirm,
                style: const TextStyle(color: _white, fontSize: 15),
                decoration: _inputDeco(
                  'Confirm Password',
                  prefix: const Icon(
                    Icons.lock_outline,
                    color: _white38,
                    size: 20,
                  ),
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _white38,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),

              if (_errorMsg.isNotEmpty) ...[
                const SizedBox(height: 12),
                _ErrorBanner(message: _errorMsg),
              ],

              const SizedBox(height: 24),

              _primaryButton(
                label: _isPhone ? 'Send OTP & Verify' : 'Create Account',
                onTap: _loading ? null : _proceed,
                loading: _loading,
              ),

              const SizedBox(height: 28),
              _dividerRow(),
              const SizedBox(height: 24),

              _socialButton(
                label: 'Sign up with Google',
                icon: _GoogleIcon(),
                onTap: _loading ? null : _googleSignUp,
              ),
              const SizedBox(height: 12),
              _socialButton(
                label: 'Sign up with Apple',
                icon: const Icon(Icons.apple, color: _white, size: 22),
                onTap: () {
                  // Wire Apple Sign In here
                },
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: _subStyle),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: _blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. OTP SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isLogin;
  final String name;
  final String password;

  const OtpScreen({
    Key? key,
    required this.phone,
    required this.isLogin,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _ctrlrs = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  bool _sending = true;
  String _verificationId = '';
  String _errorMsg = '';
  int _resendSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _sendOtp();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (final c in _ctrlrs) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendSeconds--;
        if (_resendSeconds <= 0) _canResend = true;
      });
      return _resendSeconds > 0;
    });
  }

  Future<void> _sendOtp() async {
    setState(() {
      _sending = true;
      _errorMsg = '';
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verify (Android only)
        await _signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          setState(() {
            _sending = false;
            _errorMsg = 'Failed to send OTP: ${e.message}';
          });
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _sending = false;
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _ctrlrs.map((c) => c.text).join();
    if (otp.length < 6) {
      setState(() => _errorMsg = 'Please enter the complete 6-digit OTP.');
      return;
    }
    setState(() {
      _loading = true;
      _errorMsg = '';
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
        _errorMsg = e.code == 'invalid-verification-code'
            ? 'Incorrect OTP. Please try again.'
            : 'Verification failed. Try again.';
      });
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    final userCred = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final user = userCred.user!;

    if (!widget.isLogin) {
      // New sign-up: save user doc & set display name
      await user.updateDisplayName(widget.name);
      await _AuthService.createUserDoc(
        uid: user.uid,
        name: widget.name,
        identifier: widget.phone,
        method: 'phone',
      );
    }

    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/navigation', (r) => false);
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    // Auto-verify when all 6 digits entered
    final filled = _ctrlrs.every((c) => c.text.isNotEmpty);
    if (filled) _verifyOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Text('Verify phone', style: _headingStyle),
              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  style: _subStyle,
                  children: [
                    const TextSpan(text: 'Enter the 6-digit code sent to\n'),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        color: _white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 44),

              if (_sending) ...[
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: _blue),
                      SizedBox(height: 16),
                      Text(
                        'Sending OTP…',
                        style: TextStyle(color: _white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return _OtpBox(
                      controller: _ctrlrs[i],
                      focusNode: _focusNodes[i],
                      onChanged: (v) => _onDigitChanged(i, v),
                    );
                  }),
                ),

                if (_errorMsg.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _ErrorBanner(message: _errorMsg),
                ],

                const SizedBox(height: 36),

                _primaryButton(
                  label: 'Verify',
                  onTap: _loading ? null : _verifyOtp,
                  loading: _loading,
                ),

                const SizedBox(height: 24),

                // Resend
                Center(
                  child: _canResend
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _canResend = false;
                              _resendSeconds = 60;
                              for (final c in _ctrlrs) c.clear();
                            });
                            _sendOtp();
                            _startResendTimer();
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: _blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : Text(
                          'Resend in ${_resendSeconds}s',
                          style: const TextStyle(color: _white38, fontSize: 14),
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SMALL WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          color: _white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: _surface,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _divider, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: _blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _SegmentToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ['email', 'phone'].map((v) {
          final active = selected == v;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: active ? _blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    v == 'email' ? 'Email' : 'Phone',
                    style: TextStyle(
                      color: active ? _white : _white38,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool isInfo;

  const _ErrorBanner({required this.message, this.isInfo = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isInfo
            ? const Color(0xFF1A2744)
            : Colors.redAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInfo
              ? _blue.withOpacity(0.5)
              : Colors.redAccent.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isInfo ? Icons.info_outline_rounded : Icons.error_outline_rounded,
            color: isInfo ? _blue : Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isInfo ? _blue : Colors.redAccent,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _blue,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _blue.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'R',
              style: TextStyle(
                color: _white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Rinex',
          style: TextStyle(
            color: _white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Simplified G icon using text
    final tp = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
