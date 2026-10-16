import 'package:flutter/material.dart';

void main() {
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: const TikTokHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TikTokHomePage extends StatefulWidget {
  const TikTokHomePage({super.key});

  @override
  State<TikTokHomePage> createState() => _TikTokHomePageState();
}

class _TikTokHomePageState extends State<TikTokHomePage> {
  // Mock data representing video posts
  final List<VideoPost> _posts = [
    VideoPost(
      videoUrl:
          'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=1080',
      username: '@alice',
      description: 'Sunset vibes 🌅 #nature',
      likes: 1240,
      comments: 87,
      shares: 34,
    ),
    VideoPost(
      videoUrl:
          'https://images.unsplash.com/photo-1516117172878-fd2c41f4a759?w=1080',
      username: '@bob',
      description: 'Morning coffee routine ☕️ #cafe',
      likes: 980,
      comments: 45,
      shares: 20,
    ),
    VideoPost(
      videoUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=1080',
      username: '@charlie',
      description: 'Dance challenge! 💃 #fun',
      likes: 2150,
      comments: 132,
      shares: 58,
    ),
    // Add more mock posts as needed
  ];

  final Set<int> _likedIndices = {};

  void _toggleLike(int index) {
    setState(() {
      if (_likedIndices.contains(index)) {
        _likedIndices.remove(index);
        _posts[index].likes--;
      } else {
        _likedIndices.add(index);
        _posts[index].likes++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background is black to mimic TikTok's dark UI
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final isLiked = _likedIndices.contains(index);
          return Stack(
            fit: StackFit.expand,
            children: [
              // Background video placeholder (image)
              Image.network(
                post.videoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[800]);
                },
              ),
              // Dark gradient for readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              // Right side action buttons
              Positioned(
                right: 12,
                bottom: 120,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionButton(
                      icon: Icons.favorite,
                      label: post.likes.toString(),
                      active: isLiked,
                      onTap: () => _toggleLike(index),
                    ),
                    const SizedBox(height: 24),
                    _ActionButton(
                      icon: Icons.comment,
                      label: post.comments.toString(),
                      onTap: () {
                        // Placeholder for comment action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comments not implemented')),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _ActionButton(
                      icon: Icons.share,
                      label: post.shares.toString(),
                      onTap: () {
                        // Placeholder for share action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share not implemented')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Bottom caption and username
              Positioned(
                left: 12,
                right: 80,
                bottom: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.redAccent : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class VideoPost {
  final String videoUrl; // In a real app this would be a video source
  final String username;
  final String description;
  int likes;
  final int comments;
  final int shares;

  VideoPost({
    required this.videoUrl,
    required this.username,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}