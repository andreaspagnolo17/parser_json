;;;; -*- Mode: Lisp -*-

;;;; Spagnolo Andrea 879254

;;;;per spiegazione del codice leggere README.txt

;;;; jsonparse:

(defun jsonparse (JSONStr)
  (let ((JSONList (skip-spaces (coerce JSONStr 'list))))
    (or (is-object JSONList)
        (is-array JSONList)
        (error "ERROR: syntax error"))))

;;;; is-object:

(defun is-object (obj)
  (if (eql (car obj) #\{)
      (if (eql (second obj) #\})
          (values (list 'jsonobj) (cdr (cdr obj)))
        (multiple-value-bind (result more_object) 
            (is-member (cdr obj))
          (if (eql (car more_object) #\})
              (values (cons 'jsonobj result) (cdr more_object))
            (error "ERROR: syntax error"))))
    (values nil obj)))
            
;;;; is-pair

(defun is-pair (pair)
  (multiple-value-bind (result more_pair) 
      (is-string pair)
    (if (or (null result)
            (null more_pair))
        (error "ERROR: syntax error")
      (if (eql (car more_pair) #\:)
          (multiple-value-bind (result_more_pair rest_more_pair) 
              (is-value (cdr more_pair))
            (if (null result_more_pair)
                (error "ERROR: syntax error")
              (values (list result result_more_pair) rest_more_pair)))
        (error "ERROR: syntax error")))))
          
;;;; is-array

(defun is-array (array)
  (if (eql (car array) #\[)
      (if (eql (second array) #\])
          (values (list 'json-array) (cdr (cdr array)))
        (multiple-value-bind (result more_array) 
            (is-element (cdr array))
          (if (eql (car more_array) #\])
              (values (cons 'json-array result) (cdr more_array))
            (error "ERROR: syntax error"))))
    (values nil array)))

;;;; is-member

(defun is-member (member)
  (multiple-value-bind (result more_member) 
      (is-pair member)
    (if (null result)
        (error "ERROR: syntax error")
      (if (eql (car more_member) #\,)
          (multiple-value-bind (result_more_member rest_more_member) 
              (is-member (cdr more_member))
            (if (null result_more_member)
                (error "ERROR: syntax error")
              (values (cons result result_more_member) rest_more_member)))
        (values (cons result nil) more_member)))))

;;;; is-element

(defun is-element (element)
  (multiple-value-bind (result more_element) 
      (is-value element)
    (if (null result)
        (error "ERROR: syntax error")
      (if (eql (car more_element) #\,)
          (multiple-value-bind (result_more_element rest_more_element) 
              (is-element (cdr more_element))
            (if (null result_more_element)
                (error "ERROR: syntax error")
              (values (cons result result_more_element) rest_more_element)))
        (values (cons result nil) more_element)))))
            
;;;; is-value

(defun is-value (value)
  (cond ((eql (car value) #\{) 
         (is-object value))
        ((eql (car value) #\[) 
         (is-array value))
        ((or (eql (car value) #\") 
             (eql (car value) #\')) 
         (is-string value))
        ((or (eql (car value) #\+) 
             (eql (car value) #\-) 
             (digit-char-p (car value))) (is-number value))
        (T (error "ERROR: syntax error"))))
         
;;;; is-number

(defun is-number (number)
  (cond ((or (eql (car number) #\-) 
             (eql (car number) #\+)
             (digit-char-p (car number)))
         (multiple-value-bind (result more_number) 
             (is-integer (cdr number))
           (values (car (multiple-value-list 
                         (read-from-string 
                          (coerce 
                           (cons (car number) result) 'string)))) more_number)))
        (T (error "ERROR: syntax error"))))

;;;; is-integer

(defun is-integer (integer)
  (if (null (car integer)) nil
    (cond ((and (eql (car integer) #\.)
                (digit-char-p (second integer)))
           (multiple-value-bind (result more_integer) 
               (is-float (cdr integer))
             (values (cons (car integer) result) more_integer)))
          ((digit-char-p (car integer))
           (multiple-value-bind (result more_integer) 
               (is-integer (cdr integer))
             (values (cons (car integer) result) more_integer)))
          (T (values nil integer)))))  
                                                                            
;;;; is-float

(defun is-float (float)
  (if (null (car float)) nil
    (if (digit-char-p (car float))
        (multiple-value-bind (result more_float) 
            (is-float (cdr float))
          (values (cons (car float) result) more_float))
      (values nil float))))
     
;;;; is-string

(defun is-string (string)
  (cond ((eql (car string) #\")
         (multiple-value-bind (result more_string_uno) 
             (is-some-chars-uno (cdr string) (car string))
           (values (coerce result 'string) more_string_uno)))
        ((eql (car string) #\')
         (multiple-value-bind (result more_string_due) 
             (is-some-chars-due (cdr string) (car string))
           (values (coerce result 'string) more_string_due)))
        (T (error "ERROR: syntax error"))))
 
;;;; is-some-chars-uno

(defun is-some-chars-uno (chars end)
  (if (eql (car chars) end) (values nil (cdr chars))
    (if (and (<= (char-int (car chars)) 128) 
             (<= (char-int (car chars)) 128))
        (multiple-value-bind (result more_chars) 
            (is-some-chars-uno (cdr chars) end)
          (values (cons (car chars) result) more_chars))
      (error "ERROR: syntax error"))))

;;;; is-any-chars-due

(defun is-some-chars-due (chars end)
  (if (eql (car chars) end) (values nil (cdr chars))
    (if (and (<= (char-int (car chars)) 128) 
             (<= (char-int (car chars)) 128))
        (multiple-value-bind (result more_chars) 
            (is-some-chars-due (cdr chars) end)
          (values (cons (car chars) result) more_chars))
      (error "ERROR: syntax error"))))

;;;; jsonaccess

(defun jsonaccess (json &rest fields)
  (if (null json)
      (error "ERROR: syntax error")
    (if (null fields)
        json
      (let ((head (car json)))
        (cond ((eq head 'jsonobj)
               (let ((field (assoc (car fields)
                                   (cdr json)
                                   :test 'equalp)))
                 (jsonaccess-due (second field) fields)))
              ((eq head 'json-array)
               (if (numberp (car fields))
                   (let ((field (nth (car fields)
                                     (cdr json))))
                     (jsonaccess-due field fields))
                 (error "ERROR: syntax error")))
              (T (error "ERROR: syntax error")))))))

(defun jsonaccess-due (field fields)
  (if (null field)
      (error "ERROR: syntax error")
    (apply 'jsonaccess field (cdr fields))))

;;;; jsonread
(defun jsonread (filename)
  (with-open-file (in filename
                      :direction :input
                      :if-does-not-exist :error)
    (jsonparse (coerce (read-line in) 'string))))

;;;; jsondump

(defun jsondump (json filename)
  (if (or (null json)
          (null filename))
      (error "ERROR: jsondump")
    (with-open-file (out filename
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (format out "~A" (coerce (fix (or (write-object json)
                                            (write-array json))) 'string))))
  filename)

(defun write-object (json)
  (if (eq (car json) 'jsonobj)
      (if (null (cdr json)) 
          (list #\{ #\})
        (list #\{ (write-pair (cdr json)) #\}))
    nil))


(defun write-array (json)
  (if (eq (car json) 'json-array)
      (if (null (cdr json)) 
          (list #\[ #\])
        (list #\[ (write-element (cdr json)) #\]))
    nil))

(defun write-pair (json)
  (if (null (cdr json))
      (list (write-value (car (car json)))
            #\:
            (write-value (car (cdr (car json)))))
    (list (write-value (car (car json)))
          #\:
          (write-value (car (cdr (car json))))
          #\,
          (write-pair (cdr json)))))

(defun write-element (json)
  (if (null (cdr json))
      (list (write-value (car json)))
    (list (write-value (car json))
          #\,
          (write-element (cdr json)))))

(defun write-value (json)
  (cond ((null json)
         nil)
        ((numberp json)
         (coerce (write-to-string json) 'list))
        ((stringp json)
         (list #\" (coerce json 'list) #\"))
        ((eq (car json) 'jsonobj)
         (write-object json))
        ((eq (car json) 'json-array)
         (write-array json))))

(defun fix (x)
  (cond ((null x)
         x)
        ((atom x)
         (list x))
        (T (append (fix (first x))
                   (fix (rest x))))))
              
;;;; skip-spaces

(defun skip-spaces (list)
  (let ((head (car list)))
    (cond ((or (eql head #\Space)
               (eql head #\Tab)
               (eql head #\NewLine))
           (skip-spaces (cdr list)))
          ((or (eql head #\") 
               (eql head #\')) 
           (cons head (skip-spaces-due (cdr list) head)))
          ((null head) nil)
          (T (cons head (skip-spaces (cdr list)))))))

(defun skip-spaces-due (list end)
  (let ((head (car list)))
    (cond ((null head) nil)
          ((eql head end) (cons head (skip-spaces (cdr list))))
          (T (cons head (skip-spaces-due (cdr list) end))))))

;;;; end of file -- json-parsing.lisp --