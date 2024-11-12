# Diretrizes para Contributors
:honeybee: Existe um template para Contributing.md disponível [aqui](template.md):honeybee:

## Pull Requests

- **DÊ** aos PRs nomes curtos-mas-descritivos (p.ex. "Improve code coverage for System.Console by 10%" e não "Fix #1234").
- **NÃO** submeta PRs em "work in progress". Um PR só deve ser submetido quando for considerado pronto para review (ready for review) e consequentemente ser _"merged"_ pelo the contributor.
- **MARQUE** quaisquer usuários que devem saber a respeito e/ou revisar a mudança.
- **SUBMETA** todas as mudanças de códigos via pull requests (PRs) ao invés de um commit direto. PRs serão revisados e potencialmente _"merged"_ pelos mantenedores do repositório depois de uma revisão de um colega que inclua pelo menos um mantenedor.
- **ASSEGURE-SE** que cada commit "construa" (build) com sucesso. O PR inteiro deve passar em todos os testes do sistema de Integração Contínua (Continuous Integration, CI) antes de ser _"merged"_ .
- **NÃO** misture mudanças independentes e não-relacionadas em um mesmo PR. Separe mudanças de produtos reais/códigos de teste de mudanças maiores de formatação de código/remoção de código morto. Separe ajustes não-relacionados em PRs separados, especialmente se eles estiverem em diferentes assemblies.
- **ENDERECE** feedback de PR em um commit(s) adicional(is) ao invés de adicionar a commits existentes, e só dê rebase/squash neles quando necessário. Isso torna mais fácil para os revisores acompanharem mudanças. Se necessário, squashing deve ser administrada pelo merger usando a função "squash and merge", e só deve ser feita pelo contributor se lhe for requerido.

## O que fazer e o que não fazer

- **SIGA** nosso git style guide
- **DÊ** prioridade ao estilo atual do projeto ou arquivo que você está modificando mesmo se isso divergir das diretrizes comuns
- **INCLUA** testes quando adicionar novas funções. Quando consertar bugs, comece adicionando um teste que destaque como o comportamento atual está com problemas.
- **MANTENHA** as discussões focadas. Quando um tópico novo ou relacionado surgir, frequentemente é melhor criar um novo issue do que deixar mais de um tópico na mesma discussão
- **NÃO** faça PRs pedindo mudanças de style
- **NÃO** nos surpreenda com grandes pull requests. Ao invés disso, faça um issue e comece uma discussão para que nós possamos acertar uma direção antes que você invista uma grande quantidade de tempo trabalhando nisso
- **NÃO** adicione adições de API sem abrir um issue e discutir com a gente primeiro

## Processo de Review de Mudança de API

- **Contributor abre um issue**. A descrição do issue deve conter uma sumarização que represente um rascunho das novas APIs, incluindo exemplos de como as APIs estão sendo usadas. O objetivo não é ter uma lista completa de APIs, mas uma boa ideia de como as novas APIs grosso modo parecerão e em que cenários elas estão sendo utilizadas.
- **A comunidade discute a proposta**. Se mudanças forem necessárias, o contributor é encorajado a editar a descrição do issue. Isso permite que as pessoas que entrarem mais tarde consigam entender a proposta mais recente. Para evitar confusão, o contributor deve manter um pequeno change log, como um negrito “Updates:” seguido de uma lista de pontos dos updates que foram feitos.
- **O issue é marcado como “Aceitando PRs”**. Assim que o contributor e o dono do projeto concordarem com a forma e direção gerais, o dono do projeto marca o issue como “Accepting PRs”. O contributor deve indicar se eles irão fazer um PR ou se só contribuíram com a ideia.
- **O pull request é criado**. Assim que o contributor acreditar que a implementação está pronta para review, ele/ela cria um pull request, fazendo referência ao issue criado no primeiro passo.
- **Pull request está sendo revisado**. A comunidade revisa o código do pull request. A revisão deve ser focada em mudanças de código e arquitetura – não nas APIs em si. Assim que pelo menos dois donos do projeto derem seu OK, o PR é considerado pronto para ser _"merged"_.
- **O dono toma a decisão**. Quando o dono acredita que já existe informação suficiente para tomar uma decisão, ele/ela atualizará o issue para algum dos seguintes status:
- **Marcado para review**. Se o dono acredita que a proposta está adequada para operação, ele/ela marcará o issue como api-pronto-para-review (api-ready-for-review).
- **Fechado como não operativo**. Caso o issue não tenha corpo o suficiente para ser destrinchado numa proposta concreta, o issue será fechado.
- **Fechado como não resolvendo da forma proposta**. Às vezes, o issue levantado é bom mas o dono acredita que a proposta concreta não é o jeito certo de atacar o problema. Na maioria dos casos, o dono tentará guiar a discussão numa direção que resulte num design que nós acreditamos que seja apropriado. Porém, para algumas propostas o problema está no coração do design que não pode ser facilmente mudado sem iniciar uma nova proposta. Nesses casos, o dono fechará o issue e explicar o problema com o design.
- **Fechado como não resolve o problema**. Similarmente, se a proposta está levando o produto numa direção que nós simplesmente não queremos ir, o issue também poderá ser fechado. Nesse caso, o problema não é o design proposto mas o issue em si.
- **API é revisada**. Na revisão, nós faremos observações e daremos feedback. Depois da revisão, nós publicaremos as observações no repositório de revisão da API. Existem 3 resultados possíveis:
- **Aprovado**. Nesse caso o issue é alterado de api-pronto-para-revisar para api-aprovado.
- **Precisa de alterações**. Caso nós acreditemos que a proposta ainda não está pronta, nós substituiremos a marcação api-pronta-para-revisar por api-precisa-de-alterações.
- **Rejeitado**. Se nós acreditarmos que a proposta não está numa direção que nós queremos seguir, nós vamos apenas escrever um comentário e fechar o issue.
- **O pull request é _"merged"_**. Quando não há problemas - ou eles foram resolvidos pelo contributor, o PR é _"merged"_.
