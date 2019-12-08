import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:money_controller/logic/actions.dart';
import 'package:money_controller/logic/reduxState.dart';

import 'itemEntryDialog.dart';

class MainScreenViewModel {
  final double defaultPrice;
  final bool hasEntryBeenAdded;
  final Function() openAddEntryDialog;
  final Function() acceptEntryAddedCallback;

  MainScreenViewModel({
    this.openAddEntryDialog,
    this.defaultPrice,
    this.hasEntryBeenAdded,
    this.acceptEntryAddedCallback
  });
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title, this.analytics}) : super(key: key);
  final FirebaseAnalytics analytics;
  final String title;

  @override
  State<MainScreen> createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<ReduxState, MainScreenViewModel>(
      converter: (store) {
        return new MainScreenViewModel(
          defaultPrice: store.state.entries.isEmpty
              ? 0.0
              : store.state.entries.first.price,
          hasEntryBeenAdded: store.state.mainPageState.hasEntryBeenAdded,
          acceptEntryAddedCallback: () =>
              store.dispatch(new AcceptEntryAddedAction()),
          openAddEntryDialog: () {
            store.dispatch(new OpenAddEntryDialog());
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) {
                return new ItemEntryDialog();
              },
              fullscreenDialog: true,
            ));
            widget.analytics.logEvent(name: 'open_add_dialog');
          },
        );
      },
      onInit: (store) {
        store.dispatch(new GetSavedWeightNote());
      },
      builder: (context, viewModel) {
        if (viewModel.hasEntryBeenAdded) {
          _scrollToTop();
          viewModel.acceptEntryAddedCallback();
        }
        return new Scaffold(
          body: new NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: new Text(widget.title),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: new TabBar(
                    tabs: <Tab>[
                      new Tab(
                        key: new Key('StatisticsTab'),
                        text: "STATISTICS",
                        icon: new Icon(Icons.show_chart),
                      ),
                      new Tab(
                        key: new Key('HistoryTab'),
                        text: "HISTORY",
                        icon: new Icon(Icons.history),
                      ),
                    ],
                    controller: _tabController,
                  ),
                  actions: _buildMenuActions(context),
                ),
              ];
            },
            body: new TabBarView(
              children: <Widget>[
                Text("1"),
                Text("2")
              ],
              controller: _tabController,
            ),
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () => viewModel.openAddEntryDialog(),
            tooltip: 'Add new weight entry',
            child: new Icon(Icons.add),
          ),
        );
      },
    );
  }

  List<Widget> _buildMenuActions(BuildContext context) {
    return [
      IconButton(
          icon: new Icon(Icons.settings),
          //onPressed: () => _openSettingsPage(context)
      ),
    ];
  }

  _scrollToTop() {
    _scrollViewController.animateTo(
      0.0,
      duration: const Duration(microseconds: 1),
      curve: new ElasticInCurve(0.01),
    );
  }

  _openSettingsPage(BuildContext context) async {

  }
}
