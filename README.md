# App EggGo - Gerenciador de Vendas (em construção...)

Este é um aplicativo em Flutter para o gerenciamento e cadastro de produtos e vendas, especificamente focado em ovos de diferentes tipos, tamanhos e embalagens. Feito sob medida para a empresa [EggGo](https://www.instagram.com/egg.go_ovos?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==)!

## Tecnologias Utilizadas

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Linguagem:** [Dart](https://dart.dev/)
*   **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider)

## Arquitetura

O projeto está estruturado seguindo uma arquitetura semelhante à **MVC (Model-View-Controller)**, adaptada para o ecossistema Flutter com o auxílio do pacote `provider`.

Essa abordagem visa separar as responsabilidades do código, facilitando a manutenção, escalabilidade e a realização de testes.

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
    *   Abstrai a origem dos dados, seja um banco de dados local, uma API remota (como o Firebase) ou uma lista em memória para testes.
    *   Sua responsabilidade é lidar com toda a comunicação com a fonte de dados (operações de criar, ler, atualizar e deletar - CRUD).
    *   Os Controllers dependem de uma abstração do serviço (uma classe abstrata) e não de sua implementação concreta. Isso permite trocar a fonte de dados (por exemplo, de uma lista local para o Firebase) sem precisar alterar o Controller, facilitando testes e manutenção.
    *   Exemplo: `venda_service.dart` define a interface `VendaService`, e uma implementação concreta como `VendaServiceImpl` contém a lógica para manipular os dados das vendas.

## Estrutura de Pastas

A estrutura de pastas do projeto reflete a arquitetura adotada:

```
app_egggo/
└── lib/
    ├── core/
    │
    ├── controllers/
    │
    ├── services/
    │
    ├── models/
    │
    ├── views/
    │
    ├── app.dart
    └── main.dart

    
```

## Como Executar o Projeto

1.  **Clone o repositório e entre na pasta do projeto.**
2.  **Instale as dependências:** `flutter pub get`
3.  **Execute o aplicativo:** `flutter run`