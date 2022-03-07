import 'package:bono_gifts/views/gift/controller/history_controller.dart';
import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:bono_gifts/views/gift/widgets/history_list_item.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryModel> historyList;
  HistoryList({required this.historyList});

  @override
  Widget build(BuildContext context) {
    final HistoryProvider provider = Provider.of<HistoryProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        provider.getHistoryFromFirebase();
      },
      child: ListView.separated(
          itemBuilder: (context, index) {
            if (historyList.isEmpty) {
              return Center(
                child: PrimaryText(
                  text: 'No Items',
                ),
              );
            }
            return HistoryListItem(
              history: historyList[index],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: historyList.length),
    );
  }
}
