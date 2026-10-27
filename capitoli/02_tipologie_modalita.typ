#import "../utils.typ": *

= Tipologie e cicli di vita degli ordini

In questo capitolo vengono riportati tutti i tipi di ordini possibili, determinati univocamente dalla valorizzazione dei campi in _order_, e il loro ciclo di vita in base alla modalità di esecuzione scelta.

Il tipo e lo stato di un ordine e delle sue comande sono identificabili dal valore dei campi in _order_ e _ticket_, che possono variare dopo la creazione dell'ordine. I campi delle altre tabelle associate all'ordine (_order_product_, _order_menu_ e sotto-tabelle) invece non mutano dopo la creazione, a meno di modifiche dell'ordine.

#include "tipologie/tipologie.typ"
#pagebreak()
#include "tipologie/modalita.typ"
