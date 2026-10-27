#import "utils.typ": *

#set document(
	title: "Festival Management - Documentazione",
	author: "Francesco Contran, Riccardo Fila",
)


#let current-chapter-title(section_level) = context {
	let page-no = counter(page).get().first()
	let next-headings = query(heading.where(level: section_level).after(here()))
	if next-headings != () and next-headings.first().location().page() == page-no {
		return next-headings.first().body
	}

	let headings = query(heading.where(level: section_level).before(here()))
	if headings == () { panic("At least one heading must be defined.") }
	headings.last().body
}

#set page(
	paper: "a4",
	margin: (top: 25mm, rest: 20mm),
	numbering: "1",
	header: context {
		let page-no = counter(page).get().first()
		if page-no > 1 {
			block(below: 0.5em, width: 100%)[
				#align(
					if calc.rem-euclid(page-no, 2) == 1 { right } else { left }
				)[
					#text(size: 9pt)[
        		_Festival Management — #current-chapter-title(1)_
      		]
				]
			]
			line(length: 100%, stroke: 1pt + blue3)
		}
	},
	footer: context {
		if counter(page).get().first() > 1 {
			align(center)[#counter(page).display()]
		}
	},
)

#set text(
	font: "Liberation Sans",
	size: 11pt,
	lang: "it",
)

#set table(
  fill: (x, y) =>
    if y == 0 { blue3 },
  stroke: 0.5pt + luma(210),
  inset: 5pt,
)
#show table: it => {
  block(
		above: 1.4em,
		below: 2.2em,
		breakable: false
	)[#it]
}
#show table.cell: it => {
  if it.y == 0 {
    set text(fill: white, font: "LT Sonoma")
    strong(it)
  } else {
    it
  }
}

#set par(justify: true)

#show heading.where(level: 1): it => {
	set text(font: "Montserrat Alternates", weight: "bold", size: 32pt, hyphenate: false, fill: blue3)
	block(above: 1em, below: 1em)[#it]
}
#show heading.where(level: 2): it => {
	set text(font: "Montserrat Alternates", weight: "bold", size: 24pt, hyphenate: false, fill: blue2)
	block(above: 1.4em, below: 0.5em)[#it]
}
#show heading.where(level: 3): it => {
	set text(font: "Montserrat Alternates", weight: "bold", size: 16pt, hyphenate: false, fill: blue1)
	block(above: 1em, below: 0.8em)[#it]
}
#show heading.where(level: 4): it => {
	set text(font: "Oswald", weight: "bold", size: 12pt, hyphenate: false, fill: blue3)
	block(above: 1em, below: 0.8em)[#it]
}

#show emph: body => {
	text(font: "LT Sonoma", fill: blue3)[#body]
}

// Copertina
#align(center)[
	#v(30mm)
	#image("immagini/FestivalManagement_Logo1_color.svg", width: 60%)
	#block(width: 59%)[
		#align(right)[
			#text(size: 2em, font: "Oswald", weight: "bold", fill: blue3)[
				Edizione Stra
			]
		]
	]
	#v(30mm)
	#text(size: 3.6em, font: "Montserrat Alternates", weight: "bold")[Documentazione]
	#line(length: 60%, stroke: 1pt)
	#v(12mm)
	#text(size: 1.4em)[Autori: Francesco Contran, Riccardo Fila]
]
#pagebreak()

#outline(title: "Indice", depth: 3)
#pagebreak()

#include "capitoli/01_database.typ"
#include "capitoli/02_tipologie_modalita.typ"
