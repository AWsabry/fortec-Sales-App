import 'package:flutter/widgets.dart';
import 'package:sales_app/providers/Auth_Wrapper.dart';
import 'package:sales_app/screens/home/home.dart';
import 'package:sales_app/screens/orderScreen/order_screen.dart';
import 'package:sales_app/screens/profile/profile_screen.dart';
import 'package:sales_app/screens/splash/splash_screen.dart';
import './screens/sign_in/sign_in_screen.dart';
import './screens/CustomerData/customerData.dart';
import './screens/login_success/login_success_screen.dart';
import './screens/OrderSubmit/OrderSucess.dart';
import 'screens/displayallOrders/Cart_Orders.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  AuthenticationWrapper.routeName :(context)=> AuthenticationWrapper(),
  SplashScreen.routeName :(context)=> SplashScreen(),
  SignInScreen.routeName :(context)=> SignInScreen(),
  HomeScreen.routeName :(context)=> HomeScreen(),
  ProfileScreen.routeName :(context)=> ProfileScreen(),
  CustomerData.routeName :(context)=> CustomerData(),
  LoginSuccessScreen.routeName :(context)=> LoginSuccessScreen(),
  OrderSuccessScreen.routeName :(context)=>OrderSuccessScreen(),
  OrdersScreen.routeName : (context) => OrdersScreen(),
  DisplayOrders.routeName : (context) => DisplayOrders()
};
