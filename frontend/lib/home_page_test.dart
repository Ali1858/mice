import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move37/chart.dart';
import 'package:move37/model_response_page.dart';
import 'package:move37/network/apiHelper.dart';
import 'package:responsive_framework/responsive_framework.dart';

Color containerBackgroundColor = const Color(0xff1E1E1E);
Color backgroundColor = const Color(0xffF2F2F2);
Color matrixColor = const Color(0xffF6AF65);
int groupVal = -1;

class HomePageTest extends StatefulWidget {
  const HomePageTest({Key? key}) : super(key: key);

  @override
  State<HomePageTest> createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  bool isLoading = true;
  List<bool> _isSelected = [];
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  List<Widget> dataSetsWidgets = [];
  List<String> preTrainedSentenses = [];
  List dataSets = [];
  var apiRespone;
  TextEditingController customSentence = TextEditingController();
  List<List<Map<String, dynamic>>> gData = [
    [
      {
        'id': 'Bar 1',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.993},
          {'domain': 'Minimality', 'measure': 0.98},
        ],
      },
      {
        'id': 'Bar 2',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.526},
          {'domain': 'Minimality', 'measure': 0.483},
        ],
      },
    ],
    [
      {
        'id': 'Bar 1',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.973},
          {'domain': 'Minimality', 'measure': 0.86},
        ],
      },
      {
        'id': 'Bar 2',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.359},
          {'domain': 'Minimality', 'measure': 0.461},
        ],
      },
    ],
    [
      {
        'id': 'Bar 1',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.975},
          {'domain': 'Minimality', 'measure': 0.775},
        ],
      },
      {
        'id': 'Bar 2',
        'data': [
          {'domain': 'Flip-score', 'measure': 0.636},
          {'domain': 'Minimality', 'measure': 2.447},
        ],
      },
    ]
  ];

  @override
  void initState() {
    super.initState();

    ///Fetching of datasets
    fetchDataSets();
  }

  void fetchDataSets() async {
    apiRespone = await apiBaseHelper.getDataSets();

    dataSets.clear();
    dataSets = apiRespone.entries.map((entry) => entry.key).toList();
    //dataSets = response['result'] ?? [];

    ///Building datasets locally
    for (final data in dataSets) {
      ///Build datasets widgets
      dataSetsWidgets.add(ToggleButton(name: data.toString().toUpperCase()));
      _isSelected.add(dataSets.first == data);
      if (dataSets.first == data) {
        selectedDataset = data;
        final List sentenses = apiRespone[dataSets.first];
        for (var element in sentenses) {
          preTrainedSentenses.add(element['text']);
          groupVal = 0;
        }
        selectedSent = preTrainedSentenses.first;
      }
    }
    setState(() {
      ///Kill loader
      isLoading = false;
    });
  }

  String selectedSent = "";
  String selectedDataset = "";
  void fetchModelResponse() async {
    setState(() {
      /// Trigger Loader
      // isLoading = true;
    });

    if (groupVal == -1) {
      selectedSent = customSentence.value.text;
    }
    // print(selectedSent);
    // print(selectedDataset);

    ///Send chosen dataset and string data

    await apiBaseHelper
        .getModelResponse(
            groupVal == -1 ? -1 : (groupVal), selectedSent, selectedDataset)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ModelResponsePage(
                  response: value[0],
                )),
      );
    });
  }

  void changeSentenses(int index) {
    final List sentenses = apiRespone[dataSets[index]];
    selectedDataset = dataSets[index];
    preTrainedSentenses.clear();
    for (var element in sentenses) {
      preTrainedSentenses.add(element['text']);
    }
    selectedSent = preTrainedSentenses[groupVal];
  }

  @override
  Widget build(BuildContext context) {
    double heightGap = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: heightGap,
                    ),
                    Text(
                      "Select a Dataset to Generate Counterfactual Edits",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: containerBackgroundColor,
                            fontSize: ResponsiveWrapper.of(context).isMobile
                                ? 24
                                : 30),
                      ),
                    ),
                    SizedBox(
                      height: heightGap * 2,
                    ),
                    ToggleButtons(
                      color: Colors.black,
                      fillColor: Colors.blueGrey,
                      selectedBorderColor: containerBackgroundColor,
                      selectedColor: Colors.white,
                      borderColor: containerBackgroundColor.withOpacity(0.1),
                      isSelected: _isSelected,
                      onPressed: (int newIndex) {
                        setState(() {
                          for (int i = 0; i < _isSelected.length; i++) {
                            if (i == newIndex) {
                              _isSelected[i] = true;
                            } else {
                              _isSelected[i] = false;
                            }
                          }
                          changeSentenses(newIndex);
                        });
                      },
                      children: dataSetsWidgets,
                    ),
                    Row(),
                    SizedBox(
                      height: heightGap * 2,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width:
                                selectedDataset == dataSets.first ? 350 : 300,
                            height:
                                selectedDataset == dataSets.first ? 350 : 300,
                            child: Opacity(
                              opacity:
                                  selectedDataset == dataSets.first ? 1.0 : 0.4,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  GetLegend(
                                    color2: Colors.green.shade900,
                                    color1: Colors.green.shade300,
                                  ),
                                  SizedBox(
                                    width: selectedDataset == dataSets.first
                                        ? 350
                                        : 300,
                                    height: selectedDataset == dataSets.first
                                        ? 350
                                        : 300,
                                    child: BarChart(
                                      color1: Colors.green.shade300,
                                      color2: Colors.green.shade900,
                                      gData: gData[0],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                            width: selectedDataset != dataSets.last &&
                                    selectedDataset != dataSets.first
                                ? 350
                                : 300,
                            height: selectedDataset != dataSets.last &&
                                    selectedDataset != dataSets.first
                                ? 350
                                : 300,
                            child: Opacity(
                              opacity: selectedDataset != dataSets.last &&
                                      selectedDataset != dataSets.first
                                  ? 1.0
                                  : 0.4,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  GetLegend(
                                    color2: Colors.red.shade900,
                                    color1: Colors.red.shade300,
                                  ),
                                  SizedBox(
                                    width: selectedDataset != dataSets.last &&
                                            selectedDataset != dataSets.first
                                        ? 350
                                        : 300,
                                    height: selectedDataset != dataSets.last &&
                                            selectedDataset != dataSets.first
                                        ? 350
                                        : 300,
                                    child: BarChart(
                                      color1: Colors.red.shade300,
                                      color2: Colors.red.shade900,
                                      gData: gData[1],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                            width: selectedDataset == dataSets.last ? 350 : 300,
                            height:
                                selectedDataset == dataSets.last ? 350 : 300,
                            child: Opacity(
                              opacity:
                                  selectedDataset == dataSets.last ? 1.0 : 0.4,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  GetLegend(
                                    color2: Colors.teal.shade900,
                                    color1: Colors.teal.shade300,
                                  ),
                                  SizedBox(
                                    width: selectedDataset == dataSets.last
                                        ? 350
                                        : 300,
                                    height: selectedDataset == dataSets.last
                                        ? 350
                                        : 300,
                                    child: BarChart(
                                      color1: Colors.teal.shade300,
                                      color2: Colors.teal.shade900,
                                      gData: gData[2],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Graph Description: ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            "Evaluation of minimal contrastive edits w.r.t gradient based approach considering flip score and minimality metrics.",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Flip Score: ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            "Percentage of instances for which edit results in the contrast label.",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Minimality: ",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          Text(
                            "Levenshtein distance between the original of edited input.",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: containerBackgroundColor,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [],
                    ),
                    SizedBox(
                      height: heightGap * 2,
                    ),
                    Text(
                      "Select a Quick Sentence to Generate Counterfactual Edits",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: containerBackgroundColor,
                            fontSize: ResponsiveWrapper.of(context).isMobile
                                ? 24
                                : 30),
                      ),
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < preTrainedSentenses.length; i++)
                          Container(
                            child: SentenseRadioButton(
                                label: preTrainedSentenses[i],
                                onChanged: (value) {
                                  setState(() {
                                    groupVal = value;
                                    selectedSent = preTrainedSentenses[i];
                                  });
                                },
                                index: i,
                                groupVal: groupVal,
                                customSentence: customSentence),
                          )
                      ],
                    ),
                    SizedBox(
                      height: heightGap * 2,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                          color: containerBackgroundColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextFormField(
                          controller: customSentence,
                          cursorColor: backgroundColor,
                          onChanged: (value) {
                            setState(() {
                              groupVal = -1;
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Enter your sentence for suggestions",
                              hintStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(color: Colors.white),
                              )),
                        )),
                    const SizedBox(
                      height: 20 * 2,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          fetchModelResponse();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text("Generate"),
                        )),
                    const SizedBox(
                      height: 20 * 2,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String name;
  const ToggleButton({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !ResponsiveWrapper.of(context).isMobile &&
              !ResponsiveWrapper.of(context).isPhone
          ? 120
          : ResponsiveWrapper.of(context).isMobile
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.1,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class SentenseRadioButton extends StatefulWidget {
  final String label;
  final void Function(dynamic) onChanged;
  int index, groupVal;
  final TextEditingController customSentence;

  SentenseRadioButton(
      {required this.label,
      required this.groupVal,
      required this.onChanged,
      required this.index,
      required this.customSentence,
      Key? key})
      : super(key: key);

  @override
  _SentenseRadioButtonState createState() => _SentenseRadioButtonState();
}

class _SentenseRadioButtonState extends State<SentenseRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              widget.onChanged(widget.index);
              widget.customSentence.clear();
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: 70,
              child: Card(
                shape: groupVal == widget.index
                    ? RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.transparent, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0))
                    : RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                elevation: 1.0,
                color: groupVal != widget.index
                    ? backgroundColor
                    : Colors.blueGrey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.label,
                        style: TextStyle(
                            color: groupVal == widget.index
                                ? backgroundColor
                                : containerBackgroundColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Radio<int>(
                    //   value: widget.index,
                    //   groupValue: widget.groupVal,
                    //   onChanged: widget.onChanged,
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GetLegend extends StatelessWidget {
  final Color color1;
  final Color color2;
  const GetLegend({Key? key, required this.color2, required this.color1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: color1,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Soc'),
          ],
        ),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              color: color2,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text('Gradient'),
          ],
        ),
      ],
    );
  }
}
