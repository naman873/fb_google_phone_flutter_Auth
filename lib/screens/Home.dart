import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'ad_view.dart';

class Home extends StatefulWidget {
  final user;
  @override
  _HomeState createState() => _HomeState();
  Home({this.user});
}

class _HomeState extends State<Home> {
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  var _currentPosition;
  var _currentAddress;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Future<File> crocin = getImageFileFromAssets('images/crocin.jpg');
    Future<File> biotin = getImageFileFromAssets('images/biotin.jpg');
    Future<File> ibuprofen = getImageFileFromAssets('images/ibuprofen.jpg');

    FirebaseFirestore.instance.collection('medicine').add({
      'desp': 'Tablet . 50 pieces',
      'dosage': 0.2,
      'form': 'pills',
      'name': 'ibuprofen',
      'price': '\$4.92',
      'produce': 'Biosyn,Russia',
      'stock': '10',
      'image': ibuprofen
    });
    FirebaseFirestore.instance.collection('medicine').add({
      'desp': 'Tablet . 30 pieces',
      'dosage': 0.1,
      'form': 'pills',
      'name': 'crocin',
      'price': '\$1.92',
      'produce': 'India',
      'stock': '100',
      'image': crocin
    });
    FirebaseFirestore.instance.collection('medicine').add({
      'desp': 'Tablet . 60 pieces',
      'dosage': 0.3,
      'form': 'pills',
      'name': 'biotin',
      'price': '\$10.92',
      'produce': 'England',
      'stock': '10',
      'image': biotin
    });
  }

  String? _result = '';

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];
      print(placemarks);
      setState(() {
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }

  final List<Map> myProduct =
      List.generate(100, (index) => {'id': index, 'name': 'Product ${index}'})
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          (_currentAddress != null && _currentPosition != null)
              ? ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.locationArrow,
                    color: Colors.black,
                  ),
                  title: Text(
                    _currentAddress,
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : CircularProgressIndicator(
                  strokeWidth: 3,
                ),
          SizedBox(
            height: 10,
          ),
          widget.user != null
              ? ListTile(
                  leading: GoogleUserCircleAvatar(
                    identity: widget.user,
                  ),
                  title: Text(widget.user.displayName ?? ''),
                  subtitle: Text(widget.user.email),
                )
              : ListTile(
                  leading: Text(
                    'Hi Samanta',
                    style: TextStyle(fontSize: 35),
                  ),
                  trailing: CircleAvatar(
                    backgroundImage: AssetImage('images/1.jpg'),
                  ),
                ),
          SizedBox(
            height: 30,
          ),
          //Todo:Search
          Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey,
              ),
              child: RawMaterialButton(
                padding: EdgeInsets.only(bottom: 20),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {},
                child: ListTile(
                  leading: FaIcon(FontAwesomeIcons.search),
                  title: Text('Search'),
                ),
              )
              // ElevatedButton(
              //     style: ButtonStyle(
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12.0),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: Text("Search"),),
              ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/2.jpg'),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(17.0),
              ),
              color: Colors.redAccent,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 35,
              ),
              Text(
                'Popular',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.filter,
                  size: 25,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('medicines')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                if (snapshot.data?.docs.length == 0) {
                  return Center(
                    child: Container(
                      child: Text("No Data"),
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: snapshot.data?.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AdView(
                                  name: snapshot.data?.docs[index].get('name'),
                                  desp: snapshot.data?.docs[index].get('desp'),
                                  dosage:
                                      snapshot.data?.docs[index].get('dosage'),
                                  produce:
                                      snapshot.data?.docs[index].get('produce'),
                                  price:
                                      snapshot.data?.docs[index].get('price'),
                                  stock:
                                      snapshot.data?.docs[index].get('stock'),
                                  form: snapshot.data?.docs[index].get('form'),
                                );
                              },
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            // Image(
                            //   image: NetworkImage(
                            //       snapshot.data?.docs[index].get('name')),
                            // )
                            Text(snapshot.data?.docs[index].get('name')),
                            Text(snapshot.data?.docs[index].get('desp')),
                            Text(snapshot.data?.docs[index].get('price')),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(15)),
                    );
                  },
                );
              },
              // return  GridView.builder(
              //     itemCount: myProduct.length,
              //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //         maxCrossAxisExtent: 200,
              //         childAspectRatio: 0.8,
              //         crossAxisSpacing: 1,
              //         mainAxisSpacing: 10),
              //     itemBuilder: (BuildContext context, index) {
              //       return Container(
              //         margin: EdgeInsets.all(8),
              //         alignment: Alignment.center,
              //         child: InkWell(
              //             onTap: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) {
              //                     return AdView();
              //                   },
              //                 ),
              //               );
              //             },
              //             child: Text(myProduct[index]['name'])),
              //         decoration: BoxDecoration(
              //             color: Colors.amber,
              //             borderRadius: BorderRadius.circular(15)),
              //       );
              //     }),
            ),
          )
        ],
      ),
    );
  }
}

// class CustomDelegate<T> extends SearchDelegate<T> {
//   List<String> data = nouns.take(100).toList();
//
//   @override
//   List<Widget> buildActions(BuildContext context) =>
//       [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
//
//   @override
//   Widget buildLeading(BuildContext context) => IconButton(
//       icon: Icon(Icons.chevron_left), onPressed: () => close(context, null));
//
//   @override
//   Widget buildResults(BuildContext context) => Container();
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     var listToShow;
//     if (query.isNotEmpty)
//       listToShow =
//           data.where((e) => e.contains(query) && e.startsWith(query)).toList();
//     else
//       listToShow = data;
//
//     return ListView.builder(
//       itemCount: listToShow.length,
//       itemBuilder: (_, i) {
//         var noun = listToShow[i];
//         return ListTile(
//           title: Text(noun),
//           onTap: () => close(context, noun),
//         );
//       },
//     );
//   }
// }
