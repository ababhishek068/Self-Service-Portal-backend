TableExtension 50002 tableextension70134672 extends "Bank Acc. Reconciliation Line"
{
    Caption = 'Bank Acc. Reconciliation Line';
    fields
    {
        field(58; "Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(59; "Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(71; "Notes Line 1"; Text[250]) { }
        field(72; "Notes Line 4"; Text[250]) { }
        field(50000; Reconciled; Boolean)
        {

            trigger OnValidate()
            begin
                //check if the type of entry that the user has selected is difference
                // if Type = Type::Difference then begin
                //     Error('Differences cannot be reconciled');
                // end;
            end;
        }
        field(50002; "Notes Line 2"; Text[250]) { }
        field(50058; "Notes Line 3"; Text[250]) { }
        field(50059; "Notes Line 5"; Text[250]) { }
        field(50060; "Notes Line 6"; Text[250]) { }
        field(50061; Imported; Boolean) { }
        field(50062; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(50009; "Bank Ledger Entry Line No"; Integer) { }
        field(50010; "Bank Statement Entry Line No"; Integer) { }

        field(50011; "Account Name"; text[150]) { }

        field(50012; "Document Date"; Date) { }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Type,""Applied Amount"""(Key)".

    }

    //Unsupported feature: Property Deletion (Attributes) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Property Insertion (Local) on "CreateDim(PROCEDURE 26)".



    //Unsupported feature: Code Modification on "AcceptApplication(PROCEDURE 4)".
    procedure GetStyle2(): Text
    begin
        IF "Applied Entries" <> 0 THEN
            EXIT('Favorable');

        EXIT('');
    end;
    // procedure AcceptApplication();
    // Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    // For customer payments, the applied amount is positive, so positive difference means excessive amount.
    // For vendor payments, the applied amount is negative, so negative difference means excessive amount.
    // If "Applied Amount" and Difference have the same sign, then this is an overpayment situation.
    // Two non-zero numbers have the same sign if and only if their product is a positive number.
    IF Difference * "Applied Amount" > 0 THEN BEGIN
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        ERROR(ExcessiveAmountErr,Difference);
      SetAppliedPaymentEntryFromRec(AppliedPaymentEntry);
      IF NOT AppliedPaymentEntry.FIND THEN BEGIN
        IF NOT CONFIRM(STRSUBSTNO(CreditTheAccountQst,GetAppliedToName,Difference)) THEN
          EXIT;
        TransferRemainingAmountToAccount;
      END;
    END;

    AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
    AppliedPaymentEntry.MODIFYALL("Match Confidence","Match Confidence"::Accepted);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
      IF NOT CONFIRM(STRSUBSTNO(CreditTheAccountQst,GetAppliedToName,Difference)) THEN
        EXIT;
      TransferRemainingAmountToAccount;
    #14..17
    */
    //end;


    //Unsupported feature: Code Modification on "TransferRemainingAmountToAccount(PROCEDURE 31)".

    //procedure TransferRemainingAmountToAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD("Account No.");

    SetAppliedPaymentEntryFromRec(AppliedPaymentEntry);
    AppliedPaymentEntry.VALIDATE("Applied Amount",Difference);
    AppliedPaymentEntry.VALIDATE("Match Confidence",AppliedPaymentEntry."Match Confidence"::Manual);
    AppliedPaymentEntry.INSERT(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TESTFIELD("Account No.");

    AppliedPaymentEntry.TransferFromBankAccReconLine(Rec);
    AppliedPaymentEntry."Account Type" := GetAppliedToAccountType;
    AppliedPaymentEntry."Account No." := GetAppliedToAccountNo;
    #4..6
    */
    //end;


    //Unsupported feature: Code Modification on "IsTransactionPostedAndReconciled(PROCEDURE 27)".

    //procedure IsTransactionPostedAndReconciled();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Transaction ID" <> '' THEN BEGIN
      PostedPaymentReconLine.SETRANGE("Bank Account No.","Bank Account No.");
      PostedPaymentReconLine.SETRANGE("Transaction ID","Transaction ID");
      PostedPaymentReconLine.SETRANGE(Reconciled,TRUE);
      IF NOT PostedPaymentReconLine.ISEMPTY THEN
        EXIT(TRUE);
      BankAccountStatementLine.SETRANGE("Bank Account No.","Bank Account No.");
      BankAccountStatementLine.SETRANGE("Transaction ID","Transaction ID");
      EXIT(NOT BankAccountStatementLine.ISEMPTY);
    END;
    EXIT(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
      EXIT(PostedPaymentReconLine.FINDFIRST)
    END;
    EXIT(FALSE);
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "IsTransactionPostedAndReconciled(PROCEDURE 27).BankAccountStatementLine(Variable 1000)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).FieldNo(Parameter 1001)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).TableID(Parameter 1003)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).No(Parameter 1002)".



    //Unsupported feature: Property Modification (TextConstString) on "Text000(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text000 : ENU=You cannot rename a %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text000 : ENU=You cannot rename a %1.;ESM=No se puede cambiar el nombre a %1.;FRC=Vous ne pouvez pas renommer un %1.;ENC=You cannot rename a %1.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text001(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text001 : ENU=Delete application?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text001 : ENU=Delete application?;ESM=¿Confirma que desea eliminar la conciliación?;FRC=Supprimer utilisation?;ENC=Delete application?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "Text002(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //Text002 : ENU=Update canceled.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //Text002 : ENU=Update canceled.;ESM=Actualización cancelada.;FRC=Mise-à-jour annulée.;ENC=Update cancelled.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "AmountWithinToleranceRangeTok(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //AmountWithinToleranceRangeTok : @@@={Locked};ENU=">=%1&<=%2";
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AmountWithinToleranceRangeTok : @@@={Locked};ENU=">=%1&<=%2";ESM=">=%1&<=%2";FRC=">=%1&<=%2";ENC=">=%1&<=%2";
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "AmountOustideToleranceRangeTok(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //AmountOustideToleranceRangeTok : @@@={Locked};ENU=<%1|>%2;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //AmountOustideToleranceRangeTok : @@@={Locked};ENU=<%1|>%2;ESM=<%1|>%2;FRC=<%1|>%2;ENC=<%1|>%2;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "TransactionAmountMustNotBeZeroErr(Variable 1008)".

    //var
    //>>>> ORIGINAL VALUE:
    //TransactionAmountMustNotBeZeroErr : ENU=The Transaction Amount field must have a value that is not 0.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //TransactionAmountMustNotBeZeroErr : ENU=The Transaction Amount field must have a value that is not 0.;ESM=El campo Importe de la transacción debe tener un valor que no sea 0.;FRC=La valeur du champ Montant transaction doit être différente de 0.;ENC=The Transaction Amount field must have a value that is not 0.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "CreditTheAccountQst(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //CreditTheAccountQst : @@@=%1 is the account name, %2 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);ENU=The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CreditTheAccountQst : @@@=%1 is the account name, %2 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);ENU=The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?;ESM=El Importe pendiente de liquidación es %2.\\¿Quiere crear una nueva línea de liquidación de pago que debitará o acreditará en %1 el importe pendiente cuando registre el pago?;FRC=Le montant ouvert à affecter est %2.\\Souhaitez-vous créer une ligne affectation paiement qui débitera ou créditera %1 du montant ouvert lors du report du paiement ?;ENC=The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "ExcessiveAmountErr(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //ExcessiveAmountErr : @@@=%1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);ENU=The remaining amount to apply is %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ExcessiveAmountErr : @@@=%1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);ENU=The remaining amount to apply is %1.;ESM=El importe pendiente de liquidación es %1.;FRC=Le montant ouvert à lettrer est %1.;ENC=The remaining amount to apply is %1.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "ImportPostedTransactionsQst(Variable 1014)".

    //var
    //>>>> ORIGINAL VALUE:
    //ImportPostedTransactionsQst : ENU=The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ImportPostedTransactionsQst : ENU=The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?;ESM=El estado de cuenta bancaria contiene pagos ya liquidados, pero los movimientos de banco relacionados no están cerrados.\\¿Quiere incluir estos pagos en la importación?;FRC=Le relevé bancaire contient les paiements déjà affectés, mais les écritures associées dans le compte bancaire ne sont pas fermées.\\Voulez-vous inclure ces paiements à l'importation?;ENC=The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?;
    //Variable type has not been exported.

}

