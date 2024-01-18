SPAGNOLO ANDREA 879254

SPIEGAZIONE CODICE

Jsonparse:
Questa è una funzione LISP che analizza una stringa JSON e la restituisce come un oggetto LISP. In primo luogo, utilizza la funzione "coerce" per convertire la stringa JSON in una lista e quindi utilizza la funzione "skip-spaces" per rimuovere gli spazi vuoti dalla lista. Utilizza poi una funzione "or" per controllare se la lista è un oggetto o un array chiamando rispettivamente le funzioni "is-object" e "is-array". Se nessuna di queste condizioni viene soddisfatta, restituisce un messaggio di errore "ERROR: syntax error”.

Is-object:
Questa è una funzione LISP che controlla se l'input "obj" è un oggetto JSON. Inizia controllando se il primo elemento di "obj" è una parentesi graffa aperta. Se lo è, quindi controlla se il secondo elemento è una parentesi graffa chiusa. Se lo è, la funzione restituisce una lista contenente il simbolo 'jsonobj' e il resto della lista "obj".
Altrimenti utilizza la funzione "is-member" per controllare se "obj" è una lista di coppie chiave-valore e restituisce il risultato insieme al resto della lista "obj". Se il primo elemento di "more_object" non è una parentesi graffa chiusa, viene restituito un messaggio di errore "ERROR: syntax error".


Is-member:
Questa è una funzione LISP che controlla se un determinato "membro" fa parte di una lista. Utilizza multiple-value-bind per associare il risultato della funzione "is-pair" alle variabili "result" e "more_member". La funzione quindi controlla se il risultato è nullo e restituisce un errore se lo è. Se il risultato non è nullo, controlla se il primo elemento di "more_member" è una virgola. Se lo è, la funzione chiama ricorsivamente la funzione "is-member" con il "cdr" di "more_member" e associa il risultato alle variabili "result_more_member" e "rest_more_member". Se "result_more_member" è nullo, viene restituito un errore, altrimenti la funzione restituisce una nuova lista contenente "result" e "result_more_member" e "rest_more_member". Se il primo elemento di "more_member" non è una virgola, la funzione restituisce una lista contenente solo "result" e “more_member".

Is-pair:
Questa è una funzione LISP che controlla se l'input "pair" è una coppia chiave-valore JSON. Utilizza la funzione "is-string" per controllare se l'input è una stringa e associa il risultato alla variabile "result" e "more_pair".
Se "result" o "more_pair" sono nulli, la funzione restituisce un errore "ERROR: syntax error"
Se il primo elemento di "more_pair" è un carattere ':' , la funzione utilizza la funzione "is-value" per controllare se l'input è un valore JSON e associa il risultato alla variabile "result_more_pair" e "rest_more_pair". Se "result_more_pair" è nullo, la funzione restituisce un errore "ERROR: syntax error", altrimenti restituisce una lista contenente la coppia chiave-valore e il resto della lista "more_pair".
Se il primo elemento di "more_pair" non è un carattere ':', la funzione restituisce un errore "ERROR: syntax error”.

Is-array:
Questa è una funzione LISP che controlla se l'input "array" è un array JSON. Inizia controllando se il primo elemento di "array" è un carattere "[". Se lo è, quindi controlla se il secondo elemento è un carattere "]". Se lo è, la funzione restituisce una lista contenente il simbolo 'json-array' e il resto della lista "array".
Altrimenti utilizza la funzione "is-element" per controllare se "array" è una lista di elementi JSON e restituisce il risultato insieme al resto della lista "array". Se il primo elemento di "more_array" non è un carattere "]", viene restituito un messaggio di errore "ERROR: syntax error".

Is-element:
Questa è una funzione LISP che controlla se l'input "element" è un elemento valido in un array JSON. Utilizza la funzione "is-value" per controllare se l'input è un valore valido e associa il risultato alla variabile "result" e "more_element". Se "result" è nullo, la funzione restituisce un errore "ERROR: syntax error".
Se il primo elemento di "more_element" è un carattere ',' , la funzione utilizza la funzione "is-element" ricorsivamente per controllare se ci sono altri elementi nell'array e associa il risultato alla variabile "result_more_element" e "rest_more_element". Se "result_more_element" è nullo, la funzione restituisce un errore "ERROR: syntax error", altrimenti restituisce una lista contenente gli elementi e il resto della lista "more_element".
Se il primo elemento di "more_element" non è un carattere ',' la funzione restituisce una lista contenente solo "result" e “more_element".

Is-value:
Questa è una funzione Lisp chiamata "is-value" che prende in input un singolo argomento, "value". La funzione utilizza una dichiarazione "cond" per controllare il primo carattere di "value" e determinare se è un oggetto, un array, una stringa o un numero. In caso contrario, genera un errore di sintassi.

Is-number:
Questa è una funzione Lisp chiamata "is-number" che prende in input un singolo argomento, "number". La funzione utilizza una dichiarazione "cond" per controllare se il primo carattere di "number" è un segno meno, un segno più o un numero. Utilizza quindi la funzione "is-integer" per verificare se il resto dei caratteri è un numero intero e legge il numero da una stringa utilizzando la funzione "read-from-string". In caso contrario, genera un errore di sintassi.

Is-integer:
Questa è una funzione Lisp chiamata "is-integer" che prende in input un singolo argomento, "integer". La funzione utilizza una dichiarazione "if" per controllare se "integer" è vuoto, in caso contrario utilizza un'altra dichiarazione "cond". Il primo ramo del "cond" controlla se il primo carattere di "integer" è un punto e il secondo carattere è un numero digitale, in questo caso utilizza la funzione "is-float" per verificare se il resto dei caratteri è un numero decimale e legge il numero da una stringa utilizzando la funzione "cons" per creare una nuova stringa. Il secondo ramo del "cond" controlla se il primo carattere di "integer" è un numero digitale, in questo caso utilizza la stessa logica di prima per verificare se il resto dei caratteri è un numero intero. In caso contrario, genera un errore di sintassi.

Is-float:
Questa è una funzione Lisp chiamata "is-float" che prende in input un singolo argomento, "float". La funzione utilizza una dichiarazione "if" per controllare se "float" è vuoto, in caso contrario utilizza un'altra dichiarazione "if". Il primo ramo del "if" controlla se il primo carattere di "float" è un numero, in questo caso utilizza la stessa logica utilizzata in "is-integer" per verificare se il resto dei caratteri è un numero decimale e crea una nuova stringa utilizzando la funzione "cons". Nel caso contrario, genera un errore di sintassi.

Is-string:
Questa è una funzione Lisp chiamata "is-string" che prende in input un singolo argomento, "string". La funzione utilizza una dichiarazione "cond" per controllare se il primo carattere di "string" è un virgolette doppie o virgolette singole. In caso contrario, genera un errore di sintassi. Nel caso delle virgolette doppie, utilizza la funzione "is-any-chars-uno" per verificare se il resto dei caratteri sono validi e crea una nuova stringa utilizzando la funzione "coerce". Nel caso delle virgolette singole, utilizza la stessa logica per verificare se il resto dei caratteri sono validi e crea una nuova stringa utilizzando la funzione “coerce".

Is-some-chars-uno:
Se il primo elemento  della stringa e` uguale al doppio apice (end) allora abbiamo finito di analizzare la stringa. Altrimenti se la testa e` un carattere ascii  allora utilizziamo la macro multiple-value-bind che valuta is-some-chars-uno e a result associa il carattere stesso che viene concatenato con il carattere ascii precedente (car chars). In caso contrario segnaliamo un errore.

Is-some-chars-due:
Se il primo elemento della stringa e` uguale al singolo apice (end)allora abbiamo finito di analizzare la stringa. Altrimenti se la testa e` un carattere ascii allora utilizziamo la macro multiple-value-bind 
che valuta is-some-chars-due e a result associa il carattere stesso che viene concatenato con il carattere ascii precedente (car chars). In caso contrario segnaliamo un errore.


Jsondump:
La funzione "jsondump" prende in ingresso un oggetto JSON e un nome di file. Se uno dei due parametri non è presente, genera un errore "ERROR: jsondump". Altrimenti, utilizza un file aperto con il nome specificato e sovrascrive eventuali file esistenti, creandolo se non esiste. Infine, scrive su tale file l'oggetto JSON in formato stringa. La funzione restituisce il nome del file.


Write-array:
La funzione "write-array" prende in input un oggetto "json" e verifica se il primo elemento dell'oggetto è 'json-array'. Se lo è, controlla se il resto dell'oggetto è vuoto. In caso affermativo, restituisce una lista con i caratteri '[' e ']'. Altrimenti, restituisce una lista con i caratteri '[', il risultato della funzione "write-element" applicata al resto dell'oggetto "json" e il carattere ']'. In caso contrario, la funzione restituisce nil.

Write-pair:
La funzione "write-pair" prende in input un oggetto "json" e controlla se il resto dell'oggetto è vuoto. Se lo è, restituisce una lista contenente il risultato della funzione "write-value" applicata al primo elemento dell'oggetto, il carattere ':', e il risultato della funzione "write-value" applicata al secondo elemento dell'oggetto. Altrimenti, restituisce una lista contenente il risultato della funzione "write-value" applicata al primo elemento dell'oggetto, il carattere ':', il risultato della funzione "write-value" applicata al secondo elemento dell'oggetto, il carattere ',', e il risultato della funzione "write-pair" applicata al resto dell'oggetto “json".

Write-element:
La funzione "write-element" prende in input un oggetto "json" e controlla se il resto dell'oggetto è vuoto. Se lo è, restituisce una lista contenente il risultato della funzione "write-value" applicata al primo elemento dell'oggetto. Altrimenti, restituisce una lista contenente il risultato della funzione "write-value" applicata al primo elemento dell'oggetto, il carattere ',', e il risultato della funzione "write-element" applicata al resto dell'oggetto “json".

Write-value:
La funzione "write-value" prende in input un oggetto "json" e utilizza la costruzione cond per determinare il tipo di dati. Se l'oggetto "json" è nullo, restituisce nil. Se l'oggetto è un numero, utilizza la funzione "write-to-string" per convertirlo in una stringa e quindi lo converte in una lista. Se l'oggetto è una stringa, restituisce una lista con il carattere '"' all'inizio e alla fine e la stringa convertita in una lista. Se l'oggetto è un oggetto json, utilizza la funzione "write-object" per elaborarlo. Se l'oggetto è un array json, utilizza la funzione "write-array" per elaborarlo.

Fix:
La funzione "fix" prende in input un oggetto "x" e utilizza la costruzione cond per determinare il suo tipo. Se l'oggetto "x" è nullo, restituisce x. Se l'oggetto è un atom, restituisce una lista contenente solo quell'atomo. Altrimenti, utilizza la funzione "fix" ricorsivamente sulla prima parte dell'oggetto e sulla restante parte dell'oggetto e le unisce tramite la funzione "append". In questo modo, la funzione "fix" "srotola" una lista nidificata in una lista piatta.

Jsonread:
"jsonread" è una funzione che prende come argomento il nome di un file. Utilizza la funzione "with-open-file" per aprire il file specificato e impostare la direzione di lettura su "input". Se il file non esiste, genera un errore. Utilizza la funzione "read-line" per leggere la prima riga del file e la converte in una stringa utilizzando "coerce". Infine utilizza la funzione "jsonparse" per analizzare il contenuto del file in formato JSON.

Jsonaccess:
"jsonaccess" è una funzione che prende come argomento un oggetto JSON e una serie di campi (opzionali). La funzione controlla prima se l'oggetto JSON è nullo, in caso contrario genera un errore. Se non ci sono campi specificati, restituisce l'oggetto JSON originale. Altrimenti, utilizza la funzione "let" per assegnare alla variabile "head" il primo elemento dell'oggetto JSON. Utilizza poi la funzione "cond" per controllare se "head" è uguale a "jsonobj" (oggetto JSON), "json-array" (array JSON) o nullo. Se è un oggetto JSON, utilizza la funzione "assoc" per trovare il campo specificato e passa quel valore insieme ai rimanenti campi alla funzione "jsonaccess-due". Se è un array JSON, utilizza la funzione "nth" per trovare l'elemento specificato e passa quel valore insieme ai rimanenti campi alla funzione "jsonaccess-due". In caso contrario, genera un errore.

Jsonaccess-due:
"jsonaccess-due" è una funzione che prende come argomenti un campo di un oggetto JSON e una serie di campi (opzionali). La funzione controlla prima se il campo è nullo, in caso contrario genera un errore. Utilizza la funzione "apply" per richiamare la funzione "jsonaccess" passando come argomenti il campo corrente e i rimanenti campi specificati. La funzione "apply" consente di applicare una funzione a una lista di argomenti invece di chiamare la funzione con un numero fisso di argomenti.

Skip-spaces:
"skip-spaces" è una funzione che prende come argomento una lista. Utilizza la funzione "let" per assegnare alla variabile "head" il primo elemento della lista. Utilizza poi la funzione "cond" per controllare se "head" è uno spazio bianco, un carattere di tabulazione, una nuova riga, una virgoletta o un apostrofo.
Se "head" è uno spazio bianco, un carattere di tabulazione o una nuova riga, la funzione richiama se stessa passando come argomento la lista privata del primo elemento.
Se "head" è una virgoletta o un apostrofo, la funzione utilizza la funzione "cons" per creare una nuova lista in cui il primo elemento è "head" e il resto della lista è ottenuta chiamando un'altra funzione “skip-spaces_due" passando come argomenti la lista privata del primo elemento e "head" stesso.
Se "head" è null, la funzione restituisce nil.
Se "head" è un altro tipo di carattere, la funzione utilizza la funzione "cons" per creare una nuova lista in cui il primo elemento è "head" e il resto della lista è ottenuta chiamando se stessa passando come argomento la lista privata del primo elemento.

Skip-spaces_due:
“skip-spaces_due" è una funzione che prende come argomenti una lista e un carattere di fine. Utilizza la funzione "let" per assegnare alla variabile "head" il primo elemento della lista. Utilizza poi la funzione "cond" per controllare se "head" è nullo, uguale al carattere di fine o un altro tipo di carattere.
Se "head" è null, la funzione restituisce nil.
Se "head" è uguale al carattere di fine, la funzione utilizza la funzione "cons" per creare una nuova lista in cui il primo elemento è "head" e il resto della lista è ottenuta chiamando la funzione "skip-spaces" passando come argomento la lista privata del primo elemento.
Se "head" è un altro tipo di carattere, la funzione utilizza la funzione "cons" per creare una nuova lista in cui il primo elemento è "head" e il resto della lista è ottenuta chiamando se stessa passando come argomenti la lista privata del primo elemento e il carattere di fine.