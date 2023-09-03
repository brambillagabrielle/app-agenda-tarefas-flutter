import 'screens/agenda/list_eventos.dart';
import 'screens/tarefas/list_tarefas.dart';
import 'package:flutter/material.dart';

class MenuOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuUptionState();
  }
}

class MenuUptionState extends State<MenuOptions> {
  int paginaAtual = 0;
  PageController? pc;

  @override
  Widget build(Object context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [ListaTarefa(), ListaEvento()],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm), label: "Tarefas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Agenda")
        ],
        onTap: (pagina) {
          pc?.animateToPage(pagina,
              duration: Duration(microseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }
}
