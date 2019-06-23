import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:flutter/services.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final PageController pageController = PageController(initialPage: 0);
  ValueNotifier<int> valueNotifier = ValueNotifier(0);

  App() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pageViewIndicator = PageViewIndicator(
      pageIndexNotifier: valueNotifier,
      length: 3,
      normalBuilder: (animationController, index) => Circle(
            size: 5.0,
            color: Color(0xffa15cb6),
          ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
            child: Circle(
              size: 5.0,
              color: Colors.white,
            ),
          ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color(0xff82269e),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "User",
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffbd8dcc),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      height: 339,
                      child: PageView(
                        onPageChanged: (index) => valueNotifier.value = index,
                        controller: pageController,
                        children: <Widget>[
                          buildCardFatura(),
                          buildCardFatura(),
                          buildCardFatura(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 0,
                child: Container(
                    padding: const EdgeInsets.all(14),
                    child: pageViewIndicator),
              ),
              Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 15),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(width: 17),
                    ActionCard(
                      "Indicar amigos",
                      Icons.person_outline,
                    ),
                    ActionCard(
                      "Cobrar",
                      Icons.attach_money,
                    ),
                    ActionCard(
                      "Depositar",
                      Icons.monetization_on,
                    ),
                    ActionCard(
                      "Indicar amigos",
                      Icons.person_outline,
                    ),
                    ActionCard(
                      "Indicar amigos",
                      Icons.person_outline,
                    ),
                    SizedBox(width: 17),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Center buildCardFatura() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              size: 27,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 45, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "FATURA FECHADA",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "R\$",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        "  674",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        ",54",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "VENCIMETO 25 JUN",
                              style: TextStyle(
                                color: Color(0xff999999),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 14),
                              child: OutlineButton(
                                child: Text(
                                  "PAGAR",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                onPressed: () {},
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 7,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              faturaInfoBar(
                                Color(0xffff9b00),
                                1,
                                topRadius: true,
                              ),
                              faturaInfoBar(
                                Color(0xff00bcc9),
                                1,
                              ),
                              faturaInfoBar(
                                Color(0xffe5615c),
                                2,
                              ),
                              faturaInfoBar(
                                Color(0xff9ed230),
                                1,
                                bottomRadius: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {},
                child: Container(
                  color: Color(0xfff7f7f7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Icon(Icons.directions_bus,
                            color: Color(0xff8b8b8b)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Compra mais recene em Chama - o App do Gas. no valor de R\$ 74,99 hoje",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 18,
                          color: Color(0xff8b8b8b),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget faturaInfoBar(Color backColor, int flex,
      {bool topRadius: false, bool bottomRadius: false}) {
    final sideBarRadius = Radius.circular(5);
    BorderRadius border;
    if (topRadius) {
      border = BorderRadius.vertical(top: sideBarRadius);
    } else if (bottomRadius) {
      border = BorderRadius.vertical(bottom: sideBarRadius);
    }
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: border,
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String text;
  final IconData icon;

  ActionCard(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(8),
      width: 100,
      decoration: BoxDecoration(
        color: Color(0xff9140a7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: 27,
          ),
          Text(
            text,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 15),
          )
        ],
      ),
    );
  }
}
