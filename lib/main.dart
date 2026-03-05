import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const LottieVaultApp());
}

class LottieVaultApp extends StatelessWidget {
  const LottieVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
      ),
      home: const AnimationGridScreen(),
    );
  }
}

// --- MODELS ---
class AnimationModel {
  final String path;
  final String title;
  final String category;
  final bool isPremium;

  const AnimationModel({
    required this.path,
    required this.title,
    required this.category,
    required this.isPremium,
  });
}

// --- MAIN GRID SCREEN ---
class AnimationGridScreen extends StatefulWidget {
  const AnimationGridScreen({super.key});

  @override
  State<AnimationGridScreen> createState() => _AnimationGridScreenState();
}

class _AnimationGridScreenState extends State<AnimationGridScreen> {
  String selectedCategory = "All";
  String searchQuery = "";
  final List<String> categories = ["All", "Featured", "Icons", "Characters", "Business"];

  static const List<AnimationModel> animations = [
    AnimationModel(path: 'assets/animations/Animation.json', title: "Creative Flow", category: "Featured", isPremium: false),
    AnimationModel(path: 'assets/animations/Animation2.json', title: "Rocket Launch", category: "Business", isPremium: true),
    AnimationModel(path: 'assets/animations/Animations3.json', title: "Success Check", category: "Icons", isPremium: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Lottie Vault", style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85,
        ),
        itemCount: animations.length,
        itemBuilder: (context, index) => _buildCard(animations[index]),
      ),
    );
  }

  Widget _buildCard(AnimationModel item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimationDetailScreen(model: item))),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
        child: Column(
          children: [
            Expanded(child: Lottie.asset(item.path)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  if (item.isPremium) const Icon(Icons.bolt, size: 16, color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DETAIL SCREEN ---
class AnimationDetailScreen extends StatelessWidget {
  final AnimationModel model;
  const AnimationDetailScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0),
      body: Column(
        children: [
          Expanded(child: Center(child: Lottie.asset(model.path, width: 280))),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text("Professional Lottie asset with full commercial license."),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity, height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: model.isPremium ? Colors.black : const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => model.isPremium ? _showCheckout(context) : _handleDownload(context),
              child: Text(model.isPremium ? "GET PRO ACCESS" : "DOWNLOAD FREE", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDownload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading...")));
  }

  void _showCheckout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumCheckoutSheet(),
    );
  }
}

// --- PROFESSIONAL CHECKOUT SHEET ---
class PremiumCheckoutSheet extends StatelessWidget {
  const PremiumCheckoutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              const Text("Unlock Pro Assets", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const Text("Unlimited downloads and commercial license.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              _sectionTitle("1. Account Details"),
              _textField("Full Name", Icons.person_outline),
              _textField("Email Address", Icons.email_outlined),

              const SizedBox(height: 20),
              _sectionTitle("2. Payment Information"),
              _creditCardField(),
              Row(
                children: [
                  Expanded(child: _textField("MM/YY", Icons.calendar_today_outlined)),
                  const SizedBox(width: 16),
                  Expanded(child: _textField("CVC", Icons.lock_outline)),
                ],
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessDialog(context);
                  },
                  child: const Text("Confirm & Pay \$19.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: Text("🔒 Secure SSL Encrypted Payment", style: TextStyle(fontSize: 12, color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6366F1))),
  );

  Widget _textField(String hint, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20),
        hintText: hint,
        filled: true, fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    ),
  );

  Widget _creditCardField() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.credit_card),
        hintText: "0000 0000 0000 0000",
        suffixIcon: const Padding(padding: EdgeInsets.all(12), child: Text("VISA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
        filled: true, fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    ),
  );

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text("Payment Successful!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("You are now a Pro member.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Start Downloading")),
          ],
        ),
      ),
    );
  }
}