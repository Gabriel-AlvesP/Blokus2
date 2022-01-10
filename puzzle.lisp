;;;; Puzzle.lisp
;;;; Codigo relacionado com o problema
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318



;;; Problems + Board

;; Problem A
;; At least 8 elements fulfilled
(defun board-a()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 2 2 2 2 2 2 2 2 2 2)
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2)
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2)
    (0 0 0 0 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2))
)

;; Problem b
;; At least 20 elements fulfilled
(defun board-b()
    ;A B C D E F G H I J K L M N
  '((0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (0 0 0 0 0 0 0 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2)
    (2 2 2 2 2 2 2 2 2 2 2 2 2 2))
)

;; Problem c
;; At least 28 elements fulfilled
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

;; Problem d
;; At least 36 elements fulfilled
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

;; Problem e
;; At least 44 elements fulfilled
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

;; Problem f
;; At least 72 elements fulfilled
;; Empty Board 14x14 
;  Returns a 14x14 empty board 
(defun empty-board (&optional (dimension 14))
	(make-list dimension :initial-element (make-list dimension :initial-element '0))
)

;; row
;  returns a particular row based on an index
(defun row(index board)
  "[index] must be a number between 0 and the board dimension"
  (nth index board)
)

;; column 
;  returns a particular column based on an index
(defun column(index board)
  "[index] must be a number between 0 and the board dimension"
  (mapcar (lambda (x) (nth index x))  board) 
)

;; element
;  returns a particular element based on row (r) and column (col) indexes
(defun element(r col board)
    "[r] and [col] must be numbers between 0 and the board dimension"
  (nth col (row r board))
)


;;; Secondary functions

;; Cells/elements verification

;  empty-elemp
;  returns t if a board element is empty(or the value - val) and nil if it isn't
(defun empty-elemp(row col board &optional (val 0)) 
  "[row] and [col] must be numbers between 0 and the board dimension"
  (cond 
  ((or (< row 0) (> row (1- (length board))) (< col 0) (> col (1-(length board)))) nil)
  ((= (element row col board) val) t)
  (t nil)
  )
)

; check-empty-elems
; checks if each element of indexes-list is empty or not in the board
; indexes-list - ex -  ((0 0) (0 2) (4 2))
; returns a list of t and nil depending on each index  
(defun check-empty-elems(board indexes-list &optional (val 0)) 
  "Each element(list with row and col) in indexes-list
   must contain a valid number for the row and column < (length board)"
  (mapcar (lambda (index) (empty-elemp (first index) (second index) board val)) indexes-list)
)


;; replace-pos + replace- + replace-multi-pos
;; replace position in the board


;  replaces a position in the board for val
;  returns a row(list) with element in column(col) position replaced by the val
(defun replace-pos (col row &optional (val 1)) 
    "[Col] (column) must be a number between 0 and the row length"
    (cond 
     ((null row) nil)
     ((= col 0) (cons val (replace-pos (1- col) (cdr row) val)))
     (t (cons (car row) (replace-pos (1- col) (cdr row) val)))
    )
)

;  replaces an element in the board  
;  returns the all board with element replaced by the value
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


;; remove-nil 
;;  remove all 'nil elements in a list
(defun remove-nil(list)
   (apply #'append (mapcar #'(lambda(x) (if (null x) nil (list x))) list))
)


;;;  Board Verifications

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

;; check-first-cell
;; check if first cell is empty
;; returns null if is emmpty, otherwise returns true
(defun check-first-cell (row col board)
  (cond
   ((= (element 0 0 board) row col 0) t)
   (t nil)
   )
)

;; force-move
;; This functions filters possible plays
;; if the first board's corner is empty, only allows pieces at the first corner of the board 
;; If the first board's corner is not empty, only allows moves that place pieces in touch with others (corner touch only)  
;; In sum, filters possible plays
;; returns t if the move is allow in that board and nil if it is not
(defun force-move (row col board piece) 
  (cond 
    ((and (= (element 0 0 board) 0) (or (/= row 0) (/= col 0))) nil)
    ((= (element 0 0 board) row col 0) t)
    ((eval (cons 'or (check-empty-elems board (piece-corners-elems row col piece) 1))) t)
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

;; can-place-piecep
;; test => (can-placep (list 0 0 0) (empty-board) 0 0  'piece-a)
;; result => nil
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

;; check-all-board
;; returns a list with all indexes in the board
(defun check-all-board(board row col)
  (cond 
    ((< row 0) nil)
    ((< col 0) (check-all-board board (1- row) (1- (length board))))
    (t (cons (list row col) (check-all-board board row (1- col))))
  )
)


; ---------------------------------

;;; Pieces

;; insert-piece
;; uses the piece-taken-elems to push pieces into the board
;; test => (insert-piece (init-pieces) 13 13 (empty-board) 'piece-a)
(defun insert-piece (pieces-list row col board piece) 
  (cond 
    ((null (can-placep pieces-list board row col piece)) nil)
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

;; all-spaces 
;; checks where can a piece be placed in the board from a list of indexes
;; returns a list with all possible moves based on all indexes given 
(defun all-spaces(pieces-list piece board indexes-list)
  (remove-nil(mapcar (lambda (index) (cond ((can-placep pieces-list board (first index) (second index) piece) index) (t nil))) indexes-list))
)

;; possible moves 
;; checks where can a piece can be placed in the board from all positions in the board
;; returns a list with indexes for all moves possible with a piece (sorted - up/down)
;; test => (possible-moves '(1 1 1) 'piece-a (board-a))
;; restult => ((0 0) (0 1) (0 2) (0 3) (1 0) (1 1) (1 2) (1 3) (2 0) (2 1) (2 2) (2 3) (3 0) (3 1) (3 2) (3 3))
(defun possible-moves(pieces-list piece board)
  (reverse (all-spaces pieces-list piece board (check-all-board board (1- (length board)) (1- (length (car board))))))
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
(defun piece-a (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-a)
)

;; piece-b
(defun piece-b (pieces-list index board)
   (insert-piece pieces-list (first index) (second index) board 'piece-b)
)

;; piece-c-1
(defun piece-c-1 (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-1)
)

;; piece-c-2
(defun piece-c-2 (pieces-list index board)
  (insert-piece pieces-list (first index) (second index) board 'piece-c-2)
)
