;;;; Puzzle.lisp
;;;; Implementação do algoritmo de jogo - AlfaBeta ou Negamax com cortes alfa-beta
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318


;;; Memoization

;; Memoization generalization
(defun memo (fn)
	(let ((table (make-hash-table)))
		(lambda (x)
			(or (gethash x table)
				(let ((val (funcall fn x)))
					(setf (gethash x table) val)
					val
				)
			)
		)
	)
)

;!=====================================================================
#| 
argumentos: nó n, profundidade d, cor c ;?
function negamax (n, d, α, β, c) 
	se d = 0 ou n é terminal  
		return c * valor heuristico de n 
	sucessores := OrderMoves(GenerateMoves(n)) 
	bestValue := −∞ 
	para cada sucessor nk em sucessores 
		bestValue := max (bestValue, −negamax (nk, d−1, −β, − α, −c)) 
		α := max (α, bestValue) 
		se α ≥ β 
			break 
	return bestValue 
|#
;!=====================================================================

; ---------------------------------------- ;
;;;  Negamax com cortes alfa-beta (slightly faster)

;; negamax
(defun negamax(node time-limit 
"
[node] 
[time-limit] input - limit time for an execution
[alpha] 
[beta]
[player] 
[start-time] timestamp - Execution start timestamp
[cuts-number] performance stats - returns the number of cuts executed
[nodes-visited] performance stats - returns the number of nodes visited
"
    &optional (alpha most-negative-fixnum) 
              (beta most-positive-fixnum) 
              (player 1) 
              (start-time (get-internal-real-time))
			  (cuts-number 0)
			  (nodes-visited 1)
			  )
	
	(let (())
		(cond 
		((> (runtime start-time) time-limit) solution-node) ;! Condicao de termino	
		(t
			()
		)
		)
	)
)

(defun order-moves())
(defun generate-children())


;;; Abstract Data Types

;; make-node
;;  constructs a node with the state (board), depth and the parent node
;;  returns a list with all data
;;  test => (make-node (empty-board))
(defun make-node(state &optional (parent nil) (pieces '(10 10 15)))
  (list state parent g h (list pieces)
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

;; node-pieces-left
;; returns list with the number of pieces left by type 
;; test => (node-pieces-left (make-node (empty-board) (board-d) 1 2 '(1 2 3)))  
(defun node-pieces-left(node)
  (nth (1- (length node)) node)
)

; ---------------------------------------- ; 
;;; Performance Stats

(defun runtime(start-time)
	(/(- (get-internal-real-time) start-time) 1000)
)

