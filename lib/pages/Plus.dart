import 'package:Tau/other/Climb/climb.dart';
import 'package:Tau/other/upLoadPost/Uploadview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlusPage extends StatefulWidget {
  PlusPage({Key key}) : super(key: key);

  @override
  _PlusPageState createState() => _PlusPageState();
}

class _PlusPageState extends State<PlusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.48,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    "Coздавайте climb и продвигайте",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                  ),
                  child: Text(
                    " свою  идею.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        "Climb -  это Junto настоящего времени.",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        "Junto- это клуб созданный, Бенджамином Франклином для общего развития членов клуба.Они обсуждали разные идеи и дискутировали на разные темы.С помощью клуба, даже была создана пожарная безопасность города . Позже клуб перерос  в Американское философское общество, в которое привлекали лучшие умы Америки. Среди ее членов были,такие люди, как Альберт Эйнштейн,Чарльз Дарвин и Джордж Вашингтон. В ХХ веке более 200 членов были лауреатами Нобелевской премии. ",
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Text(
              " Ниже, вы можете выбрать:",
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateClimb()));
                },
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(25),
                      shadowColor: Colors.grey,
                      color: Colors.white,
                      elevation: 8.0,
                      child: Container(
                        height: 70,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/climb.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Cоздать climb',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadView()));
                },
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(25),
                      shadowColor: Colors.grey,
                      color: Colors.white,
                      elevation: 9.0,
                      child: Container(
                        height: 70,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage('assets/idea.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Продвигать идею',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
