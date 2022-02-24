import 'package:bono_gifts/views/gift/model/history_model.dart';
import 'package:bono_gifts/views/gift/widgets/history_list_item.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<HistoryModel> historyList;
  final bool isReceived;
  HistoryList({required this.historyList, required this.isReceived});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
            isReceived: isReceived,
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: historyList.length);
  }
}
