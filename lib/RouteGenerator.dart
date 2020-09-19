import 'package:flutter/material.dart';
import 'package:ownerapp/CommonPages/EmiCalculator.dart';
import 'package:ownerapp/CommonPages/FadeTransition.dart';
import 'package:ownerapp/CommonPages/FreightCalculator.dart';
import 'package:ownerapp/CommonPages/IntroPageLoginOptions.dart';
import 'package:ownerapp/CommonPages/TollCalculator.dart';
import 'package:ownerapp/CommonPages/TripPlanner.dart';
import 'package:ownerapp/MyConstants.dart';
import 'package:ownerapp/OwnerPages/AddTruckFromOwner.dart';
import 'package:ownerapp/OwnerPages/EditTruckFromOwner.dart';
import 'package:ownerapp/OwnerPages/HomePageOwner.dart';
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

      //Login or Signup Pages
      case introLoginOptionPage:
        return FadeRoute(page: IntroPageLoginOptions());
      case ownerOptionPage:
        return FadeRoute(page: OwnerOptionsPage());

      //Pages which don't need LoggedIn User
      case emiCalculatorPage:
        return FadeRoute(page: EmiCalculator());
      case freightCalculatorPage:
        return FadeRoute(page: FreightCalculator());
      case tollCalculatorPage:
        return FadeRoute(page: TollCalculator());
      case tripPlannerPage:
        return FadeRoute(page: TripPlanner());

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
          userOwner: (args as List)[0],
          posts: (args as List)[1],
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
