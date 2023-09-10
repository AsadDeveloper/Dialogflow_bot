import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'Messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AS AIbot',
        theme: ThemeData(
          brightness: Brightness.dark
        ),

      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AS AIBOT'),
        leading:  Icon(Icons.menu),

        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.ac_unit_rounded))
        ],
        
        
        centerTitle: true,
      ) ,
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8

              ),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15)
              ),

              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                  )),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10)
                    ),
                      child: IconButton(onPressed: (){
                    sendMessage(_controller.text);
                    _controller.clear();
                  }, icon: Icon(Icons.send)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  sendMessage(String text)async{
    if(text.isEmpty){
      print('Message is empty');
    }else{
      setState(() {
     addMessage(Message(
       text: DialogText(text: [text])
     ), true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(
        text: TextInput(text: text)
      ));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }
  addMessage(Message message, [bool isUserMessage = false]){
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}

