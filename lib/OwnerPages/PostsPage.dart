import 'package:flutter/material.dart';
import 'package:ownerapp/Models/Posts.dart';
import 'package:ownerapp/Models/User.dart';
import 'package:toast/toast.dart';

class PostPage extends StatelessWidget {
  final UserOwner userOwner;
  final List<Post> posts;

  PostPage({
    Key key,
    @required this.userOwner,
    @required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: Column(
        children: posts
            .map((e) => Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 310.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('From'),
                          Text(
                            '${e.sources[0].source.substring(0, 20)}...',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('To'),
                          Text(
                            '${e.destinations[e.destinations.length - 1].destination.substring(0, 20)}...',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Material'),
                          Text(
                            '${e.material}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tonnage'),
                          Text(
                            '${e.tonnage}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Truck Preferences'),
                          Text(
                            '${e.truckPreferences}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Expected Price'),
                          Text(
                            '${e.expectedPrice}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Mode'),
                          Text(
                            '${e.paymentMode}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Created On'),
                          Text(
                            '${e.createdOn}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Expired On'),
                          Text(
                            '${e.expiredOn}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact Person'),
                          Text(
                            '${e.contactPerson}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Contact Person Phone No.'),
                          Text(
                            '${e.contactPersonPhone}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      Divider(),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print('bid now');
                            if (userOwner.oSubscriptionStatus ==
                                'Not on subcsription')
                              Toast.show(
                                'You need an active Subscription Plan',
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.CENTER,
                              );
                            else {
                              print('start');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 40.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'Bid',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
