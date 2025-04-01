import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        shape: Border(
            // bottom: BorderSide(color: Colors.black, width: 0.3),
            ),
        toolbarHeight: 70,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.1),
          child: Container(
            // color: Colors.black,
            height: 1.0,
          ),
        ),
        title: const Text(
          'About',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context)
            .size
            .height, // Set the height to the screen height
        width: MediaQuery.of(context)
            .size
            .width, // Set the width to the screen width
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fork & Fire ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '• Version: 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    '🎧 My  A u d i o :  your Music player 🎶',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enjoy a seamless music experience with our easy-to-use app, featuring built-in songs and essential controls like shuffle play, play/pause, and next/previous track navigation. Effortlessly skip forward or rewind by 5 seconds to fine-tune your listening, and switch between songs with a single tap. Whether you want to mix things up with shuffle mode or take full control of your playlist, our app ensures a smooth and enjoyable music journey anytime, anywhere! 🎶✨",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    '• Developed by:  Om Sunil Belekar',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 26),
                  Text(
                    '• Contact us:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse('https://github.com/om945'));
                            },
                            child: Image.asset(
                              "assets/images/github.png",
                              height: 30,
                              width: 30,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://www.linkedin.com/in/om-belekar-aab424326?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app'));
                            },
                            child: Image.asset(
                              "assets/images/linkedin.png",
                              height: 30,
                              width: 30,
                            ))
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
