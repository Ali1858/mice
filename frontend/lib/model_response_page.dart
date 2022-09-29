import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metooltip/metooltip.dart';
import 'package:move37/home_page_test.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ModelResponsePage extends StatefulWidget {
  Map response = {};
  ModelResponsePage({Key? key, required this.response}) : super(key: key);

  @override
  State<ModelResponsePage> createState() => _ModelResponsePageState();
}

class _ModelResponsePageState extends State<ModelResponsePage> {
  bool isLoading = true;
  List maskedIndex = [];
  List prediction = [];
  String inputData = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maskedIndex = widget.response['masked_index'];
    prediction = widget.response['prediction'];
    inputData = widget.response['input'];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePageTest()),
              );
            },
            child: const Icon(Icons.arrow_back)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: const Color(0xff8B8B8B),
              height: 2.0,
            )),
        backgroundColor: const Color(0xff0e042e),
        elevation: 0.0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/LogoM.png',
              width: 140,
            )
          ],
        ),
      ),
      body: !isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveWrapper.of(context).isMobile ||
                          (!ResponsiveWrapper.of(context).isMobile &&
                              !ResponsiveWrapper.of(context).isPhone)
                      ? width * 0.1
                      : width * 0.2),
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Row(),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                      child: Text(
                    "Model Generated Counterfactual Edits",
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: containerBackgroundColor),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5.5,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'Original Contrast \nProbability Prediction : ',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${widget.response['orig_contrast_prob'].toStringAsFixed(3)}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.redAccent
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const ToolTip(info: "testing"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: const [
                                        Text(""),
                                        // RichText(
                                        //   text: TextSpan(
                                        //     text: 'Minimality :',
                                        //     style: GoogleFonts.poppins(
                                        //       fontSize: 16,
                                        //       color: Colors.blueAccent,
                                        //     ),
                                        //     children: <TextSpan>[
                                        //       TextSpan(
                                        //         text: '',
                                        //         style: GoogleFonts.poppins(
                                        //           fontSize: 16,
                                        //           color: Colors.redAccent
                                        //               .withOpacity(0.8),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        // ToolTip(info: "testing"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Row(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.end,
                                    //   children: [
                                    //     RichText(
                                    //       text: TextSpan(
                                    //         text: 'Mask fraction : ',
                                    //         style: GoogleFonts.poppins(
                                    //           fontSize: 16,
                                    //           color: Colors.blueAccent,
                                    //         ),
                                    //         children: <TextSpan>[
                                    //           TextSpan(
                                    //             text: '',
                                    //             style: GoogleFonts.poppins(
                                    //               fontSize: 16,
                                    //               color: Colors.redAccent
                                    //                   .withOpacity(0.8),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     ToolTip(info: "testing"),
                                    //   ],
                                    // )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'Contrast Label for \nOriginal Label :',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${widget.response['orig_pred']}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.redAccent
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const ToolTip(info: "testing"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'Predicted Contrast Label :',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.blueAccent,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${widget.response['contrast_pred']}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.redAccent
                                                      .withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const ToolTip(info: "testing"),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Text(
                                    //   "Mask fraction:  ",
                                    //   style: GoogleFonts.poppins(
                                    //     fontSize: 16,
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    " Original Text :",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: containerBackgroundColor, fontSize: 24),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    elevation: 5.5,
                    child: Container(
                        width: ResponsiveWrapper.of(context).isMobile
                            ? width / 1.2
                            : width / 1.4,
                        decoration: BoxDecoration(
                          // color: containerBackgroundColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            inputData,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        )),
                  ),
                  Row(
                    children: [
                      Text(
                        " Predicted Class: ${widget.response['contrast_pred']}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: containerBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Top 5 Generated Counterfactuals :",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: containerBackgroundColor, fontSize: 24),
                    ),
                  ),
                  SizedBox(
                      width: ResponsiveWrapper.of(context).isMobile
                          ? width / 1.2
                          : width / 1.4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            prediction.length <= 5 ? prediction.length : 5,
                        itemBuilder: (context, index) {
                          return Container(
                              margin:
                                  EdgeInsets.only(top: index == 0 ? 0 : 15.0),
                              child: Card(
                                elevation: 5.6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: ResponsiveWrapper.of(context)
                                                  .isMobile
                                              ? width / 1.2
                                              : width / 1.4,
                                          decoration: BoxDecoration(
                                            // color: containerBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: PrettyDiffText(
                                            oldText: inputData,
                                            newText: prediction[index]
                                                ['edited_input'],
                                            defaultTextStyle:
                                                GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                          )),
                                      Row(
                                        children: [
                                          Text(
                                            "Predicted Class : ${prediction[index]['new_pred']}",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            " Predicted Class: ${prediction[index]['new_contrast_prob_pred'].toStringAsFixed(3)}",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color:
                                                      containerBackgroundColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveWrapper.of(context).isMobile ||
                                (!ResponsiveWrapper.of(context).isMobile &&
                                    !ResponsiveWrapper.of(context).isPhone)
                            ? width * 0.25
                            : width * 0.6),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePageTest()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Try Again"),
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
    );
  }
}

class ToolTip extends StatefulWidget {
  final String info;
  const ToolTip({Key? key, required this.info}) : super(key: key);

  @override
  State<ToolTip> createState() => _ToolTipState();
}

class _ToolTipState extends State<ToolTip> {
  @override
  Widget build(BuildContext context) {
    return MeTooltip(
      message: widget.info,
      preferOri: PreferOrientation.right,
      child: const Icon(
        Icons.info_outline,
        color: Colors.grey,
      ),
    );
  }
}
