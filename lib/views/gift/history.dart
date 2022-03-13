import 'package:bono_gifts/views/buy/buy.dart';
import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:bono_gifts/views/gift/widgets/history_list.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, bool this.fromHomepage = false})
      : super(key: key);
  final bool fromHomepage;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Init");
    Provider.of<HistoryProvider>(context, listen: false)
        .getHistoryFromFirebase();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
    Provider.of<HistoryProvider>(context, listen: false)
        .getStatusFromWordpress();
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final HistoryProvider historyProvider =
        Provider.of<HistoryProvider>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: widget.fromHomepage ? 0 : historyProvider.index,
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => BuyPage()));
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
                        Divider(height: 1, thickness: 2, color: Colors.black12),
                  ),
                ],
              ),
            ),
            title: PrimaryText(
              text: 'History',
              fontSize: 25,
            ),
          ),
          body: TabBarView(
            children: [
              HistoryList(
                historyList: historyProvider.allHistory,
              ),
              HistoryList(
                historyList: historyProvider.receivedHistory,
              ),
              HistoryList(
                historyList: historyProvider.sendHistory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
