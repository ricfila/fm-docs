#import "../../utils.typ": *

== Configurazioni

=== Utenti

#table(
  columns: (1fr, 1fr, 3fr),
  table.cell(colspan: 3)[user],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_username_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_password_], [`TEXT` #h(1fr) #notnull], [],
  [_created_at_], [`DATETIME` #h(1fr) #notnull], [],
  [_role_id_], [`INT`], [`ON_DELETE = SET_DEFAULT (2)`],
)

In principio viene generato un utente con username `admin`, password casuale (riportata nei log) e ruolo `1`.

=== Ruoli

#table(
  columns: (1.6fr, 1.2fr, 3fr),
  table.cell(colspan: 3)[role],
  [_id_ #key], [`INT` #h(1fr) #notnull], [],
  [_name_], [`VARCHAR(32)` #h(1fr) #unique #notnull], [],
  [_can_administer_], [`BOOL` #h(1fr) #notnull], [],
  [_can_order_], [`BOOL` #h(1fr) #notnull], [],
  [_can_statistics_], [`BOOL` #h(1fr) #notnull], [],
  [_can_priority_statistics_], [`BOOL` #h(1fr) #notnull], [],
  [_can_confirm_orders_], [`BOOL` #h(1fr) #notnull], [],
  [_can_complete_tickets_], [`BOOL` #h(1fr) #notnull], [],
  [_order_confirmer_id_], [`INT`], [`ON_DELETE = RESTRICT`\ Il ruolo degli utenti che possono confermare gli ordini creati dagli utenti di questo ruolo],
)

In principio vengono generati due ruoli: `admin` (_id_ = `1`), con solo _can_administer_ asserito, e `base` (_id_ = `2`) con nessun permesso asserito.

=== Impostazioni

#table(
  columns: (2fr, 1.6fr, 1.6fr),
  table.cell(colspan: 3)[setting],
	table.header([*Campo*], [*Tipo*], [*Valore di default iniziale*]),
  [_id_ #key], [`INT` #h(1fr) #notnull], [`1`],
  [_order_requires_confirmation_], [`BOOL` #h(1fr) #notnull], [#FALSE],
  [_receipt_header_], [`TEXT` #h(1fr) #notnull], [`''`],
  [_cover_charge_], [`DECIMAL(10,2)` #h(1fr) #notnull], [`0.00`],
  [_max_guests_for_main_products_], [`INT`], [#NULL],
  [_delay_after_confirmation_], [`INT` #h(1fr) #notnull], [`0`],
)

- _max_guests_for_main_products_ specifica il numero massimo di coperti per cui può avvenire il collasso dei prodotti principali (vedi sezione "Categorie, comande e stampanti"), se il numero di coperti è superiore il collasso non avviene, se è #NULL il controllo per il collasso viene sempre eseguito. Per aggiornare il campo a #NULL, inviare `-1`.
- _delay_after_confirmation_ è espresso in secondi.
