#import "../../utils.typ": *

== Elementi di listino

=== Prodotti

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[product],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(64)` #h(1fr) #unique #notnull], [Nome visualizzato nella ricevuta del cliente],
  [_short_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [Nome visualizzato nell'interfaccia dei cassieri],
  [_print_name_], [`VARCHAR(64)` #h(1fr) #unique #notnull], [Nome visualizzato nelle comande],
  [_is_priority_], [`BOOL` #h(1fr) #notnull], [],
  [_is_main_], [`BOOL` #h(1fr) #notnull], [Indica se un prodotto è una portata principale (generalmente un primo o un secondo) oppure no],
  [_price_], [`DECIMAL(10,2)` #h(1fr) #notnull], [],
  [_category_id_ #foreignkey], [`INT`], [`ON_DELETE = RESTRICT`\ La categoria a cui appartiene il prodotto, ossia su quale comanda verrà stampato.\ Può non appartenere a nessuna categoria],
  [_subgroup_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`\ Un raggruppamento dei prodotti, utile solo per l'interfaccia dei cassieri],
  [_order_], [`INT` #h(1fr) #notnull], [Ordinamento dei prodotti],
  [_daily_max_sales_], [`INT`], [Massima quantità vendibile giornalmente del prodotto],
  [_color_], [`VARCHAR(7)`], [Colore del bottone nell'interfaccia dei cassieri, nel formato '\#eb4f34'],
)

Per essere vendibile da un cassiere, il prodotto deve essere associato al ruolo di quell'utente tramite _product_role_ e attivo in almeno un intervallo di date in _product_date_.

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[product_role],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_product_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_role_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
)

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[product_date],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_start_date_], [`DATETIME` #h(1fr) #notnull], [],
  [_end_date_], [`DATETIME` #h(1fr) #notnull], [],
  [_product_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
)

/*
TODO:
* Rimuovere daily_max_sales in quanto già gestito da stock (?)
*	Documentare product_variant
*/

=== Raggruppamenti

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[group],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_order_], [`INT` #h(1fr) #notnull], [Ordinamento dei gruppi, ha priorità massima sull'ordinamento dei prodotti],
)

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[subgroup],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_order_], [`INT` #h(1fr) #notnull], [Ordinamento dei sottogruppi, ha priorità inferiore a quello dei gruppi e superiore all'ordinamento dei prodotti],
  [_include_cover_charge_], [`BOOL` #h(1fr) #notnull], [Il costo del coperto è aggiunto solo se nell'ordine viene inserito almeno un prodotto di un sottogruppo con questo campo asserito],
  [_group_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
)

=== Ingredienti

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[ingredient],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_ward_], [`VARCHAR(16)` #h(1fr) #notnull], [Reparto dove viene preparato l'ingrediente, utile al raggruppamento nel monitor cucina],
  [_is_deleted_], [`BOOL` #h(1fr) #notnull], [],
  [_is_monitored_], [`BOOL` #h(1fr) #notnull], [Se non asserito, l'ingrediente non compare nel monitor cucina. Serve per nascondere alcuni ingredienti poco importanti e seguire l'andamento solo dei principali],
  [_sell_if_stocked_], [`BOOL` #h(1fr) #notnull], ["Vendi solo se stoccato"\ Se questo campo è asserito le vendite vengono bloccate se la quantità stoccata scende a 0 o se non è stato aggiungo alcuno stock per l'ingrediente, altrimenti la vendita è libera e senza alcun controllo],
  [_cooking_time_], [`INT`], [Tempo di cottura dell'ingrediente, espresso in secondi],
  [_target_quantity_], [`DECIMAL(10,2)`], [Da reimpostare all'inizio di ogni turno in base alle statistiche passate. Indica le unità da preparare per l'ingrediente e aiuta a evidenziare una differenza rispetto alla statistica passata],
)

Un ingrediente può essere associato a più prodotti e viceversa, tramite _product_ingredient_.

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[product_ingredient],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_product_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_ingredient_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = RESTRICT`],
  [_price_], [`DECIMAL(10,2)` #h(1fr) #notnull], [Prezzo aggiuntivo per il prodotto se l'ingrediente viene selezionato],
  [_max_quantity_], [`DECIMAL(10,2)` #h(1fr) #notnull], [Se l'ingrediente è facoltativo (_is_default_ = #FALSE) è la massima quantità selezionabile dell'ingrediente per il prodotto in questione\ Se l'ingrediente è obbligatorio (_is_default_ = #TRUE) è la quantità che di regola viene venduta assieme al prodotto],
  [_is_default_], [`BOOL` #h(1fr) #notnull], [Indica se l'ingrediente è obbligatorio per il prodotto (la quantità indicata viene venduta automaticamente assieme al prodotto) oppure se è a scelta libera, es. ingredienti per la farcitura di un panino],
  [_is_deleted_], [`BOOL` #h(1fr) #notnull], [],
)

Solo se l'ingrediente è facoltativo, la quantità selezionata al momento della vendita viene indicata in un apposito record in _order_product_ingredient_, altrimenti se l'ingrediente è obbligatorio non viene aggiunto nessun record in quella tabella al momento della vendita.

Per ogni ingrediente possono essere aggiunti uno o più _stock_.

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[stock],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_ingredient_id_ #foreignkey], [`INT` #h(1fr) #notnull], [`ON_DELETE = CASCADE`],
  [_quantity_], [`DECIMAL(10,2)` #h(1fr) #notnull], [],
  [_available_from_], [`DATETIME` #h(1fr) #notnull], [Data e ora in cui viene aggiunto lo stock],
  [_is_valid_], [`BOOL` #h(1fr) #notnull], [Indica se lo stock è ancora da considerare valido, se non lo è corrisponde a una cancellazione logica del record],
)

Per il calcolo delle quantità residue di un ingrediente vengono sommate tutte le quantità degli stock contrassegnati come validi, e sottratte le quantità vendute negli ordini effettuati (_created_at_) dopo l'aggiunta (_available_from_) del primo stock valido.

Esempio:
-	18:00	- aggiunto stock *1* di $100$ (poi contrassegnato come non valido)
-	19:00	- venduti $5$
-	19:05	- aggiunto stock *2* di $100$ (valido)
-	19:30	- venduti altri $40$
-	20:00	- aggiunto stock *3* di $100$ (valido)
-	20:05	- aggiunto stock *4* di $50$ (poi contrassegnato come non valido)
-	20:30	- venduti altri $50$

Alle 20:30, con solo gli stock *2* e *3* validi, le quantità residue sono $100 + 100 - (40 + 50) = 110$. Le prime $5$ unità vendute non vengono sottratte in quanto antecedenti all'orario di inserimento del primo stock valido (il *2*).

// TODO: Documentare menu, menu_role, menu_date, menu_field e menu_field_product
