import 'package:flutter/material.dart';
import 'package:gplayer/gplayer.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title = 'Channel Soluction'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TargetPlatform _platform = TargetPlatform.android;
  bool _isKeptOn = false;
  double _brightness = 1.0;
  List listData;
  var currentData;
  static String beeUri =
      'http://shinestream.in/shine/shinekannada/playlist.m3u8';
  String videoTitle = '';
  //static bool showBackButton;
  GPlayer player = new GPlayer(uri: beeUri);

  void initState() {
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getData();
    this.video_initialize();
  }

  Future<String> getData() {
//    var response = await http.get(
//        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
//        headers: {
//          "Accept": "application/json"
//        }
//    );

    //this.setState(() {
    listData = [
      {
        "id": 1,
        "name": "shine kannada",
        "link": "http://shinestream.in/shine/shinekannada/playlist.m3u8",
        'image': "shine.png",
        "islive": true
      },
      {
        "id": 2,
        "name": "spardha tv",
        "link": "http://shinestream.in:1935/spardhatv/spardhatv/playlist.m3u8",
        'image': "spardha.png",
        "islive": true
      },
      {
        "id": 3,
        "name": "media tv",
        "link": "http://shinestream.in:1935/mediatv/mediatv/playlist.m3u8",
        'image': "media.png",
        "islive": true
      },
      {
        "id": 4,
        "name": "mysuru news",
        "link":
            "http://shinestream.in:1935/mysorenews/mysorenews/playlist.m3u8",
        'image': "mysuru.png",
        "islive": false
      },
      {
        "id": 5,
        "name": "raita dhvani",
        "link": "http://shinestream.in:1935/raithatv/raithatv/playlist.m3u8",
        'image': "raita.png",
        "islive": false
      },
      {
        "id": 6,
        "name": "hcn tv",
        "link": "http://shinestream.in:1935/hcn/hcn/playlist.m3u8",
        'image': "hcn.png",
        "islive": false
      },
    ];
    //});
    this.currentData = listData[0];
  }

  gridItem(BuildContext context, int position) {
    return GestureDetector(
      onTap: () {
        this.currentData = listData[position];
        player?.dispose();
        this.video_initialize();
//        filterBottomSheet(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/' + listData[position]['image']),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.black))),
        padding: EdgeInsets.only(left: 0, top: 0),
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Image( image: NetworkImage(listImage[position] ), fit: BoxFit.fill),
            //Text('TURN LIGHTS ON')
          ],
        ),
      ),
    );
  }

  Widget _buildDridBuilder() {
    return Builder(
      builder: (context) {
        return Container(
          color: Colors.black,
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, position) {
              return gridItem(context, position);
            },
            itemCount: listData.length,
          ),
        );
      },
    );
  }

  void video_initialize() {
    this.videoTitle = this.currentData['name'];
    player = GPlayer(uri: this.currentData['link'])
      ..init()
      ..addListener((_) {
        //update control button out of player
        setState(() {});
      })
      ..start()
      ..lazyLoadProgress = 0
      ..isLive = this.currentData['islive']
      ..aspectRatio = 16.0 / 9.0;
    player.landscapeWhenFullScreen = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        player?.dispose();
        this.video_initialize();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        player?.dispose();
        break;
      case AppLifecycleState.detached:
        player?.dispose();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player?.dispose(); //2.release player
    super.dispose();
  }

  Widget _buildVideo() {
    return player.display;
  }

  Widget _buildFullScreenButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white)),
      color: Colors.white,
      textColor: Colors.green,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        player?.mediaController?.control('toggleFullScreen');
      },
      child: Text('Fullscreen'),
    );
  }

  Widget _buildCopyRights() {
    return Text(
      'Designed @dnd communication',
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
    );
  }

  Color gradientStart = Colors.black; //Change start gradient color here
  Color gradientEnd = Colors.black; //Change end gradient color here

//
//  @override
//  void didChangeDependencies() {
//
//    this.setState(() {
//      var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//
//         print("========================isPortrait==================");
//      print(isPortrait);
//      print(player.displayModel);
//
//
//    });
//    // TODO: implement didUpdateWidget
//    super.didChangeDependencies();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 240.0,
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
            child: Center(child: _buildVideo()),
          ),
          Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Center(
                child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 20),
                Text(this.videoTitle,
                    style: new TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
                Spacer(flex: 1),
                _buildFullScreenButton(),
                SizedBox(width: 20)
              ],
            )),
          ),
          Expanded(
            child: _buildDridBuilder(),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
