import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SouqBasrahApp());
}

class SouqBasrahApp extends StatelessWidget {
  const SouqBasrahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سوق البصرة',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
      ),
      home: const SplashScreen(),
    );
  }
}

// 1. شاشة الدخول المتحركة (Splash Screen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StoreHomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF00665C),
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront,
                      size: 60,
                      color: Color(0xFF00665C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'سوق البصرة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'سوقك المحلي الأول لكل ما تحتاج',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 2. الصفحة الرئيسية للتطبيق
class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  int _currentIndex = 0;

  // دالة لإضافة إعلان جديد إلى Cloud Firestore
  void _addNewAdModal(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'إضافة إعلان جديد لسوق البصرة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان الإعلان (مثلاً: جهاز آيفون)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'السعر (مثلاً: 350,000 د.ع)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00665C),
                ),
                onPressed: () async {
                  if (titleController.text.isNotEmpty) {
                    await FirebaseFirestore.instance.collection('ads').add({
                      'title': titleController.text,
                      'price': priceController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'نشر الإعلان أونلاين',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // تبويب الرئيسية
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('🇮🇶', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'إبحث في سوق البصرة...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 95,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(width: 12),
                StoryItem(title: 'متاجر مميزة', icon: Icons.store),
                StoryItem(title: 'عروض اليوم', icon: Icons.local_offer),
                StoryItem(title: 'سيارات', icon: Icons.directions_car),
                StoryItem(title: 'عقارات', icon: Icons.home),
                StoryItem(title: 'هواتف', icon: Icons.phone_android),
                StoryItem(title: 'وظائف', icon: Icons.work),
                StoryItem(title: 'أزياء', icon: Icons.checkroom),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF00B09B), Color(0xFF96C93D)],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'أهلاً بك في سوق البصرة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'كل ما تبحث عنه من عقارات، سيارات، وموبايل تجده هنا.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المزيد',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'الأقسام',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.82,
              children: const [
                CategoryGridItem(title: 'عقارات للبيع', icon: Icons.apartment),
                CategoryGridItem(
                  title: 'دراجات نارية',
                  icon: Icons.two_wheeler,
                ),
                CategoryGridItem(
                  title: 'سيارات ومركبات',
                  icon: Icons.directions_car,
                ),
                CategoryGridItem(title: 'المتاجر', icon: Icons.storefront),
                CategoryGridItem(
                  title: 'موبايل وتابلت',
                  icon: Icons.phone_android,
                ),
                CategoryGridItem(title: 'الخدمات', icon: Icons.build),
                CategoryGridItem(
                  title: 'وظائف شاغرة',
                  icon: Icons.work_outline,
                ),
                CategoryGridItem(
                  title: 'عقارات للإيجار',
                  icon: Icons.home_work,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'إعلانات سوق البصرة (أونلاين)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('ads').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'لا توجد إعلانات مضافة حتى الآن. أضف إعلانك الأول!',
                  ),
                );
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_bag,
                        color: Color(0xFF00665C),
                      ),
                      title: Text(data['title'] ?? ''),
                      subtitle: Text(data['price'] ?? ''),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // تبويب إعلاناتي
  Widget _buildMyAdsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ads').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('لا توجد إعلانات خاصة بك.'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final docId = docs[index].id;
            return ListTile(
              leading: const Icon(Icons.article, color: Color(0xFF00665C)),
              title: Text(data['title'] ?? ''),
              subtitle: Text(data['price'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('ads')
                      .doc(docId)
                      .delete();
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeTab(),
      const Center(
        child: Text(
          '💬 الرسائل والدردشات',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox.shrink(), // مكان زر الإضافة الوسطي
      _buildMyAdsTab(),
      const Center(
        child: Text(
          '👤 حساب المستخدم',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'سوق البصرة',
            style: TextStyle(
              color: Color(0xFF00665C),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex > 2 ? _currentIndex - 1 : _currentIndex,
          onTap: (index) {
            if (index == 2) {
              _addNewAdModal(context);
            } else {
              setState(() {
                _currentIndex = index >= 2 ? index + 1 : index;
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00665C),
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'دردشاتي',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
              label: 'أضف إعلان',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'إعلاناتي',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const StoryItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00665C), width: 2),
              color: Colors.teal.shade50,
            ),
            child: Icon(icon, color: const Color(0xFF00665C), size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const CategoryGridItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CategoryGridItemContent(title: title, icon: icon);
  }
}

class CategoryGridItemContent extends StatelessWidget {
  final String title;
  final IconData icon;
  const CategoryGridItemContent({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: const Color(0xFF00665C)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
