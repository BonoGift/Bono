import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/sign_up_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/payment_screen.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum DurationVal { first, second, third }

class OrderSummry extends StatefulWidget {
  const OrderSummry({Key? key}) : super(key: key);

  @override
  _OrderSummryState createState() => _OrderSummryState();
}

class _OrderSummryState extends State<OrderSummry> {
  var formtr = DateFormat('MMM');

  @override
  void initState() {
    context.read<BuyProvider>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    final WooCommerceMarketPlaceProvider wooCommerceMarketPlaceProvider =
        Provider.of<WooCommerceMarketPlaceProvider>(context);
    final SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlueAccent,
          title: const Text(
            "Buy Gifts",
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // const Center(child: Text("Buy Gifts",style: TextStyle(fontSize: 20),)),
              // const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryText(text: "To"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black26, width: 4)),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(pro.userImage!),
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: Text(
                              pro.userName.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          FittedBox(
                            child: Text(
                              "Birthday ${pro.userDob != null ? form.format(pro.userDob!).toString() : ''} (In ${pro.diffDays} Days)",
                              maxLines: 1,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     icon: const Icon(
                    //       Icons.clear,
                    //       size: 30,
                    //       color: Colors.black,
                    //     ))
                  ],
                ),
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        color: Colors.grey[100],
                      ),
                      Positioned(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                        child: Container(
                          height: 230,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white70),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                        offset: Offset(0, 3))
                                  ]),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Hero(
                                      tag: wooCommerceMarketPlaceProvider
                                              .selectedProduct
                                              ?.images
                                              ?.first
                                              .src
                                              .toString() ??
                                          '',
                                      child: Image.network(
                                        wooCommerceMarketPlaceProvider
                                                .selectedProduct
                                                ?.images
                                                ?.first
                                                .src
                                                .toString() ??
                                            '',
                                        height: 148,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: -25,
                                      left: 33,
                                      right: 33,
                                      child: SizedBox(
                                          width: 150,
                                          child: FittedBox(
                                              child: PrimaryText(
                                            text: 'Quantity: 1',
                                            fontSize: 15,
                                          )))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   color: Colors.transparent,
                  //   child: Image.network(
                  //     wooCommerceMarketPlaceProvider.selectedProduct?.image!,
                  //     fit: BoxFit.cover,
                  //     height: 200,
                  //     width: 200,
                  //   ),
                  // ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: Container(),
                        title: FittedBox(
                          child: Text(
                            wooCommerceMarketPlaceProvider
                                    .selectedProduct?.name ??
                                '',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton(
                              onPressed: () {
                                goToPaymentScreen();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.blue,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text("Size : ${wooCommerceMarketPlaceProvider.selectedProduct?.size}"),

                            FittedBox(
                              child: Row(
                                children: [
                                  const Text('Price: '),
                                  PrimaryText(
                                    text:
                                        "${wooCommerceMarketPlaceProvider.selectedProduct?.price}\$",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  const Text('Delivery: '),
                                  PrimaryText(
                                    text:
                                        "${wooCommerceMarketPlaceProvider.deliveryPrice}\$",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  Text('Total: '),
                                  PrimaryText(
                                    text:
                                        "${wooCommerceMarketPlaceProvider.finalPrice()}\$",
                                    fontSize: 16,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: 'Add note',
                              fontSize: 16,
                            ),
                            PrimaryText(
                              text: ' (Optional)',
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: TextField(
                          controller: pro.noteController,
                          maxLines: 6,
                          onSubmitted: (val) {
                            goToPaymentScreen();
                          },
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            hintText:
                                'Eg. Write "Happy Birthday David" on the cake. Thank you',
                            hintStyle: const TextStyle(
                                color: Colors.black45, fontSize: 16),
                            fillColor: Colors.grey[100],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Text("What you would like to be writenon the cake"),
              // SizedBox(
              //   height: 30,
              // ),
              // Row(
              //   children: [
              //     Text(
              //       "Pick a delivery date",
              //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              //     ),
              //   ],
              // ),
              // Container(
              //   // color: Colors.white,
              //   child: Column(
              //     children: [
              //       ListTile(
              //         title: Text("As soon as possible (10\$ Delivery)"),
              //         trailing: Radio<DurationVal>(
              //           // fillColor: Color(0xff17B5AF),
              //           activeColor: Color(0xff17B5AF),
              //           onChanged: (val) {
              //             setState(() {
              //               _duration = DurationVal.first;
              //             });
              //           },
              //           value: DurationVal.first,
              //           groupValue: _duration,
              //         ),
              //       ),
              //       ListTile(
              //         title: Text("On his birthday (7\$ Delivery)"),
              //         trailing: Radio<DurationVal>(
              //           activeColor: Color(0xff17B5AF),
              //           onChanged: (val) {
              //             setState(() {
              //               _duration = DurationVal.second;
              //             });
              //           },
              //           value: DurationVal.second,
              //           groupValue: _duration,
              //         ),
              //       ),
              //       ListTile(
              //         title: Text("Or Select date"),
              //         trailing: Radio<DurationVal>(
              //           activeColor: Color(0xff17B5AF),
              //           onChanged: (val) {
              //             setState(() {
              //               _duration = DurationVal.third;
              //             });
              //           },
              //           value: DurationVal.third,
              //           groupValue: _duration,
              //         ),
              //       ),
              //       _duration == DurationVal.third
              //           ? InkWell(
              //               onTap: () {
              //                 DatePicker.showPicker(
              //                   context,
              //                   showTitleActions: true,
              //                   // minTime: DateTime(1950, 3, 5),
              //                   // maxTime: DateTime.now(),
              //                   onChanged: (date) {
              //                     var formt = DateFormat('dd-MMM-yyyy');
              //
              //                     wooCommerceMarketPlaceProvider.selectedProduct?.setDOB(
              //                         formt.format(date).toString(), date);
              //                   },
              //                   onConfirm: (date) {},
              //                 );
              //                 // currentTime: DateTime.now(), locale: LocaleType.en);
              //               },
              //               child: Container(
              //                   padding: const EdgeInsets.all(18),
              //                   width: getWidth(context),
              //                   child: Row(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                         padding: const EdgeInsets.all(12),
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(8),
              //                             border: Border.all()),
              //                         child: Center(
              //                           child: Text(wooCommerceMarketPlaceProvider.selectedProduct?.dob != null
              //                               ? wooCommerceMarketPlaceProvider.selectedProduct?.dob!.substring(7, 11)
              //                               : wooCommerceMarketPlaceProvider.selectedProduct?.todayDate.year.toString()),
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Container(
              //                         padding: const EdgeInsets.all(12),
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(8),
              //                             border: Border.all()),
              //                         child: Center(
              //                           child: Text(wooCommerceMarketPlaceProvider.selectedProduct?.dob != null
              //                               ? wooCommerceMarketPlaceProvider.selectedProduct?.dob!.substring(3, 6)
              //                               : formtr
              //                                   .format(wooCommerceMarketPlaceProvider.selectedProduct?.todayDate)
              //                                   .toString()),
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Container(
              //                         padding: const EdgeInsets.all(12),
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(8),
              //                             border: Border.all()),
              //                         child: Center(
              //                           child: Text(wooCommerceMarketPlaceProvider.selectedProduct?.dob != null
              //                               ? wooCommerceMarketPlaceProvider.selectedProduct?.dob!.substring(0, 2)
              //                               : wooCommerceMarketPlaceProvider.selectedProduct?.todayDate.day.toString()),
              //                         ),
              //                       )
              //                     ],
              //                   )),
              //             )
              //           : Container(),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           TextButton(
              //             onPressed: () {
              //               // pro.checkIfUSer('+923033374110');
              //               Navigator.pop(context);
              //             },
              //             child: const Text("Back"),
              //           ),
              //           MaterialButton(
              //             color: Colors.blue,
              //             onPressed: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (contxt) =>
              //                           const PaymnetScreen()));
              //             },
              //             child: const Text(
              //               "Next",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           )
              //         ],
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  goToPaymentScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (contxt) => PaymentScreen()));
  }
}
