#!/bin/bash

# ============================================================
#        ATM Management System - Transaction.sh
#              Course: Shell Scripting
# ============================================================
# Concepts Implemented:
#  1. Command Substitution  -> $(date), $(echo ... | tr ...)
#  2. String Manipulation   -> ${#var}, ${var:0:N}, ${var^^}
#  3. String Substitution   -> ${var//pattern/replace}
#  4. Pattern Matching      -> [[ =~ ]], case..esac
#  5. Functions             -> 5 Required Functions
#  6. Control Structures    -> while, if/elif/else, case
#  7. Arithmetic Op/Expand  -> $(( )), -gt -lt -eq -ne %
#  8. Error Handling        -> Validation at every input
#  9. User Input            -> read -p at every step
# 10. Prompt & Status Msgs  -> Clear prompts & feedback
# ============================================================

# ---- Global Variables ----
BALANCE=0
CUSTOMER_NAME=""
ATM_PIN="12345"

# ============================================================
# FUNCTION 1: Customer_Details
# Purpose    : Account Creation
# ============================================================
Customer_Details() {

    while true; do

        # [Command Substitution] Get current date and time
        SESSION_DATE=$(date '+%d-%m-%Y')
        SESSION_TIME=$(date '+%H:%M:%S')

        echo ""
        echo "=================================================="
        echo "         ACCOUNT CREATION PROCESS STARTED        "
        echo "  Date: $SESSION_DATE          Time: $SESSION_TIME "
        echo "=================================================="

        # ---- 1. Customer Name ----
        read -p "Enter the FullName in Bold Letters: " INPUT_NAME

        # [Error Handling] Empty name check
        if [[ -z "$INPUT_NAME" ]]; then
            echo "Invalid Name. Name Cannot be Empty."
            echo "Account Creation Process Failed. Restarting Again....."
            echo "--------------------------------------------------"
            continue
        fi

        # [String Manipulation] Uppercase via ${var^^}
        CUSTOMER_NAME="${INPUT_NAME^^}"

        # [String Substitution] Remove extra spaces ${var//pattern/replace}
        CUSTOMER_NAME="${CUSTOMER_NAME//  / }"

        # [String Manipulation] Get name length via ${#var}
        NAME_LEN=${#CUSTOMER_NAME}

        echo "  Name Confirmed : $CUSTOMER_NAME  [Length: $NAME_LEN chars]"

        # ---- 2. ID Proof Type ----
        read -p "Enter the ID Proof Type [Ex: Aadhar, Pan, License, etc..]: " ID_TYPE

        # [String Manipulation] Uppercase using ${var^^}
        ID_TYPE_UPPER="${ID_TYPE^^}"

        # [String Substitution] Remove spaces from ID type
        ID_TYPE_UPPER="${ID_TYPE_UPPER// /}"

        # [Pattern Matching] case..esac to match ID type
        case "$ID_TYPE_UPPER" in

            "AADHAR")
                echo "[Note: Aadhar must be exactly 12 digits. Must not start with 0 or 1]"
                read -p "Enter Aadhar Number: " ID_VALUE

                # [Pattern Matching] with =~ regex for Aadhar validation
                if [[ ! "$ID_VALUE" =~ ^[2-9][0-9]{11}$ ]]; then
                    echo "Only Numbers are Allowed. Must be 12 digits. Cannot start with 0 or 1."
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "--------------------------------------------------"
                    continue
                fi

                # [String Manipulation] Mask Aadhar: show first 4 and last 4 only
                ID_DISPLAY="${ID_VALUE:0:4}XXXX${ID_VALUE:8:4}"
                echo "  Aadhar Registered (Masked): $ID_DISPLAY"
                ;;

            "PAN")
                echo "[Note: PAN format - 5 Letters + 4 Digits + 1 Letter. Ex: ABCDE1234F]"
                read -p "Enter Pan Card Number: " ID_VALUE

                # [String Manipulation] Uppercase PAN using ${var^^}
                ID_VALUE="${ID_VALUE^^}"

                # [String Substitution] Remove spaces from PAN
                ID_VALUE="${ID_VALUE// /}"

                # [Pattern Matching] with =~ regex for PAN format
                if [[ ! "$ID_VALUE" =~ ^[A-Z]{5}[0-9]{4}[A-Z]{1}$ ]]; then
                    echo "Only Letters & Numbers are Allowed. Format: ABCDE1234F"
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "--------------------------------------------------"
                    continue
                fi

                # [String Manipulation] Extract 4th char to identify PAN holder type
                PAN_CHAR="${ID_VALUE:3:1}"
                case "$PAN_CHAR" in
                    P) HOLDER_TYPE="Individual" ;;
                    C) HOLDER_TYPE="Company"    ;;
                    H) HOLDER_TYPE="HUF"        ;;
                    F) HOLDER_TYPE="Firm"       ;;
                    *) HOLDER_TYPE="Other"      ;;
                esac
                echo "  PAN Registered: $ID_VALUE  [Holder: $HOLDER_TYPE]"
                ;;

            "LICENSE")
                echo "[Note: License format - StateCode-RTOYearNumber. Ex: TN-0120230012345]"
                read -p "Enter the License Number: " ID_VALUE

                # [String Manipulation] Uppercase using ${var^^}
                ID_VALUE="${ID_VALUE^^}"

                # [String Substitution] Remove spaces
                ID_VALUE="${ID_VALUE// /}"

                # [Pattern Matching] with =~ regex for License format
                if [[ ! "$ID_VALUE" =~ ^[A-Z]{2}-[0-9]{13}$ ]]; then
                    echo "Invalid License Number. Format must be: TN-0120230012345"
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "--------------------------------------------------"
                    continue
                fi

                # [String Manipulation] Extract state code using ${var:0:2}
                STATE_CODE="${ID_VALUE:0:2}"
                echo "  License Registered: $ID_VALUE  [State: $STATE_CODE]"
                ;;

            *)
                # [Error Handling] Unrecognised ID type
                echo "InValid ID Proof Type."
                echo "Account Creation Process Failed. Restarting Again....."
                echo "--------------------------------------------------"
                continue
                ;;
        esac

        # ---- 3. Account Type ----
        read -p "Enter the Account Type as Savings or Current: " ACCOUNT_TYPE

        # [String Manipulation] Uppercase using ${var^^}
        ACCOUNT_TYPE_UPPER="${ACCOUNT_TYPE^^}"

        # [String Substitution] Trim leading and trailing spaces
        ACCOUNT_TYPE_UPPER="${ACCOUNT_TYPE_UPPER## }"
        ACCOUNT_TYPE_UPPER="${ACCOUNT_TYPE_UPPER%% }"

        # [Error Handling] + [Pattern Matching] Validate account type
        if [[ "$ACCOUNT_TYPE_UPPER" != "SAVINGS" && "$ACCOUNT_TYPE_UPPER" != "CURRENT" ]]; then
            echo "InValid Account Type"
            echo "Account Creation Process Failed. Restarting Again......"
            echo "--------------------------------------------------"
            continue
        fi

        # ---- 4. Initial Deposit Amount ----
        read -p "Enter the Deposit Amount: Rs." DEPOSIT_AMOUNT

        # [Pattern Matching] with =~ to check numbers only
        if [[ ! "$DEPOSIT_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "Invalid Deposit Amount. [Note: Numbers only Allowed."
            echo "Account Creation Process Failed. Restarting Again......"
            echo "--------------------------------------------------"
            continue
        fi

        # [Arithmetic Operation] Minimum deposit check
        if [[ $(( DEPOSIT_AMOUNT )) -lt 500 ]]; then
            echo "Minimum Initial Deposit is Rs.500."
            echo "Account Creation Process Failed. Restarting Again......"
            echo "--------------------------------------------------"
            continue
        fi

        # [Arithmetic Expansion] Set balance
        BALANCE=$(( DEPOSIT_AMOUNT + 0 ))

        # [Command Substitution] Generate Account Number using date + random
        ACCOUNT_NO="ACC$(date '+%Y%m')$RANDOM"

        echo ""
        echo "Account Created Successfuly with Initial Deposit"
        echo "  Customer Name  : $CUSTOMER_NAME"
        echo "  Account Type   : $ACCOUNT_TYPE_UPPER"
        echo "  Account Number : $ACCOUNT_NO"
        echo "Your Current Available Balance is Rs.$BALANCE"
        echo "--------------------------------------------------"

        # ---- ATM Card Prompt ----
        while true; do
            read -p "Do you want to Apply for ATM Card: Type Yes or No " ATM_APPLY

            # [String Manipulation] Uppercase
            ATM_APPLY_UPPER="${ATM_APPLY^^}"

            # [Control Structure] if/elif/else
            if [[ "$ATM_APPLY_UPPER" == "YES" ]]; then
                Customer_Choice
                break 2
            elif [[ "$ATM_APPLY_UPPER" == "NO" ]]; then
                echo "Thanks for Being a Valuable Customer to Us"
                break 2
            else
                # [Error Handling]
                echo "ATM Card Process Failed. Restarting the Card Process Again......"
                echo "--------------------------------------------------"
            fi
        done

    done
}

# ============================================================
# FUNCTION 2: Customer_Choice
# Purpose    : ATM Card Processing
# ============================================================
Customer_Choice() {

    # [Command Substitution] Card issue timestamp
    CARD_TIME=$(date '+%d-%m-%Y %H:%M:%S')

    echo ""
    echo "=================================================="
    echo "           ATM CARD PROCESSING                   "
    echo "=================================================="
    echo "Your ATM Card is Processed"
    echo "Card Issued At        : $CARD_TIME"
    echo "Your Temporary ATM Pin Number is: $ATM_PIN"
    echo "=================================================="

    # [Control Structure] while loop to keep prompting until valid choice
    while true; do
        read -p "Do you want Access ATM?: Type Okay or Cancel " ACCESS_INPUT

        # [String Manipulation] Uppercase using ${var^^}
        ACCESS_UPPER="${ACCESS_INPUT^^}"

        # [String Substitution] Remove spaces
        ACCESS_UPPER="${ACCESS_UPPER// /}"

        # [Control Structure] if/elif/else
        if [[ "$ACCESS_UPPER" == "OKAY" ]]; then
            ATM_Process
            break
        elif [[ "$ACCESS_UPPER" == "CANCEL" ]]; then
            echo "Thankyou Visit Again !!"
            break
        else
            # [Error Handling]
            echo "Invalid Choice. Please Type Okay or Cancel."
        fi
    done
}

# ============================================================
# FUNCTION 3: ATM_Process
# Purpose    : Transaction Selection (Debit or Credit)
# ============================================================
ATM_Process() {

    # [Arithmetic Expansion] PIN attempt counter
    PIN_ATTEMPTS=0
    MAX_ATTEMPTS=3

    while true; do
        read -p "Enter the Pin Number: " ENTERED_PIN

        # [Control Structure] PIN validation
        if [[ "$ENTERED_PIN" != "$ATM_PIN" ]]; then

            # [Arithmetic Operation] Increment attempt counter
            PIN_ATTEMPTS=$(( PIN_ATTEMPTS + 1 ))
            REMAINING=$(( MAX_ATTEMPTS - PIN_ATTEMPTS ))

            # [Error Handling] Lockout after max attempts
            if [[ "$PIN_ATTEMPTS" -ge "$MAX_ATTEMPTS" ]]; then
                echo "Maximum PIN Attempts Reached. Your Card is Blocked. Please Contact Bank."
                exit 1
            fi

            echo "Invalid Pin Number"
            echo "Attempts Remaining: $REMAINING"
            continue
        fi

        # [Command Substitution] Login time
        LOGIN_TIME=$(date '+%H:%M:%S')
        echo "Welcome User!!"
        echo "Login Time      : $LOGIN_TIME"
        echo "Current Balance : Rs.$BALANCE"
        echo "--------------------------------------------------"

        # [Control Structure] while loop for transaction choice
        while true; do
            read -p "Enter 1 For Cash Withdraw or 2 For Cash Deposit: " TXN_CHOICE

            # [Pattern Matching] case..esac for transaction routing
            case "$TXN_CHOICE" in
                1)
                    Debit_Process
                    break
                    ;;
                2)
                    Credit_Process
                    break
                    ;;
                *)
                    # [Error Handling] Wrong choice
                    echo "You Have Entered Wrong Choice. Restarting the Process Again......"
                    echo "--------------------------------------------------"
                    PIN_ATTEMPTS=0
                    read -p "Enter the Pin Number: " ENTERED_PIN
                    if [[ "$ENTERED_PIN" != "$ATM_PIN" ]]; then
                        echo "Invalid Pin Number"
                        continue 2
                    fi
                    LOGIN_TIME=$(date '+%H:%M:%S')
                    echo "Welcome User!!"
                    echo "Login Time      : $LOGIN_TIME"
                    echo "Current Balance : Rs.$BALANCE"
                    echo "--------------------------------------------------"
                    ;;
            esac
        done
        break
    done
}

# ============================================================
# FUNCTION 4: Debit_Process
# Purpose    : Cash Withdrawal
# ============================================================
Debit_Process() {

    while true; do
        echo ""
        echo "--------------------------------------------------"
        echo "              CASH WITHDRAWAL                     "
        echo "  Available Balance: Rs.$BALANCE"
        echo "--------------------------------------------------"
        read -p "Enter the Amount to Withdraw: Rs." WITHDRAW_AMOUNT

        # [Pattern Matching] Numbers only check via =~
        if [[ ! "$WITHDRAW_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "Invalid Amount. Only Numbers Allowed."
            continue
        fi

        # [Arithmetic Operation] Denomination check — must be multiple of 100
        DENOM_CHECK=$(( WITHDRAW_AMOUNT % 100 ))
        if [[ "$DENOM_CHECK" -ne 0 ]]; then
            echo "Enter The Valid Amount"
            continue
        fi

        # [Arithmetic Operation] Minimum withdrawal
        if [[ $(( WITHDRAW_AMOUNT )) -lt 100 ]]; then
            echo "Minimum Withdrawal Amount is Rs.100"
            continue
        fi

        # [Arithmetic Operation] Sufficient balance check
        if [[ $(( WITHDRAW_AMOUNT )) -gt $(( BALANCE )) ]]; then
            echo "Insufficient Balance"
            echo "Your Current Available is Rs.$BALANCE"
            continue
        fi

        # [Arithmetic Expansion] Deduct from balance
        BALANCE=$(( BALANCE - WITHDRAW_AMOUNT ))

        # [Command Substitution] Transaction timestamp
        TXN_TIME=$(date '+%d-%m-%Y %H:%M:%S')

        # [String Manipulation] Build transaction ref using substring ${var:0:N}
        TIME_SUFFIX=$(date '+%H%M%S')
        TXN_REF="WD${TIME_SUFFIX}"

        echo ""
        echo "=================================================="
        echo "           TRANSACTION SUCCESSFUL !!              "
        echo "=================================================="
        echo "  Type          : Cash Withdrawal"
        echo "  Amount Debited: Rs.$WITHDRAW_AMOUNT"
        echo "  Txn Reference : $TXN_REF"
        echo "  Date & Time   : $TXN_TIME"
        echo "Your Current Available Balance After Deduction is Rs.$BALANCE"
        echo "=================================================="

        # Post-transaction menu
        echo ""
        echo "  1. Withdraw Again"
        echo "  2. Go Back to Transaction Menu"
        echo "  3. Exit ATM"
        read -p "Enter Your Choice: " NEXT_CHOICE

        # [Pattern Matching] case..esac for next action
        case "$NEXT_CHOICE" in
            1)
                continue
                ;;
            2)
                ATM_Process
                break
                ;;
            3)
                echo "Thank you for Banking with Us, $CUSTOMER_NAME. Goodbye!!"
                exit 0
                ;;
            *)
                # [Error Handling]
                echo "Invalid Choice. Returning to Transaction Menu..."
                ATM_Process
                break
                ;;
        esac
    done
}

# ============================================================
# FUNCTION 5: Credit_Process
# Purpose    : Cash Deposit
# ============================================================
Credit_Process() {

    while true; do
        echo ""
        echo "--------------------------------------------------"
        echo "                CASH DEPOSIT                      "
        echo "  Available Balance: Rs.$BALANCE"
        echo "--------------------------------------------------"
        read -p "Enter the Amount to Deposit: Rs." DEPOSIT_AMOUNT

        # [Pattern Matching] Numbers only check via =~
        if [[ ! "$DEPOSIT_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "Invalid Amount. Only Numbers Allowed."
            continue
        fi

        # [Arithmetic Operation] Denomination check — must be multiple of 500
        DENOM_CHECK=$(( DEPOSIT_AMOUNT % 500 ))
        if [[ "$DENOM_CHECK" -ne 0 ]]; then
            echo "Enter The Valid Amount"
            continue
        fi

        # [Arithmetic Operation] Minimum deposit
        if [[ $(( DEPOSIT_AMOUNT )) -lt 500 ]]; then
            echo "Minimum Deposit Amount is Rs.500"
            continue
        fi

        # [Arithmetic Expansion] Add to balance
        BALANCE=$(( BALANCE + DEPOSIT_AMOUNT ))

        # [Command Substitution] Transaction timestamp
        TXN_TIME=$(date '+%d-%m-%Y %H:%M:%S')

        # [String Manipulation] Build transaction ref using substring ${var:0:N}
        TIME_SUFFIX=$(date '+%H%M%S')
        TXN_REF="CR${TIME_SUFFIX}"

        echo ""
        echo "=================================================="
        echo "           TRANSACTION SUCCESSFUL !!              "
        echo "=================================================="
        echo "  Type            : Cash Deposit"
        echo "  Amount Credited : Rs.$DEPOSIT_AMOUNT"
        echo "  Txn Reference   : $TXN_REF"
        echo "  Date & Time     : $TXN_TIME"
        echo "Your Amount Deposited Successfully !!"
        echo "Your Current Available Balance is Rs.$BALANCE"
        echo "=================================================="

        # Post-transaction menu
        echo ""
        echo "  1. Deposit Again"
        echo "  2. Go Back to Transaction Menu"
        echo "  3. Exit ATM"
        read -p "Enter Your Choice: " NEXT_CHOICE

        # [Pattern Matching] case..esac for next action
        case "$NEXT_CHOICE" in
            1)
                continue
                ;;
            2)
                ATM_Process
                break
                ;;
            3)
                echo "Thank you for Banking with Us, $CUSTOMER_NAME. Goodbye!!"
                exit 0
                ;;
            *)
                # [Error Handling]
                echo "Invalid Choice. Returning to Transaction Menu..."
                ATM_Process
                break
                ;;
        esac
    done
}

# ============================================================
# MAIN — Entry Point: Customer_Details invoked first
# ============================================================
Customer_Details
