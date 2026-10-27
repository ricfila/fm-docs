#import "../../utils.typ": *

== Ordinazioni

=== Ordini

#table(
  columns: (1.4fr, 1fr, 3fr),
  table.cell(colspan: 3)[order],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_customer_], [`VARCHAR(32)` #h(1fr) #notnull], [Nome del cliente],
  [_guests_], [`INT`], [Numero di coperti, #NULL se non è un ordine principale per la sala],
  [_take_away_type_], [`INT`], [Indica il tipo di asporto dell'ordine, #NULL se non lo è],
  [_table_], [`VARCHAR(32)`], [Tavolo dov'è seduto il cliente, #NULL se non è previsto (ad esempio se è per asporto) o se l'ordine deve ancora essere confermato],
  [_needs_confirmation_], [`BOOL` #h(1fr) #notnull], [#TRUE se l'ordine richiede la conferma. Viene determinato dal back-end all'atto della creazione dell'ordine (vedere la sezione "Tipologie e cicli di vita degli ordini" per un maggior approfondimento). Se _order_requires_confirmation_ è #FALSE anche questo campo sarà sempre #FALSE.],
  [_is_deleted_], [`BOOL` #h(1fr) #notnull], [],
  [_is_voucher_], [`BOOL` #h(1fr) #notnull], [#TRUE se l'ordine è in omaggio, il totale sarà forzato a 0.],
  [_is_for_service_], [`BOOL` #h(1fr) #notnull], [#TRUE se l'ordine è per il personale di servizio],
  [_has_tickets_], [`BOOL` #h(1fr) #notnull], [#TRUE se all'ordine sono associate delle comande, se è #FALSE l'ordine è di tipo "Flash"],
  [_notes_], [`VARCHAR(64)`], [Eventuali note per il cameriere o per la cucina, vengono stampate sulla ricevuta e su tutte le comande],
  [_price_], [`DECIMAL(10,2)` #h(1fr) #notnull], [Totale pagato, può essere discordante dalla somma dei prezzi dei prodotti per omaggi o sconti, e include l'eventuale costo dei coperti],
  [_created_at_], [`DATETIME` #h(1fr) #notnull], [Data e ora di creazione dell'ordine],
  [_confirmed_at_], [`DATETIME`], [Data e ora di conferma dell'ordine, #NULL se l'ordine non ha bisogno di conferma o se deve ancora essere confermato],
  [_confirmed_by_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`],
  [_parent_order_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`\ Se l'ordine è un'aggiunta a un ordine preesistente, qui vi è indicato l'id di tale ordine. Si crea un ordine secondario quando non si prevede il pagamento del coperto],
  [_payment_method_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
  [_user_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`],
)

I campi della tabella definiscono univocamente il tipo di ordine, e la fase in cui si trova; vedere la sezione "Tipologie e cicli di vita degli ordini".

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[payment_method],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_order_], [`INT` #h(1fr) #notnull], [Campo di ordinamento],
  [_is_deleted_], [`BOOL` #h(1fr) #notnull], [],
)

#table(
  columns: (1.4fr, 1fr, 3fr),
  table.cell(colspan: 3)[order_product],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_price_], [`DECIMAL(10,2)` #h(1fr) #notnull], [Prezzo totale pagato per questo prodotto (già moltiplicato per la quantità venduta).\ È una piccola ridondanza (può essere ricavato con una query sui prodotti associati) anche per una questione di contabilità futura: se i prodotti o gli ingredienti selezionabili cambiano prezzo, il totale che è stato effettivamente pagato resta salvato qui],
  [_quantity_], [`INT` #h(1fr) #notnull], [],
  [_notes_], [`VARCHAR(64)`], [],
  [_order_id_ #foreignkey], [], [`ON_DELETE = CASCADE`],
  [_product_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
  [_variant_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`],
  [_order_menu_field_id_ #foreignkey], [`INT`], [`ON_DELETE = CASCADE`],
  [_category_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`\ Può non coincidere con la categoria del prodotto nel listino: qui è indicata la categoria sulla quale questo prodotto è collassato in quest'ordine per eventuale scarto della sua categoria originale],
)

#table(
  columns: (1.4fr, 1fr, 3fr),
  table.cell(colspan: 3)[order_product_ingredient],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_quantity_], [`DECIMAL(10,2)` #h(1fr) #notnull], [],
  [_order_product_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_ingredient_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
)

Contiene record solo degli ingredienti facoltativi che sono stati selezionati in quest'ordine, gli ingredienti obbligatori vengono anch'essi venduti ma siccome la quantità è fissa, l'ammontare delle quantità vendute può essere ricavato con una query sulle tabelle di listino.

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[revision],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_revised_at_], [`DATETIME` #h(1fr) #notnull], [],
  [_price_difference_], [`DECIMAL(10,2)` #h(1fr) #notnull], [],
  [_edited_products_], [`INT` #h(1fr) #notnull], [],
  [_order_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_user_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`\ Id dell'utente che effettua la modifica],
)

//TODO: Documentare order_menu e order_menu_field.

=== Categorie, comande e stampanti

Le categorie, nelle quali sono suddivisi i prodotti, sono la matrice per la generazione delle comande (_ticket_) dell'ordine sulle quali i prodotti andranno effettivamente a confluire nella stampa.

Non tutte le categorie avranno necessariamente la loro comanda corrispondente quando viene creato un ordine, se un articolo dell'ordine appartiene a una categoria che è stata scartata durante la generazione delle comande, questo confluisce nella comanda di una categoria genitrice secondo quanto specificato nella categoria originale del prodotto.

#table(
  columns: (2.1fr, 1.2fr, 3fr),
  table.cell(colspan: 3)[category],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_print_delay_], [`INT` #h(1fr) #notnull], [Tempo di attesa, espresso in secondi, tra l'evento scatenante di questa categoria e la stampa. Notare che a questo si somma sempre _delay_after_confirmation_ (anch'esso in secondi) se l'evento scatenante è la conferma.],
  [_wait_parent_category_], [`BOOL` #h(1fr) #notnull], [Se #TRUE, l'evento scatenante la stampa di questa categoria è il completamento della comanda della categoria genitrice (si intende sempre la categoria indicata in _parent_category_);\ Se #FALSE, l'evento scatenante è la conferma o la creazione dell'ordine.],
  [_take_away_type_], [`INT` /* TODO: unique e foreign key a questo campo su order.take_away_type */], [Se valorizzato, definisce la categoria come d'asporto per un determinato tipo. Non ci possono essere più categorie d'asporto con lo stesso tipo e le categorie d'asporto devono necessariamente essere orfane (campi parent... tutti a #NULL).],
  [_parent_category_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`],
  [_parent_for_main_products_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`],
  [_printer_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
)

All'atto di creazione dell'ordine, si decide quali categorie far collassare nelle rispettive genitrici secondo le seguenti regole, in ordine di priorità:

+ *Ordini per asporto:* se l'ordine è per asporto, tutte le categorie collassano su quella che ha _take_away_type_ corrispondente al tipo di asporto selezionato per l'ordine.

+ *Quantità di prodotti principali:* se la quantità dei prodotti principali presenti nella categoria genitrice _parent_for_main_products_ è inferiore al numero di coperti, la categoria collassa in tale categoria genitrice. Il controllo (e il possibile collasso) avviene solo se il numero di coperti non supera _max_guests_for_main_products_ o se quest'ultimo campo non è valorizzato.

+ *Ordini di aggiunta:* se l'ordine è di tipo aggiunta, tutte le categorie con una _parent_category_ vi collassano, anche se non sarebbero orfane.

+ *Orfanità:* Le categorie che hanno indicata una categoria genitrice _parent_category_ non possono essere orfane. Le categorie orfane per assenza delle suddette categorie genitrici perché non previste dall'ordine vengono collassate nelle rispettive _parent_category_, che vengono forzate ad esserci se assenti. Se una categoria genitrice è stata collassata precedentemente, anche la categoria orfana viene dirottata sulla categoria sulla quale è collassata la genitrice.

Per ogni prodotto in _order_product_ viene aggiornato il campo _category_id_ con l'id della categoria alla quale sarà destinato per quest'ordine dopo il collasso.

Per le categorie non collassate viene generata una comanda con un record in _ticket_.

#table(
  columns: (2fr, 1.2fr, 3fr),
  table.cell(colspan: 3)[ticket],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_printed_at_], [`TIMESTAMP`], [Data e ora in cui è avvenuta la stampa, se è #NULL la stampa deve ancora avvenire anche se l'orario previsto è già determinato (ossia se l'evento scatenante si è già verificato). Questo per distinguere più chiaramente le comande già stampate dalle altre],
  [_completed_at_], [`TIMESTAMP`], [Data e ora di completamento (evasione) della comanda, se è #NULL è ancora in attesa di stampa o in lavorazione],
  [_has_collapsed_categories_], [`BOOL` #h(1fr) #notnull], [],
  [_order_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_category_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
)

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[printer],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_ip_address_], [`VARCHAR(15)` #h(1fr) #unique #notnull], [],
)

//TODO: Documentare order_printer e role_printer.
