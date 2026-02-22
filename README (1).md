# 🏧 ATM Management System

> A Real-Time Terminal-Based ATM Simulation built entirely in **Bash Shell Scripting**

---

## 📋 About the Project

This project simulates a fully functional ATM system through an interactive terminal. It covers the complete ATM workflow — from opening a new bank account, issuing an ATM card, authenticating with a PIN, all the way through cash withdrawals and deposits — with real-time balance updates, transaction receipts, and robust error handling at every step.

---
💾 How to Get This Project

**Option 1 — Clone using Git**

Step 1: Clone the repository

git clone https://github.com/rohitnegi106/Shell-Scripting-Project-Submission.git

# Step 2: Go into the project folder

cd Shell-Scripting-Project-Submission

**Option 2 — Direct Download (No Git needed)**

Go to the repository on GitHub
Click the green Code button
Click Download ZIP
Extract the ZIP file on your laptop
Open terminal and navigate to the extracted folder:

cd path/to/Shell-Scripting-Project-Submission

`````

## ⚡ Quick Start

```bash
# Give execute permission
chmod +x Transaction.sh

# Run the program
./Transaction.sh
```

> **Requires:** Bash v4.0+ on Linux / Unix / WSL (Windows)

---

## 🗂️ File Structure

├── Transaction.sh        # Main script
├── README.md             # Documentation
├── screenshots/          # Terminal output screenshots
└── video/                # Screen recording of full execution
---

## 🔁 Program Flow

```
▶ START
     │
     ▼
┌─────────────────────┐
│  Customer_Details() │  ──▶  Account Creation (Name, ID, Type, Deposit)
└─────────────────────┘
          │
          ▼
┌─────────────────────┐
│  Customer_Choice()  │  ──▶  ATM Card Issued + PIN Shown
└─────────────────────┘
          │
       [Okay]
          │
          ▼
┌─────────────────────┐
│   ATM_Process()     │  ──▶  PIN Verification + Transaction Menu
└─────────────────────┘
          │
    ┌─────┴─────┐
  [1]           [2]
    │             │
    ▼             ▼
Debit_Process() Credit_Process()
(Withdrawal)    (Deposit)
```

---

## ⚙️ Functions — Explained

### 1. `Customer_Details` — Account Creation
Collects and validates all customer information to open a bank account:
- Full name — converted to uppercase, spaces normalized
- ID Proof — **Aadhar**, **PAN**, or **Driving License** with real Indian format validation
- Account type — **Savings** or **Current**
- Initial deposit — minimum Rs.500, numbers only
- Auto-generates a unique Account Number using date and random value

### 2. `Customer_Choice` — ATM Card Processing
- Confirms ATM card has been issued with a timestamp
- Displays the default PIN: `12345`
- Prompts user: **Okay** to proceed to ATM, **Cancel** to exit

### 3. `ATM_Process` — Transaction Selection
- Verifies ATM PIN — locks card after **3 wrong attempts**
- Shows welcome message, login time, and current balance
- Routes to **Debit_Process** (choice 1) or **Credit_Process** (choice 2)

### 4. `Debit_Process` — Cash Withdrawal
- Amount must be a **multiple of Rs.100**, minimum Rs.100
- Checks withdrawal does not exceed available balance
- On success: deducts amount, shows transaction receipt with reference ID
- On failure: shows "Insufficient Balance" and re-prompts
- After transaction: choose to withdraw again, go back to menu, or exit

### 5. `Credit_Process` — Cash Deposit
- Amount must be a **multiple of Rs.500**, minimum Rs.500
- Adds deposit to existing balance
- Shows full transaction receipt with reference ID and updated balance
- After transaction: choose to deposit again, go back to menu, or exit

---

## 🧠 Shell Scripting Concepts Used

| Concept | Where & How |
|---|---|
| **Command Substitution** | `$(date '+%d-%m-%Y')` — session date, card issue time, login time, transaction timestamps, account number generation |
| **String Manipulation** | `${var^^}` uppercase, `${#var}` name length, `${var:0:N}` substring for Aadhar masking, state code extraction, TXN reference building |
| **String Substitution** | `${var// /}` remove spaces, `${var## }` trim leading spaces, `${var%% }` trim trailing spaces |
| **Pattern Matching** | `[[ =~ ]]` regex for Aadhar / PAN / License / amount validation; `case..esac` for ID type routing and transaction selection |
| **Functions** | 5 modular functions — each handles one dedicated stage of the ATM workflow |
| **Control Structures** | `while true`, `if/elif/else`, `case..esac`, `break`, `break 2`, `continue`, `continue 2` |
| **Arithmetic Op & Expansion** | `$(( ))` for balance debit/credit, `%` modulo for denomination check, `-gt -lt -eq -ne` comparisons, PIN attempt counter |
| **Error Handling** | Every input validated — wrong ID type, bad format, non-numeric values, wrong denomination, insufficient balance, PIN lockout |
| **User Input** | `read -p` with clear, descriptive prompts at every single step |
| **Prompt & Status Messages** | Format hints on every input; success/failure feedback + full transaction receipt after every operation |

---

## 🪪 Indian ID Proof Validation

| ID Type | Format Rule | Valid Example |
|---|---|---|
| **Aadhar** | Exactly 12 digits · Must NOT start with 0 or 1 | `234567890123` |
| **PAN** | 5 Letters + 4 Digits + 1 Letter (10 chars total) | `ABCDE1234F` |
| **Driving License** | 2-letter state code + hyphen + 13 digits | `TN-0120230012345` |

---

## 💰 ATM Transaction Rules

| | Withdrawal | Deposit |
|---|---|---|
| **Denomination** | Multiples of Rs.100 | Multiples of Rs.500 |
| **Minimum** | Rs.100 | Rs.500 |
| **Maximum** | Current available balance | No limit |
| **PIN Attempts** | 3 attempts — card blocked on 3rd failure | — |

---

## 🖥️ Sample Terminal Output

```
==================================================
        ACCOUNT CREATION PROCESS STARTED
  Date: 22-02-2026          Time: 10:30:00
==================================================
Enter the FullName in Bold Letters: Rohit Singh Negi
  Name Confirmed : ROHIT SINGH NEGI  [Length: 16 chars]
Enter the ID Proof Type [Ex: Aadhar, Pan, License]: Aadhar
Enter Aadhar Number: 234567890123
  Aadhar Registered (Masked): 2345XXXX0123
Enter the Account Type as Savings or Current: Savings
Enter the Deposit Amount: Rs.10000

Account Created Successfuly with Initial Deposit
  Customer Name  : ROHIT SINGH NEGI
  Account Number : ACC20260289234
Your Current Available Balance is Rs.10000

Your ATM Card is Processed
Your Temporary ATM Pin Number is: 12345
Do you want Access ATM?: Type Okay or Cancel Okay

Enter the Pin Number: 12345
Welcome User!!
Current Balance : Rs.10000

Enter 1 For Cash Withdraw or 2 For Cash Deposit: 1
Enter the Amount to Withdraw: Rs.2000

==================================================
          TRANSACTION SUCCESSFUL !!
==================================================
  Type          : Cash Withdrawal
  Amount Debited: Rs.2000
  Txn Reference : WD103045
  Date & Time   : 22-02-2026 10:30:45
Your Current Available Balance After Deduction is Rs.8000
==================================================
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Bash Shell v4.0+** | Core scripting language |
| **Linux Terminal** | Runtime environment |
| **`date` command** | Timestamps via command substitution |
| **`${var^^}` / `tr`** | String case conversion |
| **Regex `=~`** | Input format validation |
| **`read -p`** | Interactive terminal input |

---

## 👤 Author

**Rohit Singh Negi**  
Course: Shell Scripting  
Project: ATM Management System — `Transaction.sh`
