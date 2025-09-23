# App EggGo - em Produção 🚀

***Software gerenciador de clientes, vendas e produtos com suporte offline***

Este é um aplicativo em Flutter para o gerenciamento e cadastro de produtos e vendas, especificamente focado em ovos de diferentes tipos, tamanhos e embalagens. Feito sob medida para a empresa [EggGo](https://www.instagram.com/egg.go_ovos?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==)!

<!-- Adicione aqui screenshots ou um GIF do app em ação -->
<!-- ![Exemplo do App](caminho/para/sua/imagem.png) -->

## Funcionalidades Principais

*   **Autenticação de Usuários:** Login seguro com e-mail e senha.
*   **Funcionalidade Offline-First:** Crie, edite e delete dados mesmo sem conexão com a internet.
*   **Sincronização Automática e Manual:** Os dados são sincronizados com o servidor em nuvem (Firebase) assim que a conexão é restabelecida.
*   **Geração de Comprovantes:** Exporte vendas em formato PDF (A4 e A6).
*   **Busca e Filtros:** Pesquise facilmente por clientes e filtre o histórico de vendas.
*   **Dashboard de Vendas:** Resumo de vendas com filtros por período (Hoje, Semana, Mês, etc.).
*   **Tema Dinâmico:** Suporte para tema Claro (Light) e Escuro (Dark).
*   **Gerenciamento Completo (CRUD):**
    *   Clientes (Pessoa Física e Jurídica)
    *   Produtos
    *   Vendas

## Tecnologias Utilizadas

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Linguagem:** [Dart](https://dart.dev/)
*   **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider)
*   **Banco de Dados Remoto:** [Cloud Firestore](https://firebase.google.com/docs/firestore)
*   **Autenticação:** [Firebase Auth](https://firebase.google.com/docs/auth)
*   **Banco de Dados Local (Offline):** [SQFlite](https://pub.dev/packages/sqflite)
*   **Requisições HTTP:** [Dio](https://pub.dev/packages/dio) (para consulta de CEP)
*   **Geração de PDF:** [pdf](https://pub.dev/packages/pdf) e [printing](https://pub.dev/packages/printing)

## Arquitetura

O projeto está estruturado seguindo uma arquitetura semelhante à **MVC (Model-View-Controller)**, adaptada para o ecossistema Flutter com o auxílio do pacote `provider`.

*   **Model (`/lib/models`):**
    *   Representa os dados e a lógica de negócio da aplicação.
    *   São classes "puras" em Dart que definem a estrutura dos objetos de dados.

*   **View (`/lib/views`):**
    *   É a camada de interface do usuário (UI). Sua responsabilidade é exibir os dados para o usuário e capturar suas interações.
    *   A View não contém lógica de negócio; ela apenas reage às mudanças de estado e notifica o Controller sobre as ações do usuário.

*   **Controller (`/lib/controllers`):**
    *   Atua como uma ponte entre o Model e a View.
    *   Recebe as ações do usuário (vindas da View), processa-as, atualiza o Model e notifica a View (através do `Provider`) para que ela se reconstrua e exiba os dados atualizados.

*   **Service (`/lib/services`):**
    *   Abstrai a origem dos dados (banco de dados local, API remota, etc.).
    *   Sua responsabilidade é lidar com toda a comunicação com as fontes de dados (operações CRUD).
    *   Os Controllers dependem de uma abstração do serviço (classe abstrata), permitindo trocar a fonte de dados (ex: de Firebase para outra API) sem alterar a lógica do Controller.

## Estrutura de Pastas

A estrutura de pastas do projeto reflete a arquitetura adotada:

```
app_egggo/
└── lib/
    │
    ├── core/
    │
    ├── models/
    │
    ├── controllers/
    │
    ├── views/
    │
    ├── services/
    │
    ├── app.dart
    └── main.dart

    
```

## Como Executar o Projeto

1.  **Clone o repositório e entre na pasta do projeto.**
2.  **Instale as dependências:** `flutter pub get`
3.  **Execute o aplicativo:** `flutter run`
