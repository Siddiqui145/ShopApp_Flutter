import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/admin/delete.dart';
import 'package:shop_app/screens/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'upload.dart';

Future<void> signOut(BuildContext context, FirebaseAuth auth) async {
  try {
    await auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged Out Successfully"),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    print("Error signing out: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing out: $e'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Drawer SideBar(String email, BuildContext context) {
  const String adminUID = "s4HvIH3u6yVzBTb8LItrqKT73Y53";
  final User? user = FirebaseAuth.instance.currentUser;
  final bool isAdmin = user?.uid == adminUID;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Column(
            children: [
              Text(
                "75BRANDSTORE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Elevate Your Style! \n Embrace Your Journey!! \n And Define Your Fashion Story!!!",
                style: TextStyle(fontSize: 15, color: Colors.white),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset("assets/images/brand/profile.jpg"),
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: Text(
          "By ~Jazib Khan",
          style: TextStyle(fontSize: 22),
        )),
        ListTile(
          leading: const Icon(Icons.person),
          title: Column(
            children: [
              Text('Welcome, $email'),
            ],
          ),
        ),
        if (isAdmin) ...[
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Upload'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadProduct(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_rounded),
            title: const Text('Delete'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeleteProductPage(),
                  ));
            },
          ),
        ] else
          ListTile(
            leading: const Icon(Icons.ac_unit),
            title: const Text('New Updates'),
            onTap: () async {
              final Uri url = Uri.parse(
                  "https://www.instagram.com/75brandstore?igsh=bmF3cnlvd2RpenBx");
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ListTile(
          leading: const Icon(Icons.wechat_sharp),
          title: const Text('Chat With Us'),
          onTap: () async {
            final Uri url =
                Uri.parse("https://wa.me/<+919960574986>?<Tap to Chat>");
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            await signOut(context, FirebaseAuth.instance);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ],
    ),
  );
}
