import 'package:flutter/material.dart';
import 'package:ownerapp/CommonPages/FadeTransition.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/OwnerPages/AddOnTruck.dart';
import 'package:ownerapp/OwnerPages/AddTruckFromOwner.dart';
import 'package:ownerapp/OwnerPages/EditTruckFromOwner.dart';
import 'package:ownerapp/OwnerPages/HomePageOwner.dart';
import 'package:ownerapp/OwnerPages/MyBidsPage.dart';
import 'package:ownerapp/OwnerPages/MyDeliveriesPage.dart';
import 'package:ownerapp/OwnerPages/OwnerOptionsPage.dart';
import 'package:ownerapp/OwnerPages/PostsPage.dart';
import 'package:ownerapp/OwnerPages/SubscriptionOwner.dart';
import 'package:ownerapp/OwnerPages/ViewProfileOwner.dart';
import 'package:ownerapp/OwnerPages/ViewTrucksOwner.dart';
import 'package:ownerapp/SplashScreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Basic Pages
      case splashPage:
        return FadeRoute(page: SplashScreen());

      case ownerOptionPage:
        return FadeRoute(page: OwnerOptionsPage());

      //Pages once the user is LoggedIn - Owner
      case homePageOwner:
        return FadeRoute(page: HomePageOwner(userOwner: args));
      case addTruckOwner:
        return FadeRoute(page: AddTruckOwner(userOwner: args));
      case viewTrucksOwner:
        return FadeRoute(
            page: ViewTrucksOwner(
          userOwner: args,
        ));
      case editTrucksOwner:
        return FadeRoute(
            page: EditTruckOwner(
                truck: (args as Map)["truck"],
                viewTrucksOwnerState: (args as Map)["state"]));
      case viewProfileOwner:
        return FadeRoute(
            page: ViewProfileOwner(
          userOwner: args,
        ));
      case subscriptionOwner:
        return FadeRoute(
            page: SubscriptionOwner(
          userOwner: args,
        ));
      case viewPosts:
        return FadeRoute(
            page: PostPage(
          userOwner: args,
        ));

      case myBidsOwner:
        return FadeRoute(
            page: MyBidspage(
          userOwner: args,
        ));

      case myDeliveriesOwner:
        return FadeRoute(page: MyDeliveriesPage(userOwner: args));

      case addOnTruckOwner:
        return FadeRoute(
            page: AddOnTruckPlansPage(
          userOwner: args,
        ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
