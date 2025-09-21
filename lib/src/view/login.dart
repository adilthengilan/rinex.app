import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  // Authentication methods
  Future<void> authenticateWithPhone() async {
    setState(() {
      isLoading = true;
    });
    
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isLoading = false;
    });
    
    // Show success message
    _showSuccessSnackBar('Phone authentication successful!');
    
    // Navigate to next screen or handle success
    // Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> authenticateWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isLoading = false;
    });
    
    _showSuccessSnackBar('Google authentication successful!');
    
    // Add your Google Sign-In logic here
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignInAccount? account = await googleSignIn.signIn();
  }

  Future<void> authenticateWithApple() async {
    setState(() {
      isLoading = true;
    });
    
    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      isLoading = false;
    });
    
    _showSuccessSnackBar('Apple authentication successful!');
    
    // Add your Apple Sign-In logic here
    // final credential = await SignInWithApple.getAppleIDCredential();
  }

  

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E88E5),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // App Logo/Brand Image
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/renex.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Welcome Text
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Subtitle
                    Text(
                      'The trusted community of\nbuyers and sellers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Login Buttons
                    _buildLoginButton(
                      icon: Icons.phone,
                      text: 'Continue with Phone',
                      onPressed: authenticateWithPhone,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildLoginButton(
                      icon: Icons.g_mobiledata,
                      text: 'Continue with Google',
                      onPressed: authenticateWithGoogle,
                    ),
                    
                    const SizedBox(height: 15),
                    
                    _buildLoginButton(
                      icon: Icons.apple,
                      text: 'Sign in with Apple',
                      onPressed: authenticateWithApple,
                      isApple: true,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // OR Divider
                    Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Email Login
                    GestureDetector(
                      // onTap: authenticateWithEmail,
                      child: const Text(
                        'Login with Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Terms and Conditions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'If You Continue You Are Accepting\nTerms And Conditions And Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading Overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.8),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    bool isApple = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isApple 
              ? Colors.white.withOpacity(0.9) 
              : Colors.white.withOpacity(0.1),
          foregroundColor: isApple ? Colors.black : Colors.white,
          side: BorderSide(
            color: isApple 
                ? Colors.white.withOpacity(0.9) 
                : Colors.white.withOpacity(0.3),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
