# Rscaping the Bunker

Rscaping the Bunker is een interactieve R/Shiny game waarin spelers door meerdere levels navigeren, vragen beantwoorden en transitions doorlopen om uiteindelijk de bunker te ontsnappen. De applicatie is modulair opgebouwd zodat levels, vraagtypes en verhaalelementen eenvoudig kunnen worden uitgebreid.

---

## Projectstructuur
Rscaping_the_bunker/
│
├── app.R                 # Hoofdapplicatie, startpunt van de game
├── fuzzy-potato.Rproj    # RStudio projectbestand
├── .gitignore            # Git ignore rules
├── README.md             # Documentatie
│
├── levels/               # Map met alle levels
│   ├── level1/
│   ├── level2/
│   ├── level3/
│   ├── level4/
│   ├── level5/
│       └── *.R           # Sublevels en level-logica
│
├── transitions/          # Scripts voor tussenstukjes
│   └── *.R               # Verhaalelementen, informatie, samenvattingen
│
└── modules/              # Functies voor vraagtypes
└── *.R               # Multiple choice, open vragen, validatie


---

## Functionaliteit

- vijf levels, waarvan level 5 het eindlevel vormt.
- Sublevels per level voor gedetailleerde opbouw van de leerstof.
- Transitions tussen levels voor introducties, verhaalelementen en samenvattingen.
- Modulaire vraagtypes via functies in de map `modules`.
- Uitbreidbare structuur: nieuwe levels, vraagtypes en transitions kunnen eenvoudig worden toegevoegd.

---

## Installatie en gebruik

1. Clone de repository:
   ```bash
   git clone https://github.com/Chelaysiah-Steba/fuzzy-potato.git

2. Open het project in RStudio

3. Installeer de packages: (c("shiny", "tidyverse", "later", "htmltools", "shinyjs"))

4. Start de applicatie:
   shiny::runApp("Rscaping_the_bunker")

## Development notes
* Houd modules klein en herbruikbaar.

* Nieuwe levels kunnen worden toegevoegd door een nieuwe map in levels/ te maken. Zorg ervoor dat de levels ook toegevoegd worden aan source en de router in de server (else if structuur).

* Transitions zijn losstaande scripts en kunnen overal worden aangeroepen.

* .gitignore bevat regels om RStudio-cache, .Rhistory en andere ongewenste bestanden te negeren.




