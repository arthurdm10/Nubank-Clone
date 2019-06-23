import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nubank_clone/screens/limite_fatura.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:flutter/services.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: App(),
      ),
    );

class App extends StatefulWidget {
  App() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  final PageController pageController = PageController(initialPage: 0);
  final TextStyle listItemText = TextStyle(color: Colors.white);
  double cardPos;
  double cardStartPos = 20.0;
  double cardMaxPos;
  bool cardDown = false;

  Duration duration = Duration(milliseconds: 0);

  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  double menuOpacity = 0.0;
  double bottomMenuOpacity = 1.0;

  _AppState() {
    cardPos = cardStartPos;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    cardMaxPos = size.height * 0.77;

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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.1),
        child: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Color(0xff82269e),
          title: GestureDetector(
            onTap: () {
              setState(() {
                duration = Duration(milliseconds: 250);
                if (cardDown) {
                  cardPos = cardStartPos;
                  menuOpacity = 0.0;
                  bottomMenuOpacity = 1.0;
                } else {
                  cardPos = cardMaxPos;
                  menuOpacity = 1.0;
                  bottomMenuOpacity = 0.0;
                }
                cardDown = !cardDown;
              });
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/Nubank_Logo.png'),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Arthur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(cardDown
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xff82269e),
        child: Stack(
          children: <Widget>[
            AnimatedOpacity(
              duration: duration,
              opacity: bottomMenuOpacity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 45),
                    child: pageViewIndicator,
                  ),
                  buildBottomMenu(size)
                ],
              ),
            ),
            buildBackMenu(),
            AnimatedPositioned(
              duration: duration,
              curve: Curves.fastOutSlowIn,
              top: cardPos,
              child: GestureDetector(
                onTap: () {
                  SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.black,
                  ));
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LimiteFatura()));
                },
                onVerticalDragEnd: (detail) {
                  setState(() {
                    duration = Duration(milliseconds: 400);
                    if (cardPos >= 100 && cardDown == false) {
                      cardPos = cardMaxPos;
                      menuOpacity = 1;
                      bottomMenuOpacity = 0;
                      cardDown = true;
                    } else {
                      cardPos = cardStartPos;
                      menuOpacity = 0;
                      bottomMenuOpacity = 1;
                      cardDown = false;
                    }
                  });
                },
                onVerticalDragStart: (detail) {
                  setState(() {
                    duration = Duration(milliseconds: 0);
                  });
                },
                onVerticalDragUpdate: (detail) {
                  final value = (detail.delta.dy - 0) / (400 - 0);

                  if (cardPos <= cardMaxPos && cardPos >= cardStartPos) {
                    setState(() {
                      if (menuOpacity + value >= 0 &&
                          menuOpacity + value <= 1) {
                        menuOpacity += value;
                        bottomMenuOpacity -= value;
                      }
                      cardPos += detail.delta.dy;
                    });
                  }
                },
                child: buildCardFatura(size),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomMenu(final Size screenSize) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: screenSize.height * 0.025),
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
            "Ajustar limite",
            Icons.timeline,
          ),
          ActionCard(
            "Bloquear cartão",
            Icons.lock,
          ),
          SizedBox(width: 17),
        ],
      ),
    );
  }

  SingleChildScrollView buildBackMenu() {
    return SingleChildScrollView(
      child: AnimatedOpacity(
        duration: duration,
        opacity: menuOpacity,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 5),
                child: QrImage(
                  data: "abc123opkasdokpasokpasokp456",
                  size: 130.0,
                  gapless: false,
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff82269e),
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Banco "),
                          Text(
                            "260 - Nu Pagamentos S.A.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Agencia"),
                          Text(
                            " - 0001",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Conta"),
                          Text(
                            " - 0132456-78",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  buildMenuListItem("Me ajuda", Icons.help_outline),
                  buildMenuListItem("Perfil", Icons.person_outline,
                      subtitle: "Nome de preferencia, telefone, e-mail"),
                  buildMenuListItem("Configurar NuConta", Icons.settings),
                  buildMenuListItem("Configurar Cartao", Icons.credit_card),
                  buildMenuListItem("Configuracoes do app", Icons.settings_cell,
                      bottomBorder: true),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlineButton(
                    onPressed: () {},
                    child: Text("SAIR DO APP",
                        style: TextStyle(color: Colors.white)),
                    borderSide: BorderSide(color: Color(0xff994eb0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuListItem(final String text, final IconData leadingIcon,
      {final String subtitle, final bottomBorder = false}) {
    final borderSide = BorderSide(color: Color(0xff994eb0), width: 1);
    Border border = Border(
        top: borderSide, bottom: bottomBorder ? borderSide : BorderSide.none);

    return Container(
      decoration: BoxDecoration(border: border),
      child: ListTile(
        dense: true,
        title: Text(
          text,
          style: listItemText,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Color(0xffbfbfbf), fontSize: 13),
              )
            : null,
        leading: Icon(
          leadingIcon,
          color: Colors.white,
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildCardFatura(Size screenSize) {
    final cardHeight = screenSize.height * 0.565;
    return Container(
      width: screenSize.width,
      height: cardHeight,
      child: Center(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Hero(
                                tag: "creditCard",
                                child: Icon(
                                  Icons.credit_card,
                                  size: 27,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: cardHeight * 0.15),
                                child: Text(
                                  "FATURA FECHADA",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: buildValorFatura(),
                              ),
                              buildFaturaInfo()
                            ],
                          ),
                          buildFaturaInfoBar(cardHeight)
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
                            "Compra mais recente em Uber do brasil. no valor de R\$ 15,99 hoje",
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
      ),
    );
  }

  Container buildFaturaInfoBar(double cardHeight) {
    return Container(
      width: 7,
      height: cardHeight * 0.53,
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
    );
  }

  Column buildFaturaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: "vencimentoFatura",
          child: Text(
            "VENCIMETO 25 JUN",
            style: TextStyle(
              color: Color(0xff999999),
            ),
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
    );
  }

  Column buildValorFatura() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              "  175.674",
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
