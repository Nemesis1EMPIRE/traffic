import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:chewie/chewie.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://msvbdururblzqnhyxfqz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zdmJkdXJ1cmJsenFuaHl4ZnF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE1ODcxNTYsImV4cCI6MjA1NzE2MzE1Nn0.en7ybyX9WmkCtghcb4_aOfQe_xkkBn8Z5Y5l0qpb4vE',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: SplashScreen(), // Ajout du Splash Screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () { // Délai de 4 secondes avant de passer à LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text(
                "TRAFFIC",
                style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (res.session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Text(
                    "Connexion",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Mot de passe", Icons.lock),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          onPressed: _signIn,
                          style: _buttonStyle(),
                          child: Text("Se connecter", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text("Créer un compte", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (res.user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Inscription",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Mot de passe", Icons.lock),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : ElevatedButton(
                          onPressed: _signUp,
                          style: _buttonStyle(),
                          child: Text("S'inscrire", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
    InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MoviesPage(),
    SearchPage(),
    FavoritesPage(),
    DownloadsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: Text("TRAFFIC", style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),),
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
     body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_selectedIndex], // Place _pages[_selectedIndex] comme enfant du Container
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purpleAccent, // Couleur de l'icône et du label sélectionnés
        unselectedItemColor: Colors.black, // Couleur des icônes et labels non sélectionnés
        showUnselectedLabels: true, // Afficher les labels même quand non sélectionnés
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Films"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Rechercher"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: "Téléchargements"),
        ],
      ),
    );
  }
}




class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Défilement automatique du carrousel
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeaturedCarousel(),
              _buildMoviesSection("Populaires"),
              _buildMoviesSection("Nouveautés"),
              _buildMoviesSection("Tendances"),
              _buildMoviesSection("Comédie"),
              _buildMoviesSection("Science Fiction"),
              _buildMoviesSection("Drame"),
              _buildMoviesSection("Thriller"),
              _buildMoviesSection("Action/Aventure"),
              _buildMoviesSection("Horreur"),
              _buildMoviesSection("Fantastique"),
              _buildMoviesSection("Animation"),
              _buildMoviesSection("Guerre"),
              _buildMoviesSection("Documentaire"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Container(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          Image.asset('assets/featured1.png', fit: BoxFit.cover),
          Image.asset('assets/featured2.png', fit: BoxFit.cover),
          Image.asset('assets/featured3.png', fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildMoviesSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                        movieTitle: "$title $index",
                        movieImage: 'assets/movie$index.png',
                        movieDescription: "Description du film $title $index...",
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/movie$index.png', width: 100, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// **Page de détails du film**
class MovieDetailPage extends StatefulWidget {
  final String movieTitle;
  final String movieImage;
  final String movieDescription;

  MovieDetailPage({
    required this.movieTitle,
    required this.movieImage,
    required this.movieDescription,
  });

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false; // État pour gérer le favori

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(widget.movieTitle),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(widget.movieImage, height: 250, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.movieTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              widget.movieDescription,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Regarder",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite; // Toggle du favori
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class VideoPage extends StatefulWidget {
  final String title; // Ajout du paramètre title
  
  VideoPage(this.title); // Constructeur prenant un titre en paramètre

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/film.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Text(widget.title, // Affichage du titre
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                VideoItem(
                  thumbnail: 'assets/movie.png',
                  title: "Film2",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoPage("Libreville Partie 2")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class VideoItem extends StatelessWidget {
  final String thumbnail;
  final String title;
  final VoidCallback onTap;

  VideoItem({required this.thumbnail, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(thumbnail, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Film2')),
      body: Center(child: Text('Vidéo 2 ici')), // Remplace par le player de la 2e vidéo
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _allItems = ["Vidéo 1", "Vidéo 2", "Vidéo 3", "Film A", "Film B", "Série X"];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
  }

  void _search(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _search,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Rechercher...",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun résultat",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _filteredItems[index],
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Icon(Icons.video_library, color: Colors.white),
                          onTap: () {
                            // Action lors du clic sur un élément
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Page des Favoris"),
    );
  }
}

class DownloadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Page des Téléchargements"),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paramètres")),
      body: Center(child: Text("Page des Paramètres")),
    );
  }
}
