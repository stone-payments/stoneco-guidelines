# Guia de Estilo Git

## Ramificação (Branching)

- Escolha nomes curtos e descritivos:

      #bom# $ git checkout -b oauth-migration
      
      #ruim# $git checkout -b login_fix
      
- Identificadores de tickets correspondentes num serviço externo (p.ex. um issue do GitHub) também são bons candidatos para uso em nomes de ramos. Por exemplo:

      #Issue do GitHub #23

      $ git checkout -b issue-15
      
- Use barras para separar palavras
- Quando várias pessoas estiverem trabalhando numa mesma funcionalidade, pode ser conveniente ramos de funcionalidade pessoais e um ramo de funcionalidade do time. Use a seguinte convenção para nomes:

      $ git checkout -b feature-a/master # ramo do time
      
      $ git checkout -b feature-a/joao # ramo do João
      
      $ git checkout -b feature-a/maria # ramo da Maria
      
	"Merge" livremente os ramos pessoais ao ramo do time. Eventualmente, o ramo do time será mesclado ao master.
- Apague o seu ramo do repositório superior depois que ele for mesclado, a não ser que haja uma razão específica para não fazer isso.

_Dica_: Use o seguinte comando quando estiver no “master”, para listar ramos mesclados: $ git branch --merged | grep -v “\*”

## Commits

- **Cada commit deve ser uma única mudança lógica.** Não coloque várias mudanças em um único commit. Por exemplo, se um patch conserta um bug e otimiza a performance de uma funcionalidade, divida-o em dois commits separados.

_Dica_: Use **git add -p** para organizar interativamente porções específicas dos arquivos modificados.

- **Não separe uma mudança lógica única em diversos commits.** Por exemplo, a implementação de uma funcionalidade e os testes correspondentes devem estar no mesmo commit.

- **Faça commits _cedo_ e _frequentemente_.** Commits pequenos e contidos são mais fáceis de entender e reverter se algo sair errado.

- **Commits devem ser ordenados _logicamente_.** Por exemplo, se o commit X depende de mudanças feitas no commit Y, então o commit Y deve vir antes do commit X.

### Mensagens de Commit

Uma mensagem de commit consiste de três partes distintas separadas por uma linha em branco: o título, o corpo (opcional) e o rodapé (opcional). O layout fica assim:

_Feat: Ensina como escrever mensagem de commit_

_Às vezes, uma maior explicação pode ser útil._

_Resolves: #1234_

O título se divide em 2 partes: o tipo e o assunto.

### Tipo

O tipo fica contido no título e pode ser um dos seguintes:

- **feat:** uma nova funcionalidade

- **fix:** um conserto de bug

- **docs:** mudanças de documentação

- **style:** formatação, ponto-e-vírgula faltando, etc.; sem mudança de código

- **refactor:** refatoração código de produção

- **test:** adicionar testes, refatorar testes; sem mudança de código de produção

- **chore:** atualização de build tasks, configuração de gerente de pacotes, etc.; sem mudança de código de produção

### Assunto

Assuntos não devem ter mais de 50 caracteres, devem começar com uma letra maiúscula e não terminar com ponto. Use o modo imperativo na linha de assunto. Separe o assunto do corpo (quando houver um) com uma linha em branco.

_Exemplo_: 

      #bom# Refactor subsystem X for readability 
      #bom# Remove deprecated methods 
      #ruim# Fixed bug with Y 
      #ruim# More fixes from broken stuff

### Corpo

Como nem todos os commits são complexos o suficiente para requerer um corpo, ele só deve estar presente na mensagem quando deixar um contexto ali e agora poupar o tempo de colegas e futuros contributors. 

Use o corpo para explicar o "o quê?" e o "por quê?" de um commit, não o "como?" – o código é que deve fazer isso. 

Quando escrever uma mensagem de commit, pense no que você mesmo precisaria saber se você desse de cara com o seu commit daqui a um ano.

Limite o corpo a 72 caracteres por linha.

### Rodapé

O rodapé também é opcional e é usado para monitoramento/referência de issues:

_Exemplo_: 

    Resolves: #123
    
    Veja também: #456, #789

## Merging

- **Não reescreva histórico publicado.** O histórico do repositório é valioso por si próprio e é muito importante para que se possa dizer o que realmente aconteceu. Alterar histórico publicado é fonte comum de problemas para qualquer um trabalhando no projeto.
- No entanto, existem casos em que reescrever o histórico é legítimo. Esses casos são:
	- Você é o único trabalhando naquele ramo e ele não está sendo revisado.
	- Você quer arrumar o seu ramo (p.ex. dar squash em commits) e/ou dar rebase dele no “master” para dar merge mais tarde.
	Dito isso, nunca reescreva o histórico do ramo "master" ou qualquer outro ramo especial (isto é, utilizados por servidores de produção ou CI)
- Mantenha o histórico limpo e simples. Imediatamente antes de dar merge no seu ramo:
	- Certifique-se de que ele está conforme o guia de estilo e realize qualquer ação necessária se ele não estiver de acordo (dar squash/reordenar commits, reescrever mensagens, etc.)
	- Dar rebase do seu ramo no ramo em que ele será _"merged"_
	
Isso resulta num ramo que pode ser aplicado diretamente ao fim do ramo "master" e resulta num histórico muito simples.
	
Essa estratégia é mais adequada para projetos com ramos "de tiro curto". Em outros casos pode ser melhor ocasionalmente dar merge no ramo "master" ao invés de dar rebase nele.

- Se o seu ramo inclui mais de um commit, não dê merge com fast-forward:

	#bom# - assegura que um commit de merge é criado
		
      $ git merge --no-ff my-branch 

	#ruim#

      $ git merge my-branch

- **NUNCA** dê commit em algo como “Fix linter” ou “Fix tests” (consertos de bugs/tests). Esses “fixes” devem tomar squash para os commits que os originaram.
- **NUNCA** dê squash totalmente num ramo antes de dar merge nele, a não ser que o ramo inteiro (todos os commits) estejam relacionados a uma única mudança lógica.
- **NUNCA** use git merge master num ramo. SEMPRE use git rebase master, depois force-push, espere que o CI (sistema de Integração Contínua) liberar e só então merge ele no "master".
- **A CONVENÇÃO** é sempre usar a interface web do Github para dar merge no "master" e NUNCA usar Git na linha de comando (isto é, git checkout master; git merge --no-ff branch; git push). Isso evita confusão e esquecer de coisas muito importantes como merge sem fast-forward.

## Diversos

- Existem variados workflows e cada um tem suas forças e fraquezas. Se um deles se adéqua ao seu caso, depende do seu time, do projeto e do seu procedimento de desenvolvimento.

Com isso em mente, o mais importante é de fato escolher um workflow e seguir firme com ele.

- _Seja consistente_. Isso é relacionado ao workflow mas também se expande para coisas como mensagens de commit, nomes de ramos e tags. Ter um estilo consistente através do seu repositório faz dele mais fácil que todos os contributors possam compreender o que está acontecendo ao olhar o log, uma mensagem de commit, etc.
- _Teste antes de dar push_. Não dê push em trabalho feito pela metade.

**Use o Senso Comum, Luke**. SIGA ESSE GUIA! Isso é muito importante, caso contrário nós não faríamos você lê-lo antes de contribuir com nossos repositórios.

## Agradecimentos

This guide was inspired on other guides found in the community, some of which we’d like to give a special thanks:

https://github.com/agis/git-style-guide#merging

https://chris.beams.io/posts/git-commit/

https://github.com/chrisjlee/git-style-guide
