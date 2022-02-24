import 'package:bono_gifts/views/buy/buy.dart';
import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:bono_gifts/views/gift/widgets/history_list.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryProvider historyProvider = HistoryProvider();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    historyProvider.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historyProvider.getHistoryFromFirebase();
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.grey[100],
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(
                    minWidth: 120,
                    height: 45,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BuyPage()));
                    },
                    child: PrimaryText(
                      text: 'Buy Gift',
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Column(
                children: const [
                  TabBar(
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.blue,
                    tabs: [
                      Text(
                        'ALL',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text('Received', style: TextStyle(fontSize: 15)),
                      Text('Sent', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child:
                        Divider(height: 1, thickness:2, color: Colors.black12),
                  ),
                ],
              ),
            ),
            title: PrimaryText(
              text: 'History',
              fontSize: 25,
            ),
          ),
          body:  TabBarView(
            children: [
              HistoryList(
                historyList: historyProvider.allHistory,
                isReceived: true,
              ),
              HistoryList(
                historyList: historyProvider.sendHistory,
                isReceived: true,
              ),
              HistoryList(
                historyList: historyProvider.receivedHistory,
                isReceived: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
