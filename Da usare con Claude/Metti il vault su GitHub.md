# Metti il vault su GitHub

Questo è un file guidato: lo dai al tuo Claude e lui ti accompagna, un passo alla volta. In lezione Mihai ti ha fatto vedere GitHub Desktop sul vault di Paola. Qui lo installi e ci metti il tuo vault, così arrivi alla Lezione 5 con lo strumento pronto. È il compito per casa, e non è obbligatorio: se sul tuo computer non puoi installare programmi, o se il tuo vault ha dati che non puoi mettere online, salti e il corso va avanti lo stesso.

## In breve, prima di cominciare

Fino a oggi il tuo vault vive in un posto solo: il tuo computer. Se un file viene cambiato per sbaglio, o se il computer non si accende più, quello che c'era prima non c'è più.

In aula l'hai visto succedere a Paola: Luca ha scritto i prezzi vecchi sopra quelli giusti, e lei con due clic è tornata alla versione di prima. Qui fai la stessa cosa con il tuo vault.

**Tre parole che incontrerai.** Una **versione** è una fotografia del vault in un momento preciso (GitHub Desktop la chiama *commit*). **Commit** vuol dire: salva la versione sul computer. **Push** vuol dire: mandala su GitHub.

**Se il tuo vault sta già su Google Drive, OneDrive o iCloud.** Hai già una copia online, sempre aggiornata, ed è un'ottima base. Quello che Drive non ti dà è lo storico del vault: tornare a com'era ieri, vedere chi ha cambiato cosa, annullare una modifica. Hai due strade:

- **tieni solo Drive**: se lavori da solo e ti basta la copia online, puoi fermarti qui, senza GitHub;
- **aggiungi GitHub**: la strada sicura è che il vault esca dalla cartella di Drive, perché i due sistemi aggiornerebbero gli stessi file e possono creare doppioni. Non lo sposti tu: Claude lo copia in una cartella normale, controlla con te che si apra in Obsidian e in Claude, e solo dopo decidi cosa fare dell'originale.

**Passo 1 - Installa GitHub Desktop e accedi.** È un programma gratuito: lo scarichi da desktop.github.com e accedi con il tuo account GitHub.
Cosa dovresti vedere: GitHub Desktop aperto e collegato al tuo account.

**Passo 2 - Metti dentro il vault.** Aggiungi la cartella del vault, salvi la prima versione e la pubblichi come privata.
Cosa dovresti vedere: su github.com, fra le tue copie, il vault con l'etichetta «Private».

**Passo 3 - Il gesto di ogni giorno.** Quando finisci di lavorare apri GitHub Desktop: a sinistra vedi i file cambiati. Scrivi due parole su cosa hai fatto, per esempio «Post del lancio e scheda cliente», clicchi **Commit to main** e poi **Push origin**.
Cosa dovresti vedere: la lista dei cambiamenti vuota. La versione ora è anche su GitHub.

**Quando serve tornare indietro.** Scheda **History**, trovi la versione sbagliata, clic destro, **Revert Changes in Commit**. Non cancella niente: aggiunge una versione nuova che rimette le cose com'erano.

Non devi ricordarti tutto: dai questo file a Claude e ti guida lui, un passo alla volta. I clic li fai tu, lui ti dice dove e controlla con te che sia andata bene. Più sotto trovi i dettagli, se vuoi leggerli.

## Cos'è, in tre righe

- **GitHub** conserva ogni versione dei tuoi file in una copia privata, fuori dal tuo computer.
- **GitHub Desktop** è il programma con cui gestisci quella copia: clicchi, non scrivi comandi.
- Se domani il computer non si accende, o un file viene cambiato per sbaglio, la versione di ieri è ancora lì.

## Cosa avrai alla fine

- **GitHub Desktop installato** e collegato al tuo account GitHub.
- **Il tuo vault come copia privata su GitHub**, che vedi solo tu. Senza i file pesanti, senza le impostazioni personali e senza i dati che hai deciso di non mettere.
- **Il gesto di ogni giorno**: guardi cosa è cambiato, scrivi due parole, salvi la versione e la mandi su GitHub.
- **Il gesto per tornare indietro**: apri lo storico, vedi chi ha cambiato cosa e quando, annulli una modifica sbagliata.

## Cosa ti serve prima di partire

Tre cose da sapere, e poi si parte.

1. **Un account GitHub gratuito.** Se non ce l'hai, lo crei da github.com/signup (puoi anche scegliere «Continue with Google»). GitHub ti chiede di confermare l'indirizzo email: senza conferma non puoi creare la copia. Ti consiglia anche di attivare la verifica in due passaggi.

2. **Un computer su cui puoi installare programmi.** Se il computer è dell'azienda, chiedi prima a chi se ne occupa: spesso l'installazione è bloccata o serve il suo permesso. Se non puoi, fermati qui. Lo vedrai fare in aula e in registrazione.

3. **Sapere cosa c'è nel tuo vault.** La copia su GitHub è privata, la vedi solo tu e chi inviti. Ma se nel vault ci sono dati di clienti o riservati, chiedi prima cosa puoi metterci. Se non puoi mettere tutto, nessun problema: una cartella si può lasciare fuori dalla copia (il passo 4 lo fa) e resta solo sul tuo computer.

## Se il tuo vault sta in iCloud Drive, OneDrive o Google Drive

Molte cartelle sono sincronizzate senza che te ne accorga: su Windows «Documenti» e «Desktop» sono spesso dentro OneDrive, sul Mac possono essere dentro iCloud Drive.

Il problema, detto in modo onesto: GitHub Desktop tiene le versioni in una cartella nascosta dentro il vault (si chiama `.git`). Anche il servizio di sincronizzazione lavora sugli stessi file, e i due possono pestarsi i piedi: a volte compaiono doppioni (file con «copia in conflitto» o con un numero nel nome) oppure la sincronizzazione rallenta perché ci sono tanti file piccoli. Non è una regola di GitHub, è un'esperienza comune: non succede sempre, ma succede.

Cosa fare, a scelta tua:

- **La strada più sicura**: il vault va in una cartella che non è sincronizzata. Con il tuo sì, Claude ti guida a copiarlo lì e a riaprirlo in Obsidian e nell'app di Claude. L'originale resta dov'è finché non controlli che la copia funzioni. Non devi spostare nulla da solo.
- **La strada più veloce**: lasci il vault dov'è e provi. Se compaiono doppioni, o la sincronizzazione si blocca, lo dici a Claude e passi alla strada sicura.

All'inizio Claude ti chiede dove sta il vault e se quella cartella è sincronizzata, e ti dice quale strada gli sembra migliore.

## Cosa non va nella copia

Non tutto quello che c'è nel vault deve finire su GitHub. Claude prepara un file, `.gitignore` (è un elenco: dice a GitHub Desktop cosa lasciare fuori), nella cartella principale del vault, con il tuo sì. Lo trovi spiegato riga per riga in `gitignore-per-il-vault.txt`, in questa cartella. Lascia fuori:

- **i file del computer**: `.DS_Store`, `Thumbs.db`;
- **le impostazioni personali**: come hai disposto le finestre di Obsidian (`.obsidian/workspace*.json`) e i «consenti sempre» di Claude (`.claude/settings.local.json`);
- **i file pesanti**: video, audio, archivi ZIP e PDF;
- **le cartelle che scegli tu**, per esempio quelle con dati di un cliente.

Perché i file pesanti: GitHub ti avvisa quando salvi un file sopra i 50 MiB e rifiuta quelli sopra i 100 MiB. Anche sotto il limite, consiglia di tenere piccola la copia, meglio sotto 1 GB. Un vault di testi pesa pochissimo; un video lo riempie in un attimo. E ogni volta che un file pesante cambia, la copia conserva anche la versione di prima: tutto diventa lento da mandare e da aprire.

**Chiavi e password non vanno mai nel vault.** La chiave per le immagini che hai ricevuto in questa lezione sta già fuori dal vault: lascia che resti lì.

Una cosa importante: l'elenco va preparato prima della prima versione. Un file già salvato in una versione non si toglie aggiungendolo all'elenco dopo.

## I passi, in breve

Claude te li dà uno alla volta. Questa è solo la mappa.

1. Controlli le tre cose di sopra e dove sta il vault.
2. Installi GitHub Desktop.
3. Accedi con il tuo account GitHub.
4. Prepari l'elenco di cosa non va nella copia.
5. Aggiungi il vault a GitHub Desktop.
6. Pubblichi la copia come **privata** e controlli su github.com.
7. Provi il gesto di ogni giorno: salvi una versione e la mandi su GitHub.
8. Provi a tornare indietro.

## Come si usa

1. Questo file deve stare dentro il tuo vault, in `0-Inbox/`. Se hai messo lì l'intera cartella della lezione, è già a posto. **Claude lavora solo dentro il vault.**
2. Apri nell'app di Claude una conversazione nuova nella cartella del vault, nella scheda Code.
3. Scrivi:

> guidami con la guida a GitHub Desktop

Da lì in poi Claude ti guida lui. Per installare e per pubblicare i clic li fai tu; Claude ti dice dove cliccare e controlla con te che sia andata bene. Quando vuoi fermarti, basta dire «ci fermiamo qui».

## Se qualcosa non va

Puoi sempre scrivere a Claude cosa vedi, o mandargli uno screenshot. I problemi più probabili:

| Cosa vedi | Cosa è successo | Cosa fare |
|---|---|---|
| Non riesci ad accedere, o il browser non torna a GitHub Desktop | L'accesso si fa dal browser e a volte il ritorno non parte | Chiudi GitHub Desktop, riaprilo e ripeti l'accesso (passo 3). Se hai la verifica in due passaggi, serve il codice. La password si scrive solo nella pagina di GitHub, mai a Claude |
| Dice che la cartella è già un repository, o «Add Local Repository» la riconosce subito | Il vault ha già le sue versioni (per esempio da un'altra guida) | Va bene: aggiungila e basta, non crearne un'altra. Dillo a Claude |
| Un file è troppo grande: il caricamento si ferma con un errore che parla di 100 MB | Un file sopra i 100 MiB è già dentro una versione e GitHub lo rifiuta | Non insistere con Push origin. Dillo a Claude: ti guida a disfare l'ultima versione (**Undo**), a lasciare il file fuori con l'elenco e a salvare di nuovo |
| In **Changes** compaiono moltissimi file, o file strani | L'elenco di cosa non va nella copia non c'è, o è incompleto | Fermati prima di salvare. Dillo a Claude: sistema l'elenco |
| Dopo **Fetch origin** il tasto diventa **Pull origin** e poi dice che ci sono conflitti | Lo stesso file è stato cambiato in due posti | Non scegliere a caso. Mandagli lo screenshot: ti spiega cosa è cambiato e dove, e decidi tu quale versione tenere |
| Compaiono doppioni, o file con «copia in conflitto» nel nome | La sincronizzazione (iCloud, OneDrive, Google Drive) e le versioni di GitHub si pestano i piedi | Non cancellare niente a mano. Dillo a Claude: guarda quali sono i doppioni e ti propone la strada sicura (vault in una cartella non sincronizzata) |
| Hai pubblicato la copia come pubblica per sbaglio | Hai dimenticato la casella **Keep this code private** | Dillo subito a Claude. Su github.com, nella pagina della copia, vai in **Settings**, sezione **Danger Zone**, e cambia la visibilità in privata. Se dentro c'era qualcosa di riservato, dillo: va trattato come già visto |
| Non trovi un tasto o un menu come descritto | Il programma può cambiare qualcosa fra una versione e l'altra | Manda uno screenshot a Claude: ti dice dove guardare |

## Per chi lavora con altri

La copia può essere condivisa: su github.com, in **Settings** della copia, **Collaborators**, **Add people**, e invii l'invito a un collega (serve il suo nome su GitHub o la sua email). Così potete lavorare sugli stessi file e ognuno vede le versioni dell'altro. Non è il compito di oggi: lo fai solo se ti serve, e non prima di aver deciso con il tuo team cosa mettere nella copia.

---

## Da qui in giù è per Claude: non devi leggerlo

## Dove sei

Claude aggiorna queste tre righe alla fine di ogni passo, e il registro in fondo al file.

- **Passo attuale**: 1 di 8
- **Ultima sessione**: -
- **Note**: -

---

## Stile di lavoro (regole per Claude)

Si aggiungono a quelle del `CLAUDE.md` del vault; se qualcosa è in conflitto, valgono quelle del vault, e Claude lo dice.

1. **Sei la guida, un passo alla volta.** Mai fare due passi senza la conferma della persona. Una domanda alla volta, e dopo ogni passo chiedi **cosa vede sullo schermo**.
2. **I clic li fa la persona.** Installare GitHub Desktop, accedere, aggiungere la cartella e pubblicare li fa lei: tu dici dove cliccare (nomi dei pulsanti in inglese, in grassetto, come appaiono) e controlli con lei il risultato. Non installare niente tu, non usare Homebrew né `sudo` né comandi da altri siti. Usa solo gli installer ufficiali, due tentativi al massimo, poi segna il passo «saltato».
3. **Il computer e i dati prima di tutto.** Se il computer è aziendale o la persona non sa se può installare, fermati e dillo (passo 1). Se nel vault ci sono dati di clienti o riservati, chiedi cosa si può mettere nella copia e proponi di escludere la cartella: non decidere tu cosa è riservato.
4. **Annuncia prima di scrivere un file.** Quale, dove, con cosa; aspetta il sì; dopo, rileggi e di' come verificare. Il registro di questa guida lo aggiorni senza chiedere.
5. **Mai credenziali in chat.** La password di GitHub e il codice di verifica si scrivono solo nella pagina di GitHub nel browser. Se la persona li scrive a te, dille di cambiarli e non ripeterli.
6. **Non pubblicare e non salvare al posto suo.** Pubblicare la copia, salvare una versione e mandarla su GitHub sono clic della persona. Tu controlli prima: casella **Keep this code private** spuntata, elenco dei file da salvare.
7. **Spiega ogni termine** la prima volta: repository (la cartella con le sue versioni), commit (una versione salvata), push (mandare su GitHub), pull (prendere da GitHub), storico.
8. **Non inventare i nomi dei pulsanti.** Quelli di questa guida vengono dalla documentazione ufficiale di GitHub Desktop (versione Windows e Mac). Se sullo schermo la persona vede altro, chiedi uno screenshot e ragionate su quello. Se qualcosa non è in questa guida, dillo.
9. **Intoppi.** Chiedi cosa vede, poi spiega: cosa è successo, perché, l'unica cosa da fare adesso e la strada alternativa. Se un'azione viene bloccata, non insistere con lo stesso comando.
10. **Lascia questo file al suo posto**, e non toccare `.gitignore` o altri file senza il sì.

## Come condurre

All'avvio:

1. Di' in quale cartella stai lavorando e controlla che sia il vault (contiene `LEGGIMI.md` e le cartelle da `0-Inbox` a `4-Archives`). Se non lo è, fermati.
2. Trova la cartella della lezione in `0-Inbox/` (contiene `Da usare con Claude/` con `gitignore-per-il-vault.txt`) e di' come si chiama.
3. Leggi il registro in fondo. Se ci sono passi già fatti, **riparti dal primo non spuntato**, senza rifare domande già fatte. Se l'ultima voce dice «in corso», riparti da lì.
4. Mostra il percorso in una riga per passo (la mappa «I passi, in breve»), poi annuncia il passo: cosa fate, perché serve, cosa ci sarà alla fine.

Chiedi il sistema operativo (Windows o Mac) una volta, all'inizio, e usa solo i nomi di menu di quel sistema.

Dopo ogni passo: spunta le caselle con la data (`✅ AAAA-MM-GG`; un passo che non si applica si spunta con «saltato: ...»), aggiorna le tre righe di «Dove sei» e aggiungi una riga in cima al registro. Poi chiedi: «continuiamo con il prossimo passo o ci fermiamo qui?».

---

## I passi

### Passo 1 - Prima di cominciare

**Perché**: GitHub Desktop non serve a niente senza un account, un computer che lo accetta e un vault pronto a essere copiato. Meglio saperlo prima di installare.

Cosa fai, una domanda alla volta:

1. **Account.** Chiedi se ha già un account GitHub. Se no, la persona lo crea da github.com/signup (anche con «Continue with Google») e conferma l'email; ricordale che GitHub consiglia la verifica in due passaggi. Un account gratuito basta: le copie private sono incluse.
2. **Computer.** Chiedi se il computer è suo o dell'azienda e se può installare programmi. Se dell'azienda: deve chiedere prima a chi se ne occupa. Se non può installare, segna l'intera guida «saltato: computer aziendale» e fermati.
3. **Dove sta il vault.** Guarda il percorso della cartella in cui lavori. Se contiene `iCloud`, `Mobile Documents`, `OneDrive`, `Google Drive` o `CloudStorage`, è sincronizzato. Se non lo vedi dal percorso, chiedi: «Il tuo Desktop o Documenti sono sincronizzati con iCloud, OneDrive o Google Drive?». Su Windows «Documenti» e «Desktop» sono spesso dentro OneDrive.
4. **Se è sincronizzato.** Spiega in tre righe il rischio (la sezione «Se il tuo vault sta in iCloud Drive, OneDrive o Google Drive» in cima) e proponi le due strade. Di' quale ti sembra migliore: la strada sicura se il vault è grande o la persona lo usa da più dispositivi, quella veloce se è piccolo e prova solo. **Non spostare il vault tu e non obbligarla.** Se sceglie di spostarlo, con il suo sì:
   - le dici dove (una cartella locale, per esempio `Documenti` solo se non è sincronizzata: fallo verificare);
   - copia la cartella con lei (Finder o Esplora file), l'originale non si tocca;
   - riaprite il vault copiato in Obsidian (**Open folder as vault**) e l'app di Claude;
   - solo dopo aver controllato che funzioni, è lei a decidere cosa fare dell'originale.
5. **Dati riservati.** Chiedi: «Nel vault ci sono cartelle con dati di clienti o riservati che non vuoi mettere nella copia?». Segna i nomi delle cartelle: vanno nell'elenco del passo 4.
6. **File pesanti.** Cerca nel vault i file sopra i 50 MB e dille quali sono (nome e dimensione). Se con i tuoi strumenti non riesci, falle guardare: Finder o Esplora file, ordina per **Dimensione**. Non aprire diari personali (`Daily/`) né aree private mentre cerchi: elenchi solo nomi e dimensioni.

**Output atteso**: sai se ha un account, se può installare, dove sta il vault (e la strada scelta se è sincronizzato), quali cartelle lasciare fuori e quali file sono pesanti.

**Verifica**: ripeti in due righe cosa hai capito e chiedi «è giusto?».

**Se non funziona**: se non sa se il computer è aziendale, la domanda è una sola: «Ti ha dato il computer l'azienda, con un'assistenza informatica?». Se sì, vale la regola dell'azienda.

- [ ] Passo 1 fatto

### Passo 2 - Installa GitHub Desktop

**Perché**: è il programma con cui gestisci la copia senza comandi.

Requisiti (dalla documentazione ufficiale): Windows 10 a 64 bit o successivo; macOS 12 o successivo.

Cosa fai:

1. Spiega in due righe cosa installa, a cosa serve e che si può togliere quando vuole.
2. Falle aprire **desktop.github.com**, scrivendo l'indirizzo a mano (non da un annuncio). Il sito ufficiale è l'unica fonte.
3. **Windows**: clic su **Download for Windows**. Nella cartella Download, doppio clic sul file di installazione (setup). Quando finisce, GitHub Desktop si apre da solo.
4. **Mac**: clic su **Download for macOS**. Nella cartella Download, doppio clic sul file zip; quando si è aperto, doppio clic su **GitHub Desktop**. Il programma si avvia da solo. Se il Mac chiede conferma per aprire un programma scaricato da internet, è normale: vale solo se l'ha scaricato lei da desktop.github.com.
5. Se Windows o il Mac chiedono una **password di amministratore**, non è un computer sul quale può installare da sola: fermati e di' di chiedere a chi lo gestisce. La password del computer si scrive solo nella finestra del sistema, mai in chat.
6. Chiedi: «Cosa vedi sullo schermo?». Deve comparire la finestra di benvenuto di GitHub Desktop.

**Output atteso**: GitHub Desktop è aperto, con una schermata di benvenuto.

**Verifica**: chiedi lo screenshot o una descrizione della finestra.

**Se non funziona**: due tentativi al massimo. Se il file non si apre o l'installazione si blocca, chiedi il messaggio esatto. Dopo due tentativi falliti, segna il passo «saltato» e di' che la persona può guardare il metodo in aula o nella registrazione.

- [ ] Passo 2 fatto

### Passo 3 - Accedi con il tuo account GitHub

**Perché**: così GitHub Desktop sa dove mettere la tua copia.

Cosa fai:

1. **Windows**: nel menu **File**, **Options**. **Mac**: nella barra dei menu in alto, **GitHub Desktop**, poi **Settings**.
2. Nella scheda **Accounts**, clic su **Sign Into GitHub.com**.
3. Nella finestra «Sign in Using Your Browser», clic su **Continue With Browser**. Si apre il browser.
4. Nel browser entra con il tuo account GitHub: clic su **Sign in**. Se hai la verifica in due passaggi, scrivi il codice e clic su **Verify**.
5. Segui le istruzioni per tornare a GitHub Desktop. Su Windows non si può accedere con nome utente e password dentro il programma: si passa sempre dal browser.
6. Se durante il primo avvio compare una schermata che chiede nome ed email per le versioni, la persona può usare il suo nome e l'email del suo account: sono quelli che appariranno accanto a ogni versione nello storico.

**Output atteso**: in **Accounts** compare il nome del tuo account GitHub.

**Verifica**: chiedi quale nome vede in **Accounts**.

**Se non funziona**: se il browser non si apre o non torna a GitHub Desktop, chiudi GitHub Desktop, riaprilo e ripeti. La password si scrive solo nel browser. Due tentativi, poi «saltato» e un messaggio a Mihai.

- [ ] Passo 3 fatto

### Passo 4 - Prepara cosa NON va nella copia

**Perché**: una volta salvata una versione, un file ci resta. L'elenco va fatto prima della prima versione.

Cosa fai:

1. Spiega in tre righe a cosa serve il `.gitignore` e cosa lascia fuori (la sezione «Cosa non va nella copia» in cima): file di sistema, impostazioni personali, file pesanti, chiavi, cartelle scelte.
2. Leggi `gitignore-per-il-vault.txt` nella cartella `Da usare con Claude/`. Controlla se nella cartella principale del vault esiste già `.gitignore`: se sì, leggilo e aggiungi solo le righe che mancano.
3. Prepara la proposta: l'elenco di partenza, più (a) le cartelle riservate del passo 1, (b) i singoli file pesanti del passo 1 che non sono già coperti dalle estensioni (per nome), (c) niente `.pdf` tolto senza il suo sì: se ha PDF piccoli che vuole tenere, togli la riga `*.pdf`.
4. Mostrala e chiedi il sì: quale file, dove (la cartella principale del vault, accanto a `LEGGIMI.md`), con quali righe. Con il sì, scrivi `.gitignore`.
5. Rileggi e di' come verificare: su Windows la cartella nascosta si mostra da **Visualizza**, **Mostra**, **Elementi nascosti**; su Mac, Cmd + Maiusc + `.` nel Finder. In Obsidian i file con il punto iniziale non si vedono: è normale.
6. Ricorda: quello che esclude non finisce nemmeno nelle versioni, quindi resta solo sul suo computer. Se vuole una copia, la tiene a parte.

**Output atteso**: `.gitignore` nella cartella principale del vault, con l'elenco concordato.

**Verifica**: riapri il file e leggi le righe alla persona; controlla che le cartelle riservate ci siano e che `.claude/settings.local.json` e `.obsidian/workspace*.json` siano elencati.

**Se non funziona**: se la persona non vuole il file, segna il passo «saltato» e passa al passo 5, ma avvisala che nella prima versione finiranno anche file di sistema e impostazioni personali.

- [ ] Passo 4 fatto

### Passo 5 - Aggiungi il vault a GitHub Desktop

**Perché**: GitHub Desktop deve conoscere la cartella per tenere le sue versioni.

Cosa fai:

1. **Windows**: menu **File**, **Add local repository**. **Mac**: menu **File**, **Add Local Repository**.
2. Nella finestra, clic su **Choose...** e scegli la cartella principale del vault (quella con dentro `LEGGIMI.md`). Poi **Add repository** (Windows) o **Add Repository** (Mac).
3. **Prima di crearla**: cerca cartelle `.git` dentro il vault, fuori da quella principale (per esempio una cartella di lezione scaricata con git). Se ce ne sono, spiega che GitHub Desktop non salverebbe quei file e, con il sì, togli solo la cartella `.git` interna.
4. **Se compare un avviso** che dice che la cartella non è un repository (cioè non ha ancora le sue versioni), clicca sul link **create a repository**. Nella finestra che si apre, il percorso della cartella non cambia. Lascia come sono Name e Description; lascia vuoto **Initialize this repository with a README**; lascia **Git ignore** su **None** (il tuo elenco c'è già) e **License** su **None**. Poi **Create repository**.
5. Se la cartella è già un repository, la finestra si chiude e il vault compare in alto a sinistra, accanto a **Current repository**. Non crearne un'altra.
6. Guarda la scheda **Changes** a sinistra: elenca tutti i file da salvare nella prima versione. Il numero accanto a **Changes** è quanti sono.
7. Con la persona, controlla l'elenco: ci sono file pesanti, strani o riservati? Se sì, ferma tutto: si torna al passo 4 e si corregge l'elenco.
8. Quando l'elenco è giusto, scrivi con lei la prima versione: nel campo **Summary** (in basso a sinistra) «Prima versione del vault», poi clic su **Commit to main**. «Commit» vuol dire salvare una versione.

**Output atteso**: il vault è in GitHub Desktop, con una prima versione salvata sul computer. In alto compare il tasto **Publish repository**.

**Verifica**: la scheda **Changes** è vuota («No local changes») e la scheda **History** mostra «Prima versione del vault». Chiedi alla persona di dirti cosa vede.

**Se non funziona**: se «Add local repository» la riconosce già come repository, va bene. Se non vedi il link **create a repository**, chiedi uno screenshot. Se il vault è molto grande e l'app resta lenta, chiedi quanti file mostra **Changes**: probabilmente mancano cartelle nell'elenco (passo 4).

- [ ] Passo 5 fatto

### Passo 6 - Pubblica la copia come privata

**Perché**: finora le versioni sono solo sul tuo computer. Con **Publish repository** nasce la copia su GitHub.

Cosa fai:

1. Prima di cliccare, ricordale che il passo giusto è uno solo: la casella **Keep this code private** deve essere spuntata. Se non lo è, la copia la può vedere chiunque su GitHub.
2. Nella barra in alto, clic su **Publish repository**.
3. Nella finestra **Publish Repository**, controlla Name e Description (compilati da soli).
4. Spunta **Keep this code private**. Se compare un menu **Organization**, lascialo sul tuo nome (a meno che il tuo team non abbia deciso altrimenti).
5. Clic su **Publish Repository**.
6. Per controllare: menu **Repository**, poi **View on GitHub**. Si apre il browser sulla pagina della tua copia.
7. Nella pagina, clic sul numero delle versioni (per esempio «1 commit»): in cima c'è «Prima versione del vault».
8. **Controllo che sia privata**: copia l'indirizzo della pagina, aprilo in una finestra privata (in incognito) del browser, dove non sei collegata o collegato a GitHub. Se vedi «404» o «Page not found», la copia è privata. Se vedi i tuoi file, non lo è: vedi «Se qualcosa non va» in cima.

**Output atteso**: la copia è su GitHub, privata, con la prima versione.

**Verifica**: la persona ti dice cosa ha visto nella finestra in incognito.

**Se non funziona**: se la pubblicazione si ferma con un errore su un file troppo grande (sopra i 100 MiB), non insistere. Il file è già dentro la versione e GitHub lo rifiuta: nella scheda **Changes** in basso a sinistra, clic su **Undo** (funziona solo prima di mandare su GitHub); il file torna fra i cambiamenti, lo aggiungi all'elenco del passo 4 e salvi di nuovo. Se non hai ancora pubblicato e la copia non si crea, chiedi lo screenshot.

- [ ] Passo 6 fatto

### Passo 7 - Il gesto di ogni giorno

**Perché**: è quello che userai ogni volta che finisci un lavoro. Quattro mosse, sempre le stesse.

Cosa fai:

1. Fate prima una modifica piccola e vera: per esempio una riga nel diario di un progetto, o chiedi a Claude di scrivere una nota nuova. Poi si torna in GitHub Desktop.
2. **Guarda cosa è cambiato.** Scheda **Changes**: i file cambiati con il loro colore (giallo cambiato, verde nuovo, rosso tolto). Clic su un file: a destra vedi cosa è cambiato. Togli la spunta a un file che non vuoi salvare in questa versione.
3. **Scrivi due parole su cosa hai fatto**, nel campo **Summary**, in poche parole: «Aggiorno il listino del Birrificio», non «modifiche». Fra un mese servono a ritrovare la versione.
4. **Salva la versione**: clic su **Commit to main**.
5. **Mandala su GitHub**: clic su **Push origin** (il tasto in alto, con la freccia in su).
6. Se lavori da più computer, o con altri, all'inizio del lavoro clicca **Fetch origin** (due frecce che formano un cerchio): se qualcuno ha mandato versioni nuove, il tasto diventa **Pull origin**, e cliccandolo le prendi.

**Output atteso**: **Changes** vuota e **Push origin** sparito: la versione è anche su GitHub.

**Verifica**: la persona apre **View on GitHub** (menu **Repository**) e vede la nuova versione in cima, con la sua riga.

**Se non funziona**: se **Push origin** non parte, chiedi il messaggio esatto. Se dice che ci sono versioni nuove su GitHub, la persona clicca prima **Fetch origin**, poi **Pull origin**, poi riprova.

- [ ] Passo 7 fatto

### Passo 8 - Tornare indietro

**Perché**: è il motivo per cui si fa tutto questo. Il caso di Luca: un collega salva i prezzi vecchi sopra quelli giusti. Si trova la sua versione e si annulla, senza perdere niente.

Cosa fai:

1. **Vedi lo storico.** Clic sulla scheda **History** a sinistra. Ogni riga è una versione, con la tua riga di descrizione, quando è stata fatta e il nome di chi l'ha fatta. Clic su una versione: a destra vedi i file cambiati; clic su un file per vedere esattamente cosa è cambiato.
2. **Annulla una versione sbagliata.** In **History**, clic con il tasto destro sulla versione e **Revert Changes in Commit**. Non cancella niente: crea una versione nuova che annulla quella sbagliata, e la vecchia resta nello storico. Poi **Push origin** per mandarla su GitHub. Se annulli più versioni, parti dalla più recente.
3. **Una modifica non ancora salvata**, che vuoi buttare: scheda **Changes**, seleziona il file e clic su **Discard Changes** (o **Discard All Changes** per tutti). Compare una finestra «Confirm Discard Changes»: controlla i file e conferma. Le modifiche buttate finiscono in un file nel Cestino, recuperabile finché non lo svuoti.
4. **Un solo file com'era ieri.** GitHub Desktop non ha un tasto per riprendere un file singolo da una versione vecchia (la documentazione non ne descrive uno). Due strade: **Revert Changes in Commit** se la versione sbagliata toccava solo quel file; altrimenti chiedi a Claude «riportami [file] com'era ieri sera»: se con i suoi strumenti riesce a trovarlo nello storico, riscrive il file, tu lo vedi in **Changes** come una modifica normale e lo salvi come versione nuova. Se Claude non riesce, resta il **Revert**.
5. **Provalo davvero**, con una piccola modifica sbagliata fatta apposta: cambia una riga di una nota, salva la versione, poi annullala con **Revert Changes in Commit** e controlla che la nota sia tornata com'era.

**Output atteso**: la persona ha visto lo storico e ha annullato una modifica con **Revert Changes in Commit**.

**Verifica**: la nota è tornata com'era e in **History** ci sono tre versioni: la prima, la modifica sbagliata e l'annullamento.

**Se non funziona**: se **Revert** dice che ci sono conflitti, fermati: non si risolve a caso. Chiedi lo screenshot e ragionate su quale riga tenere.

- [ ] Passo 8 fatto

---

## Alla fine

Quando i passi sono fatti (o segnati «saltato» con un motivo), riassumi in tre righe: cosa c'è adesso (programma installato, copia privata, cosa è fuori dalla copia), come si fa ogni giorno (Changes, Summary, Commit to main, Push origin), come si torna indietro (History, Revert Changes in Commit). Ricorda che nella Lezione 5 lo strumento servirà per conservare le copie e recuperare le versioni, e che chi non ha potuto installarlo non perde nulla: lo ha visto in aula.

## Registro

Claude aggiunge qui una riga per ogni sessione, la più recente in cima: data, passo raggiunto, cosa serve per riprendere (per esempio «passo 4: elenco concordato, manca da scrivere»).

- -

---

*Per gli autori: pagine ufficiali consultate il 12/11/2026 (docs.github.com): installazione di GitHub Desktop; accesso a GitHub da GitHub Desktop; aggiungere un repository dal computer; creare il primo repository con GitHub Desktop (comprese Publish e View on GitHub); commit e revisione delle modifiche, con Discard Changes; storico del ramo; annullare un commit (Undo); ripristinare un commit (Revert); opzioni per gestire i commit; sincronizzare il ramo (Fetch, Pull, Push); informazioni sui file grandi (50 MiB, 100 MiB, 1 GB); creare un account; invitare collaboratori; cambiare la visibilità. Non confermati dalla documentazione: il link «create a repository» nell'avviso, il comportamento di sincronizzazione con le cartelle in cloud, il ripristino di un singolo file da Desktop.*
