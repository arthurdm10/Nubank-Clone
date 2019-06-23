import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';

class Fatura extends StatelessWidget {
  Size screenSize;
  List<Widget> compras;
  final List tags = [
    ["Casa", Icons.home],
    ["Educação", Icons.book],
    ["Eletrônicos", Icons.videogame_asset],
    ["Supermercados", Icons.shopping_cart],
    ["Transporte", Icons.directions_bus],
    ["Restaurante", Icons.restaurant],
  ];
  ValueNotifier<int> valueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    compras = List<Widget>.generate(30, (index) {
      var cents = Random().nextDouble().toStringAsFixed(2);
      cents = cents.split(".")[1];

      return buildFaturaListItem(
          tags[Random().nextInt(tags.length)],
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          '${Random().nextInt(2500)},${cents}',
          "Quarta");
    });

    final pageViewIndicator = PageViewIndicator(
      pageIndexNotifier: valueNotifier,
      length: 3,
      normalBuilder: (animationController, index) =>
          Circle(size: 5.0, color: Color(0xffbcbcbc)),
      highlightedBuilder: (animationController, index) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
            child: Circle(
              size: 5.0,
              color: Colors.black,
            ),
          ),
    );

    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220,
              automaticallyImplyLeading: false,
              forceElevated: true,
              elevation: 0.5,
              pinned: true,
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
              ],
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.grey,
                ),
              ),
              title: Hero(
                tag: "creditCard",
                child: Icon(
                  Icons.credit_card,
                  size: 22,
                  color: Colors.black,
                ),
              ),
              titleSpacing: -16,
              flexibleSpace: LayoutBuilder(
                builder: (context, boxConstraints) {
                  double valorFaturabottom =
                      boxConstraints.biggest.height - 100;
                  double vencimentoFaturaTop = 110;

                  if (valorFaturabottom <= 10) {
                    valorFaturabottom = 16;
                  }

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsetsDirectional.only(
                        start: 0, bottom: valorFaturabottom),
                    title: Container(child: buildValorFatura()),
                    background: Container(
                      margin: EdgeInsets.only(top: vencimentoFaturaTop),
                      child: Column(
                        children: <Widget>[
                          buildVencimentoFatura(),
                          pageViewIndicator
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [buildPagamentoRecebidoItem("1577,55", "Ontem"), ...compras],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFaturaListItem(final List tag, final String nome,
      final String valor, final String data) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            tag[0],
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffa6a6a6),
              fontSize: 13,
            ),
          )
        ],
      ),
      subtitle: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenSize.width * 0.55,
              child: Text(
                nome,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                'R\$$valor',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 15),
        child: Icon(tag[1]),
      ),
    );
  }

  Widget buildPagamentoRecebidoItem(final String valor, final String data) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: screenSize.width * 0.55,
            child: Text(
              "Pagamento recebido",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffa6a6a6),
              fontSize: 13,
            ),
          )
        ],
      ),
      subtitle: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: Text(
                'R\$$valor',
                style: TextStyle(fontSize: 18, color: Colors.lightGreen),
              ),
            ),
          ],
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 20),
        child: Circle(
          color: Colors.lightGreen,
          size: 12,
        ),
      ),
    );
  }

  Column buildVencimentoFatura() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
    );
  }

  Widget buildValorFatura() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "R\$",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          "  175.674",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          ",54",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
