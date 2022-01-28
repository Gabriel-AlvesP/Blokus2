;;;; Puzzle.lisp
;;;; Codigo relacionado com o problema e operadores
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318

;;; Board 
;; [0] empty element/cell
;; [1] player one piece
;; [2] player two piece

;;! TESTE
;;TODO DELETE
(defun board-t()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;1
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;2
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;3
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;4
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;5
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;6
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;7
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;8
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;9
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;10
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;11
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;12
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0) ;13
    (0 0 0 0 0 0 0 0 0 0 0 0 0 0));14
)

;; Problem
;; At least 72 elements fulfilled
;; Empty Board 14x14 
;;  Returns a 14x14 empty board 
(defun empty-board (&optional (dimension 14))
	(make-list dimension :initial-element (make-list dimension :initial-element '0))
)

;; row
;;  returns a particular row based on an index
(defun row(index board)
  "[index] must be a number between 0 and the board dimension"
  (nth index board)
)

;; column 
;;  returns a particular column based on an index
(defun column(index board)
  "[index] must be a number between 0 and the board dimension"
  (mapcar (lambda (x) (nth index x))  board) 
)

;; element
;;  returns a particular element based on row (r) and column (col) indexes
(defun element(r col board)
    "[r] and [col] must be numbers between 0 and the board dimension"
  (nth col (row r board))
)


;;; Secondary functions

;; Cells/elements verification

;;  empty-elemp
;;  returns t if a board element is empty(or has the value - val) and nil if it isn't
(defun empty-elemp(row col board &optional (val 0)) 
  "[row] and [col] must be numbers between 0 and the board dimension"
  (cond 
  ((or (< row 0) (> row (1- (length board))) (< col 0) (> col (1-(length board)))) nil)
  ((= (element row col board) val) t)
  (t nil)
  )
)

;; check-empty-elems
;; checks if each element of indexes-list is empty or not in the board
;; indexes-list - ((0 0) (0 2) (4 2))
;; returns a list of t and nil depending on each index  
(defun check-empty-elems(board indexes-list &optional (val 0)) 
  "Each element(list with row and col) in indexes-list
   must contain a valid number for the row and column < (length board)"
  (mapcar (lambda (index) (empty-elemp (first index) (second index) board val)) indexes-list)
)


;; replace-pos + replace- + replace-multi-pos

;; replace position in the board
;;  replaces a position in the board for val
;;  returns a row(list) with element in column(col) position replaced by the val
(defun replace-pos (col row &optional (val 1)) 
    "[Col] (column) must be a number between 0 and the row length"
    (cond 
     ((null row) nil)
     ((= col 0) (cons val (replace-pos (1- col) (cdr row) val)))
     (t (cons (car row) (replace-pos (1- col) (cdr row) val)))
    )
)

;;  replaces an element in the board  
;;  returns the all board with element replaced by the value
(defun replace- (row col board &optional (val 1)) 
  "[Row] and [column] must be a number between 0 and the board length"
  (cond  
   ((null board) nil)
   ((= row 0) (cons (replace-pos col (car board) val) (replace- (1- row) col (cdr board) val)))
   (t (cons (car board) (replace- (1- row) col (cdr board) val)))
  )
)

;;  replaces multiple positions in the board
;;  pos-list => list with all positions to replace
;; returns the all board with all elements replaced 
(defun replace-multi-pos (pos-list board &optional (val 1)) 
    (cond 
      ((null pos-list) board)
      (t (replace-multi-pos (cdr pos-list) (replace- (first (car pos-list)) (second (car pos-list)) board val)))
    )
)


;; remove-nil 
;;  remove all 'nil elements in a list
(defun remove-nil(list)
   (apply #'append (mapcar #'(lambda(x) (if (null x) nil (list x))) list))
)

;;  check-adjacent-elems
;;  check if adjacente elements/cells are taken (1, 2 or +)
;;  if, in fact, they are taken then returns null
;;  else 
(defun check-adjacent-elems (row col board piece)
  (cond
   ((eval (cons 'or (check-empty-elems board (piece-adjacent-elems row col piece) 1))) nil)
   (t t)
   )
)


;; check-corner
;; checks if a list has the pretended corner coordenates 
;; returns null if is emmpty, otherwise returns true
(defun check-corner (piece-format &optional (corner 0))
  (let ((list-index (car piece-format)))
    (cond 
      ((null piece-format) nil)
      ((= corner (first list-index) (second list-index)) 0)
      (t (check-corner (cdr piece-format) corner))
    )
  )
)

;; force-move
;; This functions filters possible plays
;; if the first board's corner is empty, only allows pieces at the first corner of the board 
;; If the first board's corner is not empty, only allows moves that place pieces in touch with others (corner touch only)  
;; In sum, filters possible plays
;; returns t if the move is allow in that board and nil if it is not
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

;; filter-player-move 
;; This function receives the player and with that
;; filters where he must play 
;; player1 = 1, top left corner, pieces-val = 1
;; player 2 = -1, bottom right corner, pieces-val = 2
;; returns force-move function value (t - allow move || nil - it doesn't allow move)
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

;; can-place-piecep
;; test => (can-placep (list 1 0 0) (empty-board) 0 0  'piece-a 1)
;; result => T
(defun can-placep (pieces-list board row col piece player)
"
[player] player1 = 1 || player2 = -1
"
  (cond 
    ((= 0 (pieces-left-numb pieces-list piece)) nil)
    ((or (> row (length board)) (< row 0) (< col 0) (> col (length board))) nil)
    ((not (filter-player-move player row col board piece)) nil)
    ((not (check-adjacent-elems row col board piece)) nil)
    ((eval (cons 'and (check-empty-elems board (piece-taken-elems row col piece))))t)
    (t nil)
  )
)

; ------------------------------------ ;
;;; Possible Moves 

;; get-possible-indexes
;; reduces the possible moves from all board to only the corner of placed pieces by one player
;; returns a list with the corners indexes of placed pieces, from all player past moves
;; test => (get-possible-indexes (list (list 'piece-a '(0 0)) (list 'piece-b '(1 1))))
;; ((-1 -1) (1 -1) (-1 1) (1 1) (0 0) (3 0) (0 3) (3 3))
(defun get-possible-indexes (player-moves &aux (first-elem (car player-moves))  (indexes (second first-elem))) 
"
[player-moves] (('piece-b (0 0)) ('piece-b (3 3)))) => (player (list (list piece (list row col)) (list piece (list row col)) )
"
  (cond 
    ((null player-moves) nil)
    (t (append (piece-corners-elems (car indexes) (second indexes) (car first-elem)) (get-possible-indexes (cdr player-moves))))
  )
)

;; filter-possible-moves 
;; checks where can a piece be placed in the board from a list of indexes
;; returns a list with all possible moves based on all indexes given 
;; (filter-possible-moves '(1 1 1) 'piece-a (board-t) (list '(1 1) '(0 0) '(12 12) '(13 13)) -1
;; ((13 13))
(defun filter-possible-moves(pieces-list piece board indexes-list player)
  (remove-nil(mapcar (lambda (index) (cond ((can-placep pieces-list board (first index) (second index) piece player) index) (t nil))) indexes-list))
)

;; possible-moves
;; returns a list with indexes for all possible moves with a piece (filtered)
;;!test (board was adapted with the pieces used in the test)
;; test => (possible-moves (list 1 (list (list 'piece-a '(0 0)) (list 'piece-b '(1 1))) '(1 1 1)) 'piece-a (board-t))
;; return => ((3 0) (0 3) (3 3))
;; test => (possible-moves (list 1 nil '(1 1 1)) 'piece-a (board-t))
;; return => ((0 0))
(defun possible-moves(player-node piece board)
"
[player-node] (1 (('piece-b (0 0)) ('piece-b (3 3)))) => (player (list (list piece (list row col)) (list piece (list row col)) ))
"
  (let ((possible-indexes (get-possible-indexes (second player-node))) (pieces-list (third player-node)))
    (cond 
      ((null possible-indexes) (filter-possible-moves pieces-list piece board (list '(0 0) '(13 13) '(11 12) '(12 12)) (car player-node))) 
      (t(filter-possible-moves pieces-list piece board possible-indexes (car player-node)))
    )
  )
)


; --------------------------------- ;
;;; Pieces

;; piece-taken-elems 
;; returns a list with all elements/cells that a particular piece takes in a board
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

;; piece-adjacent-elems
;; returns a list with all adjacent elements/cells that a particular  piece takes in a board
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

;; piece-corners-elems
;; returns a list with all corners elements/cells that a particular piece takes in the board
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

;; insert-piece
;; uses the piece-taken-elems to push pieces into the board
;; test => (insert-piece (init-pieces) 13 13 (empty-board) 'piece-a)
(defun insert-piece (pieces-list row col board piece &optional (player 1)) 
"
[player] player1 = 1 || player2 = -1
"
  (cond 
    ((null (can-placep pieces-list board row col piece player)) nil)
    (t (replace-multi-pos (piece-taken-elems row col piece) board)))
)

;; pieces-left-numb
;; pieces-list= list with all pieces left to play
;; returns how many pieces are left per type 
;; test => (pieces-left-numb (init-pieces) 'piece-a) 
;; result => 10
(defun pieces-left-numb(pieces-list piece-type)
  (cond 
    ((equal piece-type 'piece-a)(first pieces-list))
    ((equal piece-type 'piece-b) (second pieces-list))
    (t (third pieces-list))
  )
)

;; remove-used-piece
;; remove a piece from the list of pieces left to play
;; test =>  (remove-used-piece (init-pieces) 'piece-a)
;; result => (9 10 15)
(defun remove-used-piece(pieces-list piece-type)
  (cond 
    ((equal piece-type 'piece-a) (list (1- (first pieces-list)) (second pieces-list) (third pieces-list)))
    ((equal piece-type 'piece-b) (cadr pieces-list) (list (first pieces-list) (1-(second pieces-list)) (third pieces-list)))
    (t (list (first pieces-list) (second pieces-list) (1- (third pieces-list))))
  )
)



; --------------------------------- ;

;;; Operators

;; init-pieces 
;; list with the number of each piece at the start
(defun init-pieces()
  (list 10 10 15)
)

;; operations
;; returns a list with all operations
(defun operations()
  (list 'piece-a 'piece-b 'piece-c-1 'piece-c-2)
)

;; piece-a
;; board = (node-state node)
;; returns board with the pieces placed or nil if fails 
(defun piece-a (pieces-list index board player)
  (insert-piece pieces-list (first index) (second index) board 'piece-a player)
)

;; piece-b
(defun piece-b (pieces-list index board player)
   (insert-piece pieces-list (first index) (second index) board 'piece-b player)
)

;; piece-c-1
(defun piece-c-1 (pieces-list index board player) 
  (insert-piece pieces-list (first index) (second index) board 'piece-c-1 player)
)

;; piece-c-2
(defun piece-c-2 (pieces-list index board player)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-2 player)
)

; --------------------------------- ;
;;; Endgame Handling

(defun count-points (pieces-list)
  (+ (first pieces-list) (* (second pieces-list) 4) (* (third pieces-list) 4))
)


;!===================================deprecated================================================= 
#|
;; possible moves 
;; checks where can a piece be placed in the board from all positions in the board
;; returns a list with indexes for all moves possible with a piece (sorted - up/down)
;; test => (possible-moves '(1 1 1) 'piece-a (board-a))
;; restult => ((0 0) (0 1) (0 2) (0 3) (1 0) (1 1) (1 2) (1 3) (2 0) (2 1) (2 2) (2 3) (3 0) (3 1) (3 2) (3 3))
(defun possible-moves(pieces-list piece board player)
  (reverse (filter-possible-moves pieces-list piece board (check-all-board board (1- (length board)) (1- (length (car board)))) player))
)

;; check-all-board
;; returns a list with all indexes in the board
(defun check-all-board(board row col)
  (cond 
    ((< row 0) nil)
    ((< col 0) (check-all-board board (1- row) (1- (length board))))
    (t (cons (list row col) (check-all-board board row (1- col))))
  )
)
|#
;!===================================deprecated================================================= 