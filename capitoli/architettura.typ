
= Architettura del sistema

== Componenti principali

#table(
  columns: (1fr, 2fr, 1fr),
  align: left,
  stroke: 0.5pt + luma(210),
  inset: 7pt,
  table.header(
    [*Componente*],
    [*Responsabilità*],
    [*Tecnologia*],
  ),
  [Frontend], [Interfaccia utente], [Web],
  [Backend], [Logica applicativa], [API],
  [Database], [Persistenza], [SQL],
)

== Frammento di codice

Un esempio Python semplificato:

```python
def get_user_by_id(repository, user_id: int):
    if user_id <= 0:
        raise ValueError("ID non valido")
    return repository.find_by_id(user_id)
```

== Relazioni tra componenti

Il frontend invia le richieste al backend,
che valida i dati e interroga il database.

== Formula di esempio

La complessità di un ordinamento efficiente può essere
espressa come:

$ T(n) in O(n log n) $
