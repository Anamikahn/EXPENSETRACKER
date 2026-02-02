import 'dart:ui';
import 'package:flutter/material.dart';
import 'add_expense_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B18),
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              _balanceCard(),
              const SizedBox(height: 16),
              _limitCard(),
              const SizedBox(height: 24),
              _quickInsights(),
              const SizedBox(height: 24),
              _recentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Good morning,",
                style: TextStyle(color: Colors.white54, fontSize: 14)),
            SizedBox(height: 4),
            Text("Guest👋",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.white),
        )
      ],
    );
  }

  // ---------------- BALANCE CARD ----------------
  Widget _balanceCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Available Balance",
              style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 8),
          const Text("₹42,550",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard("Income", "₹75,000", Colors.green),
              const SizedBox(width: 12),
              _statCard("Expenses", "₹32,450", Colors.red),
            ],
          )
        ],
      ),
    );
  }

  // ---------------- LIMIT CARD ----------------
  Widget _limitCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daily Spending Limit",
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.57,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor:
                const AlwaysStoppedAnimation(Color(0xFF2FE6D1)),
          ),
          const SizedBox(height: 8),
          const Text("₹650 remaining today",
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  // ---------------- QUICK INSIGHTS ----------------
  Widget _quickInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Insights",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.local_dining, color: Colors.orange),
                    SizedBox(height: 8),
                    Text("Highest Spending",
                        style: TextStyle(color: Colors.white54)),
                    SizedBox(height: 4),
                    Text("Food ₹8,500",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.pink),
                    SizedBox(height: 8),
                    Text("Most Active Day",
                        style: TextStyle(color: Colors.white54)),
                    SizedBox(height: 4),
                    Text("Saturday",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- TRANSACTIONS ----------------
  Widget _recentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Recent Transactions",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            Text("See all",
                style: TextStyle(color: Color(0xFF2FE6D1))),
          ],
        ),
        const SizedBox(height: 12),
        _transaction("Swiggy", "Food", "-₹450"),
        _transaction("Amazon", "Shopping", "-₹2,199"),
        _transaction("Uber", "Transport", "-₹180"),
      ],
    );
  }

  Widget _transaction(String title, String subtitle, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _glassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            Text(amount,
                style: const TextStyle(color: Colors.redAccent)),
          ],
        ),
      ),
    );
  }

  // ---------------- GLASS CARD ----------------
  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM NAV (UPDATED LOGIC) ----------------
  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: const Color(0xFF050B18),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2FE6D1),
      unselectedItemColor: Colors.white38,
      onTap: (index) {
        if (index == 2) {
          // ➕ OPEN ADD EXPENSE
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpensePage(),
            ),
          );
        } else {
          setState(() => _currentIndex = index);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Goals"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF2FE6D1),
            child: Icon(Icons.add, color: Color(0xFF061417)),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "Wishlist"),
        BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
      ],
    );
  }
}