#import "../../utils.typ": *

== Tipologie degli ordini

Gli ordini si suddividono in tre tipologie mutuamente esclusive, e possono essere effettuati con cinque modalità distinte:

=== Ordini principali in sala

I nuovi ordini in sala prevedono sempre la stampa delle comande per un servizio in sala. Sono identificati univocamente da:

- _guests_ > 0

oppure da:

-	_take_away_type_ = #NULL
-	_has_tickets_ = #TRUE
-	_parent_order_id_ = #NULL

Si possono effettuare con le modalità:

+ Ordine in sala con conferma (se _order_requires_confirmation_ = #TRUE)
+ Ordine in sala con tavolo già inserito (se _order_requires_confirmation_ = #FALSE)

=== Ordini di aggiunta

Gli ordini di aggiunta sono ugualmente destinati al servizio in sala, ma pensati per i clienti che hanno già effettuato un ordine della tipologia principale. Sono identificati univocamente da:

- _guests_ = #NULL
- _take_away_type_ = #NULL

e hanno necessariamente _needs_confirmation_ = #FALSE. Si possono effettuare in tre modi:

2. Ordine in sala con tavolo già inserito e con 0 coperti (che verrà poi convertito a #NULL)
+ Ordine di aggiunta collegato al principale
+ Ordine Flash

*Importante:* se a un ordine di questo tipo sono associate delle comande, il tempo di attesa indicato nel _print_delay_ delle rispettive categorie viene automaticamente ignorato; quindi, la stampa avviene sempre immediatamente dopo gli eventi scatenanti (che possono essere esclusivamente la creazione dell'ordine o il completamento di comande di categorie genitrici). Inoltre, le categorie figlie vengono collassate di default, anche se non sono orfane.

=== Ordini per asporto

Gli ordini per asporto sono identificati univocamente da _take_away_type_ valorizzato con il tipo di asporto e si possono effettuare unicamente con la modalità:

5. Ordine per asporto.

=== Ordini per il personale di servizio e omaggio

Asserire il campo _is_for_service_ ha solo fini statistici per escludere gli articoli selezionati dal report delle preferenze dei clienti, e allo stesso tempo tenere traccia dei consumi degli stock degli ingredienti e dell'incasso. Lo stesso vale per il campo _is_voucher_ che influisce solo sul totale e non definisce un particolare ciclo di vita dell'ordine.

Dato che questi campi non richiamano una modalità di servizio specifica, per questi ordini si può sceglierne una tra quelle elencate di seguito (settando i campi opportunamente), tipicamente asporto o "Cassa Flash".

