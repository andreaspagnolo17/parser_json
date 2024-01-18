SPAGNOLO ANDREA 879254

SPIEGAZIONE CODICE

jsonparse: 
risulta vero se JSONString (una stringa SWI Prolog o un atomo Prolog) può venire scorporata come stringa, numero, o nei termini composti: 
Object = jsonobj(Members) 
Object = jsonarray(Elements)
 e ricorsivamente: 
Members = [] or 
Members = [Pair | MoreMembers]
Pair = (Attribute, Value) 
Attribute = <string SWI prolog>
Number = <numero prolog>
Value = <string SWI prolog> | Number | Object 
Elements = [] or 
Elements = [Value | MoreElements]

jsonobj:
cerca di applicare l'operatore =.. per dividere le coppie usando ',', prenderne una per volta
e passarle al json_member, da cui ottiene i membri parsati con cui comporre una lista.

json_member:
cerca di applicare l'operatore =.. per dividere attributo e value usando ':' per poi
validarli separatamente, chiamando json_pair, oltre che ricostruire la coppia coi valori parsati da esso.

json_pair:
Controlla che l'attributo sia una stringa passando value al predicato is_value, compattando poi il value parsato con l’attributo.

is_value:
La funzione accetta come input un valore JSON e restituisce un valore manipolato. La funzione utilizza una serie di clausole per verificare se il valore è una stringa, un numero, un array vuoto o un oggetto JSON.
La prima clausola is_value([], []) è utilizzata per verificare se il valore è un array vuoto e restituisce un array vuoto.
La seconda clausola is_value(Value, Value) verifica se il valore è una stringa e restituisce la stringa.
La terza clausola is_value(Value, Value) verifica se il valore è un numero e restituisce il numero.
La quarta clausola is_value(Value, ValueParsed) utilizza la funzione jsonparse per verificare se il valore è un oggetto o un array JSON e restituisce l'oggetto o l'array manipolato.

Jsonaccess:
risulta vero quando Result è recuperabile seguendo la catena di campi presenti in Fields (una lista) a partire da Jsonobj. Un campo rappresentato da N (con N un numero maggiore o uguale a 0) corrisponde a un indice di un array JSON.

Jsonread:
apre il file FileName e ha successo se riesce a costruire un oggetto JSON. Se FileName non esiste il predicato fallisce.

Jsondump:
scrive l’oggetto JSON sul file FileName in sintassi JSON. Se FileName non esiste, viene creato e se esiste viene sovrascritto.

