# Skill pronte

Qui c'è lo strumento per le immagini che hai visto con Paola: la skill `immagine`. Funziona così com'è, ma **la strada consigliata è installarla con la guida «Il tuo stile al lavoro»** (Passo 4): Claude te la spiega, prepara con te la chiave e ti accompagna nella prima immagine.

## Cosa c'è

- **`immagine/`**: genera e ritocca immagini da una descrizione e, se c'è, da una foto di riferimento. Fa più varianti fra cui scegliere e poi una modifica precisa. Scritte, loghi e numeri non li chiede al modello: si aggiungono dopo. Dentro:
  - `SKILL.md`: come la usa Claude;
  - `PREPARA.md`: la preparazione della chiave, passo per passo, per Mac e Windows;
  - `scripts/`: il programma, uno per il Mac (`genera.pl`) e uno per Windows (`genera.ps1`). Usano strumenti che il computer ha già: non si installa niente;
  - `galleria-modello.html`: il modello della galleria, Image Studio. A ogni immagine il programma lo copia in `_attachments/immagini/galleria.html` con dentro le tue immagini, le loro ricette e i prompt che tieni in `3-Resources/Prompt immagini/`. La apri con un doppio clic; non va online.

## La chiave

Lo strumento chiama un servizio di immagini su internet con una chiave: in aula quella che ti dà Mihai, a casa anche la tua (OpenRouter, con cui puoi usare modelli diversi, oppure OpenAI). La chiave sta in un file **fuori dal vault** (`.config/immagini/.env` nella tua cartella utente), così non finisce mai nella copia su GitHub. Non scriverla mai in chat: Claude ti apre il file e la incolli tu. Ogni immagine costa pochi centesimi.

## Come si installa

1. Apri il tuo vault e vai nella cartella `.claude/skills/`. Se non la vedi, è normale: le cartelle che iniziano con un punto sono nascoste. Nel Finder premi Cmd+Maiusc+punto; su Windows, in Esplora file, menu «Visualizza», «Mostra», «Elementi nascosti».
2. Copia dentro la cartella `immagine` (tutta). Il risultato deve essere `.claude/skills/immagine/SKILL.md`.
3. Apri una conversazione nuova nella cartella del vault e scrivi `/`: nel menu deve comparire `immagine`. Se non compare, scrivi `/reload-skills`.

Se preferisci, chiedilo a Claude: «installa la skill immagine da skill-pronte in .claude/skills/: spiegamela prima». Claude ti dice cosa scrive e dove, e aspetta il tuo sì. L'app può mostrarti una richiesta di permesso, perché `.claude/` è una cartella speciale: va consentita.

La skill non pubblica niente e non manda messaggi a nessuno: le immagini restano nel tuo vault, in `_attachments/immagini/`.
