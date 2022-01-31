# Manual de Utilizador - Blokus Duo

## Inteligência Artificial - Projeto 2

Grupo:

- André Serrado 201900318

- Gabriel Pais 201900301

Docente:

- Filipe Mariano

Este manual de utilizador visa facilitar o compreensão do problema apresentado, e por consequência facilitar também a sua resolução. O projeto teve como principal objetivo, a procura de soluções para os tabuleiros pré-fabricados, recorrendo à utilização de algoritmos de procura. Este projeto foi também desenvolvido, exclusivamente com a linguagem Lisp.

## Índice

- [Objetivo do Jogo](#objetivo-do-jogo)
- [Regras](#regras)
- [Descrição Geral](#descricao-geral)
- [Informação Necessária](#informacao-necessaria)
- [Informação reduzida](#informacao-reduzida)
- [Limitações do Programa](#limitacoes-do-programa)

---

## [Objetivo do Jogo](#Objetivo-do-jogo)

No presente projeto, tal como na 1º fase do Projeto, desenvolvida anteriormente, vamos considerar uma versão simplificada do jogo **_Blokus_**, agora denominada de **_Blokus Duo_**.

Nesta fase o objetivo é possibilitar a jogabilidade entre 2 jogadores, tendo em conta o conhecimento adquirido no âmbito da _Teoria de Jogos_.

<center><img src="Blokus.jpg"></center>

## [Regras](#regras)

- O jogo será disputado entre 2 jogadores.

- Existem 35 peças de três tipos para cada jogador.

- O tabuleiro terá um tamanho 14x14, 14 linhas e 14 colunas, sem existência de tabuleiros pré-preenchidos.

- Os jogadores escolhem uma das peças disponíveis e colocam-as de modo a que um dos quadrados da peça preencha um dos quadrados de canto do tabuleiro do jogo (posição inicial), sendo que o **Jogador 1** deverá iniciar no canto superior esquerdo e o **Jogador 2** no canto inferior direito.

- Uma vez colocada, a posição da peça não poderá ser alterada até ao final do jogo.

- As jogadas são feitas à vez e, em cada turno, o jogador coloca uma peça de modo a que toque pelo menos numa das suas peças já existentes, mas apenas nos cantos. **Peças do mesmo jogador nunca se podem tocas nas laterais, mas podem tocar lateralmente com peças do outro jogador**.

- Quando um dos jogadores não consegue colocar uma peça no tabuleiro do jogo, deverá passar a vez.

- O jogo termina quando nenhum dos jogadores consegue colocar mais peças.

- Quando o jogo termina, os jogadores contam o número de quadrados existentes nas peças que restaram, e o jogador que tiver o menor número de quadrados é o vencedor.

## [Descrição Geral](#descricao-geral)

### [Principais diferenças](#principais-diferencas)

- Em blokus Uno existe apenas um jogador. Para efeitos de melhor compreensão, este jogador serão os métodos de procura desenvolvidos.

- O jogo, habitualmente, termina quando todas as peças tiverem sido colocadas ou não for possível colocar mais peças respeitando as regras.

- Tendo isto, para esta variante do jogo estarão disponíveis 10 peças do tipo "A", 10 do tipo B e 15 do tipo c-1 e c-2 em conjunto.

<center><img src="pecas.jpg"></center>

### [Funcionamento Geral](#funcionamento-geral)

- O número 0 para casas vazias
- O número 1 representa as casas ocupadas pelas peças do **Jogador 1**
- O número 2 representa as casas ocupadas pelas peças do **Jogador 2**

<center><img src="tabuleiro_bin.jpg"></center>

---

## <center>Tabuleiro</center>

<center><img src="problema-f.jpg"></center>

## [Informação produzida](#ecrã-teclado-e-ficheiros)

Inicialmente será apresentado um menu de interação com o utilizador. Para começar o programa deverão ser lidas e seguidas as instruções de [Limitacoes do Programa](#limitacoes-do-programa) e só depois poderá ser inserido o comando:

```lisp
(start)
```

Este comando dá ínicio ao programa e mostra o seguinte menu.

<center><img src="menustart.png"></center>

- Opção do utilizador jogar contra o computador.

- Opção do computador jogar contra o computador.

- Opção para sair do jogo.

Caso a escolha seja a primeira opção, será apresentado o seguinte menu, para decidir quem será o primeiro a jogar.

<center><img src=></center>

- Opção que seleciona o Jogador como sendo o primeiro a jogar.

- Opção que seleciona o Computador como sendo o primeiro a jogar.

- Opção para voltar ao menu anterior.

Caso escolha a segunda opção do menu inicial, será apresentado com menu apresentada na seguinte imagem. Este dá ao utilizador a hipotese de escolha do tempo limite para uma jogada do computador.

<center><img src="menucomputertime.png"></center>

- Deverá introduzir um valor no intervalo de 1 a 20.

No final será mostrada uma mensagem com as informações relativas aos intervalos.

<center><img src=></center>

Após a execução do programa será criado um ficheiro ".dat" com o output do mesmo. Este ficheiro de output terá no seu conteúdo as soluções do problema executado bem como as suas estatísticas.

## [Limitações do Programa](#limitacoes-do-programa)

Para que o projeto produza o resultado pretendido, todos os ficheiros .lisp diponibilizados deverão ser executados. Além disso, é ainda necessário que o "path" para os ficheiros seja alterado para que estes sejam compilados com sucesso! Este "path" pode ser encontrado no ficheiro _projeto.lisp_.
