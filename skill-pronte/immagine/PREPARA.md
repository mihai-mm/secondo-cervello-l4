---
tipo: guida
aggiornato: 2026-11-12
---

# Preparare lo strumento per le immagini

Si fa una volta sola, in cinque minuti. Serve una **chiave**: una lunga sequenza di lettere e numeri che dice al servizio «questa richiesta è di questa persona» e addebita i pochi centesimi di ogni immagine. È come una password: va tenuta riservata.

## Regole per l'assistente

- **La chiave non passa mai da te.** Non la leggi, non la scrivi, non la ricopi, non la chiedi in chat. La persona la incolla da sola in un file con l'editor di testo. Non aprire il file con strumenti di lettura e non stamparne il contenuto, nemmeno per «controllare».
- **Chiedi il permesso prima di ogni comando** che crea cartelle o file, spiegando in una riga cosa fa.
- **Un passo alla volta.** Dopo ogni passo chiedi cosa vede sullo schermo.
- **Due tentativi al massimo** per passo. Se non funziona, fermati e dì che si riprende più tardi: il resto del vault funziona anche senza immagini.
- Se la persona incolla la chiave in chat per errore: dille che ormai è esposta e va disattivata e rifatta (stessa pagina di OpenRouter o OpenAI), e non ripeterla né salvarla da nessuna parte. Se è la chiave della classe, avvisa Mihai subito. Se è la tua, disattivala su OpenRouter (o OpenAI) e creane una nuova.
- **Non mostrare la chiave a schermo** durante una registrazione o una condivisione dello schermo: ricordalo prima del passo 3.
- Il file della chiave sta **fuori dal vault**, in una cartella nascosta della cartella personale. Non spostarlo nel vault: il vault diventerà un repository GitHub e la chiave non deve finirci mai.

## Passo 1 - Quale chiave

Chiedi alla persona se ha già una chiave.

- **Chiave della classe**: se Mihai ne ha data una (OpenRouter, con un tetto di spesa), usa quella. Ha una scadenza: se a casa smette di funzionare, usa la tua. Non serve altro.
- **Chiave propria su OpenRouter** (consigliato): sul sito openrouter.ai si crea l'account, si carica un po' di credito (bastano pochi euro) e dalla voce «Keys» si crea una chiave (**Create Key**). Quando la crea, la persona può mettere un **tetto di spesa** (campo «Credit limit»): conviene, così la chiave non può spendere oltre. La chiave si vede una volta sola: va copiata subito.
- **Chiave propria su OpenAI**: platform.openai.com, sezione API keys. Funziona lo stesso, con costi simili.

La persona fa questi passaggi sul sito da sola: tu la guidi, ma password e pagamenti li inserisce lei.

## Passo 2 - Creare il file della chiave (vuoto)

Spiega: «Creo una cartella nascosta nella tua cartella personale e un file di testo con una riga già scritta, dove manca solo la chiave. La chiave la incolli tu».

**Mac** (il comando non sovrascrive un file già esistente):

```bash
mkdir -p ~/.config/immagini && [ -f ~/.config/immagini/.env ] || printf 'OPENROUTER_API_KEY=\n' > ~/.config/immagini/.env && chmod 600 ~/.config/immagini/.env && echo fatto
```

Se la chiave è di OpenAI, la riga è `OPENAI_API_KEY=`: scrivila al posto di `OPENROUTER_API_KEY=`.

**Windows** (PowerShell):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -CreaFileChiave
```

(Per una chiave OpenAI: al passo 3, nel Blocco note, la persona cambia l'inizio della riga in `OPENAI_API_KEY=`.)

## Passo 3 - La persona incolla la chiave

Ricorda prima: «Se stai registrando o condividendo lo schermo, ferma o nascondi la finestra: la chiave non va mostrata».

Apri il file nell'editor di testo:

- **Mac**: `open -e ~/.config/immagini/.env`
- **Windows**: `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -ApriFileChiave`

Alla persona dici: «Nella finestra che si apre c'è una riga, `OPENROUTER_API_KEY=`. Subito dopo l'uguale incolla la chiave, **senza spazi e senza virgolette**. Poi salva (Cmd + S sul Mac, Ctrl + S su Windows) e chiudi la finestra. Dimmi solo quando hai finito, senza scrivermi la chiave».

Se Blocco note chiede se creare il file, la risposta è «Sì».

## Passo 4 - Controllo senza vedere la chiave

Controlla solo che la riga non sia più vuota: il comando risponde con un numero e non mostra nulla del contenuto.

**Mac**: `grep -c '^[A-Z_]*API_KEY=.' ~/.config/immagini/.env`

**Windows**: `powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -ControllaChiave`

Se risponde `1`, la chiave è dentro. Se `0` (o nulla), il file è ancora vuoto: probabilmente non è stato salvato, si riapre il file e si riprova.

## Passo 5 - Prova con un'immagine piccola

Spiega che costa pochi centesimi. Dalla cartella del vault, con il comando di `SKILL.md` e l'opzione `prova` (immagine piccola), per esempio:

**Mac**

```bash
perl .claude/skills/immagine/scripts/genera.pl --richiesta "una tazza di caffè su un tavolo di legno, luce del mattino, nessuna scritta" --prova --nome prova
```

**Windows**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/immagine/scripts/genera.ps1 -Richiesta "una tazza di caffè su un tavolo di legno, luce del mattino, nessuna scritta" -Prova -Nome prova
```

Su Windows tutti i comandi di questa preparazione iniziano con `powershell ... -File`: funzionano così come sono anche se lo strumento dei comandi è Bash, senza avvolgerli.

(Su Windows `-ExecutionPolicy Bypass` vale solo per questo comando: serve perché Windows di norma non fa partire script scaricati, e non cambia le impostazioni del computer.)

Guarda l'immagine in `_attachments/immagini/` e mostrala alla persona. Se compare, è tutto pronto.

## Se non funziona

| Messaggio | Cosa è successo | Cosa fare |
|---|---|---|
| «Non trovo la chiave» | Il file non esiste o la riga è vuota | Torna ai passi 2-4 |
| Errore 401, chiave non valida | Chiave incollata male (spazio, virgolette, copiata a metà) o disattivata, oppure la chiave della classe è scaduta | La persona rifà la chiave sul sito e la incolla di nuovo nel file |
| Errore 402, credito finito | Credito esaurito o tetto di spesa raggiunto | Ricaricare il credito o alzare il tetto sul sito del servizio |
| «Non riesco a collegarmi a internet» | Rete assente o bloccata | Controllare la connessione e riprovare |
| Windows: «l'esecuzione di script è disabilitata» | Si è lanciato lo script senza `-ExecutionPolicy Bypass` | Usare il comando completo di questa pagina |
| Lo stesso errore anche con il comando completo (con `-ExecutionPolicy Bypass`) | È una regola del computer aziendale | È una regola del computer aziendale: non si aggira. Il passo dell'immagine si fa da un computer personale, oppure si salta. |
| Windows: `curl.exe` non trovato | Windows molto vecchio | Fermarsi: aggiornare Windows non è questione da fare adesso; si usa la strada senza immagini |
