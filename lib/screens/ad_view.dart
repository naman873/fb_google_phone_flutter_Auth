import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AdView extends StatefulWidget {
  @override
  _AdViewState createState() => _AdViewState();
  final name;
  final desp;
  final dosage;
  final price;
  final stock;
  final form;
  final produce;
  AdView(
      {this.name,
      this.desp,
      this.price,
      this.dosage,
      this.form,
      this.produce,
      this.stock});
}

class _AdViewState extends State<AdView> {
  bool val = false;

  /// create a bottom drawer controller to control the drawer.
  BottomDrawerController controller = BottomDrawerController();
  double _slider2Val = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/1.jpg'), fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 2.0,
                  top: 40.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BottomDrawer(
              header: Row(
                children: [
                  SizedBox(
                    width: 0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        // widget.snap.get('name'),
                        widget.name,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        //widget.snap.get('desp'),
                        widget.desp,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                  ),
                  IconButton(
                    //color: val == false ? Colors.green : Colors.red,
                    onPressed: () {
                      setState(() {
                        val = !val;
                      });
                    },
                    icon: !val
                        ? Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 30.0,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 30.0,
                          ),
                  )
                ],
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        '\$' +
                            //widget.snap.get('price'),
                            widget.price,
                        style: TextStyle(fontSize: 25.0),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      Column(
                        children: [
                          //     Text(
                          //       '$_slider2Val left stock',
                          //       style: TextStyle(fontSize: 10),
                          //     ),
                          //     Slider(
                          //         value: _slider2Val,
                          //         min: 0.0,
                          //         max: 14.0,
                          //         divisions: 14,
                          //         onChanged: (double val) {
                          //           setState(() {
                          //             _slider2Val = val;
                          //           });
                          //         }),
                        ],
                      ),
                      Container(
                        width: 170,
                        height: 50,
                        margin: EdgeInsets.only(left: 30, right: 30),
                        alignment: Alignment.center,
                        child: LinearPercentIndicator(
                          //leaner progress bar
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          percent: widget.stock / 15,
                          center: Text(
                            widget.stock.toString() + "%",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.blue[400],
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dosage Form',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            widget.form,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active substance',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dosage',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            widget.dosage + 'g',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.49,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manufacturor',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          Text(
                            widget.produce,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            //side: BorderSide(color: Colors.red)
                          ),
                        ),
                      ),
                      child: Text('Add To cart'),
                    ),
                  )
                ],
              ),
              headerHeight: 120.0,
              drawerHeight: 360.0,
              color: Colors.white24,
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}
