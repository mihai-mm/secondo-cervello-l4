# La tua dashboard

In lezione Paola ha aperto la giornata con una pagina sola, che rispondeva a una domanda: dove serve la mia attenzione oggi? Non l'ha riempita lei: Claude l'ha scritta leggendo i file del suo vault.

Qui ne fai una tua, per una cosa che ti serve. È l'ultimo pezzo dell'esercitazione della lezione, e lo puoi rifare quando vuoi, per altre domande.

## Cosa avrai alla fine

- **Una pagina sul tuo computer**, nella cartella principale del vault, con un nome come `Dashboard - clienti.html`. La apri con un doppio clic, nel browser. Non va online: resta lì, come gli altri tuoi file.
- **Una domanda e la sua risposta**, in cima. Sotto, quello che serve per decidere, preso dai tuoi file.
- **Ogni scheda apre la sua nota in Obsidian**, così dalla pagina torni alla fonte con un clic.
- **Una frase per aggiornarla**: «aggiorna la dashboard». Claude rilegge i file e la riscrive.

## Che domanda scegliere

Una domanda che ti fai spesso, e a cui oggi rispondi aprendo dieci note. Qualche esempio:

- **Clienti o progetti**: dove serve la mia attenzione oggi? Chi aspetta una mia risposta?
- **Contenuti**: cosa devo preparare questa settimana, e a che punto è?
- **Numeri**: com'è andato il mese, rispetto al mese prima?
- **La tua settimana**: cosa ho promesso, a chi, entro quando?

Non serve un vault pieno. Se i file sono pochi, Claude ti mostra quello che c'è e la pagina si riempie mentre lavori. Non serve nemmeno avere clienti: va bene qualsiasi cosa che segui nel tempo.

## Come si usa

1. Questo file deve stare dentro il tuo vault, in `0-Inbox/`, con il resto della cartella della lezione.
2. Apri nell'app una conversazione nuova nella cartella del vault e scrivi:

> Leggi «La tua dashboard» nella cartella della lezione e guidami.

Se sai già cosa vuoi, puoi andare dritto con questa frase, cambiando quello tra parentesi quadre:

> Fammi una dashboard che risponda a una domanda: [la tua domanda]. Leggi i file del vault che servono e dimmi quali prima di leggerli. Ogni scheda apre la sua nota in Obsidian. Un file solo nella cartella principale del vault, che resta sul computer. Quando hai finito, aprila nel browser.

## Se qualcosa non va

- **Al primo clic su una scheda il browser chiede se aprire Obsidian**: va consentito (puoi spuntare «consenti sempre»).
- **Obsidian dice che il vault non c'è**: il nome nel link non è quello del tuo vault. Dillo a Claude: lo corregge.
- **La pagina non si apre da sola**: cercala nella cartella del vault (nel Finder sul Mac, in Esplora file su Windows) e aprila con un doppio clic.

---

## Da qui in giù è per Claude: non devi leggerlo

## Regole

Valgono insieme a quelle del `CLAUDE.md` del vault; se qualcosa è in conflitto, valgono quelle del vault, e lo dici.

1. **Una domanda alla volta**, con opzioni numerate quando servono. Mai due passi senza la conferma della persona.
2. **Non dare per scontato** che la persona abbia clienti, progetti in corso, contenuti da pubblicare o un vault pieno. Se un pezzo non si applica, si salta.
3. **Leggi solo dentro il vault**, e solo ciò che serve alla domanda. Prima di leggere di' quali cartelle leggerai. Non aprire diari personali (`Daily/`) né aree private senza un sì esplicito.
4. **Non inventare niente.** Ogni numero e ogni data della pagina vengono da un file. Se un dato manca, la pagina dice che manca. Niente dati di esempio nella pagina della persona.
5. **La pagina resta sul computer**: niente pubblicazione, niente artifact, niente dati mandati fuori. Usa i caratteri già presenti nel computer.

## Come condurre

1. **La domanda.** Chiedi a cosa servirà la pagina, con questo menu (risponde con il numero):
   1. dove serve la mia attenzione oggi (clienti, progetti, scadenze);
   2. a che punto sono i miei progetti o i miei clienti;
   3. cosa devo preparare questa settimana (contenuti, documenti, consegne);
   4. i numeri di un periodo (un mese, un trimestre);
   5. un'altra domanda: la scrive lei.
2. **Le fonti.** Guarda `Home.md` e le cartelle del vault, poi proponi da quali file leggere: per esempio lo `Stato corrente` del diario più recente di ogni progetto (in `attivita/`, la settimana più alta nel nome), le `MEMORY.md`, le call in `calls/`, un calendario, un file di numeri. Aspetta il sì, poi leggi.
3. **Vault quasi vuoto.** Se per la domanda ci sono pochi file, va bene: dillo in una riga e prosegui con quello che c'è. Ogni sezione vuota della pagina ha una riga che dice come si riempirà («quando un progetto avrà il suo diario, qui compare il prossimo passo»). Se per quella domanda non c'è proprio niente, proponi una domanda per cui i file ci sono, oppure una pagina che elenca quali file servirebbero e dove metterli.
4. **La proposta.** Prima di scrivere, mostra in cinque o sei righe cosa ci sarà nella pagina e da quali file viene ogni parte. Aspetta il sì.
5. **La pagina.** Un file HTML solo, nella cartella principale del vault, con il nome `Dashboard - [argomento].html` (per esempio `Dashboard - clienti.html`). Dentro:
   - in cima la domanda e la risposta in una frase («In breve»), poi la data a cui sono fermi i dati;
   - le sezioni concordate; per «dove serve la mia attenzione» tre colonne: cosa scade nei prossimi sette giorni, cosa è fermo, cosa aspetta una risposta (da chi, da quando);
   - date con il giorno della settimana («lunedì 16 novembre»), numeri con la loro fonte;
   - in fondo «Cosa manca o non torna nei file» e l'elenco dei file letti;
   - leggibile anche su uno schermo stretto. Se nel vault c'è un brand o uno stile (un file `brand-*.md`), proponi di usarlo per colori e caratteri.
6. **I link a Obsidian.** Ogni scheda apre la nota da cui viene, con un link `obsidian://open?vault=NOME&file=PERCORSO`: NOME è il nome della cartella del vault, PERCORSO il percorso del file dentro il vault (con le barre `/`, anche su Windows); tutti e due codificati per un indirizzo web (lo spazio diventa `%20`, la barra `%2F`). Esempio: `obsidian://open?vault=Il%20mio%20vault&file=1-Projects%2FCliente%20Rossi%2Fattivita%2F2026-W46.md`.
7. **Annuncia e scrivi.** Di' il nome del file e dove lo metti, aspetta il sì, scrivilo.
8. **Aprila.** Sul Mac: `open "Dashboard - [argomento].html"`; su Windows, in PowerShell: `Invoke-Item "Dashboard - [argomento].html"` (nel terminale Bash: `start "" "Dashboard - [argomento].html"`). Se il comando non parte, di' alla persona dove trovare il file e di aprirlo con un doppio clic. Poi chiedi di cliccare una scheda: deve aprirsi Obsidian sulla nota giusta. Al primo clic il browser chiede se aprire Obsidian: spiega che va consentito. Se Obsidian dice che il vault non c'è, chiedi il nome del vault che vede in Obsidian (in basso a sinistra) e correggi i link.
9. **Perché funzioni anche domani.** Proponi di aggiungere al `CLAUDE.md` del vault due righe: dove sta la dashboard, quali file legge e che con «aggiorna la dashboard» si rileggono quei file e si riscrive la pagina. Con il sì, aggiungile.
10. **Chiusura.** Di' in tre righe cosa c'è nella pagina, da quali file viene e come si aggiorna. Se questo file è stato aperto dalla guida «Il tuo stile al lavoro», torna lì e spunta il passo.
