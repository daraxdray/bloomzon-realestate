import 'package:flutter/material.dart';
import 'package:bloomzon_estate/services/salesServices.dart';
import 'dart:async';
import '../services/rentServices.dart';
import '../classes/property.dart';
import '../components/propertyList.dart';
import 'eachProperty.dart';
import 'package:bloomzon_estate/data/states.dart';
import 'package:bloomzon_estate/data/countries.dart';

class SaleHouses extends StatefulWidget {
  SaleHouses() : super();

  @override
  State<StatefulWidget> createState() => _SaleHousesState();
}

class _SaleHousesState extends State<SaleHouses> {
  List<Property> properties = [];
  List<Property> filteredProperties = [];

  String typeValue = "Any Property Type";
  String furnValue = "Furnished";
  String regionValue = "Any Region";
  String bedroomValue = "Bedrooms";
  String bathroomValue = "Bathrooms";
  String minAmountValue = "Min Amount";
  String maxAmountValue = "Max Amount";
  String statusValue = "Any Status";
  List countries; //Countries data
  List states = [{'name':'Any Region'}]; //States data
  int stateLoading;
  String countryValue = "0";

  TextEditingController bathroomController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();

  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();

  String number = "5";

  bool isButtonDisabled;
  bool isInitFilter;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = true;
    SalesServices.getProperties().then((propertiesFromServer) {
      setState(() {
        properties = propertiesFromServer;
        filteredProperties = properties;
      });
    });
  }

  getStates(){
    List st = stateList;
    st = st.where((element)
    {
      return   element['id'] == 0 || element['country_id'] == int.parse(countryValue);
    }).toList();
    print(st);
    return st.length > 1 ? st : [];

  }
  void filter() {
    List<Property> tempProperty = properties;
    if (regionValue != null &&
        regionValue.trim().isNotEmpty &&
        regionValue != "Any Region") {
      tempProperty = tempProperty
          .where(
              (p) => p.state.toLowerCase().contains(regionValue.toLowerCase()))
          .toList();
    }
    if (typeValue != null &&
        typeValue.trim().isNotEmpty &&
        typeValue != "Any Property Type") {
      tempProperty = tempProperty
          .where(
              (p) => p.propType.toLowerCase().contains(typeValue.toLowerCase()))
          .toList();
    }
    if (bedroomController.text != null &&
        bedroomController.text.trim().isNotEmpty) {
      tempProperty = tempProperty
          .where((p) => p.bedroom == bedroomController.text)
          .toList();
    }

    if (bathroomController.text != null &&
        bathroomController.text.trim().isNotEmpty) {
      tempProperty = tempProperty
          .where((p) => p.bathroom.contains(bathroomController.text))
          .toList();
    }

    if (minController.text != null && minController.text.trim().isNotEmpty) {
      tempProperty = tempProperty
          .where((p) => int.parse(p.amount) >= int.parse(minController.text))
          .toList();
    }

    if (maxController.text != null && maxController.text.trim().isNotEmpty) {
      tempProperty = tempProperty.where((p) {
        if (int.parse(p.amount) <= int.parse(maxController.text)) {
          print(p.title);
          print("${p.amount} --------- ${maxController.text}");
          print(int.parse(p.amount));
          print(int.parse(maxController.text));
          return true;
        }
        return false;
      }).toList();
    }

    setState(() {
      filteredProperties = tempProperty;
    });
  }

  Future<void> refresh() async {
    setState(() {
      filteredProperties = properties;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Properties for Sale"),
        backgroundColor: Color(0xff780202),
        key: GlobalKey(debugLabel: "sca"),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          children: <Widget>[
            Container(
                child: Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              child: MaterialButton(
                  disabledColor: Colors.grey,
                  color: Colors.white,
                  elevation: 0,
                  key: GlobalKey(debugLabel: "sca"),
                  onPressed: () {
                    setState(() {
                      _settingModalBottomSheet(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.filter_list),
                      Text(
                        "Filter",
                        style: TextStyle(
                          color: Color(0xff022378),
                        ),
                      ),
                    ],
                  )),
            )),
            filteredProperties.length > 0
                ? Expanded(
                    child: ListView(
                      children: filteredProperties.map(
                        (item) {
                          return PropertyList(
                            amount: item.amount,
                            imagePath: item.img1,
                            location: item.address,
                            propId: item.prop_id,
                            region: item.region,
                            saleOrRent: item.status,
                            title: item.title,
                            phone: item.phone,
                            state: item.state,
                            name: item.name,
                            email: item.user_email,
                            isFav: item.isFav,
                            goto: EachProperty(
                              item: item,
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
                : CircularProgressIndicator(
                    backgroundColor: Color(0xffff0000),
                  ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 500,
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModelState) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "Filter Property type",
                        style: TextStyle(fontSize: 30),
                      ),
                      // FutureBuilder(
                      //   future: getCountries(),
                      //   builder: (context,snapshot){
                      //
                      //     if(snapshot.hasData) {
                      //       List gc = [{'id':"0",'name':'Any Country'}];
                      //       gc.addAll(snapshot.data);
                      //       return ;
                      //     }
                      //     else  {
                      //       return Container(
                      //         alignment: Alignment.center,
                      //           height: 90,
                      //           width:90,
                      //           child: CircularProgressIndicator(
                      //           backgroundColor: Color(0xffff0000),
                      //     ));
                      //     }
                      //   }
                      // ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: countryValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {

                            setModelState(() {
                              countryValue = newValue;
                              List res = [{'id':"0", 'name': 'Any Region'}];
                              res.addAll(getStates());

                              if(res.length <= 1){
                                stateLoading = 0;
                              }else{
                                states = res;
                                stateLoading = 2;
                              }
                            });
                          },
                          items: countryList.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: "${value['id']}",
                              child: Text(value['name']),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        child: stateLoading == 0? DropdownButton<String>(
                          isExpanded: true,
                          value: regionValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setModelState(() {
                              regionValue = newValue;
                            });
                          },
                          items: states.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value['name'],
                              child: Text(value['name']),
                            );
                          }).toList(),
                        ) :
                        stateLoading == 1? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xffff0000),
                            )) : DropdownButton<String>(
                          isExpanded: true,
                          value: regionValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setModelState(() {
                              regionValue = newValue;
                            });
                          },
                          items: states.map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: "${value['name']}",
                              child: Text(value['name']),
                            );
                          }).toList(),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: typeValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setModelState(() {
                              typeValue = newValue;
                            });
                          },
                          items: <String>[
                            'Any Property Type',
                            'House',
                            'Offic'
                                'e',
                            'Store',
                            'Land'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: statusValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setModelState(() {
                              statusValue = newValue;
                            });
                          },
                          items: <String>['Any Status', 'Sale', 'Rent']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black45,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: bedroomController,
                            decoration: InputDecoration(hintText: "Bedrooms"),
                          )),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black45,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: bathroomController,
                          decoration: InputDecoration(hintText: "Bathroom"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black45,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: minController,
                          decoration: InputDecoration(hintText: "Min Amount"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black45,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: maxController,
                          decoration: InputDecoration(hintText: "Max Amount"),
                        ),
                      ),
                      MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          // setState(() {
                          //   filteredProperties = properties
                          //       .where((p) => p.amount.contains("5"))
                          //       .toList();
                          // });
                          setModelState(() {
                            isButtonDisabled = false;
                            number = "3";
                          });
                          Navigator.pop(context);
                          filter();
                        },
                        child: Text(
                          "Apply Filter",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xfffa2121),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}

class isButtonDisabled {}
