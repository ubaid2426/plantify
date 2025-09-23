import 'package:flutter/material.dart';


class Branches extends StatefulWidget {
  const Branches({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBranchDetails(
      String address, String phoneNumber, String mapLink) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                phoneNumber,
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.map, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "Location on map",
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(
              child: Text("Google Map Placeholder"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        //      leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(Icons.arrow_back),
        // ),
        title: const Text("Pakistan Branch"),
       flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF33A248),
                Color(0xFFB2EA50),
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            // Tab(text: "The Headquarter (Hawally)"),
            // Tab(text: "Kawait"),
            Tab(text: "Pakistan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // buildBranchDetails(
          //   "3rd Ring Road, Opposite Qadisiya, Block: 212, St. Mosa Ibin Naseer, Near Al-Wazan Masjid, Hawalli, Kuwait.",
          //   "00965 1866 888",
          //   "Hawalli Location",
          // ),
          // buildBranchDetails(
          //   "Al-Rawdah Address, Kuwait",
          //   "00965 1234 5678",
          //   " Location",
          // ),
          buildBranchDetails(
            "Lahore Address, Pakistan",
            "00965 8765 4321",
            "Khaitan Location",
          ),
        ],
      ),
    );
  }
}
