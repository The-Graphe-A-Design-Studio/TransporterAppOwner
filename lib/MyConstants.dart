//API Key
const GoogleApiKey = "AIzaSyCSdJNFravZ9yjzisUAhLgohy_MWbS41XI";
const GoogleMapsKey = "AIzaSyDH8iEIWiHLIRcSsJWm8Fh1qbgwt0JRAc0";

const autoCompleteLink =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GoogleApiKey&components=country:in&types=(cities)&input=";
const reverseGeocodingLink =
    'https://maps.googleapis.com/maps/api/geocode/json?key=$GoogleMapsKey&latlng=';

const RAZORPAY_ID = "rzp_test_Ox9H2BWMViEG65";
const RAZORPAY_SECRET = "2rOaeIWZt4iOJUjMJGXRk5dw";

//Basic Pages
const String splashPage = "/";
const String truckOwnerUser = "TruckOwner";
const String transporterUser = "Transporter";
const String driverUser = "Driver";

//Login or SignUp Pages
const String driverOptionPage = "/driverOptionPage";
const String transporterOptionPage = "/transporterOptionPage";
const String ownerOptionPage = "/ownerOptionPage";

//Pages which don't need LoggedIn User
const String emiCalculatorPage = "/emiCalculatorPage";
const String freightCalculatorPage = "/freightCalculatorPage";
const String tollCalculatorPage = "/tollCalculatorPage";
const String tripPlannerPage = "/tripPlannerPage";

//Pages once the user is LoggedIn - Driver
const String homePageDriver = "/homePageDriver";
const String driverUpcomingOrderPage = "/driverUpcomingOrderPage";

//Pages once the user is LoggedIn - Transporter
const String homePageTransporter = "/homePageTransporter";
const String uploadDocsTransporter = "/uploadDocsTransporter";
const String newTransportingOrderPage = "/newTransportingOrderPage";
const String orderSummaryPage = "/orderSummaryPage";
const String requestTransportPage = "/requestTransportPage";
const String viewPosts = "/viewPosts";

//Pages once the user is LoggedIn - Owner
const String homePageOwner = "/homePageOwner";
const String addTruckOwner = "/addTruckOwner";
const String viewTrucksOwner = "/viewTrucksOwner";
const String editTrucksOwner = "/editTrucksOwner";
const String viewProfileOwner = "/viewProfileOwner";
const String subscriptionOwner = "/subscriptionOwner";
const String myBidsOwner = "/myBids";
const String myDeliveriesOwner = "/myDeliveries";
const String addOnTruckOwner = "/addOns";
const String truckDetails = "/details";
const String driverLocation = '/driver';
const String truckDetailsInfo = '/truck-details-info';
