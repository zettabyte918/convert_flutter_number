import 'package:flutter/material.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Translate english number to arabic letter, and to english',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  final List<String> _locations = ['Arabic', 'English']; // Option 1

  String _selectedLocation = 'Arabic'; // Option 2

  getArabicText(text) {
    if (_selectedLocation == "Arabic") {
      if (text.split(".").length == 2) {
        return '${Tafqeet.convert(text.toString().split(".")[0])} دينار و ${Tafqeet.convert(text.toString().split(".")[1].substring(0, 3))} مليم';
      } else {
        return '${Tafqeet.convert(text)} دينار';
      }
    } else {
      if (text.split(".").length == 2) {
        final one = NumberToWordsEnglish.convert(
            int.parse(text.toString().split(".")[0]));
        final two = NumberToWordsEnglish.convert(
            int.parse(text.toString().split(".")[1].substring(0, 3)));
        return '$one dollar, $two cents';
      } else {
        return '${NumberToWordsEnglish.convert(int.parse(text))} dollar';
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate English, Arabic number to letter'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton(
                hint: const Text(
                    'Please choose a location'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
              ),
              TextField(
                controller: myController,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(
                  '${myController.text}  تعنى : ${getArabicText(myController.text)}',
                  //الف وثلاثمائة وسبعة وتسعون
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
          );
        },
        tooltip:
            'Translate now the number ${myController.text} to arabic letter!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
