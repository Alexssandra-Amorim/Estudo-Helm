## Atenção, qualquer pessoa desenvolvedora pode realizar aprovações em Pull Requests neste repositório, ou seja, repasse essa PR ao seu time e siga as instruções para um merge íntegro da sua aplicação. Qualquer dúvida a FAQ esta aqui embaixo! 🙂

## Approval Flow 🌀
Para o `update` e `merge` funcionar basta adicionar a label `automerge` no Pull Request em aberto em direção a branch _master_. Para dúvidas sobre o integração consulte [kodiakhq.com](https://kodiakhq.com/) ou tire suas dúvidas direto pelo nosso canal [kodiak-helm-integration]

### FAQ ☝️
- _Terminei minhas alterações e estou pronto para o merge, terei que esperar os checks e realizar o update manualmente?_\
Não, basta adicionar a label `automerge` que o Kodiak se encarregará de realizar o update e ao terminar seguirá com o merge também de forma automática!
- _O fluxo de aprovação continua igual?_\
Sim, para todo o fluxo da PR funcionar é necessário pelo menos um único review (aconselhamos que sempre realizem um pair-review :slightly_smiling_face:). **Importante**: Mesmo com todos os checks em status ok e com a branch atualizada automaticamente via label o Kodiak entendi que é **necessário** pelo um review para prosseguir com as ações!
- _Tenho problemas de conflito, lint ou de referências do template, o Kodiak interpreta isso de alguma forma?_\
O fluxo de checks se mantém o mesmo então caso o Pull Request não passe em um dos checks o Kodiak não será acionado para nenhuma ação! Isso nos assegura em promovermos os nossos values íntegros e respeitando o template!
- _Os commits na master vão se manter com o autor da Pull Requests?_\
Sim, não perderemos rastreabilidade nenhuma dos autores de cada solicitação de mudança em direção a branch principal!

