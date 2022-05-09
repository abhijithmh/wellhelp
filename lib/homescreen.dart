import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellhelp/colors.dart';
import 'package:wellhelp/login.dart';
import 'package:wellhelp/moods.dart';

class homeScreen extends StatefulWidget {
  final name;
  const homeScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  bool isvisible = true;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                _backBgCover(),
                _greetings(),
                _moodsHolder(),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _nextAppointmentText(),
                    _appoinmentCard(),
                    _areaSpecialistsText(),
                    _specialistsCardInfo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _moodsHolder() {
    return Positioned(
      bottom: -45,
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width - 40,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 5.5,
                blurRadius: 5.5,
              )
            ]),
        child: MoodsSelector(),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
    );
  }

  Container _backBgCover() {
    return Container(
      height: 260.0,
      decoration: const BoxDecoration(
        gradient: purpleGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }

  Positioned _greetings() {
    return Positioned(
      left: 20,
      bottom: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hi '+widget.name,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                'How are you feeling today ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              FloatingActionButton(
                child: const Icon(Icons.account_box),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
                    return loginScreen();
                  }));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _areaSpecialistsText() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'INFO',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: const Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: midColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _appoinmentCard() {
    return SingleChildScrollView(
      controller: _scrollController2,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://png.pngtree.com/png-clipart/20210905/original/pngtree-red-warning-sign-icon-png-image_6686804.jpg'),
            backgroundColor: Color(0xFFD9D9D9),
            radius: 36.0,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('well').snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      String OxySat =
                          snapshot.data!.docs.elementAt(0).get('oxy_sat');
                      double oxySat = double.parse(OxySat);

                      if (oxySat < 94) {
                        return RichText(
                          text: const TextSpan(
                            text: 'Low Blood oxygen level detected',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  }),
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('well').snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      String GasValue =
                          snapshot.data!.docs.elementAt(0).get('gas_value');
                      String OxySat =
                          snapshot.data!.docs.elementAt(0).get('oxy_sat');
                      double oxySat = double.parse(OxySat);

                      if (GasValue == 'Danger') {
                        return RichText(
                          text: const TextSpan(
                            text: 'High Poisonous Gas concentration Detected',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        );
                      } else if (oxySat < 94 && GasValue == 'Normal') {
                        return Container();
                      } else {
                        return RichText(
                          text: const TextSpan(
                            text: 'No Alert',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        );
                      }
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nextAppointmentText() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'ALERT BOX',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: () {
              _scrollController2.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: const Text(
              'Read More',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: midColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialistsCardInfo() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("well").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            String altitude = snapshot.data!.docs.elementAt(0).get("altitude");
            String gasvalue = snapshot.data!.docs.elementAt(0).get("gas_value");
            String oxysat = snapshot.data!.docs.elementAt(0).get("oxy_sat");
            String pulse = snapshot.data!.docs.elementAt(0).get("pulse");
            String temperature =
                snapshot.data!.docs.elementAt(0).get("temperature");
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 18.0),
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(
                                'https://static.thenounproject.com/png/322033-200.png'),
                            radius: 36.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'ALTITUDE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              altitude + ' m',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 18.0),
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(
                                'https://www.pngfind.com/pngs/m/630-6309081_support-the-propaganda-toxic-gas-icon-hd-png.png'),
                            radius: 36.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'GAS VALUE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              gasvalue,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 18.0),
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(
                                'https://media.istockphoto.com/vectors/pulse-oximeter-finger-medical-device-icon-corona-virus-covid-protect-vector-id1218905934?k=20&m=1218905934&s=612x612&w=0&h=UnY9R8QhqzPKNEVt5O7NZhmomrEM8G8DmgU-QP4CtZQ='),
                            radius: 36.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'OXYGEN SATURATION',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              oxysat + ' %',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 18.0),
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/865/865969.png'),
                            radius: 36.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'PULSE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              pulse + ' bpm',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 18.0),
                  margin: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1.0,
                          blurRadius: 6.0,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                            backgroundImage: NetworkImage(
                                'https://www.clipartmax.com/png/middle/226-2260634_temperature-png-room-temperature-icon-png.png'),
                            radius: 36.0,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: const TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'TEMPERATURE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      RaisedButton(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: purpleGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0, minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              temperature + ' °C',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
