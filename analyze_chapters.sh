#!/bin/bash


# Dart Analyzer tests for Dart in Action code

set ANA=dart_analyzer --enable_type_checks --fatal-type-errors --extended-exit-code --type-checks-for-inferred-types 

echo "Testing Chapter 1"
%ANA% chap-01/1_1_strings/Listing11Strings.dart
%ANA% chap-01/1_2_simple_class/Listing12_SimpleClass.dart
%ANA% chap-01/1_3_implied_interfaces/Listing13_ImpliedInterfaces.dart
%ANA% chap-01/1_4_factory_constructors/Listing14_Factoryconstructors.dart
%ANA% chap-01/1_5_libraries/Listing15_Libraries.dart
%ANA% chap-01/1_6_first_class_functions/Listing16_Firstclassfunctions.dart
%ANA% chap-01/1_7_dart_html/Listing17_Dart_html.dart
%ANA% chap-01/1_8_dart_canvas/Listing18_DartCanvas.dart

echo "Testing Chapter 2"