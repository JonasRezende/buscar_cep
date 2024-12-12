import 'package:buscar_cep/controllers/cep_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'; // Biblioteca para máscaras

// Widget customizado para AppBar reduzida
class ReducedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const ReducedAppBar({
    super.key,
    this.height = 40.0, // Altura reduzida para a AppBar
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFBBA2B),
      elevation: 0,
      toolbarHeight: height, // Define a altura reduzida
      // Centraliza o título
    );
  }
}

class CepPage extends StatefulWidget {
  const CepPage({super.key});

  @override
  CepPageState createState() => CepPageState();
}

class CepPageState extends State<CepPage> {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController ufController = TextEditingController();

  bool showResults = false;
  bool showError = false;
  bool isLoading = false; // Controla o estado de carregamento

  @override
  void initState() {
    super.initState();

    // Adiciona um listener ao campo CEP para limpar os resultados ao editar
    cepController.addListener(() {
      if (!isLoading && cepController.text.length < 9) {
        setState(() {
          showResults = false;
          ruaController.clear();
          bairroController.clear();
          cidadeController.clear();
          ufController.clear();
        });
      }
    });
  }

  @override
  void dispose() {
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    ufController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<CepController>();

    return Scaffold(
      appBar: const ReducedAppBar(height: 40.0), // AppBar reduzida
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: RichText(
                text: const TextSpan(
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

            // Campo de CEP e botão de buscar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
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
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: cepController,
                        decoration: InputDecoration(
                          hintText: "Digite o CEP",
                          filled: true, // Habilita o fundo
                          fillColor: Colors.grey.shade200, // Cor do fundo
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none, // Remove a borda
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskedInputFormatter('00000-000'), // Máscara do CEP
                        ],
                        onChanged: (value) {
                          setState(() {
                            showError = false; // Remove o erro ao corrigir
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (cepController.text.length < 9) {
                            setState(() {
                              showError = true;
                            });
                            return;
                          }
                          setState(() {
                            isLoading = true; // Inicia o carregamento
                          });
                          final rawCep = cepController.text
                              .replaceAll('-', ''); // Remove a máscara
                          await controller.searchCep(rawCep);
                          if (controller.state.address != null) {
                            ruaController.text =
                                controller.state.address!.logradouro;
                            bairroController.text =
                                controller.state.address!.bairro;
                            cidadeController.text =
                                controller.state.address!.localidade;
                            ufController.text = controller.state.address!.uf;

                            setState(() {
                              showResults = true;
                              showError = false;
                            });
                          } else {
                            setState(() {
                              showError =
                                  true; // Exibe erro se o CEP não existir
                            });
                          }
                          setState(() {
                            isLoading = false; // Finaliza o carregamento
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED7160),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Buscar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (showError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Informe um CEP válido",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            if (isLoading) ...[
              const Center(
                child: CircularProgressIndicator(), // Mostra o loading
              ),
              const SizedBox(height: 20),
            ],

            if (showResults) ...[
              buildTextField("Rua", ruaController),
              const SizedBox(height: 10),
              buildTextField("Bairro", bairroController),
              const SizedBox(height: 10),
              buildTextField("Cidade", cidadeController),
              const SizedBox(height: 10),
              buildTextField("UF", ufController),
            ],

            if (showResults)
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 60,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Confirmação realizada com sucesso!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Obrigado por validar suas informações. Caso precise de algo mais, estamos à disposição.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    cepController.clear();
                                    ruaController.clear();
                                    bairroController.clear();
                                    cidadeController.clear();
                                    ufController.clear();
                                    setState(() {
                                      showResults = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 24,
                                    ),
                                  ),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26D512),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                    ),
                    child: const Text(
                      "CONFIRMAR CEP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: label,
              filled: true, // Habilita o fundo
              fillColor: Colors.grey.shade200, // Cor do fundo
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // Remove a borda
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
