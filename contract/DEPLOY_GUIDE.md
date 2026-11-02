# Smart Contract Deploy Karne Ka Guide (Remix IDE se)

Kuch bhi install nahi karna — sab browser mein ho jayega.

## Step 1: Remix kholo
1. Browser mein jao: **https://remix.ethereum.org**
2. Left sidebar mein **"File Explorer"** icon pe click karo
3. Naya file banao: **`SubscriptionBilling.sol`**
4. Is repo ke `contract/SubscriptionBilling.sol` ka poora code copy-paste karo usme

## Step 2: Compile karo
1. Left sidebar mein **"Solidity Compiler"** icon (2nd icon) pe click karo
2. Compiler version **0.8.19** ya usse upar select karo
3. **"Compile SubscriptionBilling.sol"** button dabao
4. Green checkmark aana chahiye — matlab code sahi hai, koi error nahi

## Step 3: MetaMask ko BSC pe connect karo
1. Apne laptop/computer mein **MetaMask extension** install karo (agar nahi hai)
2. MetaMask mein network **"BNB Smart Chain"** add karo aur select karo (Chrome extension mein karna aasan hai)
3. Us MetaMask wallet mein thoda **BNB** daalo (deploy karne ke liye gas fee lagegi, ~$1-2 jitni)

**Zaroori:** Ye MetaMask wallet **deploy karne ke liye** hai — deploy karne wala wallet hi contract ka **owner** ban jayega (jo `/api/charge` commands chala payega). Agar chaho to yehi wallet apna backend ka spender wallet bhi ban sakta hai — same private key jo Render mein `SPENDER_PRIVATE_KEY` mein daali thi, wahi MetaMask mein import karke deploy karo, taaki backend hi owner ho.

## Step 4: Deploy karo
1. Left sidebar mein **"Deploy & Run Transactions"** icon (3rd/4th icon) pe click karo
2. **"Environment"** dropdown mein **"Injected Provider - MetaMask"** select karo — MetaMask popup aayega, connect karo
3. Confirm karo ki network **BNB Smart Chain** dikha raha hai (upar chhota text mein)
4. **"CONTRACT"** dropdown mein `SubscriptionBilling` select hona chahiye
5. Neeche 2 input fields dikhenge (constructor arguments):
   - `_usdt`: `0x55d398326f99059fF775485246999027B3197955` (USDT BEP20 official contract — fixed value)
   - `_merchantWallet`: apna shop ka wallet address jahan paisa aana chahiye (jaisa `0x5c2f254b10e79ba4efe188be69a02086a10e974b`)
6. **"Deploy"** button dabao (orange button)
7. MetaMask mein transaction confirm karo — thoda gas fee lagegi
8. Kuch second mein deploy ho jayega — neeche **"Deployed Contracts"** section mein tumhara contract address dikhega, jaisa `0xABC123...`

**Ye naya contract address copy kar lo — agle steps mein iski zaroorat padegi.**

## Step 5: Contract verify karo BscScan pe (optional lekin recommended)
Verify karne se code publicly readable ho jata hai — wallets aur customers zyada trust karte hain verified contracts pe.
1. https://bscscan.com pe jao, apne naye contract address search karo
2. **"Contract"** tab → **"Verify and Publish"**
3. Compiler version wahi select karo jo Remix mein use kiya tha (0.8.19)
4. Source code paste karo (same file jo Remix mein tha)
5. Verify submit karo

## Step 6: Backend aur frontend update karo
README ke "After Contract Deploy" section mein bataya gaya hai kya-kya values badalni hain (`CONTRACT_ADDRESS` naya wala daalna hoga backend aur frontend dono jagah).
