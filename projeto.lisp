;;;; Projeto.lip 
;;;; Carrega os outros ficheiros de codigo, escreve e le ficheiros e trata, ainda, da interacao com o utilizador
;;;; Gabriel Pais - 201900301
;;;; Andre Serrado - 201900318


;;; Menu

;; init-menu 
;;  shows the game's initial menu
(defun init-menu()
  (progn
    (format t "~%_________________________________________________________")
    (format t "~%\\                      BLOKUS UNO                       /")
    (format t "~%/                                                       \\")
    (format t "~%\\     1 - Escolher algoritmo                            /")
    (format t "~%/                                                       \\")  
    (format t "~%\\     0 - Sair                                          /")
    (format t "~%/_______________________________________________________\\~%~%>")
  )
)

;; choose-algorithm
;; shows the algorithms menu
(defun choose-algorithm()
  (progn
    (format t "~%_________________________________________________________")
    (format t "~%\\                      BLOKUS UNO                       /")
    (format t "~%/                  Escolha o algoritmo                  \\")
    (format t "~%\\                                                       /")
    (format t "~%/     1 - Breadth-First Search                          \\")
    (format t "~%\\     2 - Depth-First Search                            /")
    (format t "~%/     3 - A*                                            \\")
    (format t "~%\\     0 - Voltar                                        /")
    (format t "~%/_______________________________________________________\\~%~%> ")
  )
)

;; choose-heuristic
;; show the heuristics menu
(defun choose-heuristic()
  (format t "~%_________________________________________________________")
  (format t "~%\\                      BLOKUS UNO                       /")
  (format t "~%/                 Escolha uma heurística                \\")
  (format t "~%\\                                                       /")
  (format t "~%/     1 - Heurística Base                               \\")
  (format t "~%\\     2 - Heurística Desenvolvida                       /")
  (format t "~%/     0 - Voltar                                        \\")
  (format t "~%\\                                                       /")
  (format t "~%/_______________________________________________________\\~%~%> ")
)

;; choose-depth
;; menu for user enter depth 
(defun choose-depth()
  (format t "~%__________________________________________________________")
  (format t "~%\\                      BLOKUS UNO                        /")
  (format t "~%/           Insira a profundidade máxima desejada        \\")
  (format t "~%\\                     -1 - Voltar                        /")
  (format t "~%/________________________________________________________\\~%~%> ")
)

;; choose-board 
;; shows the board choice menu
(defun choose-board()
  (format t "~%__________________________________________________________")
  (format t "~%\\                      BLOKUS UNO                        /")
  (format t "~%/                  Escolha um tabulerio                  \\")
  (format t "~%                  1 - 1º Tabuleiro                      /~%")
  (format-board-to-listener (get-board (load-problems-file) 1))
  (format t "~%                  2 - 2º Tabuleiro                      ~%")
  (format-board-to-listener (get-board (load-problems-file) 2))
  (format t "~%                  3 - 3º Tabuleiro                      ~%")
  (format-board-to-listener (get-board (load-problems-file) 3))
  (format t "~%                  4 - 4º Tabuleiro                      ~%")
  (format-board-to-listener (get-board (load-problems-file) 4))
  (format t "~%                  5 - 5º Tabuleiro                      ~%")
  (format-board-to-listener (get-board (load-problems-file) 5))
  (format t "~%                  6 - 6º Tabuleiro                      ~%")
  (format-board-to-listener (get-board (load-problems-file) 6))
  (format t "~%\\                                                        /")
  (format t "~%/________________________________________________________\\~%~%> ")
)

;; read-board-chosen
;; read the board chosen by the user
(defun read-board-chosen()
  (choose-board)
  (let ((option (read)))
    (if (and (numberp option) (>= option 0) (<= option 6))
        option
      (progn (format t"~% Opção inválida.~% Tente novamente.") (read-board-chosen))
      )
    )
  )


;;; Files Handler

;; get-problems-path
;; returns the path to the problems.dat file 
(defun get-problems-path()
  (make-pathname :host "D" :directory '(:absolute "IPS\\3º Ano\\1º Semestre\\Inteligência Artificial\\Blokus") :name "problemas" :type "dat")   
)

;; get-solutions-path
;; returns the path to the solutions.dat file
(defun get-results-path()
  (make-pathname :host "D" :directory '(:absolute "IPS\\3º Ano\\1º Semestre\\Inteligência Artificial\\Blokus") :name "resultados" :type "dat")
)

;; load-problems-file
;; returns all boards of problemas.dat file
;; teste -> (load-problems-file)
(defun load-problems-file ()
  (with-open-file (stream (get-problems-path))
    (labels ((read-recursively ()
               (let ((line (read stream nil 'eof)))
                 (if (eq line 'eof) nil (cons line (read-recursively))))))
      (read-recursively))
    )
  )

;; get-board-to-use
;; returns the board
;; teste -> (get-board-to-use (load-problems-file) 1)
(defun get-board (file number)
  (cond  
   ((= number 1) (car (nth 1 file)))
   ((= number 2) (car (nth 3 file)))
   ((= number 3) (car (nth 5 file)))
   ((= number 4) (car (nth 7 file)))
   ((= number 5) (car (nth 9 file)))
   ((= number 6) (car (nth 11 file)))
   (t nil))
  )

;; board-solution
;; returns board-solution 
;; teste -> (get-board-solution (load-problems-file) 1)
(defun board-solution (file number)
  (cond
   ((= number 1) (cadr (nth 1 file)))
   ((= number 2) (cadr (nth 3 file)))
   ((= number 3) (cadr (nth 5 file)))
   ((= number 4) (cadr (nth 7 file)))
   ((= number 5) (cadr (nth 9 file)))
   ((= number 6) (cadr (nth 11 file)))
   (t nil))
  ) 





;; write-file
;; <algorithm> list with algorithm, start time, end time, duration time, solution-path, depth, board,fator de ramificação média, nº de nós gerados,nº de nós expandidos, penetrância, comprimento da solução
(defun write-file(solution start end)
  (with-open-file (stream "D:\\IPS\\3º Ano\\1º Semestre\\Inteligência Artificial\\Blokus\\resultados.dat" :direction :output :if-exists :append :if-does-not-exist :create)
    (format stream "~% *** Solução do Tabuleiro: ***")
    (terpri stream)
    (format stream"~%~tInício: ~a" start)
    (format stream"~%~tFim: ~a" end)
    (format stream"~%~tDuração: ~a" (- end start))
    (format stream"~%~tFator de ramificação média: ~a" (average-branching-factor solution (generated-nodes solution) 2))
    (format stream"~%~tNúmero de nós gerados: ~a" (generated-nodes solution))
    (format stream"~%~tNúmero de nós expandidos: ~a" (number-of-expanded-nodes solution)) 
    (format stream"~%~tPenetrância: ~a" (piercing-factor solution))
    (format stream"~%~tComprimento da solução: ~a" (solution-length solution))
    (format stream"~%~tCaminho da solução: ~%")
    (format stream (format-solution-path (solution-path(solution-node solution))) )
    (terpri stream)
    (format stream"~%~t------ Fim de Execução ------")
    (terpri stream)
    (terpri stream)
    )
  )

(defun format-board-line (board)
  (cond
   ((null (first board)) "")
   (t (format nil "~a~%" (first board)))
   )
)

(defun format-board (board)
  (cond
   ((null board) "")
   (t (format nil "~a~a" (format-board-line board) (format-board (cdr board))))
   )
  )  

(defun format-solution-path (path)
  (cond
   ((null path) "")
   (t (format nil "~a~%~a" (format-board (first (first path))) (format-solution-path (cdr path))))
   )
)

(defun format-board-to-listener (board)
  (cond
   ((null board) nil)
   (t 
    (progn (format t "~a~%" (first board) (format-board-to-listener (cdr board)))))
   )
  )

;;; User Handler

;; start
;; Receive data from the keyboard, by the user in relation to the option he want to choose
(defun start()
  (init-menu)
  (let ((option (read)))
    (if (and (numberp option) (>= option 0) (<= option 1)) 
        (cond
         ((equal option 1) (run-algorithm))
         ((equal option 0) (format t "~%Adeus!"))) 
      (progn (print "Opção inválida. Tente novamente") (start))
      )
    )
  )

  
;; run-algorithm
;; run the algorithm chosen by the user
(defun run-algorithm ()
  (progn
    (choose-algorithm)
    (let ((option (read)))
      (if (and (numberp option) (>= option 0) (<= option 3))
          (let* ((solution-number (read-board-chosen))
                 (start-time (current-time))
                 (final-node 
                  (cond
                   ((equal option 1)   
                    (bfs (board-solution (load-problems-file) solution-number) (operations) (list (make-node (get-board (load-problems-file) solution-number)))))
                   ((equal option 2) 
                    
                    (let* ((depth (read-depth-chosen)))
                      (dfs (board-solution (load-problems-file) solution-number) (operations) (list (make-node (get-board (load-problems-file) solution-number))) depth)))
                   ((equal option 3) 
                    
                    (let* ((heuristic (read-heuritic-chosen)))
                    (a* (board-solution (load-problems-file) solution-number) (operations) (list (make-node (get-board (load-problems-file) solution-number))) heuristic)))
         ((equal option 0) (start))
         )
                              )
                 (end (current-time))
                 )   
            (write-file final-node start-time end)
            )
        )
      ) 
    )
  )
  
;; read-depth-chosen
;; read the depth chosen by the user
(defun read-depth-chosen ()
  (choose-depth)
  (let ((option (read)))
    (cond
     ((and (numberp option) (equal option -1)) (run-algorithm))
     ((numberp option) option)
     (t  (progn (format t"~% Opção inválida.~% Tente novamente.") (read-depth-chosen)))
     )
    )
  )


;; read-heuristic-chosen
;; read the heuristic chosen by the user
(defun read-heuritic-chosen ()
  (choose-heuristic)
  (let ((option (read)))
    (if (and (numberp option) (>= option 0) (<= option 2))
        (cond
         ((equal option 1) 'h1)
         ((equal option 2) 'h2)
         ((equal option 0) (run-algorithm))
         )
      (progn (format t"~% Opção inválida.~% Tente novamente.") (read-heuritic-chosen))
      )
    )
  )





;;;Stats

;; write-bfs-and-dfs-stats
;; write the solution and measures for the bfs and dfs algorithms
(defun write-bfs-dfs-a*-stats (solution start end stream)
    (format stream "~% *** Solução do Tabuleiro: ***")
    (terpri stream)
    (format stream"~%~tInício: ~a" start)
    (format stream"~%~tFim: ~a" end)
    (format stream"~%~tTempo Total: ~a" (- end start))
    (format stream"~%~tFator de ramificação média: ~a" (average-branching-factor solution (generated-nodes solution) 2))
    (format stream"~%~tNúmero de nós gerados: ~a" (generated-nodes solution))
    (format stream"~%~tNúmero de nós expandidos: ~a" (number-of-expanded-nodes solution)) 
    (format stream"~%~tPenetrância: ~a" (piercing-factor solution))
    (format stream"~%~tComprimento da solução: ~a" (solution-length solution))
    (format stream"~%~tCaminho da solução: ~a" (solution-path solution))
    (terpri stream)
    (format stream"~%~t------ Fim de Execução ------")
    (terpri stream)
    (terpri stream)
)


;; current-time
;; returns a list with a actual time (hours minutes seconds)
(defun current-time()
  (get-internal-real-time)
)