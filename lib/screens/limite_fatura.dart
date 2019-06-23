import 'package:flutter/material.dart';
import 'package:nubank_clone/badge.dart';
import 'package:nubank_clone/screens/fatura.dart';

class LimiteFatura extends StatefulWidget {
  @override
  _LimiteFaturaState createState() => _LimiteFaturaState();
}

class _LimiteFaturaState extends State<LimiteFatura> {
  Size screenSize;
  double screenWidth;
  double faturaScreenPos;
  bool updatePos = true;
  Duration animationDuration = Duration(milliseconds: 50);
  final Fatura fatura = Fatura();

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;
    if (updatePos) {
      faturaScreenPos = 12;
      updatePos = false;
    }

    return Scaffold(
      backgroundColor: Color(0xff3d2b40),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragUpdate: (detail) {
            final pos = screenWidth - detail.globalPosition.dx;
            if (pos > -screenWidth - 12) {
              setState(() {
                faturaScreenPos = screenWidth - detail.globalPosition.dx;
              });
            }
          },
          onHorizontalDragEnd: (_) {
            setState(() {
              animationDuration = Duration(milliseconds: 100);
              if (faturaScreenPos > screenWidth * 0.6) {
                faturaScreenPos = screenWidth;
              } else {
                faturaScreenPos = 12;
              }
            });
          },
          onHorizontalDragStart: (_) {
            setState(() {
              animationDuration = Duration(milliseconds: 50);
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[buildSideBar(), buildFaturaInfo()],
                ),
                AnimatedPositioned(
                  duration: animationDuration,
                  width: screenWidth,
                  height: screenSize.height,
                  right: faturaScreenPos,
                  child: fatura,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildFaturaInfo() {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            faturaInfoBar(
                Color(0xffff9b00), 1, "PROXIMAS FATURAS", "R\$ 4789,59",
                buttomText: "ANTECIPAR"),
            faturaInfoBar(
              Color(0xff00bcc9),
              1,
              "FATURA ATUAL",
              "R\$ 2374,09",
            ),
            faturaInfoBar(
              Color(0xffe5615c),
              1,
              "FATURA FECHADA",
              "R\$ 4789,59",
              buttomText: "PAGAR",
            ),
            faturaInfoBar(
              Color(0xff9ed230),
              1,
              "LIMITE DISPONIVEL",
              "R\$ 5141,00",
            ),
          ],
        )
      ],
    );
  }

  Container buildSideBar() {
    return Container(
      width: screenWidth * 0.25,
      color: Color(0xff443147),
      child: Column(
        children: <Widget>[
          buildSibebarItem(Icons.list, "Resumo de Faturas"),
          buildSibebarItem(Icons.help_outline, "Me ajuda"),
          Stack(
            children: <Widget>[
              buildSibebarItem(Icons.person, "Indicar"),
              Align(
                alignment: Alignment.topRight,
                widthFactor: 3,
                child: Badge(
                  value: "10",
                  padding: EdgeInsets.all(3),
                  backgroundColor: Color(0xfff06770),
                ),
              )
            ],
          ),
          buildSibebarItem(Icons.lock_open, "Bloqueio Temporario"),
          buildSibebarItem(Icons.credit_card, "Cartão Virtual"),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/Nubank_Logo.png"),
            ),
          )
        ],
      ),
    );
  }

  Container buildSibebarItem(
    final IconData iconData,
    final String text,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: screenWidth * 0.045,
        right: screenWidth * 0.045,
        top: screenSize.height * 0.025,
        bottom: screenSize.height * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            color: Color(0xff9c9c9d),
            size: 33,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: TextStyle(
              color: Color(0xff9c9c9d),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget faturaInfoBar(
    Color backColor,
    int flex,
    final String tipoFatura,
    final String valor, {
    final String buttomText,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        children: <Widget>[
          buttomText != null
              ? Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.05),
                  height: 23,
                  width: buttomText.length * 10.0,
                  child: OutlineButton(
                    padding: EdgeInsets.all(0),
                    borderSide: BorderSide(
                      color: backColor,
                    ),
                    child: Text(
                      buttomText,
                      style: TextStyle(
                        color: backColor,
                        fontSize: 10,
                      ),
                    ),
                    onPressed: () {},
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(right: screenWidth * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  tipoFatura,
                  style: TextStyle(
                    color: Color(0xff9c9c9d),
                    fontSize: 11,
                  ),
                ),
                Text(
                  "R\$ $valor",
                  style: TextStyle(
                    color: backColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            decoration: BoxDecoration(
              color: backColor,
            ),
          ),
        ],
      ),
    );
  }
}
