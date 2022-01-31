# Manual Técnico - Blokus Uno

## Inteligência Artificial - Projeto 2

Grupo:

- André Serrado 201900318

- Gabriel Pais 201900301

Docente:

- Filipe Mariano

Este manual técnico contém a documentação da implementação do projeto, Blokus Uno. Este projeto teve como principal objetivo, a procura de soluções nos tabuleiros, recorrendo à utilização de algoritmos de procura. Este projeto foi também desenvolvido, exclusivamente com a linguagem Lisp.

Para uma melhor organização do projeto, este foi divido em três ficheiros.

- puzzle.lisp
- algoritmo.lisp
- jogo.lisp

---

## Índice

- [Puzzle](#puzzle)
  - [Problemas](#problemas)
  - [Componentes do tabuleiro](#componentes-do-tabuleiro)
  - [Funções secundárias](#funcoes-secundarias)
  - [Possíveis movimentos](#moves)
  - [Operações com Peças](#operacoes-com-pecas)
  - [Verificações do tabuleiro](#verificacoes-do-tabuleiro)
  - [Final do Jogo](#endgame)
- [Algoritmo](#procura)
  - [Memoização](#memoização)
  - [Tipos de Dados Abstratos](#tipos-de-dados-abstratos)
  - [Algoritmos](#algoritmos)
  - [Auxiliares](#auxiliares)
  - [Performance Stats](#performance-stats)
- [Jogo](#jogo)
  - [Game Handler](#gameHandler)
  - [Files Handler](#filesHandler)
  - [Formatters](#formatters)
---

## **[Puzzle](#puzzle)**

Este ficheiro contém o código relacionado com todo o problema, sendo assim responsável, todas as verificações de restrições de inserção de peças no tabuleiro, inserção das mesmas, verificação das possíveis posições e contagem das peças.

Para uma melhor organização interna, o ficheiro foi dividido pelas seguintes secções, problemas, componentes do tabuleiro, funções secundárias, possíveis movimentos, operações com peças, verificações do tabuleiro e fim do jogo.

### **[Problemas](#problemas)**

Para a representação do tabuleiro do problema, foi implementada uma função que retorna uma lista, contendo um conjunto de sublistas. As sublistas representam as várias linhas do tabuleiro e cada átomo das mesmas, representam o valor da posição das colunas. Para representação do conteúdo do tabuleiro, as posições sem peças estão representadas pelo valor 0, com peças, temos representadas pelo valor 1, as que foram inseridas pelo **Jogador 1** e com o valor 2 as que foram inseridas pelo **Jogador 2**. Este tabuleiro é representa o estado inicial e visa facilitar a testagem das restantes funções implementadas.

De seguida, temos a função que retorna o tabuleiro utilizado.

```lisp
;;; Board
;; [0] empty element/cell
;; [1] player one piece
;; [2] player two piece
```

```lisp
;; Problem
;; At least 72 elements fulfilled
;; Empty Board 14x14
;; Returns a 14x14 empty board
(defun empty-board (&optional (dimension 14))
	(make-list dimension :initial-element (make-list dimension :initial-element '0))
)
```

### **[Componentes do tabuleiro](#componentes)**

#### [Row](#row)

- A função _[row](#row)_ recebe por parâmetro um índice em conjunto com o respetivo tabuleiro e retorna a linha correspondente ao índice dado por parâmetro.

```lisp
(defun row(index board)
  "[index] must be a number between 0 and the board dimension"
  (nth index board)
)
```

#### [Column](#column)

- A função _[column](#column)_ recebe por parâmetro um índice em conjunto com o respetivo tabuleiro e retorna a coluna correspondente ao índice dado por parâmetro.

```lisp
(defun column(index board)
  "[index] must be a number between 0 and the board dimension"
  (mapcar (lambda (x) (nth index x))  board) 
)
```

#### [Element](#element)

- A função _[element](#element)_ recebe por parâmetro uma linha, uma coluna e um tabuleiro, e retorna o elemento que está nessa mesma posição.

```lisp
(defun element(r col board)
    "[r] and [col] must be numbers between 0 and the board dimension"
  (nth col (row r board))
)
```

### **[Funções secundárias](#secundary)**

As funções secundárias, são responsáveis pelas verificações nos vários elementos dos tabuleiros.

#### [Empty-elemp](#empty-elemp)

- A função _[empty-elemp](#empty-elemp)_, recebe por parâmetro, a linha, a coluna, o tabuleiro e opcionalmente, um valor inteiro a verficar. Retorna _true_ se um elemento for igual ao _val_ (por defeito é 0 - elemento vazio) e _nil_ caso contrário. Utiliza a função _[element](#element)_ para verificar a casa do tabuleiro.

```lisp
(defun empty-elemp(row col board &optional (val 0)) 
  "[row] and [col] must be numbers between 0 and the board dimension"
  (cond 
  ((or (< row 0) (> row (1- (length board))) (< col 0) (> col (1-(length board)))) nil)
  ((= (element row col board) val) t)
  (t nil)
  )
)
```

#### [Check-empty-elems](#check-empty-elems)

- A função _[check-empty-elems](#check-empty-elems)_, verifica índices. Recebe por parâmetro, o tabuleiro, uma lista de índices e opcionalmente um valor inteiro a verificar. Retorna uma lista com _true_ ou _nil,_ dependendo se os **índices** estão **iguais** ao valor passado no **val** ou não. Utiliza a função _[empty-elemp](#empty-elemp)_ para verificar cada elemento.

```lisp
(defun check-empty-elems(board indexes-list &optional (val 0)) 
  "Each element(list with row and col) in indexes-list
   must contain a valid number for the row and column < (length board)"
  (mapcar (lambda (index) (empty-elemp (first index) (second index) board val)) indexes-list)
)
```

#### [Replace-pos](#replace-pos)

- A função _[replace-pos](#replace-pos)_, substitui uma posição no tabuleiro pelo parâmetro _val._ Esta recebe por parâmetro, a linha, a coluna e opcionalmente um valor, que por defeito é "**1"** e retorna uma linha (lista) com o elemento na posição da coluna, substituído pelo _val_.

```lisp
(defun replace-pos (col row &optional (val 1)) 
    "[Col] (column) must be a number between 0 and the row length"
    (cond 
     ((null row) nil)
     ((= col 0) (cons val (replace-pos (1- col) (cdr row) val)))
     (t (cons (car row) (replace-pos (1- col) (cdr row) val)))
    )
)
```

#### [Replace-](#replace-)

- A função _[replace-](#replace-)_, substitui um elemento no tabuleiro. Esta recebe por parâmetro, a linha, a coluna, o tabuleiro e opcionalmente um valor inteiro (por defeito é 1). Retorna o tabuleiro com o elemento substituído, pelo valor passado por parâmetro, ou por "**1**" caso não tenha sido passado nenhum valor. Utiliza a função _[replace-pos](#replace-pos)_ para substituir o valor no elemento pretendido.

```lisp
(defun replace- (row col board &optional (val 1)) 
  "[Row] and [column] must be a number between 0 and the board length"
  (cond  
   ((null board) nil)
   ((= row 0) (cons (replace-pos col (car board) val) (replace- (1- row) col (cdr board) val)))
   (t (cons (car board) (replace- (1- row) col (cdr board) val)))
  )
)
```

#### [Replace_multi_pos](#replace-multi-pos)

- A função _[replace-multi-pos](#replace-multi-pos)_, substitui várias posições no tabuleiro. Esta recebe por parâmetro uma lista com todas as posições a substituir, o tabuleiro e opcionalmente um valor inteiro (por defeito é 1), retorna o tabuleiro com todos os elementos substituídos pelo valor **"1"**, ou pelo valor passado por parâmetro ao _val_. Utiliza a função _[replace-](#replace-)_ para substituir cada elemento.

```lisp
(defun replace-multi-pos (pos-list board &optional (val 1)) 
    (cond 
      ((null pos-list) board)
      (t (replace-multi-pos (cdr pos-list) (replace- (first (car pos-list)) (second (car pos-list)) board val) val))
    )
)
```

#### [Remove-nil](#romeve-nil)

- A função _[remove-nil](#romeve-nil)_ recebe por parâmetro uma lista, remove todos os elementos _nil_ e retorna uma lista após efetuar esta operação.

```lisp
(defun remove-nil(list)
   (apply #'append (mapcar #'(lambda(x) (if (null x) nil (list x))) list))
)
```

### **[Verificações do tabuleiro](#verificacoes-do-tabuleiro)**

Nesta secção as funções são responsáveis por verificar, a adjacência entre peças, a primeira posição do tabuleiro, os cantos das peças e se é possível inserir uma peça.

#### [Check-adjacent-elems](#check-adjacent-elems)

- A função _[check-adjacent-elems](#check-adjacent-elems)_ verifica a adjacência das peças. Esta recebe por parâmetro, a linha, a coluna, o tabuleiro e uma peça. Se a peça for adjacente a outra, retorna _nil,_ caso contrário retorna _true_.

```lisp
(defun check-adjacent-elems (row col board piece val)
"
[val] must have the player piece value
"
  (cond
   ((eval (cons 'or (check-empty-elems board (piece-adjacent-elems row col piece) val))) nil)
   (t t)
   )
)
```

#### [Check-corner](#check-corner)

- A função _[check-corner](#check-corner)_ recebe por parâmetro uma lista com as cordenadas da peça e opcionalmente um valor a comparar nos cantos da peça, que por defeito é 0. Retorna _nil_ caso a posição esteja vazia, caso contrário retona _true_.

```lisp
(defun check-corner (piece-format &optional (corner 0))
  (let ((list-index (car piece-format)))
    (cond 
      ((null piece-format) nil)
      ((= corner (first list-index) (second list-index)) 0)
      (t (check-corner (cdr piece-format) corner))
    )
  )
)
```

#### [Force-move](#force-move)

- A função _[force-move](#force-move)_, filtra as possíveis jogadas, se o primeiro elemento do canto superior esquerdo estiver vazio, isto para o **Jogador 1**, caso seja o **Jogador 2**, verifica o canto inferior direito, só permite peças nesse elemento, caso não esteja vazio, só permite movimentos que colocam peças em contacto com outras (apenas nos cantos). Esta recebe por parâmetro, a linha, a coluna, o tabuleiro e a peça, retorna _true_ se o movimento for permitido e _nil_ caso contrário.

```lisp
(defun force-move (row col board piece &optional (corner2check 0) (pieces-val 1)) 
"
[corner2check] player1 = 0 || player2 = 13
[pieces-val]   player1 = 1 || player2 = 2   
"
  (let ((corner-index (check-corner (piece-taken-elems row col piece) corner2check)) ; [corner-index] 0 if player's trying to put a piece in his corner || nil if he is not
        (corner-state (element corner2check corner2check board))                     ; [corner-state] 0 if the player corner is empty || 1 or 2 if it already has a piece 
       )
   (cond 
    ((and (= corner-state  0) (null corner-index)) nil)
    ((and (= corner-state 0 corner-index)) t)
    ((eval (cons 'or (check-empty-elems board (piece-corners-elems row col piece) pieces-val))) t)
    (t nil)
   ) 
  )
)
```

#### [Filter-player-move](#piece-player-move)

- A função _[filter-player-move](#filter-player-move)_ recebe por parâmetro o jogador, a linha, a coluna, o tabuleiro e a peça. Com esta informação filtra as jogadas do utilizador, caso seja o **Jogador 1**, este deverá jogar no canto superior esquerdo e o valor da peça será 1, para o **Jogador 2** a peça terá o valor 2 e este terá que jogar no canto inferior direito. Retorna o valor da função _[force-move](#force-move)_, _true_ se a jogada for possível e _nil_ caso contrário.

```lisp
(defun filter-player-move (player row col board piece)
"
[player] player1 = 1 || player2 = -1
"
  (cond 
    ((equal player 1) (force-move row col board piece))
    ((equal player -1) (force-move row col board piece 13 2))
    (t nil)
  )
)
```

#### [Can-placep](#can-placep)

- A função _[can-placep](#can-placep)_, reúne as funções de verificações. Esta recebe por parâmetro uma lista com os elementos a ocupar pela peça, o tabuleiro, a linha, a coluna, a peça e o jogador, retorna _true_ caso seja possível inserir a peça e _nil_ caso contrário. Utiliza as funções _[pieces-left-numb](#pieces-left-numb)_, _[force-move](#force-move)_, _[check-adjacent-elems](#check-adjacent-elems)_, _[check-empty-elems](#check-empty-elems)_ e _[piece-taken-elems](#piece-taken-elems)_ para fazer todas a verificações necessárias.

```lisp
(defun can-placep (pieces-list board row col piece player)
"
[player] player1 = 1 || player2 = -1
"
(let ((pieces-val (cond ((= player 1) 1) (t 2))))
  (cond 
    ((= 0 (pieces-left-numb pieces-list piece)) nil)
    ((or (> row (length board)) (< row 0) (< col 0) (> col (length board))) nil)
    ((not (filter-player-move player row col board piece)) nil)
    ((not (check-adjacent-elems row col board piece pieces-val)) nil)
    ((eval (cons 'and (check-empty-elems board (piece-taken-elems row col piece))))t)
    (t nil)
  )
)
)
```

### **[Possíveis movimentos](#moves)**

As funções que verificam os possíveis movimentos, são responsáveis pelas verificações que melhoram a eficiência do algoritmo, estas evitam a verificação de posições desnecessárias do tabuleiro.

#### [Filter-possible-moves](#filter-possible-moves)

- A função _[filter-possible-moves](#filter-possible-moves)_ verifica onde a peça pode ser colocada no tabuleiro a partir da lista de índices recebida por parâmetro. Retorna uma lista com todos os possíveis movimentos, com base nos índices (coordenadas) fornecidos.

```lisp
(defun filter-possible-moves(pieces-list piece board indexes-list player)
  (remove-nil(mapcar (lambda (index) (cond ((can-placep pieces-list board (first index) (second index) piece player) index) (t nil))) indexes-list))
)
```

#### [All-spaces](#all-spaces)

- A função _[all-spaces](#all-spaces)_ verifica onde a peça pode ser colocada no tabuleiro a partir de uma lista de índices. Retorna uma lista com todos os movimentos possíveis com base em todos os índices fornecidos. 

```lisp
(defun all-spaces(pieces-list piece board indexes-list player)
  (remove-nil(mapcar (lambda (index) (cond ((can-placep pieces-list board (first index) (second index) piece player) index) (t nil))) indexes-list))
)
```

#### [Possible-moves](#possible-moves)

- A função _[possible-moves](#possible-moves)_ verifica onde a peça pode ser colocada no tabuleiro. Retorna uma lista com índices para todos os movimentos possíveis dessa mesma peça, ordenada de cima para baixo.

```lisp
(defun possible-moves(pieces-list piece board player)
  (reverse (all-spaces pieces-list piece board (check-all-board board (1- (length board)) (1- (length (car board)))) player))
)
```

#### [Check-all-board](#check-all-board)

- A função _[check-all-board](#check-all-board)_ retorna uma lista com todos os índices do tabuleiro

```lisp
(defun check-all-board(board row col)
  (cond 
    ((< row 0) nil)
    ((< col 0) (check-all-board board (1- row) (1- (length board))))
    (t (cons (list row col) (check-all-board board row (1- col))))
  )
)
```

#### [Piece-taken-elems](#piece-taken-elems)

- A função _[piece-taken-elems](#piece-taken-elems)_, recebe por parâmetro, a linha, a coluna e uma peça. Retorna uma lista com todos os elementos, que essa mesma peça ocupa no tabuleiro.

```lisp
(defun piece-taken-elems (row col piece) 
  (cond 
   ((equal piece 'piece-a) (cons (list row col) nil))                                            
   ((equal piece 'piece-b)                                  
    (list (list row col) (list row (1+ col)) (list (1+ row) col) (list (1+ row) (1+ col)))         
    )
   ((equal piece 'piece-c-2) 
    (list (list row col) (list (1+ row) col) (list (1+ row) (1+ col)) (list (+ row 2) (1+ col)))  
    ) 
   ((equal piece 'piece-c-1) (list (list row col) (list row (1+ col)) (list (1- row) (1+ col)) (list (1- row) (+ col 2))))
   (t nil)
   )
)
```

#### [Piece-adjacent-elems](#piece-adjacent-elems)

- A função _[piece-adjacent-elems](#piece-adjacent-elems)_ cria uma lista para cada peça, das casas adjacentes. Esta recebe por parâmetro, a linha, a coluna e uma peça. Retorna uma lista, referente à peça passado por parâmetro com todas os elementos adjacentes da mesma.

```lisp
(defun piece-adjacent-elems (row col piece)
  (cond
   ((equal piece 'piece-a) (list (list row (1+ col)) (list row (1- col)) (list (1+ row) col) (list (1- row) col)))
   ((equal piece 'piece-b) (list (list row (1- col)) (list (1+ row) (1- col)) (list (1- row) col) (list (1- row) (1+ col)) (list (+ row 2) col) (list (+ row 2) (1+ col)) (list row (+ col 2)) (list (1+ row) (+ col 2))))
   ((equal piece 'piece-c-1) 
    (list (list row (- col 2)) (list (1- row) col) (list (- row 2) (1+ col)) (list (- row 2) (+ col 2)) (list (1- row) (+ col 3)) (list (1+ row) col) (list (1+ row) (1+ col)) (list row (+ col 2))))
   ((equal piece 'piece-c-2) (list (list (1- row) col) (list row (1- col)) (list row (1+ col)) (list (1+ row) (1- col)) (list (1+ row) (+ col 2)) (list (+ row 2) col) (list (+ row 2) (+ col 2)) (list (+ row 3) (1+ col))))
   (t nil)
   )
)
```

#### [Piece-corners-elems](#piece-corners-elems)

- A função _[piece-corners-elems](#piece-corners-elems)_, cria uma lista para cada peça, das casas referentes aos cantos exteriores. Esta recebe por parâmetro, a linha, a coluna e uma peça. Retorna uma lista, referente à peça passada por parâmetro com todas os elementos que dizem respeito aos cantos exteriores da mesma.

```lisp
(defun piece-corners-elems (row col piece)
  (cond
   ((equal piece 'piece-a)
    (list (list (1- row) (1- col)) (list (1+ row) (1- col)) (list (1- row) (1+ col)) (list (1+ row) (1+ col))))
   ((equal piece 'piece-b)
    (list (list (1- row) (1- col)) (list (+ row 2) (1- col)) (list (1- row) (+ col 2)) (list (+ row 2) (+ col 2))))
   ((equal piece 'piece-c-1)
    (list (list (- row 2) col) (list (1- row) (1- col)) (list (1+ row) (1- col)) (list (- row 2) (+ col 3)) (list row (+ col 3)) (list (1+  row) (+ col 2))))
   ((equal piece 'piece-c-2)
    (list (list (1- row) (1- col)) (list (1- row) (1+ col)) (list row (+ col 2)) (list (+ row 2) (1- col)) (list (+ row 3) col) (list (+ row 3) (+ col 2))))
   )
)
```

#### [Insert-piece](#insert-piece)

- A função _[insert-piece](#insert-piece)_, insere peças no tabuleiro. Esta recebe por parâmetro uma lista com os elementos a ocupar, a linha, a coluna, o tabuleiro, uma peça e opcionalmente o jogador, que por defeito é o **Jogador 1**. Com recurso à função _[can-placep](#can-placep)_, retorna o tabulerio caso seja possível inserir a peça no mesmo, ou _nil_ caso contrário. Utiliza ainda as funções _[replace-multi-pos](#replace-multi-pos)_ e _[piece-taken-elems](#piece-taken-elems)_ para inserir a as peças com a suas formas corretas, respetivamente.

```lisp
(defun insert-piece (pieces-list row col board piece &optional (player 1)) 
"
[player] player1 = 1 || player2 = -1
"
  (let ((val (cond ((= player 1) 1) (t 2))))
    (cond 
      ((null (can-placep pieces-list board row col piece player)) nil)
      (t (replace-multi-pos (piece-taken-elems row col piece) board val)))
  )
)
```

#### [Pieces-left-numb](#pieces-left-numb)

- A função _[pieces-left-numb](#pieces-left-numb)_, recebe por parâmetro uma lista com todas as peças restantes por jogar e tipo da peça, retorna quantas peças sobraram por tipo.

```lisp
(defun pieces-left-numb(pieces-list piece-type)
  (cond 
    ((equal piece-type 'piece-a)(first pieces-list))
    ((equal piece-type 'piece-b) (second pieces-list))
    (t (third pieces-list))
  )
)
```

#### [Removed-used-piece](#removed-used-piece)

- A função _[removed-used-piece](#removed-used-piece)_, recebe por parâmetro uma lista com todas as peças e o tipo da peça, e remove uma peça da lista de peças restantes a jogar.

```lisp
(defun remove-used-piece(pieces-list piece-type)
  (cond 
    ((equal piece-type 'piece-a) (list (1- (first pieces-list)) (second pieces-list) (third pieces-list)))
    ((equal piece-type 'piece-b) (cadr pieces-list) (list (first pieces-list) (1-(second pieces-list)) (third pieces-list)))
    (t (list (first pieces-list) (second pieces-list) (1- (third pieces-list))))
  )
)
```

### **[Operações com Peças](#pecas)**

Esta secção contém as funções referentes à inserção das peças, número de peças a inserir, atualização do número de peças a inserir e verificação de todas as possíveis inserções de peças no tabuleiro.

Nesta secção definimos as funções referentes à quantidade de peças iniciais, lista de todas as operações e a inserção das peças no tabueleiro.

#### [Init-pieces](#init_pieces)

- A função _[init-pieces](#init_pieces)_, cria uma lista com o número total de peças, por cada tipo de peças.

```lisp
(defun init-pieces()
  (list 10 10 15)
)
```

#### [Operations](#operations)

- A função _[operations](#operations)_ retorna uma lista com todas as operações.

```lisp
(defun operations()
  (list 'piece-b 'piece-c-1 'piece-c-2 'piece-a)
)
```

- As seguintes funções retornam o tabuleiro com as peças colocadas ou _nil_ caso contrário.

#### [Piece-a](#piece-a)

```lisp
(defun piece-a (pieces-list index board player)
"
[pieces-list] list with the number of each piece left
[index] list with row and column
[player] player playing  player1 = 1 || player2 = -1
"
  (insert-piece pieces-list (first index) (second index) board 'piece-a player)
)
```

#### [Piece-b](#piece-b)

```lisp
(defun piece-b (pieces-list index board player)
   (insert-piece pieces-list (first index) (second index) board 'piece-b player)
)
```

#### [Piece-c-1](#piece-c1)

```lisp
(defun piece-c-1 (pieces-list index board player) 
  (insert-piece pieces-list (first index) (second index) board 'piece-c-1 player)
)
```

#### [Piece-c-2](#piece-c2)

```lisp
(defun piece-c-2 (pieces-list index board player)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-2 player)
)
```

### **[Final do Jogo](#endgame)**

#### [Get-h](#get-h)

- A função _[get-h](#get-h)_ retorna o valor da heurística.

```lisp
(defun get-h(node color)
  (- (count-points (pieces-list node color)) (count-points (pieces-list node (- color))))
)
```

#### [Count-points](#count-points)

- A função _[Count-points](#counts-points)_ recebe por parâmetro e retorna o valor da pontução.

```lisp
(defun count-points (pieces-list)
  (+ (- 10 (first pieces-list)) (* (- 10 (second pieces-list)) 4) (* (- 15 (third pieces-list)) 4))
)
```

#### [Winner](#winner)

- A função _[winner](#winner)_ recebe por parâmetro o nó, define o vencedor, usa a função [count-points](#count-points). Retorna o vencedor.

```lisp
(defun winner(node)
	(let ((p1-points (count-points (pieces-list node 1))) (p2-points (count-points (pieces-list node -1))))
		(cond 
		((> p1-points p2-points) 'Jogador1)
		((< p1-points p2-points) 'Jogador2)
		(t 'Empate)
		)
	)
)
```

---

## **[Algoritmo](#algoritmo)**

### **[Memoização](#memoização)**

A Memoização melhora o desempanho dos algoritmos, armazenando os resultados das funções na memória e retornando o resultado em cache quando as mesmas entradas ocorrerem novamente.

```lisp
(let ((tab (make-hash-table)))
  (defun fib-memo (n)
    (or (gethash n tab) (let ((val (funcall #'FUNC n))) (setf (gethash n tab) val) val))
  )
)
```

### **[Tipos de Dados Abstratos](#tipos-de-dados-abstratos)**

Os tipos abstratos de dados são criados e utilizados para guardar as informações necessárias de modo a facilitar o desenvolvimento de uma solução independentemente do problema enfrentado. Assim sendo, estes dados abstratos podem ser utilizados para tentar resolver qualquer problema com os algoritmos disponíveis.

#### [Player-info](#player-info)

- A função _[player-info](#player-info)_ recebe por parâmetro uma peça e um jogador. Retorna uma lista com a peça e o jogador.

```lisp
(defun move-info(piece move)
"
[piece] operation 
[move] list with row and col
"
(list (list piece move))
)
```

#### [Make-node](#make-node)

- A função _[make-node](#make-node)_ contrói um nó com o estado no _tabuleiro_, a _profundidade_ e o _nó pai_. Usa a função _[init-pieces](#init_pieces)_ para definir a lista de peças e retorna uma lista com todos os dados.

```lisp
(defun make-node(state &optional (parent nil) (p1-node (player-info)) (p2-node (player-info -1)) (f 0))
  (list state parent f p1-node p2-node)
)
```

#### [Node-state](#node-state)

- A função _[node-state](#node-state)_ retorna o estado do nó. O estado de um nó é representado pelo tabuleiro com as peças inseridas (em caso de utilização das operações disponíveis).

```lisp
(defun node-state(node)
  (first node)
)
```

#### [Node-parent](#node-parent)

- A função _[node-parent](#node-parent)_ retorna o nó pai do nó, através do ponteiro que este guarda.

```lisp
(defun node-parent(node)
  (second node)
)
```

#### [Node-value](#node-value)

- A função _[node-value](#node-value)_ retorna o valor do nó.

```lisp
(defun node-value(node)
	(third node)
)
```

#### [Node-p1](#node-p1)

- A função _[node-p1](#node-p1)_ retorna o nó referente ao **Jogador 1**.

```lisp
(defun node-p1 (node)
	(fourth node)
)
```

#### [Node-p2](#node-p2)

- A função _[node-p2](#node-p2)_ retorna o nó referente ao **Jogador 2**.

```lisp
(defun node-p2 (node)
  (nth (1- (length node)) node)
)
```

#### [Player-moves](#player-moves)

- A função _[player-moves](#player-moves)_, retorna todos os movimentos realizados por um jogador.

```lisp
(defun player-moves(node color)
	(cond 
		((= 1 color) (second (node-p1 node)))
		(t (second (node-p2 node)))
	)
)
```

#### [Last-move](#last-move)

- A função _[last-move](#last-move)_, retorna um nó com a informação referente à última jogada.

```lisp
(defun last-move(node color)
  (let ((moves (player-moves node color)))
    (nth (1-(length moves)) moves)
  )
)
```

#### [Pieces-list](#pieces-list)

- A função _[pieces-list](#pieces-list)_ retorna uma lista com o número de peças que ainda se pode pôr, por tipo. Inicialmente a lista deverá ser sempre iniciada com valores predefinidos, (**10** **10** **15**) **peça-a**, **peça-b** e **peça-c**, respetivamente.

```lisp
(defun pieces-list(node color)
	(cond 
		((= 1 color) (third (node-p1 node)))
		(t (third (node-p2 node)))
	)
)
```

### **[Algoritmos](#algoritmos)**

Os algoritmos são funções que executam um conjunto de operações com o objetivo de chegar a um estado final (pré-definido). Estes algoritmos exploram um espaço de possibilidades tentanto vários caminhos possíveis. Este processo consiste num espaço de estados.

#### [Negamax](#negamax)

- A função _[negamax](#negamx)_ é responsável por executar todos os passos do algoritmo negamax.

```lisp
(defun negamax(max-time                 
               &optional 
               (node (make-node (empty-board) nil (player-info 1) (player-info -1) most-negative-fixnum))
               (color 1)
               (player 1)
               (max-depth 6)
               (alpha most-negative-fixnum) 
               (beta most-positive-fixnum) 
               (start-time (get-internal-real-time))
               (visited-nodes 1)
               (cuts 0)
               )

  (let* ((children (order-nodes (funcall #'expand-node node (operations) player))))
    (cond
     ((or (= max-depth 0) (null children) (>= (runtime start-time) max-time)) 
      (solution-node (final-node-f node color player) visited-nodes cuts start-time))
     (t (negamax- node children max-time color player max-depth alpha beta start-time visited-nodes cuts))
     )
    )
  )
```

#### [Negamax-](#negamax-)

- A função _[negamax-](#negamx-)_ é uma função auxiliar, responsável por criar a árvore a partir dos sucessores.

```lisp
(defun negamax-(parent children max-time color player max-depth alpha beta start-time visited-nodes cuts)
	(cond
   		((= (length children) 1) 
    		(negamax max-time (-f (car children)) (- color) (- player) (1- max-depth) (- beta) (- alpha) start-time (1+ visited-nodes) cuts))
   		(t (let* (
			(solution (negamax max-time (-f (car children)) (- color) (- player) (1- max-depth) (- beta) (- alpha) start-time (1+ visited-nodes) cuts))
            (best-value (node-value (max-f (car solution) parent)))
            (temp-alpha (max alpha best-value))
            (v-nodes (get-visited-nodes solution))       
            (cuts-numb (get-cuts solution))
            )
      			(cond 
	  				((>= temp-alpha beta) (solution-node parent v-nodes (1+ cuts-numb) start-time))
        			(t (negamax- parent (cdr children) max-time color player max-depth temp-alpha beta start-time v-nodes cuts-numb))
    			)
      		)
   		)
  	)
)
```

### **[Solution Node](#solution-node)**

#### [Solution-node](#solution-node)

```lisp
(defun solution-node(node visited-nodes cuts-number start-time)
	(list node (list visited-nodes cuts-number (runtime start-time)))
)
```

#### [Get-solution-node](#get-solution-node)

```lisp
(defun get-solution-node(sol-node) (car sol-node))
```

#### [Get-visited-nodes](#get-visited-nodes)

```lisp
(defun get-visited-nodes(sol-node) (car (second sol-node)))
```

#### [Get-cuts](#get-cuts)

```lisp
(defun get-cuts(sol-node)(second (second sol-node)))
```

#### [Get-runtime](#get-runtime)

- A função _[get-runtime](#get-runtime)_

```lisp
(defun get-runtime(sol-node)(third (second sol-node)))
```

### **[Auxiliares](#auxiliares)**

As funções auxiliares são utilizadas como suporte aos dados abstratos, aos algoritmos implementados ou até como suplemento a outras funções secundárias.

#### [Get-child](#get-child)

- A função _[get-child](#get-child)_ utiliza uma peça e aplica uma operação com um dos movimentos possíveis para criar um filho de um nó.
- Cria um nó filho e retorna-o.
- Utiliza como funções auxiliares _[make-node](#make-node)_, _[remove-used-piece](#remove-used-piece)_, _[pieces-left](#pieces-left)_ e _[player-info](#player-info)_.

```lisp
(defun get-child(node possible-move operation color &aux (pieces-left (pieces-list node color)) (state (node-state node)))
    "
	[Operation] must be a function
	[color] represents the player - player1 = 1 || player2 = -1 
	"
    (let* (
          (move (funcall operation pieces-left possible-move state color))
          (updated-pieces-list (remove-used-piece pieces-left operation))
		      (updated-player-info (player-info color (append (player-moves node color) (move-info operation possible-move)) updated-pieces-list))  
		      ;(updated-player-info (player-info color nil updated-pieces-list)) 
          )
      (cond 
        ((null move) nil)
		;((= color 1) (make-node move nil updated-player-info (node-p2 node) (count-points updated-pieces-list)))
		((= color 1) (make-node move nil updated-player-info (node-p2 node) 0))
    ;(t (make-node move nil (node-p1 node) updated-player-info (count-points updated-pieces-list))) 
		(t (make-node move nil (node-p1 node) updated-player-info 0))
      )
  )
)
```

#### [Get-children](#get-children)

- A função _[get-children](#get-children)_ cria todos os sucessores possíveis a partir de um estado e um tipo de peça.
- Utiliza como função auxiliar _[get-child](#get-child)_ para criar os vários sucessores para as várias jogadas possíveis.
- Retorna uma lista com todos os sucessores de um nó aplicados a uma operação/peça.

```lisp
(defun get-children(node possible-moves operation color)
  (cond 
    ((null possible-moves) nil) 
    (t (cons (get-child node (car possible-moves) operation color) (get-children node (cdr possible-moves) operation color)))
  )
)
```

#### [Expand-node](#expand-node)

- A função _[expand-node](#expand-node)_ cria todos os sucessores possíveis de um nó, ou seja, cria os filhos do nó _**node**_, para todas as jogadas possíveis e todas as operações/peças.
- Retorna uma lista com todos os sucessores.
- Utiliza como funções auxiliares _[remove-nil](#remove-nil)_, _[possible-moves](#possible-moves)_ e _[get-children](#get-children)_.

```lisp
(defun expand-node(node operations color)
  "
  [operations] must be a list with all available operations
  "
		(cond
    		((null operations) nil)
    		(t (remove-nil (append (get-children node (funcall #'possible-moves (pieces-list node color) (car operations) (node-state node) color) (car operations) color)        
                      (expand-node node (cdr operations) color))))

   		)
)
```

#### [Order-nodes](#order-nodes)

- A função _[order-nodes](#order-nodes)_ ordena uma lista de nós de forma decrescente.

```lisp
(defun order-nodes(node-list) 
	(sort node-list #'> :key #'node-value)
)
```

#### [Max-f](#max-f)

- A função _[max-f](#max-f)_ recebe por parâmetro dois nós e devolve o nó com o valor mais alto.

```lisp
(defun max-f(node1 node2)
	(cond 
		((>= (node-value node1) (node-value node2)) node1)
		(t node2)
	)
)
```

#### [-f](#-f)

- A função _[-f](#-f)_ recebe por parâmetro um nó e devolve o nó com o valor invertido.

```lisp
(defun -f(node)
	(make-node (node-state node) (node-parent node) (node-p1 node) (node-p2 node) (- (node-value node)))
)
```

#### [Final-node-f](#final-node-f)

- A função _[final-node-f](#final-node-f)_ retorna um nó com o seu valor multiplicado pela cor das peças do jogador.

```lisp
(defun final-node-f(node color player)
	(make-node (node-state node) (node-parent node) (node-p1 node) (node-p2 node) (* color (get-h node player)))
)
```

### **[Performance Stats](#performance-stats)**

#### [Runtime](#runtime)

- A função _[runtime](#runtime)_ calcula o tempo.

```lisp
(defun runtime(start-time)
	(/(- (get-internal-real-time) start-time) 1000)
)
```

---

## **[Jogo](#jogo)**

### **[Game Handler](#gameHandler)**

#### [Start](#start)

- A função _[start](#start)_ recebe dados pelo utilizador a partir do teclado e por consequência executa a ação/operação correspondente, em relação à função _[init-menu](#init-menu)_.

```lisp
(defun start()
    (init-menu)
    (let ((option (read)))
      (if (and (numberp option) (>= option 0) (<= option 2))
        (cond
          ((equal option 1) (get-starter))
          ((equal option 2) (get-time-limit))
          ((equal option 0) (format t "~%Adeus!"))
        )

        (progn (print "Opção inválida. Tente novamente") (start))
      )
    )
)
```

#### [Starter-view](#starter-view)

- A função _[starter-view](#starter-view)_ mostra o menu referente à opção de quem irá começar primeiro _Humano_ ou _Computador_.

```lisp
(defun starter-view()
    (format t "~%_________________________________________________________")
    (format t "~%\\                     BLOKUS DUO                        /")
    (format t "~%/                  Quem começa primeiro?                \\")
    (format t "~%\\                   (tipo das peças)                    /")
    (format t "~%/     1 - Humano (1)                                    \\")
    (format t "~%\\     2 - Computador (2)                                /")
    (format t "~%/     0 - Voltar                                        \\")
    (format t "~%\\_______________________________________________________/~%~%> ")
)
```

#### [Get-starter](#get-starter)

- A função _[get-starter](#get-starter)_ recebe dados pelo utilizador a partir do teclado e por consequência executa a ação/operação correspondente, em relação à função _[starter-view](#starter-view)_.

```lisp
(defun get-starter()
  (starter-view)
  (let ((option (read)))
    (cond
      ((or (< option 0) (> option 2)) (progn (format t "Insira uma opcao valida") (get-starter)))
      ((= option 0) (start))
      (t (get-time-limit option))
    )
  )
)
```

#### [Time-limit-view](#time-limit-view)

- A função _[time-limit-view](#time-limit-view)_ mostra o menu referente à opção escolha do tempo limite para uma jogada do _computador_.

```lisp
(defun time-limit-view()
  (format t "~%_________________________________________________________")
  (format t "~%\\                      BLOKUS DUO                       /")
  (format t "~%/          Defina o tempo limite para uma jogada        \\")
  (format t "~%\\            do computador (1 - 20) segundos.           /")
  (format t "~%\\                                                      \\")
  (format t "~%/     0 - Voltar                                        /")
  (format t "~%\\                                                     \\")
  (format t "~%/_______________________________________________________/~%~%> ")
)
```

#### [Get-time-limit](#get-time-limit)

- A função _[get-time-limit](#get-time-limit)_ recebe dados pelo utilizador a partir do teclado, neste caso recebe um número que corresponde ao tempo limite para uma jogada do computador _[time-limit-view](#time-limit-view)_.

```lisp
(defun get-time-limit(&optional (starter nil))
  (progn (time-limit-view)
    (let ((option (read)))
      (cond
        ((and (= option 0) (null starter)) (start))
        ((= option 0) (get-starter))
        ((or (not (numberp option)) (< option 1) (> option 20)) (progn (format t "Insira uma opção válida") (get-time-limit)))
        (t (list starter option))
      )
    )
  )
)
```

### **[Files Handler](#filesHandler)**

#### [Get-log-path](#get-log-path)

- A função _[get-log-path](#get-log-path)_ retorna o caminho para o arquivo de log.

```lisp
(defun get-log-path()
  (make-pathname :host "D" :directory '(:absolute "GitHub\\Blokus2") :name "log" :type "dat")   
)
```

### [Human-vs-Computer](#human-vs-computer)

- A função _[human-vs-computer](#human-vs-computer)_ é responsável por executar o algoritmo no jogo entre **Humano** (Utilizador) contra **Computador**.

```lisp
(defun human-vs-computer(max-time player &optional (node (make-node (empty-board))))
  (let* (
          (p-moves    (expand-node node (operations) 1))
          (p-pieces   (pieces-list node 1))
          (can-p-play (or (null p-moves) (= 0 (apply '+ p-pieces))))                                          ; t = can't play
          (c-moves    (expand-node node (operations) -1))
          (c-pieces   (pieces-list node -1))
          (can-c-play (or (null c-moves) (= 0 (apply '+ c-pieces))))                                          ; t = can't play
          (can-current-play (cond ((= player 1) can-c-play) (t can-c-play)))                                  ; t = can't play
        )
    (cond 
      ((and can-p-play can-c-play) (log-footer node))
      ((= 1 player)                                                                                           ; Man 
        (cond 
          ((eval can-current-play) 
            (progn  
              (format t "~%~%________Sem Jogadas________~%~%")
              (human-vs-computer max-time (- player) node))
          )
          (t(let* (
                    (piece (piece-input node player))  
                    (indexes (move-input node piece player))  
                    (move (get-child node indexes piece player))
                  )
              (progn
                  (log-file (solution-node move 0 0 0) player)
                  (format t "Jogou a peca ~a na posicao (~a , ~a)~%" piece (first indexes) (second indexes))
                  (human-vs-computer max-time (- player) move)
              ) 
            )
          )
        )
      )
      (t                                                                                                       ; Computer 
        (cond 
          ((eval can-current-play) 
            (progn  
              (format t "~%~%________Computador Sem Jogadas________~%~%")
              (human-vs-computer max-time (- player) node)
            )
          )
          (t(let* (
                    (solution-nd (negamax max-time node 1 player))
                    (sol-node (get-solution-node solution-nd))
                  )
              (progn 
                (log-file solution-nd player) 
                (human-vs-computer max-time (- player) (make-node (node-state sol-node) nil (node-p1 sol-node) (node-p2 sol-node)))
              )
            )
          )
        )
      ) 
    )
  )
)
```

### [Piece-view](#piece-view)

- A função _[piece-view](#piece-view)_ mostra o menu de escolha do tipo de peça a colocar. 

```lisp
(defun piece-view(pieces)
  (progn
    (format t "~%___________________________________________________________")
    (format t "~%\\           Escolha o tipo de peca a colocar              /")
    (cond 
      ((> (first pieces) 0)
        (format t "~%/                     1 - peca A                          \\"))
      ((> (second pieces) 0)
        (format t "~%\\                    2 - peca B                           /"))
      ((> (third pieces) 0)
        (progn 
          (format t "~%\\                    3 - peca C1                         \\")
          (format t "~%/                     4 - peca C2                          /")
        )
      )
    )
    (format t "~%/_________________________________________________________\\~%~%>")
  )
)
```

#### [Run-h-vs-c](#run-h-vs-c)

- A função _[run-h-vs-c](#run-h-vs-c)_ inicia o jogo Humano contra Computador, utilizando como função auxiliar _[human-vs-computer](#human-vs-computer)_.

```lisp
(defun run-h-vs-c() 
  (let* ((starter (get-starter)) (starter-val (cond ((= 1 starter) 1) (t -1) )) (max-time (get-time-limit)))
    (progn
      (log-header max-time)
      (human-vs-computer max-time starter-val)
    ) 
  )
)
```

#### [Piece-input](#piece-input)

- A função _[piece-input](#piece-input)_ recebe a peça a utilizar pelo utilizador.

```lisp
(defun piece-input(node player &optional (pieces (pieces-list node player)))
    (prog
        (piece-view pieces)
        (let (option (read))
          (cond 
            ((or (not (numberp option)) (< 1 option) (> 4 option)) 
              (progn 
                (format t "~% __________________________________________________________")
                (format t "~%/                 Escolha uma opcao valida                /") 
                (format t "~%__________________________________________________________~%")
                (piece-input node player pieces)
              ) 
            )
            (t 
              (cond 
                ((and (= 1 option) (> (first pieces) 0)) 'piece-a) 
                ((and (= 2 option) (> (second pieces) 0)) 'piece-b) 
                ((and (= 3 option) (> (third pieces) 0)) 'piece-c-1) 
                ((and (= 4 option) (> (third pieces) 0)) 'piece-c-2) 
                (t (progn 
                  (format t "~% __________________________________________________________")
                  (format t "~%/                 Escolha uma opcao valida                /") 
                  (format t "~%__________________________________________________________~%")
                  (piece-input node player pieces)
                ))
              )
            )
          )
        )
    )
)
```

#### [Move-view](#move-view)

- A função _[move-view](#move-view)_ mostra uma mensagem, que pede ao tulizador para inserir a posição do tabuleiro que deseja inserir a peça.

```lisp
(defun move-view(moves &optional (first-time t) (piece-numb 1) &aux (move (car moves)))
  (cond
    ((null moves) (format t "~%__________________________________________________________~%"))
    (t (progn 
      (cond 
        ((eval first-time)
          (progn 
          (format t "~%___________________________________________________________")
          (format t "~%\\               Escolha a posicao da peca                /")
          (format t "~%/                                                        \\")
          )
        )
      )
          (format t "~%\\                    ~a - (~a , ~a)                     /" piece-numb (first move) (second move))
      (move-view (cdr moves) nil )  
    ))
  )
)
```

#### [Move-input](#move-input)

- A função _[move-input](#move-input)_ recebe a posição que o utilizador deseja inserir a peça no tabuleiro.

```lisp
(defun move-input(node piece player)
  (let* (
          (pieces (pieces-list node player))
          (state (node-state node))
          (moves (possible-moves pieces piece state player))
        )
    (progn 
      (move-view moves)
      (let (option (read))
        (cond 
          ((or (not (numberp option)) (< option 1) (> option (length moves)))
          (progn 
                  (format t "~% __________________________________________________________")
                  (format t "~%/                 Escolha uma opcao valida                /") 
                  (format t "~%__________________________________________________________~%")
                  (move-input node piece player)
          )
        )
        (t (nth (1- option) moves))
      )
    )
  )
)
```

#### [Computer-only](#computer-only)

```lisp
(defun computer-only(max-time player &optional (node (make-node (empty-board))))
  (let* (
          (c1-moves    (expand-node node (operations) 1))
          (c1-pieces   (pieces-list node 1))
          (can-c1-play (or (null c1-moves) (= 0 (apply '+ c1-pieces))))        ; t = can't play
          (c2-moves    (expand-node node (operations) -1))
          (c2-pieces   (pieces-list node -1))
          (can-c2-play (or (null c2-moves) (= 0 (apply '+ c2-pieces))))        ; t = can't play
          (can-current-play (cond ((= player 1) can-c1-play) (t can-c2-play)))  ; t = can't play
          ;(player-numb (cond ((= player 1) 1) (t 2)))
        )
    (cond 
      ((and can-c1-play can-c2-play) (log-footer node))                            ; endgame (+ log.dat)
      (t 
        (cond 
          ((eval can-current-play) 
            (progn  
              (format t "~%~%________Sem Jogadas________~%~%")
              (computer-only max-time (- player) node)
            )
          )
          (t(let* (
                    (solution-nd (negamax max-time node 1 player))
                    (sol-node (get-solution-node solution-nd))
                  )
              (progn 
                (log-file solution-nd player) 
                (computer-only max-time (- player) (make-node (node-state sol-node) nil (node-p1 sol-node) (node-p2 sol-node)))
              )
            )
          )
        )
      )
    )
  )
)
```

#### [Run-computer-only](#run-computer-only)

```lisp
(defun run-computer-only()
  (let ((max-time (get-time-limit)))
    (progn 
      (log-header max-time)
      (computer-only max-time 1)
    )
  )
)
```

### **[Menus](#menus)**

#### [Init-menu](#init-menu)

- A função _[init-menu](#init-menu)_ mostra o menu inicial do jogo.

```lisp
(defun init-menu()
    (format t "~%___________________________________________________________")
    (format t "~%\\                      BLOKUS DUO                         /")
    (format t "~%/                                                         \\")
    (format t "~%\\     1 - Humano vs Computador                            /")
    (format t "~%/       2 - Computador vs Computador                      \\")  
    (format t "~%\\     0 - Sair                                            /")
    (format t "~%/_________________________________________________________\\~%~%>")
)
```

#### [Start](#start)

- A função _[start](#start)_  dá inicio ao jogo, mostrando o menu inicial.

```lisp
(defun start()
    (init-menu)
    (let ((option (read)))
      (if (and (numberp option) (>= option 0) (<= option 2)) 
        (cond
          ((equal option 1) (get-starter))
          ((equal option 2) (run-computer-only)) 
          ((equal option 0) (format t "~%Adeus!"))
        ) 

        (progn (print "Opção inválida. Tente novamente") (start))
      )
    )
)
```

#### [Start-view](#start-view)

- A função _[start-view](#start-view)_ mostra o menu de escolha de quem inicia o jogo, humano (utilizador) ou computador.

```lisp
(defun starter-view()
    (format t "~%_________________________________________________________")
    (format t "~%\\                     BLOKUS DUO                        /")
    (format t "~%/                  Quem começa primeiro?                \\")
    (format t "~%\\                   (tipo das peças)                    /")
    (format t "~%/     1 - Humano (1)                                    \\")
    (format t "~%\\     2 - Computador (2)                                /")
    (format t "~%/     0 - Voltar                                        \\")
    (format t "~%\\_______________________________________________________/~%~%> ")
)
```

#### [Get-starter](#get-starter)

- A função _[get-starter](#get-starter)_

```lisp
(defun get-starter()
  (starter-view)
  (let ((option (read)))
    (cond
      ((or (< option 0) (> option 2)) (progn (format t "Insira uma opcao valida") (get-starter)))
      ((= option 0) (start))
      (t option)
    )
  )
)
```

#### [Time-limit-view](#time-limit-view)

- A função _[time-limit-view](#time-limit-view)_ mostra a mensagem para o utilizador escolher o tempo limite da jogada do computador.

```lisp
(defun time-limit-view()
  (format t "~%_________________________________________________________")
  (format t "~%\\                      BLOKUS DUO                       /")
  (format t "~%/          Defina o tempo limite para uma jogada        \\")
  (format t "~%\\            do computador (1 - 20) segundos.           /")
  (format t "~%\\                                                      \\")
  (format t "~%/     0 - Voltar                                        /")
  (format t "~%\\                                                     \\")
  (format t "~%/_______________________________________________________/~%~%> ")
)
```

#### [Get-time-limit](#get-time-limit)

- A função _[get-time-limit](#get-time-limit)_ 

```lisp
(defun get-time-limit()
  (progn (time-limit-view)
    (let ((option (read)))
      (cond 
        ((= option 0) (start))
        ((or (not (numberp option)) (< option 1) (> option 20)) (progn (format t "Insira uma opção válida") (get-time-limit)))
        (t option)
      )
    )
  )
)
```

#### [Header](#header)

- A função _[header](#header)_ 

```lisp
(defun header(stream max-time)
  (format stream "~%----------------- INICIO -----------------~%max-time: ~a~%~%" max-time)
)
```

#### [Log-header](#log-header)

- A função _[log-header](#log-header)_ 

```lisp
(defun log-header(max-time)
  (progn 
    (with-open-file (file (get-log-path) :direction :output :if-exists :append :if-does-not-exist :create) (header file max-time))  
    (header t max-time)
  )     
)
```

#### [Log-file](#log-file)

- A função _[log-file](#log-file)_ 

```lisp
(defun log-file(solution-nd color)
  (let* (
        (player (cond ((= color 1) 1) (t 2)))
        (node (get-solution-node solution-nd))
        (move (last-move node color))
        (visited-nodes (get-visited-nodes solution-nd))
        (cuts (get-cuts solution-nd))
        (alg-runtime (get-runtime solution-nd))
      )
    (progn 
      (with-open-file (file (get-log-path) :direction :output :if-exists :append :if-does-not-exist :create)
        (log-stream file (node-state node) player (first move) (second move) visited-nodes cuts alg-runtime))
      (log-stream t (node-state node) player (first move) (second move) visited-nodes cuts alg-runtime)
    )
  )
)
```

#### [Log-stream](#log-stream)

- A função _[log-stream](#log-stream)_ 


```lisp
(defun log-stream (stream state player piece indexes nodes-visited cuts runtime)
  (progn 
    (format-board state stream)
    (format stream "~%Jogador ~a ~%" player)
    (format stream "Jogou a peca ~a na posicao (~a , ~a)~%" piece (first indexes) (second indexes))
    (format stream "Nos Analisados: ~a ~%" nodes-visited)
    (format stream "Numero de Cortes: ~a ~%" cuts)
    (format stream "Tempo de Execucao: ~a ~%" runtime)
  )                       
)
```

#### [Log-footer](#log-footer)

- A função _[log-footer](#log-footer)_ 


```lisp
(defun log-footer(node)
  (progn
    (with-open-file (file (get-log-path) :direction :output :if-exists :append :if-does-not-exist :create) (log-winner node file))
    (log-winner node t)
  )
) 
```

#### [Log-winner](#log-winner)

- A função _[log-winner](#log-winner)_ 


```lisp
(defun log-winner(node stream)
  (let ((pieces-p1 (pieces-list node 1)) (pieces-p2 (pieces-list node -1)))
    (format stream    "~%__________________________________________________________")
    (format stream "~%\\                      BLOKUS DUO                        /")
    (format stream "~%/                                                        \\")
    (format stream "~%\\                       Vencedor                         /")
    (format stream "~%/                           ~a                     \\" (winner node))
    (format stream "~%\\                                                        /")
    (format stream "~%/    Jogador 1: ~a pontos  vs  Jogador 2: ~a pontos      \\" (count-points pieces-p1) (count-points pieces-p2)) 
    (format stream "~%\\      pecas: ~a            pecas: ~a         /" pieces-p1 pieces-p2)
    (format stream "~%/                                                        \\")
    (format stream "~%\\________________________________________________________/~%~%> ")
  )
)
```

## **[Formatters](#formatters)**

#### [Format-board-line](#format-board-line)

- A função _[format-board-line](#format-board-line)_ 

```lisp
(defun format-board-line (board &optional (stream t))
  (cond
   ((null (first board)) "")
   (t (format stream "~a~%" (first board)))
   )
)
```

#### [Format-board](#format-board)

- A função _[format-board](#format-board)_ 

```lisp 
(defun format-board (board &optional (stream t))
  (cond
   ((null board) "")
   (t (format stream "~&" (append(format-board-line board stream) (format-board (cdr board) stream))))
   )
)  
```

