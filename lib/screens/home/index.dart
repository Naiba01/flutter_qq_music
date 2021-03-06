import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_qq_music/screens/home/header_bar.dart' show HeaderBar;
import 'package:flutter_qq_music/screens/home/my/my_body.dart' show MyBody;
import 'package:flutter_qq_music/screens/home/music_hall/music_hall_body.dart' show MusicHallBody;
import 'package:flutter_qq_music/screens/home/find/find_body.dart' show FindBody;
import 'package:flutter_qq_music/components/micro_player.dart' show MicroPlayer;
import 'package:flutter_qq_music/app_state.dart' show AppState;
import 'package:flutter_qq_music/constants/index.dart' show HomeTabs;
import 'package:flutter_qq_music/screens/home/quick_func_modal.dart' show QuickFuncModal;
import 'package:flutter_qq_music/screens/home/reactive.dart' show HomeState, SwitchTabAction;
import 'package:flutter_qq_music/tools/device_info.dart' show DeviceInfo;
import 'package:flutter_qq_music/components/custom_carousel.dart' show CustomCarousel;
import 'package:flutter_qq_music/components/page_carousel.dart' show PageCarousel;

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  AnimationController _slideAnimationController;
  Animation _slideAnimation;
  double screenWidth;
  int pageId = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
//    _slideAnimationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
//    _slideAnimation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
//      .animate(CurvedAnimation(parent: _slideAnimationController, curve: Curves.fastOutSlowIn))
//      ..addListener(() {
//        setState(() {});
//      })
//      ..addStatusListener((status) {
//        print('slide status');
//        print(status);
//        print(_slideAnimationController.value);
//      });
//    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
//
//  void _move(DragUpdateDetails details) {
//    final double delta = details.primaryDelta / screenWidth;
//    print('delta');
//
//    _slideAnimationController.value += delta;
//    print(_slideAnimationController.value);
//  }
//
//  void _handleDragEnd(DragEndDetails details) {
//    if (_slideAnimationController.value > 0.5) {
//      _slideAnimationController.forward();
//      print('向前');
//      print(_slideAnimationController.value);
//    } else {
//      _slideAnimationController.reverse();
//      print('反响');
//      print(_slideAnimationController.value);
//    }
//  }

  transferTabToIndex(tabType) {
    switch (tabType) {
      case HomeTabs.MY:
        return 0;
      case HomeTabs.MUSIC_HALL:
        return 1;
      default:
        return 2;
    }
  }

  onSlidePage(pageIndex) {
    print(pageIndex);
    var tab;
    if (pageIndex == 0) {
      tab = HomeTabs.MY;
    } else if (pageIndex == 1) {
      tab = HomeTabs.MUSIC_HALL;
    } else {
      tab = HomeTabs.FIND;
    }
    StoreProvider.of<AppState>(context).dispatch(SwitchTabAction(tab));
  }

  Widget mainContent() {
    return Column(
        children: <Widget>[
          HeaderBar(),
          Expanded(
            flex: 1,
            child: StoreConnector<AppState, HomeTabs>(
              builder: (context, tabType) {
                return Container(
                  color: const Color.fromRGBO(250, 250, 250, 1.0),
                  child: PageCarousel(
                    initialIndex: 1,
                    index: transferTabToIndex(tabType),
                    autoPlay: false,
                    onSlide: onSlidePage,
                    children: <Widget>[
                      MyBody(),
                      MusicHallBody(),
                      FindBody(),
                    ]
                  ),
                );
              },
              converter: (store) => store.state.homeState.tabType
            ),
          ),
          MicroPlayer()
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = DeviceInfo().getDeviceWidth(context);

    return StoreConnector<AppState, HomeState>(
        builder: (context, homeState) {
          return homeState.showQuickFuncModal ? Stack(
            children: <Widget>[
              mainContent(),
              QuickFuncModal()
            ],
          ) : Stack(
            children: <Widget>[
              mainContent()
            ],
          );
        },
        converter: (store) {
          return store.state.homeState;
        }
    );
  }
}