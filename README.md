# USDT (BEP20) Payment + Subscription System — Unified Deploy

Ab frontend aur backend **ek hi Render service** mein deploy hote hain. Alag static site
banane ki zaroorat nahi.

## Structure
```
/
├── server.js          ← Express API + static file server
├── package.json
├── .env.example        ← copy to .env, fill real values
├── subscribers.json     ← auto-managed database
└── public/
    ├── index.html       ← one-time payment page (Send USDT)
    ├── subscribe.html    ← subscription page
    └── manifest.json     ← for "Add to Home Screen" fullscreen mode
```

## Render pe deploy karne ke steps

1. Is poore folder ko GitHub repo mein push karo (root mein `server.js`, `package.json` sab
   direct dikhne chahiye — kisi sub-folder ke andar NAHI)
2. Render → **"New +"** → **"Web Service"** → apna repo connect karo
3. Settings:
   - **Root Directory:** khali chhodo (blank) — ab sab kuch root mein hai
   - **Build Command:** `npm install`
   - **Start Command:** `node server.js`
4. **Environment Variables** mein `.env.example` jaisi values daalo (private key waghera —
   real secrets, kabhi GitHub pe commit mat karna)
5. Deploy karo

## Deploy hone ke baad

Ek hi URL milega (jaisa `xyz.onrender.com`), jispe:
- `xyz.onrender.com/` → payment page (Send USDT)
- `xyz.onrender.com/subscribe.html` → subscription page
- `xyz.onrender.com/api/...` → backend APIs (subscribe, unsubscribe, status)

Customers ko link bhejte waqt seedha `xyz.onrender.com` ya `xyz.onrender.com/subscribe.html`
bhejna hai — dono automatically usi server se serve hongi, koi alag backend URL set karne
ki zaroorat nahi (frontend files mein `BACKEND_URL` empty rakha hai isi wajah se).

## Telegram admin bot

Pehle jaisa hi — `.env` mein `TELEGRAM_BOT_TOKEN` aur `ADMIN_TELEGRAM_ID` set karo, bot
isi server ke andar automatically start ho jayega. Commands: `/list`, `/cancel`, `/resume`,
`/status`, `/charge`.

## Smart Contract (naya, recommended)

Personal wallet ko approve karne ki jagah, ab customers **SubscriptionBilling.sol contract**
ko approve karte hain — wallets isko zyada trust karte hain, aur subscriber-status +
lifetime-cap dono blockchain pe khud enforce hote hain.

**Deploy karne ka poora guide:** `/contract/DEPLOY_GUIDE.md` (Remix IDE se, browser mein hi
ho jata hai, kuch install nahi chahiye)

Deploy hone ke baad:
1. Naye contract address ko **backend** ke `.env` mein `CONTRACT_ADDRESS` mein daalo
2. Wahi address **frontend** (`public/subscribe.html`) mein `CONTRACT_ADDRESS` constant mein daalo
3. `SPENDER_PRIVATE_KEY` wahi rahegi jo backend mein hai — bas ab ye wallet contract ka
   **owner** honi chahiye

## Zaroori Security Baatein

1. `.env` file kabhi GitHub pe mat daalna — sirf Render ke Environment Variables mein.
2. `SPENDER_PRIVATE_KEY` kisi ko mat dikhana.
3. Spender wallet mein sirf utna hi BNB/USDT rakho jitna is kaam ke liye chahiye.
4. Amount hamesha capped rakho (TOTAL_CAP), kabhi unlimited approval mat maango.
