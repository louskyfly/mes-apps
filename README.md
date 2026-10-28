# Mes apps — lanceur de raccourcis pour iPad

Une page web unique, façon écran d'accueil, avec des tuiles qui ouvrent YouTube,
AnyDesk, OpenCode et Arc. On l'ajoute à l'écran d'accueil de l'iPad : elle
s'ouvre alors en plein écran, sans barre d'adresse, comme une vraie app.

## Structure

```
mes-apps\
├── public\                     <- ce qui est publié
│   ├── index.html              la page (HTML + CSS + JS, sans dépendance)
│   ├── manifest.webmanifest    nom, icône, mode plein écran
│   ├── icon-180.png            icône iPad / iPhone
│   ├── icon-192.png            icône Android / favicon
│   └── icon-512.png            icône haute résolution
├── .github\workflows\pages.yml publication automatique sur GitHub Pages
├── firebase.json               config Firebase Hosting (alternative)
├── demarrer.cmd                aperçu local (double-clic)
└── README.md                   ce fichier
```

## Modifier la liste des apps

Dans `public/index.html`, vers le milieu du fichier :

```js
const APPS = [
  { name: "YouTube",   url: "https://www.youtube.com/",     icon: "youtube",   embed: false },
  { name: "AnyDesk",   url: "https://anydesk.com/fr",       icon: "anydesk",   embed: false },
  { name: "WhatsApp",  url: "https://web.whatsapp.com/",    icon: "whatsapp",  embed: false },
  { name: "Instagram", url: "https://www.instagram.com/",   icon: "instagram", embed: false },
];
```

- **Ajouter une app** : copie une ligne, change `name` et `url`.
- **Retirer une app** : supprime la ligne.
- `icon` peut être `youtube`, `anydesk`, `whatsapp`, `instagram` ou `web`.
  Si tu mets autre chose, la tuile affiche la première lettre du nom.
- `embed: true` affiche le site **dans** la page. `embed: false` (YouTube,
  AnyDesk, WhatsApp, Instagram : tous les quatre refusent) affiche un message
  dans la page, avec un bouton pour ouvrir le site.

## Ouvrir une app « dans la page » : ce qui est possible

Un site ne peut être affiché dans un cadre (`<iframe>`) que si **son serveur
l'autorise**. Trois des quatre apps qui t'intéressent envoient un refus
explicite, que le navigateur applique sans discussion :

| Site | En-tête envoyé | Affichage intégré |
| --- | --- | --- |
| youtube.com | `X-Frame-Options: SAMEORIGIN` | non |
| anydesk.com | `X-Frame-Options: SAMEORIGIN` | non |
| web.whatsapp.com | `CSP: frame-ancestors *.whatsapp.com` | non |
| instagram.com | `X-Frame-Options: DENY` | non |

Aucune page web ne peut contourner ça : c'est le serveur du site qui décide,
pas le navigateur. La seule façon d'afficher ces sites dans ta page serait un
serveur intermédiaire qui télécharge les pages et les réécrit — un proxy. Ça
sort du cadre d'un simple site et ça revient à contourner le filtrage réseau
du lycée.

## Aperçu local

Double-clique `demarrer.cmd` → <http://127.0.0.1:8765>.
Ou ouvre `public/index.html` directement (le manifeste et les icônes ne sont
alors pas lus, ce qui n'a aucune importance sur PC).

## Mettre en ligne

### GitHub Pages (déjà en place)

Le site est publié automatiquement à chaque `git push` sur `main`, par le
workflow `.github/workflows/pages.yml` qui publie le dossier `public/`.

**Adresse : <https://louskyfly.github.io/mes-apps/>**
Dépôt : <https://github.com/louskyfly/mes-apps>

Pour mettre à jour :

```powershell
cd C:\Users\sanch\mes-apps
git add -A
git commit -m "mise a jour"
git push
```

Compter une minute, puis la page est à jour.

### Firebase Hosting (alternative)

Le dossier est aussi prêt pour Firebase, si tu préfères un domaine `.web.app` :

1. Récupère l'**ID du projet** sur <https://console.firebase.google.com>
   (du genre `mes-apps-a1b2c`, ce qui donnera
   `https://mes-apps-a1b2c.web.app`).
2. Écris-le dans `.firebaserc` :

   ```json
   { "projects": { "default": "mes-apps-a1b2c" } }
   ```

3. Publie :

   ```powershell
   cd C:\Users\sanch\mes-apps
   firebase login            # une seule fois, ouvre le navigateur
   firebase deploy --only hosting
   ```

### Mettre l'app sur l'iPad

1. Ouvre l'adresse dans **Safari** (pas Chrome : sur iPad, seul Safari sait
   créer un raccourci web) — et vérifie qu'elle n'est pas filtrée par le lycée.
2. Bouton **Partager** → **Sur l'écran d'accueil** → *Ajouter*.

La page s'ouvre ensuite en plein écran, avec l'icône et le nom « Mes apps ».

## Ce que cette page ne peut pas faire

- **Afficher YouTube / AnyDesk / OpenCode *dans* la page.** Ces sites envoient
  des en-têtes (`X-Frame-Options`, `Content-Security-Policy`) qui interdisent
  l'affichage dans un cadre. Le navigateur bloque, on ne peut pas contourner ça
  côté page web. Les tuiles ouvrent donc le vrai site.
- **Franchir le pare-feu du lycée.** Une page web ne cache pas le domaine
  qu'elle visite : l'iPad demande toujours `youtube.com` au réseau. Si ce
  domaine est filtré, il reste filtré. Un lanceur sert à ranger ses accès, pas
  à contourner un filtrage réseau.
