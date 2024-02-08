import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Reader'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _startNFCReading,
              child: const Text('Start NFC Reading'),
            ),
          ),
          Text('text: $text'),
        ],
      ),
    );
  }

  void _startNFCReading() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      if (tag.ndefAvailable ?? false) {
        List<NDEFRecord> ndefRecords = await FlutterNfcKit.readNDEFRecords();
        String ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        RegExp regExp = RegExp(r'text=([^ ]+)');
        Iterable<Match> matches = regExp.allMatches(ndefString);
        List<String?> extractedCharacters = matches.map((match) => match.group(1)).toList();
        String extractedCharactersString = extractedCharacters.join(', ');
        debugPrint(extractedCharactersString);
        setState(() {
          text = extractedCharactersString;
        });
      }
    } catch (e) {
      debugPrint('Error reading NFC: $e');
    }
  }
}
