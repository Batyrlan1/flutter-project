import 'package:Tau/other/Climb/climb.dart';
import 'package:Tau/other/Climb/places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'geolocation.dart';

class Searchloc extends StatefulWidget {
  const Searchloc({Key key}) : super(key: key);

  @override
  _SearchlocState createState() => _SearchlocState();
}

class _SearchlocState extends State<Searchloc> {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            centerTitle: true,
            title: Text(
              "Найдите свой город",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
                size: 18,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateClimb()));
              },
            ),
          ),
        ),
        body: SearchInjector(
            child: SafeArea(
          child: Consumer<LocationApi>(
            builder: (_, api, child) => SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.062,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              offset: Offset(6, 2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              offset: Offset(-6, -2),
                              blurRadius: 6.0,
                              spreadRadius: 3.0,
                            ),
                          ]),
                      child: TextFormField(
                        controller: api.adressController,
                        onChanged: api.handleSearch,
                        cursorColor: Color(0xFF7A9BEE),
                        decoration: InputDecoration(
                          suffixIcon: Icon(CupertinoIcons.search, size: 18),
                          hintStyle: GoogleFonts.montserrat(
                              fontSize: 14, color: Colors.black),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            top: 7,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(
                              color: Color(0xFF7A9BEE),
                            ),
                          ),
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Colors.white,
                      child: StreamBuilder<List<Place>>(
                          stream: api.controllerOut,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Center(
                                child: Text(
                                  "Город не найден",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            }
                            final data = snapshot.data;
                            return Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Container(
                                  child: Builder(builder: (context) {
                                    return Column(
                                      children: List.generate(
                                        data.length,
                                        (index) {
                                          final place = data[index];
                                          return ListTile(
                                            onTap: () {
                                              api.adressController.text =
                                                  "${place.locality}";
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            title: Text("${place.locality}"),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      height: 30.0,
                      width: 105,
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        shadowColor: Colors.blueAccent,
                        color: Color(0xFF7A9BEE),
                        elevation: 7.0,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateClimb(
                                        address: api.adressController.text)));
                          },
                          child: Center(
                            child: Text(
                              "Выбрать",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}

class SearchInjector extends StatelessWidget {
  final Widget child;

  const SearchInjector({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationApi(),
      child: child,
    );
  }
}
