import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_brightness/flutter_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

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
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white), // Animation de chargement
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
       
        title: Text("Traffic", style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
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
class MovieDetailPage extends StatelessWidget {
  final String movieTitle;
  final String movieImage;
  final String movieDescription;

  MovieDetailPage({
    required this.movieTitle,
    required this.movieImage,
    required this.movieDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(movieTitle),
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
                child: Image.asset(movieImage, height: 250, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(
              movieTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              movieDescription,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      videoUrl: "https://msvbdururblzqnhyxfqz.supabase.co/storage/v1/object/sign/films/Download%20(5).mp4?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJmaWxtcy9Eb3dubG9hZCAoNSkubXA0IiwiaWF0IjoxNzQxNzIxMTU5LCJleHAiOjE3NDIzMjU5NTl9.u0_JszWtDmtIZz3v0yRfZWSZuC-__EiQ-fkAwNoIn6M", // Remplace avec ton URL
                    ),
                  ),
                );
              },
              child: Text("Regarder"),
            ),

          ],
        ),
      ),
    );
  }
}


class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  
  const VideoPlayerPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  double _brightness = 0.5;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Récupérer la luminosité et le volume actuels
    FlutterBrightness.getBrightness().then((value) {
      setState(() {
        _brightness = value ?? 0.5;
      });
    });

    FlutterVolumeController.getVolume().then((value) {
      setState(() {
        _volume = value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _seekForward() {
    final position = _controller.value.position + Duration(seconds: 5);
    _controller.seekTo(position);
  }

  void _seekBackward() {
    final position = _controller.value.position - Duration(seconds: 5);
    _controller.seekTo(position);
  }

  void _changeBrightness(double value) {
    setState(() {
      _brightness = value;
    });
    FlutterBrightness.setBrightness(value);
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
    });
    FlutterVolumeController.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),

          // Contrôles Vidéo
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.red,
                    bufferedColor: Colors.white70,
                    backgroundColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_5, color: Colors.white, size: 30),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_5, color: Colors.white, size: 30),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Barre de luminosité et volume
          Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                Icon(Icons.brightness_6, color: Colors.white),
                RotatedBox(
                  quarterTurns: -1,
                  child: Slider(
                    value: _brightness,
                    min: 0,
                    max: 1,
                    activeColor: Colors.yellow,
                    inactiveColor: Colors.white38,
                    onChanged: _changeBrightness,
                  ),
                ),
                Icon(Icons.volume_up, color: Colors.white),
                RotatedBox(
                  quarterTurns: -1,
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 1,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.white38,
                    onChanged: _changeVolume,
                  ),
                ),
              ],
            ),
          ),

          // Bouton Retour
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}


class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Page de Recherche"),
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
