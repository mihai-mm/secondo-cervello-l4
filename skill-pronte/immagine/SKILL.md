---
name: immagine
description: >
  Genera e ritocca immagini per i contenuti della persona (copertine di post, foto prodotto in
  scena, illustrazioni, immagini tecniche) partendo da una descrizione e, se c'è, da una foto di
  riferimento. Fa più varianti da scegliere e poi una modifica precisa sulla scelta. Scritte,
  loghi, numeri e misure non si chiedono al modello: si aggiungono dopo. Usala per «fammi
  un'immagine di...», «una copertina per questo post», «dammi tre varianti», «rifalla con più
  neve», «generami una foto del prodotto in scena», «apri la galleria delle immagini», «tieni
  questo prompt», «salva come prompt riusabile la richiesta dell'immagine...», oppure /immagine. Ogni immagine finisce in una galleria (Image Studio) che si apre
  con un doppio clic.
---

# Immagine

Lo strumento genera immagini con un servizio online (OpenRouter o OpenAI) usando una chiave della persona. Non serve installare nulla: sul Mac lavora con `perl`, su Windows con PowerShell, che ci sono già. Ogni immagine costa pochi centesimi e Claude lo dice prima di fare molte varianti.

## Prima di tutto: la chiave c'è?

Controlla solo che la riga della chiave non sia vuota, **senza aprire il file né mostrarne il contenuto**: il comando risponde con un numero.

- Mac: `grep -c '^[A-Z_]*API_KEY=.' ~/.config/immagini/.env`
- Windows: `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -ControllaChiave` (funziona così com'è anche se lo strumento dei comandi è Bash)

Questo controllo è l'unica eccezione alla regola di non leggere file fuori dal vault, e si fa **solo con questo comando**, che risponde con un numero: sul file della chiave non usare altri programmi o lettori (nemmeno quello di `porta-i-tuoi-file`, se ce l'hai), che lo mostrerebbero a schermo.

Se risponde `1` la chiave c'è. Se risponde `0` (o il file non esiste), leggi `PREPARA.md` (nella stessa cartella di questo file) e guida la persona, un passo alla volta. **La chiave non si legge, non si scrive e non si incolla mai in chat.**

## Il metodo (quello della lezione)

1. **Descrivi cosa si deve vedere**, per quale contenuto e con quale stile. Una scena precisa batte un aggettivo: «lattina nella neve, colline al tramonto, luce calda, formato verticale per LinkedIn». Se la persona è vaga, falle una domanda sola su ciò che manca (di solito: dove verrà usata, che atmosfera).
2. **Dai un riferimento.** Se la persona ha una foto del prodotto, del luogo o del suo stile, passala: l'immagine nuova parte da lì e il prodotto resta riconoscibile. Formati accettati: JPG, PNG o WEBP. Una foto .heic dell'iPhone si converte prima (sul Mac: `sips -s format jpeg foto.heic --out foto.jpg`; su Windows: si salva come JPG dall'app Foto). Nel testo della richiesta dì sempre che ruolo ha ogni riferimento, per esempio «l'immagine di riferimento è la lattina: deve restare identica».
3. **Chiedi più varianti** (tre sono un buon numero) e guardale tutte.
4. **Scegli e chiedi una modifica precisa.** Parti dalla variante scelta, passala come riferimento e cambia una cosa sola: «più neve, meno cielo». Non rigenerare da zero ciò che va già bene. Nella richiesta al modello scrivi la modifica in modo concreto, con le proporzioni: «il cielo occupa solo la striscia in alto, circa un quinto dell'immagine; tutto il resto è neve». Con una richiesta vaga il modello restituisce un'immagine quasi uguale (prova del 12/11).

## Il pittore e il tipografo

Al modello si chiede ciò che può cambiare: scena, atmosfera, luce, stile. **Scritte esatte, loghi, numeri, prezzi e misure non si chiedono al modello**: le sbaglia, e ogni volta in modo diverso. Nella richiesta scrivi sempre «nessuna scritta, nessun numero, nessun logo nell'immagine». Poi il testo si aggiunge sopra, identico ogni volta, in Canva o nel programma di grafica che la persona usa già. Se la persona chiede un'immagine con una scritta dentro, spiega in una riga questa regola e proponi di aggiungerla dopo.

## Come si lancia

Scrivi la richiesta in un file (evita problemi con virgolette e accenti): `_attachments/immagini/_richiesta.txt`, sovrascrivendo ogni volta. Poi lancia il programma **dalla cartella del vault**, senza `cd` e senza altro attorno.

**Mac**

```bash
perl .claude/skills/immagine/scripts/genera.pl --file-richiesta _attachments/immagini/_richiesta.txt --proporzione 4:5 --varianti 3 --rif "percorso/foto.png" --nome copertina-post
```

**Windows** (PowerShell; più riferimenti separati da virgola, senza spazi)

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -FileRichiesta _attachments/immagini/_richiesta.txt -Proporzione 4:5 -Varianti 3 -Rif "percorso/foto.png" -Nome copertina-post
```

Su Windows i comandi che iniziano con `powershell ... -File` funzionano così come sono, anche se lo strumento dei comandi è Bash. Un comando PowerShell semplice (per esempio `Start-Process`) da Bash si avvolge così: `powershell -NoProfile -Command '...'`, solo se dentro non ha apici singoli.

Lancia il comando con un tempo massimo di 10 minuti: con tre varianti e un modello lento ci vuole più del solito.

Opzioni (stessi nomi sui due sistemi; su Mac `--opzione`, su Windows `-Opzione`):

| Opzione | Cosa fa |
|---|---|
| `richiesta` o `file-richiesta` | il testo, oppure il file con il testo |
| `rif` | foto di riferimento (fino a 14; sul Mac si ripete l'opzione) |
| `proporzione` | `1:1` quadrata, `4:5` post verticale, `3:2` foto, `16:9` copertina larga, `9:16` storia |
| `varianti` | quante immagini (predefinito 1) |
| `nome` | prefisso del nome del file (per esempio `copertina-post`) |
| `uscita` | cartella dove salvare (predefinita `_attachments/immagini/`) |
| `risoluzione` | `1K` predefinita; `2K` e `4K` costano di più |
| `modello` | solo se serve davvero (vedi sotto) |
| `prova` | immagine piccola per controllare che tutto funzioni |

Le immagini finiscono in `_attachments/immagini/` con un file `.json` accanto: richiesta, modello, riferimenti, proporzione, data e costo. Se la persona deve rifare qualcosa fra un mese, la ricetta è lì.

## Dopo la generazione

- **Guarda le immagini** con lo strumento di lettura delle immagini, tutte, prima di rispondere.
- Rispondi corto e colloquiale: com'è venuta ciascuna in una riga (cosa funziona, cosa no: forma, dettaglio, coerenza del prodotto fra le varianti, scritte comparse per sbaglio), poi **una domanda sola**: quale tieni, o cosa cambio.
- Se compaiono scritte o numeri sbagliati, non rigenerare in loop: spiega la regola del tipografo e proponi di toglierli o aggiungerli dopo.
- Dì il costo (lo scrive il programma a fine esecuzione) in una frase.

## La galleria (Image Studio)

Dopo ogni generazione il programma riscrive `_attachments/immagini/galleria.html`: una pagina che si apre con un doppio clic e mostra tutte le immagini con la loro ricetta (prompt, foto di partenza, modello, costo), il confronto prima e dopo per le modifiche e, nella scheda «Prompt», i prompt salvati. Non va online e non salva niente: legge i file che stanno già nel vault.

- La prima volta che la persona genera un'immagine, dille che la galleria c'è e aprila tu: sul Mac `open _attachments/immagini/galleria.html`, su Windows `Start-Process _attachments/immagini/galleria.html`.
- Se la persona chiede di aggiornare la galleria senza generare (per esempio dopo aver cancellato delle immagini o salvato un prompt): Mac `perl .claude/skills/immagine/scripts/genera.pl --solo-galleria`, Windows `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -SoloGalleria`. Poi la persona ricarica la pagina.
- Le foto di partenza che stanno fuori da `_attachments/immagini/` il programma le copia in `_attachments/immagini/riferimenti/`, così la galleria le mostra accanto al risultato.

## Tenere un prompt

Quando la persona dice «tieni questo prompt», «salva il prompt di quell'immagine» (dalla galleria il pulsante «Tienilo come prompt» copia proprio questa frase):

1. Prendi la richiesta dal file `.json` dell'immagine e rendila riusabile: le parti che cambiano ogni volta diventano segnaposto in maiuscolo fra parentesi quadre, per esempio `[PRODOTTO]`, `[LUOGO]`.
2. Salvala in `3-Resources/Prompt immagini/` con un nome che dica a cosa serve (per esempio `Prodotto in scena.md`), in questo formato:

```markdown
---
tipo: prompt-immagine
creato: AAAA-MM-GG
proporzione: 4:5
esempio: nome-del-file-immagine.png
---

# Titolo che dice a cosa serve

Il testo del prompt, con i segnaposto fra parentesi quadre.

## Quando lo uso

Una o due righe.

## Cosa cambio ogni volta

I segnaposto da riempire.
```

3. Aggiorna la galleria con `--solo-galleria` (o `-SoloGalleria`) e di' alla persona di ricaricare la pagina: il prompt compare nella scheda «Prompt».

Per riusare un prompt salvato, leggilo da `3-Resources/Prompt immagini/`, riempi i segnaposto con ciò che chiede la persona e genera come al solito.

## Costi e modello

- Il modello predefinito è Nano Banana 2 su OpenRouter (con la chiave OpenAI, `gpt-image-2.6-flare`): circa 0,07 $ a immagine a 1K. Tre varianti e una modifica fanno circa 0,30 $.
- Cambia modello solo se la persona lo chiede o se il risultato non regge il dettaglio (scene molto tecniche, tanti elementi precisi). Su OpenRouter il più preciso è `openai/gpt-image-2.6-sunburst`, più lento e più caro (circa 0,11 $ a immagine). Dillo prima.
- Prima di una serie lunga (più di cinque immagini) dì quanto verrà a costare e chiedi.

## Quando qualcosa non va

Il programma scrive già un messaggio chiaro in italiano. Riportalo con parole semplici e di' cosa fare:

- **Chiave mancante o non valida (401)**: si torna a `PREPARA.md`, passo del file della chiave. Non chiedere mai di vedere la chiave.
- **Credito finito (402)**: la persona ricarica il credito su OpenRouter (o su OpenAI), oppure alza il tetto di spesa della chiave. Non si risolve da qui.
- **Modello inesistente**: togli l'opzione `modello`.
- **Nessuna connessione**: controlla internet e riprova.
- **Nessuna immagine restituita**: il servizio ha rifiutato la richiesta; riscrivila in modo diverso (senza persone reali riconoscibili, senza marchi altrui).

Due tentativi al massimo con lo stesso errore, poi ferma e spiega.

## Privacy

Una foto di riferimento viene inviata al servizio per generare l'immagine. Non usare foto di persone senza il loro consenso, né documenti o dati riservati.
