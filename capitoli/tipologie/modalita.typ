#import "../../utils.typ": *

== Modalità di servizio

=== 1. Ordine in sala con conferma

Questo ciclo di ordini è consentito solo se nelle impostazioni _order_requires_confirmation_ è impostato a #TRUE, altrimenti questa modalità è preclusa e per poter creare un nuovo ordine da servire in sala bisogna avvalersi della modalità descritta in seguito "Ordine con tavolo già inserito".

#table(
  columns: (2fr, 2fr, 4fr),
  table.cell(colspan: 3)[order],
  table.header([*Campo*], [*Dopo la creazione*], [*Dopo la conferma*]),
  [_guests_], table.cell(colspan: 2)[Numero > 0],
  [_take_away_type_], table.cell(colspan: 2)[#NULL],
  [_table_], [#NULL], [Numero del tavolo],
  [_needs_confirmation_], table.cell(colspan: 2)[#TRUE],
  [_has_tickets_], table.cell(colspan: 2)[#TRUE],
  [_created_at_], table.cell(colspan: 2)[Data e ora di creazione dell'ordine],
  [_confirmed_at_], [#NULL], text(fill: blue1, weight: "bold")[#flash Data e ora di conferma],
  [_confirmed_by_id_], [#NULL], [Id dell'utente che conferma],
  [_parent_order_id_], table.cell(colspan: 2)[#NULL],
)

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 3fr),
  table.cell(colspan: 5)[ticket],
	table.header([*Campo*], text(hyphenate: false)[*Dopo la\ creazione*], text(hyphenate: false)[*Dopo la\ conferma*], [*Dopo la\ stampa*], [*Dopo il completamento*]),
	[_printed_at_], table.cell(colspan: 2)[#NULL], table.cell(colspan: 2)[Data e ora di stampa],
	[_completed_at_], table.cell(colspan: 3)[#NULL], text(fill: blue1, weight: "bold")[#flash Data e ora del completamento]
)

Eventi scatenanti: conferma dell'ordine e completamento di comande di categorie genitrici.

=== 2. Ordine in sala con tavolo già inserito

Questa modalità è usata sia per i nuovi ordini in sala (disponibile solo se _order_requires_confirmation_ è #FALSE) che per gli ordini di aggiunta.

Le comande seguono lo stesso ciclo di vita descritto sopra, con l'unica differenza che al posto della conferma dell'ordine l'evento scatenante diventa la creazione dell'ordine. Anche se sono stati impostati dei tempi di attesa nulli la stampa avviene al primo ciclo utile, quindi per un breve lasso di tempo _printed_at_ resta valorizzato a #NULL.

Al momento della creazione, le uniche differenze nei campi con la modalità "con conferma" per i nuovi ordini in sala sono _table_ (qui obbligatorio) e _needs_confirmation_, mentre per gli ordini di aggiunta è richiesto che _guests_ sia #NULL, inoltre il completamento di una comanda non è un evento scatenante in quanto le categorie figlie negli ordini di aggiunta vengono collassate.

#table(
  columns: (2fr, 6fr),
  table.cell(colspan: 2)[order],
  table.header([*Campo*], [*Dopo la creazione*]),
  [_guests_], [Numero > 0 oppure #NULL (per le aggiunte)],
  [_take_away_type_], [#NULL],
  [_table_], [Numero del tavolo],
  [_needs_confirmation_], [#FALSE],
  [_has_tickets_], [#TRUE],
  [_created_at_], text(fill: blue1, weight: "bold")[#flash Data e ora di creazione dell'ordine],
  [_confirmed_at_], [#NULL],
  [_confirmed_by_id_], [#NULL],
  [_parent_order_id_], [#NULL],
)

#table(
  columns: (1fr, 1.4fr, 1.4fr, 2.4fr),
  table.cell(colspan: 4)[ticket],
	table.header([*Campo*], [*Dopo la creazione*], [*Dopo la stampa*], [*Dopo il completamento*]),
	[_printed_at_], [#NULL], table.cell(colspan: 2)[Data e ora di stampa],
	[_completed_at_], table.cell(colspan: 2)[#NULL], text(fill: blue1, weight: "bold")[(#flash) Data e ora del completamento]
)

=== 3. Ordine di aggiunta collegato al principale
Possibile solo se si conosce l'id dell'ordine principale, funziona allo stesso modo di un ordine in sala con tavolo già inserito, con l'unica differenza che non occorre inserire nuovamente il numero del tavolo e il nome del cliente.

La modalità di aggiunta collegata è compatibile con la modalità Flash e incompatibile con gli ordini per asporto.

#table(
  columns: (2fr, 6fr),
  table.cell(colspan: 2)[order],
  table.header([*Campo*], [*Dopo la creazione*]),
  [_guests_], [#NULL],
  [_take_away_type_], [#NULL],
  [_table_], [#NULL],
  [_needs_confirmation_], [#FALSE],
  [_has_tickets_], [#TRUE oppure #FALSE (vedi mod. 4)],
  [_created_at_], text(fill: blue1, weight: "bold")[#flash Data e ora di creazione dell'ordine],
  [_confirmed_at_], [#NULL],
  [_confirmed_by_id_], [#NULL],
  [_parent_order_id_], [Id dell'ordine genitore, da cui viene prelevato il numero del tavolo],
)

#table(
  columns: (1fr, 1.4fr, 1.4fr, 2.4fr),
  table.cell(colspan: 4)[ticket],
	table.header([*Campo*], [*Dopo la creazione*], [*Dopo la stampa*], [*Dopo il completamento*]),
	[_printed_at_], [#NULL], table.cell(colspan: 2)[Data e ora di stampa],
	[_completed_at_], table.cell(colspan: 2)[#NULL], [Data e ora del completamento]
)

=== 4. Ordine Flash

Questo tipo di ordine non prevede la stampa di comande e il suo ciclo di vita termina immediatamente dopo la creazione dell'ordine.

La modalità  Flash è compatibile con la modalità di aggiunta collegata e incompatibile con gli ordini per asporto.

#table(
  columns: (2fr, 6fr),
  table.cell(colspan: 2)[order],
  table.header([*Campo*], [*Dopo la creazione*]),
  [_guests_], [#NULL],
  [_take_away_type_], [#NULL],
  [_table_], [#NULL],
  [_needs_confirmation_], [#FALSE],
  [_has_tickets_], [#FALSE],
  [_created_at_], [Data e ora di creazione dell'ordine],
  [_confirmed_at_], [#NULL],
  [_confirmed_by_id_], [#NULL],
  [_parent_order_id_], [#NULL (facoltativo, vedi mod. 3)],
)

=== 5. Ordine per asporto

Modalità analoga a quella di un ordine in sala con tavolo già inserito all'atto della creazione (quindi un ordine che non richiede la conferma e senza un ordine genitore), con l'unica differenza che la data del completamento delle comande non è un evento scatenante per altre comande dato che tutte le categorie collassano in quella relativa al tipo di asporto scelto.

Per poter emettere un ordine da asporto, deve esistere almeno una categoria d'asporto.

#table(
  columns: (2fr, 6fr),
  table.cell(colspan: 2)[order],
  table.header([*Campo*], [*Dopo la creazione*]),
  [_guests_], [#NULL],
  [_take_away_type_], [Tipo di asporto],
  [_table_], [#NULL],
  [_needs_confirmation_], [#FALSE],
  [_has_tickets_], [#TRUE],
  [_created_at_], text(fill: blue1, weight: "bold")[#flash Data e ora di creazione dell'ordine],
  [_confirmed_at_], [#NULL],
  [_confirmed_by_id_], [#NULL],
  [_parent_order_id_], [#NULL],
)

#table(
  columns: (1fr, 1.4fr, 1.4fr, 2.4fr),
  table.cell(colspan: 4)[ticket],
	table.header([*Campo*], [*Dopo la creazione*], [*Dopo la stampa*], [*Dopo il completamento*]),
	[_printed_at_], [#NULL], table.cell(colspan: 2)[Data e ora di stampa],
	[_completed_at_], table.cell(colspan: 2)[#NULL], [Data e ora del completamento]
)
