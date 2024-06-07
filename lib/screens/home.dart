import 'package:flutter/material.dart';
import 'package:final_project/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String? username;
  double? income;
  double? expand;
  int? userId = DatabaseHelper.loggedInUserId;
  List<Map<String, dynamic>> userExpenses = [];
  @override
  void initState() {
    super.initState();
    _fetchInfo();
    _fetchUserExpenses();
  }

  Future<void> _fetchInfo() async {
    String? name = await DatabaseHelper().getLoggedinUserName();
    double? incomefrom = await DatabaseHelper().income();
    double? expandfrom = await DatabaseHelper().expand();
    setState(() {
      username = name;
      income = incomefrom;
      expand = expandfrom;
    });
  }

  Future<void> _fetchUserExpenses() async {
    if (userId != null) {
      List<Map<String, dynamic>> expenses =
          await databaseHelper.getUserExpenses(userId!);
      setState(() {
        userExpenses = expenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 350,
                child: _head(),
              ),
            ),
            const SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction History",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: Colors.black),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                ],
              ),
            )),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                Map<String, dynamic> expense = userExpenses[index];
                return ListTile(
                    leading: Image.asset(
                      'assets/${expense['category']}.png',
                      width: 20,
                    ),
                    title: Text(
                      expense['category'],
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(expense['description'],
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Text(
                      "\$${expense['amount']}",
                      style: TextStyle(
                          color: expense['type'] == 'Income'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ));
              },
              childCount: userExpenses.length,
            ))
          ],
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(children: [
          Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(27, 66, 66, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 35,
                  left: 340,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: const Color.fromRGBO(250, 250, 250, 0.1),
                      child: const Icon(
                        Icons.notification_add_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Good afternoon",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Text(
                        "$username",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
        Positioned(
            top: 160,
            left: 31,
            child: Container(
              height: 170,
              width: 350,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 106, 106, 1),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white)),
                          Icon(Icons.more_horiz, color: Colors.white)
                        ],
                      )),
                  const SizedBox(
                    height: 7,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Text("\$15151",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
                                color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ]),
                        Row(children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Outcome',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$$income',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$$expand',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
