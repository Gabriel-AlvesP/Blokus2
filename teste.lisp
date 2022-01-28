(defun negamax(board alpha beta depth player)
	(cond 
		((or (= depth 0) (terminal_node (cdr board)) (get_evaluation board player))
		(t (get_max_move board (possible_moves (cdr board)) alpha beta depth player)))))

(defun get_max_move (board poss_moves alpha beta depth player)
	(cond
		((null poss_moves) alpha)
		(t (let (
             (alpha (max_eval alpha (- negamax (next_state (cdr board) player (caar poss_moves) (cadar poss_moves)) (1- depth) (- beta) (- alpha) (next_player player)))))
         (if (>= alpha beta)
           alpha ; if true
           (get_max_move (cdr poss_moves) alpha beta depth player) ; else
           )))))

(defun terminal_node (board)
  (equalp 0 (length (possible_moves board))))

(defun max_eval (a b)
  (if (> (car a) (car b))
    a ; if a>b
    b)); else if a<=b

(defun get_evaluation (board player)
	(cond ((equalp player #\X) (evaluate_board board))
		(t (- (evaluate_board board)))))