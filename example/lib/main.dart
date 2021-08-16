import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_chatbot/package_chatbot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServicesBinding.instance.defaultBinaryMessenger;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.locale(context), // Add the locale here
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chatbot demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textEditingCtrHoTen = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () => ExtensionFunction.instance.goThuThapData(),
          //   )
          // ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Bạn vui lòng nhập tên và bấm chat ngay để bắt đầu'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: textEditingCtrHoTen,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                        color: Color(0xff073551),
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    decoration: InputDecoration(
                      hintText: 'Nhập ở đây',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(8),
                    )),
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            if (textEditingCtrHoTen.text.trim().isEmpty) {
              Get.snackbar('Thông báo', 'Bạn vui lòng nhập tên của bạn!!!');
            } else {
              FocusScope.of(context).unfocus();
              ExtensionFunction.instance.goChatBot(
                  context: context,
                  urlAPI: 'http://demo.vietinfo.tech:8090',
                  urlChatBot: 'http://chatbot.vietinfo.tech:8088',
                  userName: textEditingCtrHoTen.text,
                  fullName: 'Nhan Test Ten',
                  soDienThoai: '000000000');
            }
          },
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                top: 10,
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    color: Color(0xff80b4e7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'ChatBot',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 3,
                  right: 0,
                  child: Container(
                    width: 48,
                    height: 18,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(11)),
                        border: Border.all(
                            color: const Color(0xffffffff), width: 1),
                        color: const Color(0xffec4a5d)),
                    child: const Center(
                      child: Text(
                        'Chat ngay',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                            fontSize: 9.0),
                      ),
                    ),
                  ))
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
