#!/usr/bin/perl
# Genera immagini con OpenRouter oppure con OpenAI (versione Mac).
# Usa solo perl e curl, già presenti sul Mac: non c'è nulla da installare.
# La chiave sta in ~/.config/immagini/.env (fuori dal vault) e non viene mai stampata.
#
# Uso:
#   perl genera.pl --richiesta "una lattina di birra sulla neve" --proporzione 4:5 --varianti 3
#   perl genera.pl --file-richiesta richiesta.txt --rif foto.png --rif altra.png
#
# Opzioni:
#   --richiesta "testo"      cosa deve vedersi (oppure --file-richiesta file.txt)
#   --rif file               immagine di riferimento (si ripete, fino a 14)
#   --proporzione 4:5        1:1, 4:5, 3:2, 16:9, 9:16... (predefinita 1:1)
#   --varianti 3             quante immagini (predefinito 1, massimo 10)
#   --modello nome           facoltativo; sceglie lo strumento in automatico
#   --uscita cartella        predefinita: _attachments/immagini/
#   --nome prefisso          prefisso del nome file (predefinito: immagine)
#   --servizio openrouter|openai   solo se nel .env ci sono entrambe le chiavi
#   --risoluzione 1K         1K (predefinita), 2K o 4K: più grande costa di più
#   --prova                  immagine piccola e quasi gratis, per controllare che tutto funzioni
#   --solo-galleria          non genera: riscrive soltanto la galleria (galleria.html nella cartella di uscita)
#   --cartella-prompt dir    dove stanno i prompt salvati (predefinita: 3-Resources/Prompt immagini)
#
# Galleria: dopo ogni generazione lo strumento riscrive galleria.html nella cartella di uscita, partendo da
# galleria-modello.html della skill. Dentro mette l'elenco delle immagini (dalle ricette .json) e dei prompt salvati
# (i file .md della cartella dei prompt). La pagina si apre con un doppio clic e non va online.
use strict;
use warnings;
use utf8;
use Getopt::Long qw(GetOptions);
use JSON::PP;
use MIME::Base64 qw(encode_base64 decode_base64);
use File::Temp qw(tempfile);
use File::Path qw(make_path);
use File::Basename qw(basename dirname);
use Encode qw(decode encode);
use POSIX qw(strftime);
use FindBin qw($RealBin);
use File::Copy qw(copy);
use Cwd qw(abs_path);

binmode(STDOUT, ':encoding(UTF-8)');
binmode(STDERR, ':encoding(UTF-8)');

# File temporanei (uno contiene la chiave): se il programma viene interrotto, si cancellano.
our @TEMPORANEI;
$SIG{INT} = $SIG{TERM} = sub { unlink @TEMPORANEI; exit 1; };

my ($risoluzione, $richiesta, $file_richiesta, @rif, $proporzione, $varianti, $modello, $uscita, $nome, $servizio, $prova, $solo_galleria, $cartella_prompt);
$proporzione = '1:1';
$varianti    = 1;
$uscita      = '_attachments/immagini';
$nome        = 'immagine';
$cartella_prompt = '3-Resources/Prompt immagini';
GetOptions(
    'richiesta=s'      => \$richiesta,
    'file-richiesta=s' => \$file_richiesta,
    'rif=s'            => \@rif,
    'proporzione=s'    => \$proporzione,
    'varianti=i'       => \$varianti,
    'modello=s'        => \$modello,
    'uscita=s'         => \$uscita,
    'nome=s'           => \$nome,
    'servizio=s'       => \$servizio,
    'prova'            => \$prova,
    'risoluzione=s'    => \$risoluzione,
    'solo-galleria'    => \$solo_galleria,
    'cartella-prompt=s' => \$cartella_prompt,
) or fine("Opzione non riconosciuta. Controlla il comando e riprova.");

for ($richiesta, $proporzione, $modello, $uscita, $nome, $servizio, $cartella_prompt) {
    $_ = decode('UTF-8', $_) if defined $_ && !utf8::is_utf8($_);
}

# --- solo la galleria, senza generare ---
if ($solo_galleria) {
    make_path($uscita) unless -d $uscita;
    my $g = aggiorna_galleria($uscita, $cartella_prompt);
    fine("Non riesco a scrivere la galleria in $uscita (manca galleria-modello.html nella skill?).") unless $g;
    print "Galleria aggiornata: $g\n";
    exit 0;
}

# --- richiesta ---
if (defined $file_richiesta) {
    open(my $fh, '<:encoding(UTF-8)', $file_richiesta)
        or fine("Non riesco a leggere il file della richiesta: $file_richiesta");
    local $/; $richiesta = <$fh>; close $fh;
}
fine("Manca la richiesta. Scrivi cosa deve vedersi nell'immagine (--richiesta \"...\" oppure --file-richiesta file.txt).")
    unless defined $richiesta && $richiesta =~ /\S/;
fine("Le proporzioni vanno scritte così: 1:1, 4:5, 3:2, 16:9, 9:16.") unless $proporzione =~ /^\d+(?:\.\d+)?:\d+(?:\.\d+)?$/;
$varianti = 1 if $varianti < 1;
fine("Al massimo 10 varianti per volta.") if $varianti > 10;
fine("Al massimo 14 immagini di riferimento.") if @rif > 14;
for my $r (@rif) {
    fine("Non trovo l'immagine di riferimento: $r") unless -f $r;
}

# --- chiave ---
my $env_path = $ENV{IMMAGINI_ENV} || ($ENV{HOME} . '/.config/immagini/.env');
my %chiavi = leggi_env($env_path);
my $ha_or = ($chiavi{OPENROUTER_API_KEY} // '') ne '';
my $ha_oa = ($chiavi{OPENAI_API_KEY} // '') ne '';
if (!$ha_or && !$ha_oa) {
    fine("Non trovo la chiave per generare le immagini.\n"
       . "Serve il file $env_path con una riga OPENROUTER_API_KEY=... oppure OPENAI_API_KEY=...\n"
       . "Segui la preparazione guidata (file PREPARA.md della skill).");
}
if ($servizio) {
    $servizio = lc $servizio;
    fine("Il servizio può essere solo openrouter oppure openai.") unless $servizio =~ /^(openrouter|openai)$/;
    fine("Nel file .env non c'è la chiave di $servizio.")
        if ($servizio eq 'openrouter' && !$ha_or) || ($servizio eq 'openai' && !$ha_oa);
} else {
    $servizio = $ha_or ? 'openrouter' : 'openai';
}
my $chiave = $servizio eq 'openrouter' ? $chiavi{OPENROUTER_API_KEY} : $chiavi{OPENAI_API_KEY};
$modello ||= $servizio eq 'openrouter' ? 'google/gemini-3.1-flash-image' : 'gpt-image-2.6-flare';

# --- riferimenti ---
my @rif_dati;
for my $r (@rif) {
    open(my $fh, '<:raw', $r) or fine("Non riesco a leggere $r");
    local $/; my $raw = <$fh>; close $fh;
    push @rif_dati, { percorso => $r, nome => basename($r), raw => $raw, mime => mime_da_nome($r, $raw) };
}

make_path($uscita) unless -d $uscita;
fine("Non riesco a creare la cartella $uscita") unless -d $uscita;

# Le foto di partenza che stanno fuori dalla cartella delle immagini si copiano in riferimenti/, così la galleria le
# mostra accanto al risultato. Nella ricetta resta il nome con cui la galleria le trova.
my $uscita_abs = abs_path($uscita);
for my $r (@rif_dati) {
    my $dir_rif = abs_path(dirname($r->{percorso})) // '';
    next if $dir_rif eq $uscita_abs;
    make_path("$uscita/riferimenti") unless -d "$uscita/riferimenti";
    my ($radice, $est) = $r->{nome} =~ /^(.*?)(\.[^.]*)?$/;
    $est //= '';
    my $nome_rif = $r->{nome};
    for (my $k = 2; -e "$uscita/riferimenti/$nome_rif"; $k++) {
        last if -s "$uscita/riferimenti/$nome_rif" == length($r->{raw});   # stessa foto, già copiata
        $nome_rif = "$radice-$k$est";
    }
    copy($r->{percorso}, "$uscita/riferimenti/$nome_rif") unless -e "$uscita/riferimenti/$nome_rif";
    $r->{nome} = "riferimenti/$nome_rif";
}

my $json = JSON::PP->new->utf8->canonical;
my $data_tag = strftime('%Y%m%d-%H%M%S', localtime);
my @salvate;
my $costo_tot = 0;
my $costo_noto = 0;

for my $i (1 .. $varianti) {
    my $t0 = time;
    my ($codice, $resp, $esito_curl) = chiama($servizio, $chiave, $modello, $richiesta, $proporzione, \@rif_dati, $prova);
    if ($esito_curl) {
        fine("Non riesco a collegarmi a internet (curl, codice $esito_curl). Controlla la connessione e riprova."
             . (@salvate ? "\nImmagini già salvate: " . join(', ', @salvate) : ''));
    }
    if ($codice != 200) {
        spiega_errore($codice, $resp, $servizio, $modello, \@salvate);
    }
    my ($b64, $url_img, $costo, $testo) = estrai($resp);
    my $raw;
    if (defined $b64) {
        $raw = decode_base64($b64);
    } elsif (defined $url_img && $url_img =~ m{^data:[^;]+;base64,(.+)$}s) {
        $raw = decode_base64($1);
    }
    if (!defined $raw || !length $raw) {
        fine("Il servizio non ha restituito nessuna immagine."
             . (defined $testo && length $testo ? " Ha risposto: " . substr($testo, 0, 200) : '')
             . "\nProva a riscrivere la richiesta in modo diverso." . (@salvate ? "\nImmagini già salvate: " . join(', ', @salvate) : ''));
    }
    my $ext = $raw =~ /^\x89PNG/ ? 'png' : $raw =~ /^\xff\xd8\xff/ ? 'jpg' : $raw =~ /^RIFF.{4}WEBP/s ? 'webp' : 'png';
    my $base = sprintf('%s-%s-%d', $nome, $data_tag, $i);
    my $file = "$uscita/$base.$ext";
    open(my $out, '>:raw', $file) or fine("Non riesco a salvare $file");
    print $out $raw; close $out;

    my %meta = (
        richiesta   => $richiesta,
        modello     => $modello,
        servizio    => $servizio,
        riferimenti => [ map { utf8::is_utf8($_->{nome}) ? $_->{nome} : decode('UTF-8', $_->{nome}) } @rif_dati ],
        proporzione => $proporzione,
        data        => strftime('%Y-%m-%d %H:%M:%S', localtime),
        secondi     => time - $t0,
        costo_usd   => $costo,
        file        => "$base.$ext",
    );
    open(my $mj, '>:raw', "$uscita/$base.json") or fine("Non riesco a salvare $uscita/$base.json");
    print $mj JSON::PP->new->utf8->canonical->pretty->encode(\%meta); close $mj;

    if (defined $costo) { $costo_tot += $costo; $costo_noto = 1; }
    push @salvate, "$file";
    print "Salvata: $file" . (defined $costo ? sprintf(" (costo %.3f \$)", $costo) : '') . "\n";
}
print "Fatto: " . scalar(@salvate) . " immagine/i in $uscita"
    . ($costo_noto ? sprintf(", costo totale circa %.3f \$", $costo_tot) : ", costo non comunicato dal servizio") . ".\n";
my $galleria = aggiorna_galleria($uscita, $cartella_prompt);
print "Galleria aggiornata: $galleria (si apre con un doppio clic)\n" if $galleria;
exit 0;

# ---------------------------------------------------------------

# Riscrive galleria.html nella cartella delle immagini: il modello della skill con dentro le ricette delle immagini e i
# prompt salvati. Restituisce il percorso, oppure '' se il modello manca.
sub aggiorna_galleria {
    my ($dir, $dir_prompt) = @_;
    my $modello_html = "$RealBin/../galleria-modello.html";
    return '' unless -f $modello_html;
    my $j = JSON::PP->new->utf8;
    my @immagini;
    if (opendir(my $dh, $dir)) {
        for my $f (sort grep { /\.json$/i && !/^_/ } readdir $dh) {
            open(my $fh, '<:raw', "$dir/$f") or next;
            my $txt = do { local $/; <$fh> }; close $fh;
            my $m = eval { $j->decode($txt) };
            next unless ref $m eq 'HASH' && $m->{file} && defined $m->{richiesta} && -f "$dir/$m->{file}";
            push @immagini, $m;
        }
        closedir $dh;
    }
    my @prompt;
    if (defined $dir_prompt && opendir(my $dp, $dir_prompt)) {
        for my $f (sort grep { /\.md$/i && !/^[_.]/ } readdir $dp) {
            open(my $fh, '<:raw', "$dir_prompt/$f") or next;
            my $txt = do { local $/; <$fh> }; close $fh;
            push @prompt, { file => decode('UTF-8', $f), testo => decode('UTF-8', $txt),
                            modificato => strftime('%Y-%m-%d %H:%M:%S', localtime((stat("$dir_prompt/$f"))[9])) };
        }
        closedir $dp;
    }
    my $dati = JSON::PP->new->utf8->canonical->encode({
        aggiornata => strftime('%Y-%m-%d %H:%M:%S', localtime), cartella_prompt => $dir_prompt,
        immagini => \@immagini, prompt => \@prompt });
    $dati =~ s/</\\u003c/g;     # nessun «<» dentro lo script: la pagina non si può rompere
    open(my $mh, '<:raw', $modello_html) or return '';
    my $html = do { local $/; <$mh> }; close $mh;
    my $apri = '<script id="dati" type="application/json">';
    my $a = index($html, $apri);
    return '' if $a < 0;
    my $b = index($html, '</script>', $a);
    return '' if $b < 0;
    substr($html, $a + length($apri), $b - $a - length($apri)) = $dati;
    my $dest = "$dir/galleria.html";
    open(my $out, '>:raw', $dest) or return '';
    print $out $html; close $out;
    return $dest;
}

sub fine {
    my ($msg) = @_;
    print STDERR "ERRORE: $msg\n";
    exit 1;
}

sub leggi_env {
    my ($p) = @_;
    my %h;
    return %h unless -f $p;
    open(my $fh, '<:raw', $p) or return %h;
    while (my $l = <$fh>) {
        $l =~ s/\r?\n$//;
        $l =~ s/^\x{EF}\x{BB}\x{BF}//;
        next if $l =~ /^\s*#/;
        next unless $l =~ /^\s*(?:export\s+)?([A-Za-z0-9_]+)\s*=\s*(.*?)\s*$/;
        my ($k, $v) = ($1, $2);
        $v =~ s/^(["'])(.*)\1$/$2/;
        next if $v eq '' || $v =~ /^(incolla|\.\.\.|xxx)/i;
        $h{$k} = $v;
    }
    close $fh;
    return %h;
}

sub mime_da_nome {
    my ($p, $raw) = @_;
    return 'image/png'  if $raw =~ /^\x89PNG/;
    return 'image/jpeg' if $raw =~ /^\xff\xd8\xff/;
    return 'image/webp' if $raw =~ /^RIFF.{4}WEBP/s;
    return 'image/png';
}

# Dimensioni in pixel (multipli di 16, circa 1 megapixel) per OpenAI.
sub dimensioni {
    my ($prop) = @_;
    my ($w, $h) = split /:/, $prop;
    my $s = sqrt(1048576 / ($w * $h));
    my $W = int($w * $s / 16 + 0.5) * 16;
    my $H = int($h * $s / 16 + 0.5) * 16;
    $W = 1536 if $W > 1536; $H = 1536 if $H > 1536;
    return "${W}x${H}";
}

sub data_url { my ($r) = @_; return "data:$r->{mime};base64," . encode_base64($r->{raw}, ''); }

sub chiama {
    my ($serv, $chiave, $modello, $richiesta, $prop, $rif, $prova) = @_;

    my ($hfh, $hfile) = tempfile('immagini-h-XXXXXX', TMPDIR => 1, UNLINK => 0);
    push @TEMPORANEI, $hfile;
    chmod 0600, $hfile;
    print $hfh "Authorization: Bearer $chiave\n";
    print $hfh "X-Title: Secondo Cervello - immagini\n" if $serv eq 'openrouter';
    close $hfh;
    my ($rfh, $rfile) = tempfile('immagini-r-XXXXXX', TMPDIR => 1, UNLINK => 0);
    close $rfh;
    push @TEMPORANEI, $rfile;
    my @pulizia = ($hfile, $rfile);

    my @args = ('-sS', '-X', 'POST', '--connect-timeout', '20', '--max-time', '300',
                '-H', '@' . $hfile, '-o', $rfile, '-w', '%{http_code}');
    my ($url, $bfile);
    if ($serv eq 'openrouter') {
        $url = 'https://openrouter.ai/api/v1/images';
        my %body = (
            model        => $modello,
            prompt       => $richiesta,
            aspect_ratio => $prop,
            n            => 1,
        );
        if ($modello =~ /gpt-image/) { $body{quality} = $prova ? 'low' : 'medium'; }
        if ($modello =~ m{^google/gemini}) { $body{resolution} = $prova ? '512' : ($risoluzione || '1K'); }
        elsif ($risoluzione) { $body{resolution} = $risoluzione; }
        if (@$rif) {
            $body{input_references} = [ map { { type => 'image_url', image_url => { url => data_url($_) } } } @$rif ];
        }
        my $fh; ($fh, $bfile) = tempfile('immagini-b-XXXXXX', TMPDIR => 1, UNLINK => 0);
        binmode $fh; print $fh JSON::PP->new->utf8->encode(\%body); close $fh;
        push @pulizia, $bfile;
        push @TEMPORANEI, $bfile;
        push @args, '-H', 'Content-Type: application/json', '--data-binary', '@' . $bfile, $url;
    } else {
        my $size = $prova ? '1024x1024' : dimensioni($prop);
        my $qual = $prova ? 'low' : 'medium';
        if (@$rif) {
            $url = 'https://api.openai.com/v1/images/edits';
            push @args, '--form-string', "model=$modello", '--form-string', 'prompt=' . encode('UTF-8', $richiesta),
                        '--form-string', "size=$size", '--form-string', "quality=$qual", '-F', 'n=1';
            for my $r (@$rif) {
                push @args, '-F', "image[]=\@$r->{percorso};type=$r->{mime}";
            }
            push @args, $url;
        } else {
            $url = 'https://api.openai.com/v1/images/generations';
            my %body = (model => $modello, prompt => $richiesta, size => $size, quality => $qual, n => 1);
            my $fh; ($fh, $bfile) = tempfile('immagini-b-XXXXXX', TMPDIR => 1, UNLINK => 0);
            binmode $fh; print $fh JSON::PP->new->utf8->encode(\%body); close $fh;
            push @pulizia, $bfile;
            push @TEMPORANEI, $bfile;
            push @args, '-H', 'Content-Type: application/json', '--data-binary', '@' . $bfile, $url;
        }
    }

    my ($codice, $esito) = (0, 0);
    for my $tentativo (1 .. 2) {
        open(my $p, '-|', 'curl', @args) or do { unlink @pulizia; fine("Non trovo il programma curl sul computer."); };
        my $c = <$p>; close $p;
        $esito = $? >> 8;
        $codice = defined $c ? $c + 0 : 0;
        last if $esito;
        last unless ($codice == 429 || $codice >= 500) && $tentativo == 1;
        sleep 8;
    }
    my $resp = '';
    if (open(my $in, '<:raw', $rfile)) { local $/; $resp = <$in>; close $in; }
    unlink @pulizia;
    my $dec = eval { JSON::PP->new->utf8->decode($resp) };
    return ($codice, $dec // { _grezzo => substr($resp, 0, 300) }, $esito);
}

sub estrai {
    my ($r) = @_;
    my ($b64, $url, $costo, $testo);
    if (ref $r->{data} eq 'ARRAY' && @{ $r->{data} }) {
        $b64 = $r->{data}[0]{b64_json};
        $url = $r->{data}[0]{url};
    }
    if (ref $r->{usage} eq 'HASH') { $costo = $r->{usage}{cost}; }
    if (ref $r->{choices} eq 'ARRAY' && @{ $r->{choices} }) {
        my $m = $r->{choices}[0]{message} || {};
        $testo = $m->{content} if defined $m->{content} && !ref $m->{content};
    }
    return ($b64, $url, $costo, $testo);
}

sub spiega_errore {
    my ($codice, $r, $serv, $modello, $salvate) = @_;
    my $msg = '';
    if (ref $r eq 'HASH') {
        if (ref $r->{error} eq 'HASH') { $msg = $r->{error}{message} // ''; $msg .= ' ' . ($r->{error}{code} // '') if ref \($r->{error}{code}) eq 'SCALAR'; }
        elsif (defined $r->{error}) { $msg = "$r->{error}"; }
        elsif ($r->{_grezzo}) { $msg = $r->{_grezzo}; }
    }
    $msg =~ s/\s+/ /g;
    my $dettaglio = length $msg ? " Dettaglio del servizio: " . substr($msg, 0, 250) : '';
    my $gia = @$salvate ? "\nImmagini già salvate: " . join(', ', @$salvate) : '';
    my $nomeserv = $serv eq 'openrouter' ? 'OpenRouter' : 'OpenAI';
    if ($codice == 401) {
        fine("La chiave non è valida (errore 401). Controlla di averla incollata per intero nel file .env, "
           . "senza spazi né virgolette, e che su $nomeserv non sia stata disattivata.$gia");
    }
    if ($codice == 402 || ($codice == 429 && $msg =~ /quota|billing|credit|insufficient/i)) {
        fine("Il credito è finito (errore $codice). Su $nomeserv va ricaricato il credito, oppure il tetto di spesa della chiave è stato raggiunto.$dettaglio$gia");
    }
    if ($codice == 404 || ($codice == 400 && $msg =~ /model/i && $msg =~ /(valid|exist|found|support|access|unknown)/i)) {
        fine("Il modello «$modello» non esiste o non è disponibile con questa chiave. "
           . "Togli l'opzione --modello per usare quello predefinito.$dettaglio$gia");
    }
    if ($codice == 429) {
        fine("Troppe richieste in poco tempo (errore 429). Aspetta un minuto e riprova.$gia");
    }
    if ($codice >= 500) {
        fine("Il servizio $nomeserv ha un problema momentaneo (errore $codice). Riprova fra qualche minuto.$dettaglio$gia");
    }
    if ($codice == 0) {
        fine("Nessuna risposta dal servizio. Controlla la connessione e riprova.$gia");
    }
    fine("La richiesta non è stata accettata (errore $codice).$dettaglio$gia");
}
