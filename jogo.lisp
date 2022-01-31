;;;; Projeto.lip 
;;;; Funções que permitem escrever e ler em ficheiros, trata ainda da interação com o utilizador
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318


;;; Game Handler

;; get-log-path
;; returns the path to the log file 
(defun get-log-path()
  (make-pathname :host "D" :directory '(:absolute "GitHub\\Blokus2") :name "log" :type "dat")   
)

(defun human-vs-computer(max-time player &optional (node (make-node (empty-board))))
  (let* (
          (p-moves    (expand-node node (operations) 1))
          (p-pieces   (pieces-list node 1))
          (can-p-play (or (null c1-moves) (= 0 (apply '+ c1-pieces))))        ; t = can't play
          (c-moves    (expand-node node (operations) -1))
          (c-pieces   (pieces-list node -1))
          (can-c-play (or (null c2-moves) (= 0 (apply '+ c2-pieces))))        ; t = can't play
          (can-current-play (cond ((= player 1) can-c1-play) (t can-c2-play)))  ; t = can't play
        )
    (cond 
      ((and can-c1-play can-c2-play) (log-footer node))
      ((= -1 player)                                    ; Man 

      )
      (t                                                ; Computer 
        (cond )
      ) 

    )

  )
)

;; run-h-vs-c
;; person = -1 || computer = 1
(defun run-h-vs-c() 
  (let* ((starter (get-starter)) (starter-val (cond ((= 1 starter) -1) (t 1) )) (max-time (get-time-limit)))
    (progn
      (log-header max-time)
      (human-vs-computer max-time starter-val)
    ) 
  )
)

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

(defun run-computer-only()
  (let ((max-time (get-time-limit)))
    (progn 
      (log-header max-time)
      (computer-only max-time 1)
    )
  )
)

;;; Menus + Views (and its operations)

;; init-menu 
;;  shows the game's initial menu
(defun init-menu()
    (format t "~%___________________________________________________________")
    (format t "~%\\                      BLOKUS DUO                         /")
    (format t "~%/                                                         \\")
    (format t "~%\\     1 - Humano vs Computador                            /")
    (format t "~%/       2 - Computador vs Computador                      \\")  
    (format t "~%\\     0 - Sair                                            /")
    (format t "~%/_________________________________________________________\\~%~%>")
)

;; start
;; It receives data from the keyboard
;; and executes the correspondent action/operation 
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

;; starter-view
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

;; get-starter
;; 1 - human || -1 - computer
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

;; time-limit-view
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

;; get-time-limit
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

;; possible-moves-view
(defun possible-moves-view())

;;; Files Handler (log.dat)

(defun header(stream max-time)
  (format stream "~%----------------- INICIO -----------------~%max-time: ~a~%~%" max-time)
)

(defun log-header(max-time)
  (progn 
    (with-open-file (file (get-log-path) :direction :output :if-exists :append :if-does-not-exist :create) (header file max-time))  
    (header t max-time)
  )     
)

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

(defun log-footer(node)
  (progn
    (with-open-file (file (get-log-path) :direction :output :if-exists :append :if-does-not-exist :create) (log-winner node file))
    (log-winner node t)
  )
) 

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

;;; Formatters

(defun format-board-line (board &optional (stream t))
  (cond
   ((null (first board)) "")
   (t (format stream "~a~%" (first board)))
   )
)

(defun format-board (board &optional (stream t))
  (cond
   ((null board) "")
   (t (format stream "~&" (append(format-board-line board stream) (format-board (cdr board) stream))))
   )
)  
