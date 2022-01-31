;;;; Puzzle.lisp
;;;; Implementação do algoritmo de jogo - AlfaBeta ou Negamax com cortes alfa-beta
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318


;;; Memoization

(let ((tab (make-hash-table)))
  (defun fib-memo (n)
    (or (gethash n tab) (let ((val (funcall #'FUNC n))) (setf (gethash n tab) val) val))
  )
)


; ---------------------------------------- ;
;;; Abstract Data Types


;; play-nodess
;; (list jogador (list '('peca (row col)) '('peca2 (row2 col2))))
;; moves = (list (list 'peca (row col)) (list 'peca2 (row2 col2)))
;; test ->  (player-info 1 (append (move-info 'piece-b '(1 2)) (move-info 'piece-a '(0 0))))
;; return -> (1 ((PIECE-B (1 2)) (PIECE-A (0 0))) (10 10 15))
(defun player-info(&optional (color 1) (moves nil) (pieces-list (init-pieces)))
	(list color moves pieces-list)
)

;; play-info 
(defun move-info(piece move)
"
[piece] operation 
[move] list with row and col
"
(list (list piece move))
)

;; make-node
;;  constructs a node with the state (board), depth and the parent node
;;  uses the function 'init-pieces' (puzzle/game dependent) to define the pieces list
;;  returns a list with all data
;;  test => (make-node (empty-board))
(defun make-node(state &optional (parent nil) (p1-node (player-info)) (p2-node (player-info -1)) (f -500))
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
;; test => (node-parent (make-node (empty-board) (board-t)))
(defun node-parent(node)
  (second node)
)

;; node-value (f)
(defun node-value(node)
	(third node)
)

;; players sub-node (list color (list '('piece (row col))  '('piece (row col))) '(10 10 15))
;; color 1 || -1

;; node-p1
;; player 1 node 
;; test
;; (node-p1 (make-node (empty-board)))
;; (1 NIL (10 10 15))
(defun node-p1 (node)
	(fourth node)
)

;;;; node-p1
;; player 2 node 
;; test
;; (node-p2 (make-node (empty-board)))
;; (-1 NIL (10 10 15))
(defun node-p2 (node)
  (nth (1- (length node)) node)
)

;; player-moves
;; all moves made by one player
(defun player-moves(node color)
	(cond 
		((= 1 color) (second (node-p1 node)))
		(t (second (node-p2 node)))
	)
)

;; pieces-list
;; player's pieces left list
(defun pieces-list(node color)
	(cond 
		((= 1 color) (third (node-p1 node)))
		(t (third (node-p2 node)))
	)
)


; ---------------------------------------- ;
;;;  Negamax com cortes alfa-beta (slightly faster)

;;TODO
;; geral -> limite de tempo usado,
;; cada jogada -> valor, profundidade do grafo, numero de cortes na analise
;; TODO
;; Ficheiro log.dat : 
; - qual a jogada realizada
; - o valor da posicao para onde jogou
; - o numero de nos analisados
; - o numero de cortes efetuados (de cada tipo)



; --------------------------------------- ; 
(defun negamax(max-time                 
               &optional 
               (node (make-node (empty-board) nil (player-info 1) (player-info -1) most-negative-fixnum))
               (color 1)
               (max-depth 6)
               (alpha most-negative-fixnum) 
               (beta most-positive-fixnum) 
               (start-time (get-internal-real-time))
               (visited-nodes 1)
               (cuts 0)
               )

  (let* ((children (order-nodes (funcall #'expand-node node (operations) color))))
    (cond
     ((or (= max-depth 0) (null children) (>= (runtime start-time) max-time)) 
      (solution-node (final-node-f node color) visited-nodes cuts start-time))
     (t (negamax- node children max-time color max-depth alpha beta start-time visited-nodes cuts))
     )
    )
  )

(defun negamax-(parent children max-time color max-depth alpha beta start-time visited-nodes cuts)
	(cond
   		((= (length children) 1) 
    		(negamax max-time (-f (car children)) (- color) (1- max-depth) (- beta) (- alpha) start-time (1+ visited-nodes) cuts))
   		(t (let* (
			(solution (negamax max-time (-f (car children)) (- color) (1- max-depth) (- beta) (- alpha) start-time (1+ visited-nodes) cuts))
            (best-value (node-value (max-f (car solution) parent)))
            (alpha (max alpha best-value))
            (v-nodes (get-visited-nodes solution))       
            (cuts-numb (get-cuts solution))
            )
      			(cond 
	  				((>= alpha beta) (solution-node parent v-nodes (1+ cuts-numb) start-time))
        			(t (negamax- parent (cdr children) max-time color max-depth alpha beta start-time v-nodes cuts-numb))
    			)
      		)
    	
   		)
  	)
)

; ---------------------------------------- ;
;;; Solution Node

;; Solution node
(defun solution-node(node visited-nodes cuts-number start-time)
	(list node (list visited-nodes cuts-number (runtime start-time)))
)

;; solution
(defun get-solution-node(sol-node) (car sol-node))

;; solution-get-visited-nodes
(defun get-visited-nodes(sol-node) (car (second sol-node)))

;; solution-get-cuts
(defun get-cuts(sol-node)(second (second sol-node)))

;; solution-runtime
(defun get-runtime(sol-node)(third (second sol-node)))

; ---------------------------------------- ;
;;; Aux Functions

;; get-child
;; Uses one piece and applies an operation with a possible move to create a child from a node 
;; returns a node
;; test => (get-child (make-node (empty-board)) (car (possible-moves (init-pieces) 'piece-a (empty-board))) 'piece-a)
(defun get-child(node possible-move operation color &aux (pieces-left (pieces-list node color)) (state (node-state node)))
    "
	[Operation] must be a function
	[color] represents the player - player1 = 1 || player2 = -1 
	"
    (let* (
          (move (funcall operation pieces-left possible-move state color))
          (updated-pieces-list (remove-used-piece pieces-left operation))
		  ;(updated-player-info (player-info color (append (player-moves node color) (move-info operation possible-move)) updated-pieces-list))  
		  (updated-player-info (player-info color nil updated-pieces-list)) 
          )
      (cond 
        ((null move) nil)
		((= color 1) (make-node move nil updated-player-info (node-p2 node) (count-points updated-pieces-list)))
        (t (make-node move nil (node-p1 node) updated-player-info (count-points updated-pieces-list))) 
      )
  )
)


;; get-children 
;; Uses the get-child function to create a child for every possible move with a piece
;; Generates all children from a operation(piece)
;; returns a list of nodes 
;; test => (get-children (make-node (board-t)) (possible-moves  (player-info 1  (move-info 'piece-c-2 '(0 0))) 'piece-a (board-t)) 'piece-a 1)
(defun get-children(node possible-moves operation color)
  (cond 
    ((null possible-moves) nil) 
    (t (cons (get-child node (car possible-moves) operation color) (get-children node (cdr possible-moves) operation color)))
  )
)


;; expand-node
;; Uses the get-children function to generate all possibilities from each operation(piece)
;; In sum, expand a node 
;; return a list of nodes
;; test => (expand-node (make-node (empty-board)) (operations) 1)  
(defun expand-node(node operations color)
  "
  [operations] must be a list with all available operations
  "
	;(let ((player-data (cond ((= color 1) (node-p1 node)) (t (node-p2 node)))))
		(cond
    		((null operations) nil)
    		(t (remove-nil (append (get-children node (funcall #'possible-moves (pieces-list node color) (car operations) (node-state node) color) (car operations) color)        
                      (expand-node node (cdr operations) color))))
   		)
  	;)
)

;; order-nodes
;; Order a list of nodes (Descending by value)
;; test
;; (order-nodes (expand-node (make-node (empty-board)) (operations) 1))
(defun order-nodes(node-list) 
	(sort node-list #'> :key #'node-value)
)

(defun max-f(node1 node2)
	(cond 
		((> (node-value node1) (node-value node2)) node1)
		(t node2)
	)
)

;; -f 
;; returns a node with its value reversed
(defun -f(node)
	(make-node (node-state node) (node-parent node) (node-p1 node) (node-p2 node) (- (node-value node)))
)

;; final-node-f 
;; returs a node with its value multiplied by the player pieces color
(defun final-node-f(node color)
	(make-node (node-state node) (node-parent node) (node-p1 node) (node-p2 node) (* color (node-value node)))
)


;; remove-duplicated 
;; removes elements duplicated between 2 lists
(defun remove-duplicated(list1 list2)
	(cond 
		((null list2) list1)
		(t (remove-nil (mapcar (lambda(x) (cond ((exist-nodep x list2) nil) (t x))) list1)))
	)
)

;; exist-nodep
;; checks if the node-list contains a node with the same state as the parameter node
;; returns t if exists and nil if it doesn't 
;; test => (exist-nodep (make-node (empty-board)) (list (make-node (board-d))(make-node (empty-board))))
(defun exist-nodep(node node-list)
  (cond 
   ((null node-list) nil)
   (t (eval (cons 'or (mapcar (lambda (x) (cond ((equal (node-state node) (node-state x)) t) (t nil))) node-list))))
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


