import 'package:buscar_cep/controllers/cep_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchCepPage extends StatefulWidget {
  @override
  _SearchCepPageState createState() => _SearchCepPageState();
}

class _SearchCepPageState extends State<SearchCepPage> {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController ufController = TextEditingController();

  bool showResults = false; // Variável para controlar a visibilidade das caixas

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<CepController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBBA2B), // Define a cor da AppBar
        elevation: 0, // Remove a sombra da AppBar
        toolbarHeight: 40, // Reduz o tamanho da AppBar
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Espaçamento entre a AppBar e a frase
            SizedBox(height: 20),
            // Frase principal
            Padding(
              padding: const EdgeInsets.only(bottom: 75.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(text: "Para consultar seu "),
                    TextSpan(
                      text: "endereço",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ", digite seu "),
                    TextSpan(
                      text: "CEP",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " e confirme se as "),
                    TextSpan(
                      text: "informações",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " estão corretas."),
                  ],
                ),
              ),
            ),
            // Label CEP * acima da caixa de texto
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "CEP",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  " *",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Asterisco em vermelho
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Espaçamento entre o label e a caixa de texto
            // Caixa de texto e botão de busca
            Row(
              children: [
                // Caixa de texto
                Expanded(
                  child: TextField(
                    controller: cepController,
                    decoration: InputDecoration(
                      hintText: 'CEP', // Apenas a palavra "CEP"
                      hintStyle: TextStyle(
                        color:
                            Colors.grey.shade400, // Efeito apagado para o hint
                        fontSize: 14, // Tamanho menor
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Bordas menos arredondadas
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 6.0, // Menor altura da caixa
                        horizontal: 12.0, // Espaçamento interno
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 14), // Texto menor
                  ),
                ),
                SizedBox(width: 10), // Espaço entre a caixa e o botão
                // Botão de busca
                ElevatedButton(
                  onPressed: () async {
                    // Fecha o teclado ao remover o foco do campo
                    FocusScope.of(context).unfocus();

                    await controller.searchCep(cepController.text);
                    if (controller.state.address != null) {
                      // Atualiza os valores nas caixas de texto
                      ruaController.text = controller.state.address!.logradouro;
                      bairroController.text = controller.state.address!.bairro;
                      cidadeController.text =
                          controller.state.address!.localidade;
                      ufController.text = controller.state.address!.uf;

                      // Exibe as caixas de texto
                      setState(() {
                        showResults = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFED7160), // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Bordas arredondadas
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0, // Altura do botão
                      horizontal: 16.0, // Largura do botão
                    ),
                  ),
                  child: Text(
                    'Buscar',
                    style: TextStyle(
                      color: Colors.white, // Texto na cor branca
                      fontSize: 14, // Tamanho do texto
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espaçamento após a caixa e botão
            // Exibe os resultados apenas se showResults for true
            if (showResults) ...[
              // Rua
              Text("Rua"),
              SizedBox(height: 4),
              TextField(
                controller: ruaController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Bairro
              Text("Bairro"),
              SizedBox(height: 4),
              TextField(
                controller: bairroController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Cidade
              Text("Cidade"),
              SizedBox(height: 4),
              TextField(
                controller: cidadeController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // UF
              Text("UF"),
              SizedBox(height: 4),
              TextField(
                controller: ufController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      // Botão na parte inferior
      bottomNavigationBar: showResults
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Exibe a modal de confirmação
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Seu endereço foi confirmado com sucesso!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Obrigado por validar suas informações. Caso precise de algo mais, estamos à disposição.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26D512),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                ),
                child: Text(
                  'CONFIRMAR CEP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
