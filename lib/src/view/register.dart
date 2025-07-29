import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          SizedBox(height: screenHeight * 0.25), // Approximately 25% of screen height for blue area

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
                    // Register Title
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: screenWidth * 0.065, // Adjust font size based on screen width
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748), // Dark text color
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04), // Spacing below title

                    // First name input
                    Text(
                      'First name',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildTextField(_firstNameController, 'First name', screenWidth),
                    SizedBox(height: screenHeight * 0.02), // Spacing between fields

                    // Last name input
                    Text(
                      'Last name',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildTextField(_lastNameController, 'Last name', screenWidth),
                    SizedBox(height: screenHeight * 0.02),

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
                    SizedBox(height: screenHeight * 0.02),

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
                    SizedBox(height: screenHeight * 0.04), // Spacing before register button

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: screenWidth * 0.13, // Consistent height for buttons
                      child: ElevatedButton(
                        onPressed: () {
                          print('Register button pressed');
                          print('First Name: ${_firstNameController.text}');
                          print('Last Name: ${_lastNameController.text}');
                          print('Email: ${_emailController.text}');
                          print('Password: ${_passwordController.text}');
                          // Implement registration logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6), // Blue background
                          foregroundColor: Colors.white, // White text
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.13 / 2),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Spacing below register button

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

                    // Social login icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(Icons.g_mobiledata_outlined, Colors.blueGrey, screenWidth), // Google
                        SizedBox(width: screenWidth * 0.05),
                        _buildSocialIcon(Icons.apple, Colors.black, screenWidth), // Apple
                        SizedBox(width: screenWidth * 0.05),
                        _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2), screenWidth), // Facebook
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
        // Implement social login logic here
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