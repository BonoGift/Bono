import 'package:bono_gifts/config/constants.dart';
import 'package:bono_gifts/models/wcmp_api/vendor_product.dart';
import 'package:bono_gifts/provider/buy_provider.dart';
import 'package:bono_gifts/provider/wcmp_provider.dart';
import 'package:bono_gifts/views/buy/order_summry.dart';
import 'package:bono_gifts/views/buy/select_network.dart';
import 'package:bono_gifts/views/gift/widgets/loading_gifts_widget.dart';
import 'package:bono_gifts/views/gift/widgets/primary_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final pro = Provider.of<BuyProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var form = DateFormat('dd-MMM');
    final pro = Provider.of<BuyProvider>(context);
    final wcmp = Provider.of<WooCommerceMarketPlaceProvider>(context);
    int index = 1000000;

    return SafeArea(
      child: Scaffold(
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
              const SizedBox(
                height: 10,
              ),
              pro.userName != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PrimaryText(text: "To"),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black26, width: 4)),
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
                                      pro.userName!,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                            IconButton(
                                onPressed: () {
                                  if (wcmp.apiState == ApiState.completed || wcmp.apiState == ApiState.error) {
                                    wcmp.apiState = ApiState.none;
                                    wcmp.clearShops();
                                    pro.clearAll();
                                  }
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  size: 30,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectNetwork()));
                        },
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15, right: 15),
                                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                                child: const Center(child: Text("To")),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "add a recipient",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  RotatedBox(
                                    quarterTurns: 4,
                                    child: Image.asset(
                                      addBtn,
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                              Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              pro.userName != null
                  ?
                  // Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           // const Text("Delivery Address : Available"),
                  //           Text("Location : ${pro.userAddress}"),
                  //           // Row(
                  //           //   mainAxisAlignment: MainAxisAlignment.end,
                  //           //   children: [
                  //           //     MaterialButton(
                  //           //       onPressed: () =>
                  //           //           Navigator.pushNamed(context, orderSummry),
                  //           //       color: Colors.grey,
                  //           //       child: const Text(
                  //           //         "Next",
                  //           //         style: TextStyle(color: Colors.white),
                  //           //       ),
                  //           //     )
                  //           //   ],
                  //           // )
                  //         ],
                  //       ),
                  Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey[600],
                                ),
                                PrimaryText(
                                  text: "Delivery Location: ",
                                  fontSize: 17,
                                ),
                                PrimaryText(
                                  text: "Available (xxxxxx, ${pro.userAddress})",
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  : Container(),
              giftWidget(wcmp, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget giftWidget(WooCommerceMarketPlaceProvider provider, int index) {
    switch (provider.apiState) {
      case ApiState.none:
        return Container();
      case ApiState.loading:
        return LoadingGiftsWidget();

      case ApiState.completed:
        if (provider.nearbyVendors.isEmpty) {
          return const Center(
            child: Text("No gift shops found near you."),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                provider.categoriesshow.length,
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          PrimaryText(
                            text: provider.categoriesshow[index].name ?? '',
                            textAlign: TextAlign.start,
                            fontSize: 17,
                          ),
                          PrimaryText(
                            text: ' (Same Day Delivery)',
                            fontSize: 12,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      height: 140,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, prodIndex) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: InkWell(
                              onTap: () {
                                VendorProduct vendorProduct = provider.filterByCategory(provider.categories[index])[prodIndex];
                                provider.selectVendor(vendorProduct);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderSummry()));
                              },
                              child: Container(
                                width: 90,
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3, color: index == prodIndex ? Colors.white : Colors.white)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: Hero(
                                        tag: provider.filterByCategory(provider.categories[index])[prodIndex].images!.first.src.toString(),
                                        child: Image.network(
                                          provider.filterByCategory(provider.categories[index])[prodIndex].images!.first.src.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: Text(
                                              provider.filterByCategory(provider.categories[index])[prodIndex].name.toString(),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Text(
                                              "Price ${provider.filterByCategory(provider.categories[index])[prodIndex].price.toString()}\$",
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 8.0,
                          ),
                          itemCount: provider.filterByCategory(provider.categories[index]).length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      case ApiState.error:
        return const Center(child: Text("Error!"));
    }
  }
}
