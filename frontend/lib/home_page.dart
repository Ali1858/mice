import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:move37/model_response_page.dart';
// import 'package:move37/network/apiHelper.dart';
// import 'package:responsive_framework/responsive_framework.dart';
//
Color backgroundColor = const Color(0xff1E1E1E);
Color containerBackgroundColor = const Color(0xffF2F2F2);
Color matrixColor = const Color(0xfff7c38f);
//
// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool isLoading = true;
//   List<bool> _isSelected = [];
//   ApiBaseHelper apiBaseHelper = ApiBaseHelper();
//   List<Widget> dataSetsWidgets = [];
//   @override
//   void initState() {
//     super.initState();
//
//     ///Fetching of datasets
//     fetchDataSets();
//   }
//
//   void fetchDataSets() async {
//     List dataSets = [];
//     final response = await apiBaseHelper.getDataSets();
//
//     dataSets = response['result'] ?? [];
//
//     ///Building datasets locally
//     for (final data in dataSets) {
//       ///Build datasets widgets
//       dataSetsWidgets.add(ToggleButton(name: data.toString().toUpperCase()));
//       _isSelected.add(dataSets.first == data);
//     }
//     setState(() {
//       ///Kill loader
//       isLoading = false;
//     });
//   }
//
//   void fetchModelResponse() async {
//     setState(() {
//       /// Trigger Loader
//       isLoading = true;
//     });
//
//     ///Send chosen dataset and string data
//     final response = await apiBaseHelper.getModelResponse();
//     setState(() {
//       /// Kill Loader
//       isLoading = false;
//     });
//     if (response['prediction'].isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ModelResponsePage(
//                   response: response,
//                 )),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double heightGap = MediaQuery.of(context).size.height / 30;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         bottom: PreferredSize(
//             preferredSize: Size.fromHeight(4.0),
//             child: Container(
//               color: Color(0xff8B8B8B),
//               height: 2.0,
//             )),
//         backgroundColor: backgroundColor,
//         elevation: 0.0,
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/LogoM.png',
//               width: 140,
//             )
//           ],
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator.adaptive(
//                   backgroundColor: Colors.white),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     width: ResponsiveWrapper.of(context).isMobile
//                         ? width / 1.2
//                         : width / 1.4,
//                     decoration: BoxDecoration(
//                       color: containerBackgroundColor,
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     child: TextFormField(
//                       cursorColor: backgroundColor,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                           ),
//                           focusedBorder: InputBorder.none,
//                           enabledBorder: InputBorder.none,
//                           errorBorder: InputBorder.none,
//                           disabledBorder: InputBorder.none,
//                           contentPadding: EdgeInsets.only(
//                               left: 15, bottom: 11, top: 11, right: 15),
//                           hintText: "Enter your sentence for suggestions",
//                           hintStyle: GoogleFonts.poppins(
//                             textStyle: TextStyle(color: Color(0xff8A8282)),
//                           )),
//                     )),
//                 SizedBox(
//                   height: heightGap,
//                 ),
//                 Text(
//                   "Select a method to generate results",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                         color: containerBackgroundColor,
//                         fontSize:
//                             ResponsiveWrapper.of(context).isMobile ? 24 : 30),
//                   ),
//                 ),
//                 SizedBox(
//                   height: heightGap,
//                 ),
//                 ToggleButtons(
//                   color: Colors.white,
//                   fillColor: backgroundColor,
//                   selectedBorderColor: containerBackgroundColor,
//                   selectedColor: Colors.white,
//                   borderColor: containerBackgroundColor.withOpacity(0.1),
//                   isSelected: _isSelected,
//                   onPressed: (int newIndex) {
//                     setState(() {
//                       for (int i = 0; i < _isSelected.length; i++) {
//                         if (i == newIndex) {
//                           _isSelected[i] = true;
//                         } else {
//                           _isSelected[i] = false;
//                         }
//                       }
//                     });
//                   },
//                   children: dataSetsWidgets,
//                 ),
//                 Row(),
//                 SizedBox(
//                   height: heightGap,
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       fetchModelResponse();
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.all(15.0),
//                       child: Text("Generate"),
//                     )),
//               ],
//             ),
//     );
//   }
// }
//
// class ToggleButton extends StatelessWidget {
//   final String name;
//   const ToggleButton({Key? key, required this.name}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: !ResponsiveWrapper.of(context).isMobile &&
//               !ResponsiveWrapper.of(context).isPhone
//           ? 120
//           : ResponsiveWrapper.of(context).isMobile
//               ? MediaQuery.of(context).size.width * 0.2
//               : MediaQuery.of(context).size.width * 0.1,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//       padding: EdgeInsets.symmetric(vertical: 4),
//       alignment: Alignment.center,
//       child: Text(
//         name,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }
