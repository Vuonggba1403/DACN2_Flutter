import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/attractions/view_attractions_card.dart';
import '../../components/attractions/view_attractions_filter.dart';
import '../../components/attractions/view_attractions_sort.dart';
import 'package:intl/intl.dart';

class ViewAttractions extends StatefulWidget {
  const ViewAttractions({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewAttractionsState();
  }
}

class _ViewAttractionsState extends State<ViewAttractions> {
  int optionSort = 0;
  int currentAmount = 0;
  bool sortAndFilter = false;

  List<dynamic> filters = [];
  List<Widget> results = [];
  Set visibilityItems = {};

  @override
  Widget build(BuildContext context) {
    if (filters.isNotEmpty) {
      results.clear();
      for (var item in filters) {
        if (item[0] != null && item[1]['isSelected'] == true) {
          results.add(buildResultItem(item));
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(),
            SizedBox(
              // width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        children: results,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ViewAttractionCard(sortAndFilter: sortAndFilter),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              color: const Color.fromARGB(255, 0, 59, 149),
            ),
            Container(
              height: 55,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromARGB(255, 170, 170, 170),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildSortButton(),
                  buildFilterButton(),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 25,
          right: 25,
          top: 20,
          child: buildSearchBar(),
        ),
      ],
    );
  }

  Widget buildSortButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.6,
              child: ViewAttractionsSort(currentOptionSort: optionSort),
            );
          },
        ).then((value) {
          if (value != null) {
            setState(() {
              optionSort = value;
              sortAndFilter = true;
            });
          }
        });
      },
      child: Row(
        children: [
          const Icon(Icons.sort),
          const SizedBox(width: 5),
          const Text(
            'Sắp xếp',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          optionSort != 0
              ? const Text(
                  '.',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildFilterButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const ViewAttractionsFilter();
          },
        ).then((value) {
          if (value != null && value[0] > 0) {
            setState(() {
              filters.clear();
              currentAmount = value[0];
              filters = value[1];
              sortAndFilter = true;
            });
          }
        });
      },
      child: Row(
        children: [
          const Icon(Icons.tune),
          const SizedBox(width: 5),
          const Text(
            'Lọc',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          currentAmount > 0
              ? const Text(
                  '.',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    DateTime now = DateTime.now();
    // Định dạng ngày
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 3, color: const Color.fromARGB(255, 238, 155, 77)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            iconSize: 24,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          ),
          const SizedBox(width: 10),
          const Text(
            'Đà Nẵng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Text(
            ' . $formattedDate',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget buildResultItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.fromLTRB(0, 8, 10, 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 108, 228)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            item[0].values.elementAt(0).toString(),
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 0, 108, 228)),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              int amount = item[0]['amount'];
              setState(() {
                currentAmount -= amount;
                filters.remove(item);
                results.removeWhere((result) => result.key == item[0].key);
              });
            },
            child: const Icon(Icons.cancel_outlined,
                color: Color.fromARGB(255, 0, 108, 228)),
          ),
        ],
      ),
    );
  }
}
