;;;; Puzzle.lisp
;;;; Implementação do algoritmo de jogo - AlfaBeta ou Negamax com cortes alfa-beta
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318


;;; Memoization

(let ((tab (make-hash-table)))
		(defun fib-memo (n)
			(or 
				(gethash n tab) 
				(let ((val (funcall #'FUNC n))) (setf (gethash n tab) val) val)
			)
		)
)


; ---------------------------------------- ;
;;; Abstract Data Types

;; play-info 
;;TODO test
(defun play-info(piece row col)
	(list piece '(row col))
)
;; play-nodess
;; (list jogador (list '('peca (row col)) '('peca2 (row2 col2))))
(defun player-node(&optional (player 1) (play-info nil) (pieces-list (init-pieces)))
	(list player play-info pieces-list)
)

;; make-node
;;  constructs a node with the state (board), depth and the parent node
;;  uses the function 'init-pieces' (puzzle/game dependent) to define the pieces list
;;  returns a list with all data
;;  test => (make-node (empty-board))
(defun make-node(state &optional (parent nil) (p1-node (player-node)) (p2-node (player-node -1)) (f 0))
  (list state parent f p1-node p2-node)
)

;; node-state
;; returns a node's state
;; test => (node-state (make-node (empty-board)))
(defun node-state(node)
  (first node)
)

;; node-parent 
;; returns a parent node of other node 
;; test => (node-parent (make-node (empty-board) (board-d)))
(defun node-parent(node)
  (second node)
)

(defun node-value(node)
	(third node)
)

(defun node-p1 (node)
	(fourth node)
)

(defun node-p2 (node)
	(nth (- (lenght node) 1) node)
)

(defun pieces-list(node player)
	(cond 
		((= 1 player) (third (node-p1 node)))
		(t (third (node-p2 node)))
	)
)

(defun player-moves(node player)
	(cond 
		((= 1 player) (second (node-p1 node)))
		(t (second (node-p2 node)))
	)
)

 
; ---------------------------------------- ;
;;;  Negamax com cortes alfa-beta (slightly faster)

;!=====================================================================
#| 
;;; argumentos: nó n, profundidade d, cor c
;;; b = ramificação (número de sucessores)
function negamax (n, d, α, β, c)
se d = 0 ou n é terminal
return c * valor heuristico de n
sucessores := OrderMoves(GenerateMoves(n))
bestValue := −∞
para cada sucessor nk em sucessores
bestValue := max (bestValue, −negamax (nk
, d−1, −β, − α, −c))
α := max (α, bestValue)
se α ≥ β
break
return bestValue
|#
;!=====================================================================
;;TODO
;; geral -> limite de tempo usado,
;; cada jogada -> valor, profundidade do grafo, numero de cortes na analise
;; TODO
;; Ficheiro log.dat : 
; - qual a jogada realizada
; - o valor da posicao para onde jogou
; - o numero de nos analisados
; - o numero de cortes efetuados (de cada tipo)


;; negamax
(defun negamax(node max-time 
    		&optional	
              	(player 1)
				(c 1)                             ; color
				(alpha most-negative-fixnum) 
              	(beta most-positive-fixnum) 
			  	(nodes-visited 1)
			  	(cuts-number 0)
              	(start-time (get-internal-real-time))
				(depth 49)                            ; 14x14/(4) -> numero de jogadas necessarias para encher o tabuleiro com pecas de 4 casas (melhor caso)
			  )
"
[node] 
[max-time] input - limit time for an execution
[alpha] 
[beta]
[player] 
[start-time] timestamp - Execution start timestamp
[cuts-number] performance stats - returns the number of cuts executed
[nodes-visited] performance stats - returns the number of nodes visited
"
	(let* (
			(children-nodes ())
		 )
		(cond 
		((or (> (runtime start-time) max-time) (= depth 0) (null children) solution-node) ;! Condicao de termino	
		(t
			()
		)
		)
	)
)

; ---------------------------------------- ;
;;; Aux Functions

;; get-child
;; Uses one piece and applies an operation with a possible move to create a child from a node 
;; returns a node
;; test => (get-child (make-node (empty-board)) (car (possible-moves (init-pieces) 'piece-a (empty-board))) 'piece-a)
(defun get-child(node possible-move operation &optional (h 'h0) (solution 0) &aux (pieces-left (node-pieces-left node)) (state (node-state node)))
    "Operation must be a function"
    (let (
          (move (funcall operation pieces-left possible-move state))
          (updated-pieces-list (remove-used-piece pieces-left operation))  
          )
      (cond 
        ((null move) nil)
        (t (make-node move node (1+ (node-depth node)) (hts solution move h updated-pieces-list) updated-pieces-list)) 
      )
  )
)


;; get-children 
;; Uses the get-child function to create a child for every possible move with a piece
;; Generates all children from a operation(piece)
;; returns a list of nodes 
;; test => (get-children (make-node (board-d)) (possible-moves (init-pieces) 'piece-a (board-d)) 'piece-a)
(defun get-children(node possible-moves operation &optional (h 'h0) (solution 0))
  (cond 
    ((null possible-moves) nil)
    (t (cons (get-child node (car possible-moves) operation h solution) (get-children node (cdr possible-moves) operation h solution)))
  )
)


;; expand-node
;; Uses the get-children function to generate all possibilities from each operation(piece)
;; In sum, expand a node 
;; return a list of nodes
;; test => (expand-node (make-node (empty-board)) 'possible-moves (operations) 'bfs) 
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

;;
(defun order-nodes(node-list)


)

;; exist-nodep
;; checks if the node-list contains a node with the same state as the parameter node
;; returns t if exists and nil if it doesn't 
;; test => (exist-nodep (make-node (empty-board)) (list (make-node (board-d))(make-node (empty-board))))
(defun exist-nodep(node node-list)
  (cond 
   ((null node-list)nil)
   (t (eval (cons 'or (mapcar (lambda (x) (cond ((equal (node-state node) (node-state x)) t) (t nil))) node-list))))
   )
)

; ---------------------------------------- ;
;;; Endgame Functions

;; winner
;; defines the winner
;; uses the function 'count-points' (puzzle/game dependent) 
;; returns 
(defun winner(node)
	(let ((p1-points (funcall #'count-points )) (p2-points (funcall #'count-pieces )))
		(cond 
		((< p1-points p2-points) 'Player1)
		((> p1-points p2-points) 'Player2)
		(t 'Draw)
		)
	)
)

; ---------------------------------------- ; 
;;; Performance Stats

;;TODO
;; geral -> limite de tempo usado,
;; cada jogada -> valor, profundidade do grafo, numero de cortes na analise
;; TODO
;; Ficheiro log.dat : 
; - qual a jogada realizada
; - o valor da posicao para onde jogou
; - o numero de nos analisados
; - o numero de cortes efetuados (de cada tipo)

;; runtime 
(defun runtime(start-time)
	(/(- (get-internal-real-time) start-time) 1000)
)


