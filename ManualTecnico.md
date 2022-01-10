# Manual Técnico - Blokus Uno

## Inteligência Artificial - Projeto 1

Grupo:

- André Serrado 201900318

- Gabriel Pais 201900301

Docente:

- Filipe Mariano

Este manual técnico contém a documentação da implementação do projeto, Blokus Uno. Este projeto teve como principal objetivo, a procura de soluções nos tabuleiros, recorrendo à utilização de algoritmos de procura. Este projeto foi também desenvolvido, exclusivamente com a linguagem Lisp.

Para uma melhor organização do projeto, este foi divido em três ficheiros.

- puzzle.lisp
- procura.lisp
- projeto.lisp

---

## Índice

- [Puzzle](#puzzle)
  - [Problemas](#problemas)
  - [Componentes do tabuleiro](#componentes-do-tabuleiro)
  - [Funções secundárias](#funcoes-secundarias)
  - [Operações com Peças](#operacoes-com-pecas)
  - [Verificações do tabuleiro](#verificacoes-do-tabuleiro)
- [Procura](#procura)
  - [Tipos de Dados Abstratos](#tipos-de-dados-abstratos)
  - [Algoritmos](#algoritmos)
  - [Auxiliares](#auxiliares)
  - [Performance Stats](#performance-stats)
- [Projeto](#projeto)
- [Estatisticas](#estatisticas)

---

## **[Puzzle](#puzzle)**

Este ficheiro contém o código relacionado com todo o problema, sendo assim responsável, por todos os tabuleiros, todas as verificações de restrições de inserção de peças no tabuleiro, inserção das mesmas, verificação das possíveis posições e contagem das peças.

Para uma melhor organização interna, o ficheiro foi dividido pelas seguintes secções, tabuleiros, funções secundárias, peças e operadores.

### **[Problemas](#problemas)**

Para a representação dos tabuleiros dos problemas, foram implementadas funções que retornam uma lista, contendo um conjunto de sublistas. As sublistas representam as várias linhas dos tabuleiros e cada átomo das mesmas, representam o valor da posição das colunas. Para representação do conteúdo do tabuleiro, as posições sem peças estão representadas pelo valor 0, com peças pelo valor 1 e as posições pré preenchidas pelo valor 2. Estes tabuleiros são replicas dos tabuleiros do ficheiros problemas.dat e visam facilitar a testagem das restantes funções implementadas.

De seguida, temos as funções que retornam os vários tabuleiros utilizados.

```lisp
;; problem A
;; objective 8 filled elements/cells
(defun board-a()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 2 2 2 2 2 2 2 2 2 2) ;1
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2) ;2
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2) ;3
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2) ;4
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;5
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;6
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;7
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;8
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;9
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;10
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;11
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;12
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;13
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2));14
)
```

```lisp
;; problem b
;; objective 20 filled elements/cells
(defun board-b()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;1
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;2
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;3
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;4
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;5
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;6
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2) ;7
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;8
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;9
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;10
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;11
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;12
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;13
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2));14
)
```

```lisp
;; problem c
;; objective 28 filled elements/cells
(defun board-c()
    ;A B C D E F G H I J K L M N
  '((0 0 2 0 0 0 0 0 0 2 2 2 2 2) ;1
    (0 0 0 2 0 0 0 0 0 2 2 2 2 2) ;2
    (0 0 0 0 2 0 0 0 0 2 2 2 2 2) ;3
    (0 0 0 0 0 2 0 0 0 2 2 2 2 2) ;4
    (0 0 0 0 0 0 2 0 0 2 2 2 2 2) ;5
    (0 0 0 0 0 0 0 2 0 2 2 2 2 2) ;6
    (0 0 0 0 0 0 0 0 2 2 2 2 2 2) ;7
    (0 0 0 0 0 0 0 0 0 2 2 2 2 2) ;8
    (0 0 0 0 0 0 0 0 0 2 2 2 2 2) ;9
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;10
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;11
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;12
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;13
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2));14
)
```

```lisp
;; problem d
;; objective 36 filled elements/cells
(defun board-d()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;1
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;2
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;3
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;4
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;5
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;6
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;7
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;8
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;9
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;10
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;11
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;12
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2) ;13
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2));14
)
```

```lisp
;; problem e
;; objective 44 filled elements/cells
(defun board-e()
    ;A B C D E F G H I J K L M N
  '((0 2 2 2 2 2 2 2 2 2 2 2 2 2) ;1
    (2 0 2 0 0 0 0 0 0 2 0 0 0 2) ;2
    (2 0 0 2 0 0 0 0 0 0 2 0 0 2) ;3
    (2 0 0 0 2 0 0 0 0 0 0 2 0 2) ;4
    (2 0 0 0 0 2 0 0 0 0 0 0 2 2) ;5
    (2 0 0 0 0 0 2 0 0 0 0 0 0 2) ;6
    (2 0 0 0 0 0 0 2 0 0 0 0 0 2) ;7
    (2 0 0 0 0 0 0 0 2 0 0 0 0 2) ;8
    (2 0 0 0 0 0 0 0 0 2 0 0 0 2) ;9
    (2 0 2 0 0 0 0 0 0 0 2 0 0 2) ;10
    (2 2 0 0 0 0 0 0 0 0 0 2 0 2) ;11
    (2 0 0 0 2 0 0 0 0 0 0 0 2 2) ;12
    (2 0 0 0 0 2 0 0 0 0 0 0 0 2) ;13
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2));14
)
```

```lisp
;; problem f
;; objective 72 filled elements/cells
(defun empty-board (&optional (dimension 14))
    (make-list dimension :initial-element (make-list dimension :initial-element '0))
)
```

### **[Componentes do tabuleiro](#componentes)**

#### [Row](#row)

- A função _[row](#row)_ recebe por parâmetro um índice em conjunto com o respetivo tabuleiro e retorna a linha correspondente.

```lisp
(defun row(index board)
  "Index must be a number between 0 and the board dimension"
  (nth index board)
)
```

#### [Column](#column)

- A função _[column](#column)_ recebe por parâmetro um índice em conjunto com o respetivo tabuleiro e retorna a coluna correspondente.

```lisp
(defun column(index board)
  "Index must be a number between 0 and the board dimension"
  (mapcar (lambda (x) (nth index x))  board)
)
```

#### [Element](#element)

- A função _[element](#element)_ recebe por parâmetro a linha, a coluna e um tabuleiro, e retorna o elemento que está nessa mesma posição.

```lisp
(defun element(r col board)
    "r and col must be numbers between 0 and the board dimension"
  (nth col (row r board))
)
```

### **[Funções secundárias](#secundary)**

As funções secundárias, são responsáveis por verificações nos elementos dos tabuleiros.

#### [Empty-elemp](#empty-elemp)

- A função _[empty-elemp](#empty-elemp)_, recebe por parâmetro, a linha , a coluna, o tabuleiro e, opcionalmente, um valor inteiro a verficar. Retorna _true_ se um elemento for igual ao _val_ (por definição 0 - elemento vazio) e _nil_ caso contrário. Utiliza a função _[element](#element)_ para verificar a casa do tabuleiro.

```lisp
(defun empty-elemp(row col board &optional (val 0))
  "row and col must be numbers between 0 and the board dimension"
  (cond
  ((or (< row 0) (> row (1- (length board))) (< col 0) (> col (1-(length board)))) nil)
  ((= (element row col board) val) t)
  (t nil)
  )
)
```

#### [Check-empty-elems](#check-empty-elems)

- A função _[check-empty-elems](#check-empty-elems)_, verifica índices. Recebe por parâmetro, o tabuleiro, uma lista de índices e opcionalmente um valor inteiro. Retorna uma lista com _true_ ou _nil,_ dependendo se os **índices** estão **iguais** ao valor passado no **val** ou não. Utiliza a função _[empty-elemp](#empty-elemp)_ para verificar cada elemento.

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
    "Col (column) must be a number between 0 and the row length"
    (cond
     ((null row) nil)
     ((= col 0) (cons val (replace-pos (1- col) (cdr row) val)))
     (t (cons (car row) (replace-pos (1- col) (cdr row) val)))
    )
)
```

#### [Replace-](#replace-)

- A função _[replace-](#replace-)_, substitui um elemento no tabuleiro. Esta recebe por parâmetro, a linha, a coluna, o tabuleiro e opcionalmente um valor inteiro. Retorna o tabuleiro com o elemento substituído, pelo valor passado por parâmetro, ou por "**1**" caso não tenha sido passado nenhum valor. Utiliza a função _[replace-pos](#replace-pos)_ para substituir o valor no elemento pretendido.

```lisp
(defun replace- (row col board &optional (val 1))
  "[Row] and [column] must be a number between 0 and the board's length"
  (cond
   ((null board) nil)
   ((= row 0) (cons (replace-pos col (car board) val) (replace- (1- row) col (cdr board) val)))
   (t (cons (car board) (replace- (1- row) col (cdr board) val)))
  )
)
```

#### [Replace_multi_pos](#replace-multi-pos)

- A função _[replace-multi-pos](#replace-multi-pos)_, substitui várias posições no tabuleiro. Esta recebe por parâmetro uma lista com todas as posições a substituir, o tabuleiro e opcionalmente um valor inteiro, retorna o tabuleiro com todos os elementos substituídos pelo valor **"1",** ou pelo valor passado por parâmetro. Utiliza a função _[replace-](#replace-)_ para substituir cada elemento.

```lisp
(defun replace-multi-pos (pos-list board &optional (val 1))
    (cond
      ((null pos-list) board)
      (t (replace-multi-pos (cdr pos-list) (replace- (first (car pos-list)) (second (car pos-list)) board val)))
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
(defun check-adjacent-elems (row col board piece)
  (cond
   ((eval (cons 'or (check-empty-elems board (piece-adjacent-elems row col piece) 1))) nil)
   (t t)
   )
)
```

#### [Piece-adjacent-elems](#piece-adjacent-elems)

- A função _[piece-adjacent-elems](#piece-adjacent-elems)_ cria uma lista para cada peça, das casas adjacentes. Esta recebe por parâmetro, a linha, a coluna e uma peça. Retorna uma lista, referente à peça passado por parâmetro com todas os elementos adjacentes.

```lisp
(defun piece-adjacent-elems (row col piece)
  (cond
   ((equal piece 'piece-a) (list (list row (1+ col)) (list row (1- col)) (list (1+ row) col) (list (1- row) col)))
   ((equal piece 'piece-b) (list (list row (1- col)) (list (1+ row) (1- col)) (list (1- row) col) (list (1- row) (1+ col)) (list (+ row 2) col) (list (+ row 2) (1+ col)) (list row (+ col 2)) (list (1+ row) (+ col 2))))
   ((equal piece 'piece-c-1) (list (list (1- row) col) (list row (1- col)) (list (1+ row) col) (list (1+ row) (1+ col)) (list row (+ col 2)) (list (1- row) (+ col 3)) (list (1- row) (+ col 2)) (list (1- row) (1+ col))))
   ((equal piece 'piece-c-2) (list (list (1- row) col) (list row (1- col)) (list row (1+ col)) (list (1+ row) (1- col)) (list (1+ row) (+ col 2)) (list (+ row 2) col) (list (+ row 2) (+ col 2)) (list (+ row 3) (1+ col))))
   (t nil)
   )
)
```

#### [Check-first-cell](#check_first-cell)

- A função _[check-first-cell](#check-first-cell)_, verifica se a primeira célula/elemento está vazio. Esta recebe por parâmetro, a linha, a coluna e o tabulerio, se estiver vazia retorna _nil,_ caso contrário retorna _true_. Utiliza a função _[element](#element)_ para verificar o elemento/posição (0 0) do tabuleiro.

```lisp
(defun check-first-cell (row col board)
  (cond
   ((= (element 0 0 board) row col 0) t)
   (t nil)
   )
)
```

#### [Force-move](#force-move)

- A função _[force-move](#force-move)_, filtra as possíveis jogadas, se o primeiro elemento do canto superior esquerdo estiver vazio, só permite peças nesse elemento, caso não esteja vazio, só permite movimentos que colocam peças em contacto com outras (apenas nos cantos). Esta recebe por parâmetro, a linha, a coluna, o tabuleiro e a peça, retorna _true_ se o movimento for permitido e _nil_ caso contrário.

```lisp
(defun force-move (row col board piece)
  (cond
    ((and (= (element 0 0 board) 0) (or (/= row 0) (/= col 0))) nil)
    ((= (element 0 0 board) row col 0) t)
    ((eval (cons 'or (check-empty-elems board (piece-corners-elems row col piece) 1))) t)
    (t nil)
  )
)
```

#### [Piece-corners-elems](#piece-corners-elems)

- A função _[piece-corners-elems](#piece-corners-elems)_, cria uma lista para cada peça, das casas referentes aos cantos exteriores. Esta recebe por parâmetro, a linha, a coluna e uma peça. Retorna uma lista, referente à peça passado por parâmetro com todas os elementos que dizem respeito aos cantos exteriores da mesma.

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

#### [Can-placep](#can-placep)

- A função _[can-placep](#can-placep)_, reúne as funções de verificações. Esta recebe por parâmetro uma lista com os elementos a ocupar pela peça, o tabuleiro, a linha, a coluna e a peça, retorna _true_ caso seja possível inserir a peça e _nil_ caso contrário. Utiliza as funções _[pieces-left-numb](#pieces-left-numb)_, _[force-move](#force-move)_, _[check-adjacent-elems](#check-adjacent-elems)_, _[check-empty-elems](#check-empty-elems)_ e _[piece-taken-elems](#piece-taken-elems)_ para fazer todas a verificações necessárias.

```lisp
(defun can-placep (pieces-list board row col piece)
  (cond
    ((= 0 (pieces-left-numb pieces-list piece)) nil)
    ((or (> row (length board)) (< row 0) (< col 0) (> col (length board))) nil)
    ((not (force-move row col board piece)) nil)
    ((not (check-adjacent-elems row col board piece)) nil)
    ((eval (cons 'and (check-empty-elems board (piece-taken-elems row col piece))))t)
    (t nil)
  )
)
```

#### [Check-all-board](#check-all-board)

- A função _[check-all-board](#check-all-board)_, retorna uma lista com todos os índices no tabuleiro, até ao índice passado por parâmetro inclusive. Esta recebe por parâmetro o tabuleiro, a linha e a coluna.

```lisp
(defun check-all-board(board row col)
  (cond
    ((< row 0) nil)
    ((< col 0) (check-all-board board (1- row) (1- (length board))))
    (t (cons (list row col) (check-all-board board row (1- col))))
  )
)
```

### **[Operações com Peças](#pecas)**

Esta secção contém as funções referentes à inserção das peças, número de peças a inserir, atualização do número de peças a inserir e verificação de todas as possíveis inserções de peças no tabuleiro.

#### [Insert-piece](#insert-piece)

- A função _[insert-piece](#insert-piece)_, insere peças no tabuleiro. Esta recebe por parâmetro uma lista com os elementos a ocupar, a linha, a coluna, o tabuleiro e uma peça. Com recurso à função _[can-placep](#can-placep)_, retorna o tabulerio caso seja possível inserir a peça no mesmo, ou _nil_ caso contrário. Utiliza ainda as funções _[replace-multi-pos](#replace-multi-pos)_ e _[piece-taken-elems](#piece-taken-elems)_ para inserir a as peças com a suas formas corretas, respetivamente.

```lisp
(defun insert-piece (pieces-list row col board piece)
  (cond
    ((null (can-placep pieces-list board row col piece)) nil)
    (t (replace-multi-pos (piece-taken-elems row col piece) board)))
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

#### [All-spaces](#all-spaces)

- A função _[all-spaces](#all-spaces)_, verifica onde a peça pode ser colocada no tabuleiro a partir de uma lista de índices. Esta recebe por parâmetro uma lista com todas as peças, uma peça, um tabuleiro e uma lista de índices. Retorna uma lista com todos os movimentos possíveis com base em todos os índices fornecidos.

```lisp
(defun all-spaces(pieces-list piece board indexes-list)
  (remove-nil(mapcar (lambda (index) (cond ((can-placep pieces-list board (first index) (second index) piece) index) (t nil))) indexes-list))
)
```

#### [Possible-moves](#possible-moves)

- A função [_possible-moves_](#possible-moves), verifica todas as posições do tabuleiro, que a peça pode ser colocada. Esta recebe por parâmetro uma lista com todas as peças, uma peça e um tabuleiro. Retorna uma lista com índices para todos os movimentos possíveis com uma peça, ordenado por ordem crescente. Utiliza as funções _[all-spaces](#all-spaces)_ e _[check-all-board](#check-all-board)_ para retornar a lista com as pecas .

```lisp
(defun possible-moves(pieces-list piece board)
  (reverse (all-spaces pieces-list piece board (check-all-board board (1- (length board)) (1- (length (car board))))))
)
```

### **[Operadores](#operadores)**

Nesta secção definimos as funções referentes à quantidade de peças iniciais, lista de todas as operações e a inserção das peças no tabueleiro.

#### [Init-pieces](#init_pieces)

- A função [_init-pieces_](#init_pieces), cria uma lista com o número total de peças, por cada tipo de peças.

```lisp
(defun init-pieces()
  (list 10 10 15)
)
```

#### [Operations](#operations)

- A função _[operations](#operations)_ retorna uma lista com todas as operações.

```lisp
(defun operations()
  (list 'piece-a 'piece-b 'piece-c-1 'piece-c-2)
)
```

- As seguintes funções retornam o tabuleiro com as peças colocadas ou _nil_ caso contrário.

#### [Piece-a](#piece-a)

```lisp
(defun piece-a (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-a)
)
```

#### [Piece-b](#piece-b)

```lisp
(defun piece-b (pieces-list index board)
   (insert-piece pieces-list (first index) (second index) board 'piece-b)
)
```

#### [Piece-c-1](#piece-c1)

```lisp
(defun piece-c-1 (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-1)
)
```

#### [Piece-c-2](#piece-c2)

```lisp
(defun piece-c-2 (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-2)
)
```

---

## **[Procura](#procura)**

### **[Tipos de Dados Abstratos](#tipos-de-dados-abstratos)**

Os tipos abstratos de dados são criados e utilizados para guardar as informações necessárias de modo a facilitar o desenvolvimento de uma solução independentemente do problema enfrentado. Assim sendo, estes dados abstratos podem ser utilizados para tentar resolver qualquer problema com os algoritmos disponíveis.

#### [Make-node](#make-node)

- A função _[make-node](#make-node)_ contrói um nó. Recebe como parametros um tabuleiro (_state_), uma referencia para o nó pai (_parent_) caso exista, a profundidade do nó a criar (_g_), o valor da heuristica (_h_), caso o algoritmo seja de procura informada, e uma lista com o número restante de peças(_pieces_).

```lisp
(defun make-node(state &optional (parent nil) (g 0) (h 0) (pieces '(10 10 15)))
  (list state parent g h pieces)
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

#### [Node-depth](#node-depth)

- A função _[node-depth](#node-depth)_ retorna a profundidade do nó.

```lisp
(defun node-depth(node)
  (third node)
)
```

#### [Node-h](#node-h)

- A função _[node-h](#node-h)_ retorna o valor heuristico do nó. Este valor será sempre constante (0 zero) caso o algoritmo utilizado não seja de procura informada. Caso contrário o valor da _**h**_ variará consoante a heuristica utilizada.

```lisp
(defun node-h(node)
  (fourth node)
)
```

#### [Node-f](#node-f)

- A função _[node-f](#node-f)_ retorna o valor de f, que representa o custo de um nó. Esta função é apenas utilizada para os algoritmos de procura informada (_[a\*](#a)_, IDA\*, RBFS e SMA\*).

```lisp
(defun node-f (node)
  (+ (node-depth node) (node-h node))
)

```

#### [Node-pieces-left](#node-pieces-left)

- A função _[node-pieces-left](#node-pieces-left)_ retorna uma lista com o número de peças que ainda se pode pôr, por tipo. Inicialmente a lista deverá ser sempre iniciada com valores predefinidos, (**10** **10** **15**) **peça-a**, **peça-b** e **peça-c**, respetivamente.

```lisp
(defun node-pieces-left(node)
  (nth (1- (length node)) node)
)
```

### **[Algoritmos](#algoritmos)**

Os algoritmos são funções que executam um conjunto de operações com o objetivo de chegar a um estado final (pré-definido). Estes algoritmos exploram um espaço de possibilidades tentanto vários caminhos possíveis. Este processo consiste num espaço de estados.

#### [BFS](#bfs)

- _[BFS](#bfs)_ significa _Breadth-First Search_, ou seja, métodos de procura - **largura primeiro**.Este algoritmo é de procura não informado e, assim sendo, e tal como o nome indica o algoritmo prioriza a procura de estados em largura.
- Para que o algoritmo tente resolver o problema é necessário introduzir uma série de dados pré-definidos, tais como:
  - O estado final, **_solution_**. No caso do **_Blokus_** o número de casas que devem ser preenchidas).
  - A lista de operadores, _[operations](#operations)_.
  - A lista de nós abertos, **_open_**, que inicialmente terá apenas o tabuleiro do problema selecionado (_[problemas](#problemas)_).
- Como dados opcionais temos a lista de fechados (por definição _nil_), o número de nós gerados e expandidos (ambos, por motivos lógicos, 0 por definição), _nodes-number_ e _expanded-nodes_, respetivamente.

```lisp
(defun bfs (solution operations open  &optional (closed nil) (nodes-number 0) (expanded-nodes 0))
  "solution must be a number,
   operations must be a list(must use operations function)"

  (cond
    ((null open) nil)
    (t (let* (
              (current-node (car open))
              (closed1 (cons current-node closed))
              (all-children (expand-node current-node 'possible-moves operations 'bfs))
              (nodes-counter (+ (length all-children) nodes-number))
              (filtered-children (remove-duplicated all-children 'duplicatedp open closed1))
              (open1 (append (cdr open) filtered-children))
              (first-solution (get-solution filtered-children solution))
             )
         (cond
          ((null first-solution) (bfs solution operations open1 closed1 nodes-counter (1+ expanded-nodes)))
          (t (list first-solution nodes-counter (1+ expanded-nodes)))
         )
      )
    )
  )
)
```

#### [DFS](#dfs)

- _[DFS](#dfs)_ significa _Depth-First Search_, ou seja, métodos de procura - **profundidade primeiro**. Este algoritmo é de procura não informado e tal como o nome indica, o algoritmo prioriza a procura de estados próximos em profundidade.
- Para que o algoritmo tente resolver o problema é necessário introduzir uma série de dados pré-definidos, tais como:
  - O estado final, **_solution_**. No caso do **_Blokus_** o número de casas que devem ser preenchidas).
  - A lista de operadores, _[operations](#operations)_.
  - A lista de nós abertos, **_open_**, que inicialmente terá apenas o tabuleiro do problema selecionado (_[problemas](#problemas)_).
  - A profundidade máxima, **_max-g_**, à qual o algoritmo irá procurar estados solução.
- Como dados opcionais temos a lista de fechados, **_closed_**, (por definição _nil_), o número de nós gerados e expandidos (ambos, por motivos lógicos, 0 por definição), **_nodes-number_** e **_expanded-nodes_**, respetivamente.

```lisp
(defun dfs (solution operations open max-g  &optional (closed nil) (nodes-number 0) (expanded-nodes 0))
  (cond
    ((null open) nil)
    (t (let* (
              (current-node (car open))
              (all-children (expand-node current-node 'possible-moves operations 'dfs max-g))
              (nodes-counter (+(length all-children) nodes-number))
              (filtered-children (remove-duplicated-dfs all-children (cdr open) (cons current-node closed)))
              (closed1 (remove-closed-duplicated filtered-children (cdr open) (cons current-node closed)))
              (open1 (append filtered-children (cdr open)))
              (first-solution (get-solution filtered-children solution))
            )
        (cond
          ((null first-solution) (dfs solution operations open1 max-g closed1 nodes-counter (1+ expanded-nodes)))
          (t (list first-solution nodes-counter (1+ expanded-nodes)))
        )
      )
    )
  )
)
```

#### [A\*](#a)

- _[A\*](#a)_ é um método de procura informado e, como tal, o método prioriza a procura de estados com menor custo, _[node-f](#node-f)_, que por sua vez depende da heuristica utilizada _[hts](#hts)_ e da profundidade do nó _[node-depth](#node-depth)_.
- Para que o algoritmo tente resolver o problema é necessário introduzir uma série de dados pré-definidos, tais como:
  - O estado final, **_solution_**. No caso do **_Blokus_** o número de casas que devem ser preenchidas).
  - A lista de operadores, _[operations](#operations)_.
  - A lista de nós abertos, **_open_**, que inicialmente terá apenas o tabuleiro do problema selecionado (_[problemas](#problemas)_).
  - Heuristica, **_heuristic_**, que representa a heuristica escolhida para a seleção de estados.
- Como dados opcionais temos a lista de fechados, **_closed_**, (por definição _nil_), o número de nós gerados e expandidos (ambos, por motivos lógicos, 0 por definição), **_nodes-number_** e **_expanded-nodes_**, respetivamente.

```lisp
(defun a* (solution operations open heuristic &optional (closed nil) (nodes-number 0) (expanded-nodes 0))
  "
  [solution] must be a number,
  [operations] must be a list with all operations available
  [open] must be an list with nodes
  "
  (cond
    ((null open) nil)
    (t (let* (
               (current-node (get-lowest-node (car open) open))
               (closed1 (cons current-node closed))
               (all-children (expand-node current-node 'possible-moves operations 'a 0 heuristic solution))
               (nodes-counter (+ (length all-children) nodes-number))
               (filtered-children (to-insert-in-open (remove-duplicated all-children 'duplicatedp-a* open closed1) (cdr open)))
               (open1 (append (check-duplicated filtered-children (cdr open)) filtered-children))
               (sol (get-solution (list current-node) solution))
             )
          (cond
            ((null sol) (a* solution operations open1 heuristic closed1 nodes-counter (1+ expanded-nodes)))
            (t (list sol nodes-counter (1+ expanded-nodes)))
          )
        )
    )
  )
)
```

### **[Auxiliares](#auxiliares)**

As funções auxiliares são utilizadas como suporte aos dados abstratos, aos algoritmos implementados ou até como suplemento a outras funções secundárias.

#### [Get-child](#get-child)

- A função _[get-child](#get-child)_ utiliza uma peça e aplica uma operação com um dos movimentos possíveis.
- Cria um nó filho e retorna-o.
- Utiliza como funções auxiliares _[make-node](#make-node)_, _[remove-used-piece](#remove-used-piece)_ e _[node-pieces-left](#node-pieces-left)_

```lisp
(defun get-child(node possible-move operation &optional (h 'h0) (solution 0) &aux (pieces-left (node-pieces-left node)) (state (node-state node)))
    "Operation must be a function"
    (let ((move (funcall operation pieces-left possible-move state)))
      (cond
        ((null move) nil)
        (t (make-node move node (1+ (node-depth node)) (hts solution move h) (remove-used-piece (node-pieces-left node) operation)))
      )
    )
)
```

#### [Get-children](#get-children)

- A função _[get-children](#get-children)_ cria todos os sucessores possíveis a partir de um estado e um tipo de peça.
- Utiliza como função auxiliar _[get-child](#get-child)_ para criar os vários sucessores para as várias jogadas possíveis.
- Retorna uma lista com todos os sucessores de um nó aplicados a uma operação/peça.

```lisp
(defun get-children(node possible-moves operation &optional (h 'h0) (solution 0))
  (cond
    ((null possible-moves) nil)
    (t (cons (get-child node (car possible-moves) operation h solution) (get-children node (cdr possible-moves) operation h solution)))
  )
)
```

#### [Expand-node](#expand-node)

- A função _[expand-node](#expand-node)_ cria todos os sucessores possíveis de um nó, ou seja, cria os filhos do nó _**node**_, para todas as jogadas possíveis e todas as operações/peças.
- Retorna uma lista com todos os sucessores.
- Utiliza como funções auxiliares _[remove-nil](#remove-nil)_, _[possible-moves](#possible-moves)_ e _[get-children](#get-children)_.

```lisp
(defun expand-node(node possible-moves operations alg &optional (g 0) (h 'h0) (solution 0))
  "
  [possible-moves] must be a function that returns a list with indexes and the operations,
  [operations] must be a list with all available operations
  "
  (cond
    ((null operations) nil)
    ((and (equal alg 'dfs) (< g (1+ (node-depth node)))) nil)
    (t (remove-nil (append (get-children node (funcall possible-moves (node-pieces-left node) (car operations) (node-state node)) (car operations) h solution)
                      (expand-node node possible-moves (cdr operations) alg g h solution)
                   )
       )
    )
  )
)
```

#### [Exist-nodep](#exist-nodep)

- Verifica se o nó, _**node**_, está presente numa lista, _**node-list**_.
- Utiliza como função auxiliar [node-state](#node-state)

```lisp
(defun exist-nodep(node node-list)
  (cond
   ((null node-list)nil)
   (t (eval (cons 'or (mapcar (lambda (x) (cond ((equal (node-state node) (node-state x)) t) (t nil))) node-list))))
   )
)
```

#### [Count-row-elems](#count-row-elems)

- Conta e retorna o número de casas/elementos de uma linha cujo o numero é igual ao _val_.

```lisp
(defun count-row-elems (row &optional (val 1))
  (cond
    ((null row) 0)
    ((= (car row) val) (1+ (count-row-elems (cdr row) val)))
    (t (count-row-elems (cdr row) val))
    )
)
```

#### [Count-board-elems](#count-board-elems)

- Conta o número de casas/elementos de cada linha do tabuleiro (_**board**_) cujo o número é igual ao _**val**_.
- Retorna uma **lista**, em que cada elemento desta, é o número de casas igual a _**val**_ numa linha.
- Utiliza como função auxiliar [count-row-elems](#count-row-elems).

```lisp
(defun count-board-elems (board &optional (val 1))
  (cond
    ((null board) nil)
    (t (cons (count-row-elems (car board) val) (count-board-elems (cdr board) val)))
  )
)
```

#### [Count-all-elems](#count-all-elems)

- Conta e retorna o número total de casas/elementos de um tabuleiro preenchidas/dos com _**val**_.
- Utiliza como função auxiliar [count-board-elems](#count-board-elems).

```lisp
(defun count-all-elems (board &optional (val 1))
    (cond
      ((null board) nil)
      (t (apply '+ (count-board-elems board val)))
    )
)
```

#### [Solutionp](#solutionp)

- Verifica se um nó (_**node**_) é solução para o problema.

```lisp
(defun solutionp (node solution &optional (val 1))
  "solution must be and number"
  (cond
    ((null node) nil)
    ((>= (count-all-elems (node-state node) val) solution) t)
    (t nil)
  )
)
```

#### [Get-solution](#get-solution)

- Retorna um nó que será possível solução para o problema
- Caso não encontre solução devolve nil

```lisp
(defun get-solution (node-list solution &optional (val 1))
  "solution must be a number"
  (cond
    ((null node-list) nil)
    ((solutionp (car node-list) solution val) (car node-list))
    ;(t (remove-nil(cons (solutionp (car node-list) solution val) (get-solution (cdr node-list) solution val))))
    (t (get-solution (cdr node-list) solution val))
  )
)
```

#### [Remove-duplicated](#remove-duplicated)

- Verifica se a (_**node-list**_) possui nós com o mesmo estado que os nós presentes em abertos (_**open**_) ou fechados (_**closed**_)
- Retorna a lista de nós (_**node-list**_) sem os repetidos

```lisp
(defun remove-duplicated(node-list duplicated-fun &optional (open nil) closed )
        (cond
         ((null node-list) nil)
         ((funcall duplicated-fun (car node-list) open closed) (remove-duplicated (cdr node-list) duplicated-fun open closed))
         (t (cons (car node-list) (remove-duplicated (cdr node-list) duplicated-fun open closed)))
        )
)
```

#### [Duplicatedp](#duplicatedp)

- Verifica se um nó está presente em alguma das duas listas inseridas por parâmetros (_**open**_ ou _**closed**_).
- Devolve _t_ se o nó _**node**_ está duplicado e _nil_ em caso contrário.

```lisp
(defun duplicatedp (node open &optional closed)
  (cond
    ((or (null node) (null open)) nil)
    ((or (exist-nodep node open) (exist-nodep node closed)) t)
    (t nil)
  )
)
```

#### [Get-duplicated](#get-duplicated)

- Verifica se o nó está duplicado e devolve-o caso, realmente, esteja.

```lisp
(defun get-duplicated (node node-list)
  (cond
    ((null node-list) nil)
    ((equal (node-state node) (node-state (car node-list))) (car node-list))
    (t (get-duplicated node (cdr node-list)))
    )
)
```

#### [Duplicated-dfs](#duplicated-dfs)

- Checks if a node is duplicated in two list(open and closed)
- Verifica se um nó está duplicado em duas listas, abertos (_**open**_) ou fechados (_**closed**_).
- Devolve:
  - 0, se o nó não está duplicado e deve ser adicionado em abertos
  - 1 se o nó deve ser abandonado
  - nó-duplicado (_**duplicated-node**_) se deve remover o nó duplicado em fechados e adicionar o sucessor duplicado em abertos

```lisp
(defun duplicated-dfs (node open closed)
    (let ((duplicated-node (get-duplicated node closed)))
    (cond
      ((exist-nodep node open) 1)
      ((null duplicated-node) 0)
      ((< (node-depth node) (node-depth duplicated-node)) duplicated-node)
      (t 1)
     )
  )
)
```

#### [Remove-duplicated-dfs](#remove-duplicated-dfs)

- Devolve uma lista sem nós duplicados
- Utiliza a função _[duplicated-dfs](#duplicated-dfs)_ como auxiliar, de modo a saber que nós devem ser removidos ou adicionados nas respetivas listas

```lisp
(defun remove-duplicated-dfs(node-list open closed)
  (let ((duplicated-val (duplicated-dfs (car node-list) open closed)))
    (cond
      ((null node-list) nil)
      ((= 0 duplicated-val) (cons (car node-list) (remove-duplicated-dfs (cdr node-list) open closed)))
      (t (remove-duplicated-dfs (cdr node-list) open closed))
    )
  )
)
```

#### [remove-closed-duplicated](#remove-closed-duplicated)

- Remove os nós duplicados em fechados que têm um custo menor que os sucessores com o mesmo estado.
- Utilizado no método de procura _[dfs](#dfs)_ para remover da lista de fechados.
- Delvolve a lista dos fechados atualizada.

```lisp
(defun remove-closed-duplicated (node-list open closed)
  (let ((duplicated-val (duplicated-dfs (car node-list) open closed)))
    (cond
      ((null node-list) closed)
      ((numberp duplicated-val) (remove-closed-duplicated (cdr node-list) open closed))
      (t (remove-closed-duplicated (cdr node-list) open (remove duplicated-val closed)))
    )
  )
)
```

#### [Hts](#hts)

- A função _[hts](#hts)_ verifica que heuristica deve ser utilizada nos métodos de procura.
  - Caso o método de procura seja não informado retorna apenas 0
  - Caso seja ordenado depende da heuristica escolhida
- Retorna o valor da heuristica de um estado. Utiliza as funções _[h1](#h1)_ e _[h2](#h2)_ para calcular as heuristicas.

```lisp
(defun hts (solution state h-type child-pieces-list)
  (cond
      ((equal h-type 'h0) 0)
      ((equal h-type 'h2) (h2 solution child-pieces-list))
      (t (h1 solution state))
  )
)
```

#### [H1](#h1)

- A função _[h1](#h1)_ calcula a heuristica de um nó pela diferença do valor da solução _**solution**_ pelo número total de casas preenchidas. É utilizada como função auxiliar a função _[count-all-elems](#count-all-elems)_ para calcular o número de casas preenchidas.

```lisp
(defun h1 (solution state)
  (- solution (count-all-elems state))
)
```

#### [H2](#h2)

- A função [h2](#h2) calcula a heuristica de um nó através da diferença entre as peças necessárias para atingir o valor da solução pretendida e a diferença entre o número total das maiores peças (b e c's) e o número de utilizadas da mesma.

```lisp
(defun h2 (solution child-pieces-list)
  (let ((to-place (/ solution 4)))                                                  ; solution/4 -> places needed to place to get the objective
    (- to-place (- 10 (second child-pieces-list)) (- 15 (third child-pieces-list))) ; 10, 15 -> number of the best pieces when the game starts
  )
)
```

#### [Duplicated-a\*](#duplicated-a*)

- Utilizada especificamente para o metodo de procura informada implementado [a\*](#a).
- Substitui a função [exist-nodep](#exist-nodep) pois esta não pode ser utilizada em [remove-duplicated](#remove-duplicated) (utilizada dentro de a\*).

```lisp
(defun duplicatedp-a*(node &optional open closed)
  (cond
    ((exist-nodep node closed) t)
    (t nil)
  )
)
```

#### [To-insert-in-open](#to-insert-in-open)

- Insere nós expandidos não repetidos ou com f (_[node-f](#node-f)_), < que f do nó repetido em abertos.

```lisp
(defun to-insert-in-open (expanded-nodes open)
  (let* (
        (current (car expanded-nodes))
        (duplicated-open (get-duplicated current open))
       )
    (cond
      ((null expanded-nodes) nil)
      ((null duplicated-open) (cons current (to-insert-in-open (cdr expanded-nodes) open)))
      ((<= (node-f current) (node-f duplicated-open))  (cons current (to-insert-in-open (cdr expanded-nodes) open)))
      (t (to-insert-in-open (cdr expanded-nodes) open))
    )
  )
)
```

#### [Get-lowest-node](#get-lowest-node)

- Utilizada no método de procura informada [a\*](#a).
- Devolve o no com menor custo.

```lisp
(defun get-lowest-node (lowest-node open)
  "[open] list of nodes"
  (let ((open-first (car open)))
    (cond
      ((null open) lowest-node)
      ((< (node-f lowest-node) (node-f open-first)) (get-lowest-node lowest-node (cdr open)))
      ((and (= (node-f lowest-node) (node-f open-first)) (>= (node-depth lowest-node) (node-depth open-first)))  (get-lowest-node lowest-node (cdr open)))
      (t (get-lowest-node (car open) (cdr open)))
    )
  )
)
```

#### [Check-duplicated](#check-duplicated)

- Verifica se existe algum nó duplicado em abertos que deve ser removido
- Utilizado no método de procura informada implementado - [a\*](#a)

```lisp
(defun check-duplicated (expanded-nodes open)
  "[open] list with nodes"
  (let* (
        (current (car expanded-nodes))
        (duplicated-open (get-duplicated current open))
       )
    (cond
      ((null expanded-nodes) open)
      ((null duplicated-open) (check-duplicated (cdr expanded-nodes) open))
      (t (check-duplicated (cdr expanded-nodes) (remove duplicated-open open)))
    )
  )
)
```

### **[Performance Stats](#performance-stats)**

#### [Solution-node](#solution-node)

- Retorna o nó solução

```lisp
(defun solution-node(solution-list)
  (first solution-list)
)
```

#### [Solution-path](#solution-path)

- Retorna o caminho, desde o tabuleiro vazio até ao nó solução.

```lisp
(defun solution-path(solution-list)
  (let ((final-node (solution-node solution-list)))
      (cond
        ((null (node-parent final-node)) nil)
        (t (cons final-node (solution-path (node-parent final-node))))
    )
  )
)
```

#### [Number-of-expanded-nodes](#number-of-expanded-nodes)

- Retorna o número de nós expandidos, a partir da solução retornada na aplicação num dos algoritmos implementados (_[bfs](#bfs)_, _[dfs](#dfs)_ ou _[a\*](#a)_).

```lisp
(defun number-of-expanded-nodes (solution-list)
  "[solution-list] list with all execution info"
  (third solution-list)
)
```

#### [Generated-nodes](#generated-nodes)

- Retorna o número de nós gerados, a partir da solução retornada na aplicação num dos algoritmos implementados (_[bfs](#bfs)_, _[dfs](#dfs)_ ou _[a\*](#a)_).

```lisp
(defun generated-nodes(solution-list)
  "[solution-list] list with all execution info"
  (second solution-list)
)
```

#### [Piercing-factor](#piercing-factor)

- Penetrância
- É o caminho até ao nó objetivo a dividir pelo numero de nós gerados

```lisp
(defun piercing-factor(solution-list)
  "[solution-list] list with all execution info"
  (/ (+ (node-depth (solution-node solution-list)) 1) (generated-nodes solution-list))
)
```

#### [Average-branching-factor](#average-branching-factor)

- Fator de ramificação médio. Aplica

```lisp
(defun average-branching-factor (solution-list maximum tolerance &optional (minimum 0))
  "
  [solution-list] list with all execution info,
  [maximum] value must be the result of \"generated-nodes\",
  [tolerance] must be a number
  "
  (let* (
          (n-nodes (generated-nodes solution-list))
          (g (node-depth (solution-node solution-list)))
          (average-min-max (/ (+ maximum minimum) 2))                       ; media como fator de ramificacao
          (average-generated-n (average-generated-nodes average-min-max g))
          (diff (- n-nodes average-generated-n))
        )
      (cond
        ((< diff tolerance) average-min-max)
        ((< average-generated-n n-nodes) (average-branching-factor solution-list maximum average-generated-n))
        (t (average-branching-factor solution-list average-generated-n minimum))
      )
  )
)
```

#### [average-generated-nodes](#averages-generated-nodes)

- Função auxiliar para a função _[average-branching-factor](#average-branching-factor)_.
- Calcula o número de nós gerados usando a média como fator de ramificação

```lisp
(defun average-generated-nodes (average g)
  "
  [average] must be a number,
  [g] must be a numebr
  "
  (cond
    ((= 1 g) 0)
    (t (+ (expt average g) (average-generated-nodes average (1- g))))
  )
)
```

---

## **[Projeto](#projeto)**

.

.

.

---

## **[Estatisticas](#estatisticas)**

| Tabuleiro |         Algoritmo          | Nós Gerados | Nós Expandidos | Penetrância | Fator de Ramificação | Duração |
| :-------: | :------------------------: | :---------: | :------------: | :---------: | :------------------: | :-----: |
|    `A`    |            BFS             |     11      |       3        |    3/11     |         11/2         |    5    |
|    `A`    |            DFS             |     11      |       8        |    3/11     |         11/2         |  27521  |
|    `A`    | A\* - Heurística Fornecida |      6      |       3        |     1/2     |          3           |  2407   |
|    `A`    |  A\* - Heurística Criada   |      6      |       3        |     1/2     |          3           |  4437   |
|    `B`    |            BFS             |    11553    |      936       |   2/3851    |       11553/2        |  2777   |
|    `B`    |            DFS             |    9468     |      5895      |   1/1578    |       41185/2        |  26882  |
|    `B`    | A\* - Heurística Fornecida |     43      |       6        |    6/43     |         43/2         |  1249   |
|    `B`    |  A\* - Heurística Criada   |     43      |       6        |    6/43     |         43/2         |  2476   |
|    `C`    |            BFS             |      -      |       -        |      -      |          -           |    -    |
|    `C`    |            DFS             |      -      |       -        |      -      |          -           |    -    |
|    `C`    | A\* - Heurística Fornecida |     75      |       8        |    8/75     |         75/2         |  1498   |
|    `C`    |  A\* - Heurística Criada   |     75      |       8        |    8/75     |         75/2         |   921   |
|    `D`    |            BFS             |      -      |       -        |      -      |          -           |    -    |
|    `D`    |            DFS             |      -      |       -        |      -      |          -           |    -    |
|    `D`    | A\* - Heurística Fornecida |     145     |       10       |    2/29     |        145/2         |  1245   |
|    `D`    |  A\* - Heurística Criada   |     145     |       10       |    2/29     |        145/2         |   961   |
|    `E`    |            BFS             |      -      |       -        |      -      |          -           |    -    |
|    `E`    |            DFS             |      -      |       -        |      -      |          -           |    -    |
|    `E`    | A\* - Heurística Fornecida |     216     |       13       |   13/216    |         108          |  1073   |
|    `E`    |  A\* - Heurística Criada   |     216     |       13       |   13/216    |         108          |  1628   |
|    `F`    |            BFS             |      -      |       -        |      -      |          -           |    -    |
|    `F`    |            DFS             |      -      |       -        |      -      |          -           |    -    |
|    `F`    | A\* - Heurística Fornecida |     327     |       19       |   19/327    |        327/2         |  1017   |
|    `F`    |  A\* - Heurística Criada   |     327     |       19       |   19/327    |        327/2         |   940   |

- **_\- significa que a memória heap do \_lispWorks_ chegou ao limite.\_**
