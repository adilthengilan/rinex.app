import 'package:estate_/src/view/screens/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle login
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simple email validation
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // For demo purposes, accept any valid email and password
    // In a real app, you would validate against your backend
    print('Login attempt - Email: $email, Password: $password');
    
    // Navigate to HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3B82F6), // Blue background for the top part
      body: Column(
        children: [
          // Top blue section (adjust height as needed)
          SizedBox(height: screenHeight * 0.35), // Approximately 35% of screen height for blue area

          // White container for the form
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08, // 8% of screen width for horizontal padding
                  vertical: screenHeight * 0.04, // 4% of screen height for vertical padding
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Log In Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: screenWidth * 0.065, // Adjust font size based on screen width
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748), // Dark text color
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04), // Spacing below title

                    // Email Address input
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildTextField(_emailController, 'Email', screenWidth, keyboardType: TextInputType.emailAddress),
                    SizedBox(height: screenHeight * 0.02), // Spacing between fields

                    // Password input
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildPasswordField(_passwordController, 'Password', screenWidth),
                    SizedBox(height: screenHeight * 0.04), // Spacing before login button

                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      height: screenWidth * 0.13, // Consistent height for buttons
                      child: ElevatedButton(
                        onPressed: _handleLogin, // Call the login handler
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6), // Blue background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.13 / 2),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Spacing below login button

                    // Or continue with text
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          color: const Color(0xFF9CA3AF), // Grey text color
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025), // Spacing above social icons

                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google
                        _buildSocialIcon(Icons.g_mobiledata_outlined, Colors.blueGrey, screenWidth),
                        SizedBox(width: screenWidth * 0.05), // Spacing between icons
                        // Apple
                        _buildSocialIcon(Icons.apple, Colors.black, screenWidth),
                        SizedBox(width: screenWidth * 0.05),
                        // Facebook
                        _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2), screenWidth),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a standard text field
  Widget _buildTextField(TextEditingController controller, String hintText, double screenWidth, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: screenWidth * 0.13, // Consistent height for text fields
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Light grey background
        borderRadius: BorderRadius.circular(screenWidth * 0.13 / 2),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1), // Light border
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF9CA3AF), fontSize: screenWidth * 0.04), // Grey hint text
          border: InputBorder.none, // Remove default border
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Adjust padding
        ),
        style: TextStyle(
          color: const Color(0xFF2D3748),
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  // Helper method to build a password field with toggle visibility
  Widget _buildPasswordField(TextEditingController controller, String hintText, double screenWidth) {
    return Container(
      height: screenWidth * 0.13,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(screenWidth * 0.13 / 2),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible, // Toggle visibility
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFF9CA3AF), fontSize: screenWidth * 0.04),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF9CA3AF), // Icon color
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          prefixIcon: Icon(
            Icons.lock_outline, // Key icon for password
            color: const Color(0xFF9CA3AF),
            size: screenWidth * 0.05,
          ),
        ),
        style: TextStyle(
          color: const Color(0xFF2D3748),
          fontSize: screenWidth * 0.04,
        ),
      ),
    );
  }

  // Helper method to build social media icons using built-in icons
  Widget _buildSocialIcon(IconData icon, Color iconColor, double screenWidth) {
    return GestureDetector(
      onTap: () {
        print('Social login pressed: $icon');
        // For social login, you could also navigate to home screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      child: Container(
        width: screenWidth * 0.15, // Size of the circular container for the icon
        height: screenWidth * 0.15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: screenWidth * 0.07, // Size of the icon itself
          ),
        ),
      ),
    );
  }
}