
#let blue1 = rgb("5170ff")
#let blue2 = rgb("455dc8")
#let blue3 = rgb("2f2a52")

#let TRUE = text(weight: "bold", fill: green, `TRUE`)
#let FALSE = text(weight: "bold", fill: red, `FALSE`)
#let NULL = text(weight: "bold", fill: rgb("#777"), `NULL`)

#let key = box(
	height: 9pt,
	image(bytes(
		read("immagini/key-fill.svg").replace(
			"currentColor", blue1.to-hex()
		)
	))
)

#let foreignkey = box(
	height: 9pt,
	image(bytes(
		read("immagini/link-45deg.svg").replace(
			"currentColor", blue1.to-hex()
		)
	))
)

#let unique = box(
	height: 9pt,
	image(bytes(
		read("immagini/fingerprint.svg").replace(
			"currentColor", blue1.to-hex()
		)
	))
)
	
#let notnull = box(
	height: 9pt,
	image(bytes(
		read("immagini/slash-square.svg").replace(
			"currentColor", blue1.to-hex()
		)
	))
)

#let flash = box(
	height: 9pt,
	image(bytes(
		read("immagini/lightning-charge-fill.svg").replace(
			"currentColor", blue1.to-hex()
		)
	))
)
