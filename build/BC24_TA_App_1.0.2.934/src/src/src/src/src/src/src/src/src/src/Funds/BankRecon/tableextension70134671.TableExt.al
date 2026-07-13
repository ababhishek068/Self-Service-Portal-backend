TableExtension 50001 tableextension70134671 extends "Bank Acc. Reconciliation"
{

    //Unsupported feature: Property Modification (Permissions) on ""Bank Acc. Reconciliation"(Table 273)".

    Caption = 'Bank Acc. Reconciliation';
    fields
    {
        modify("Bank Account No.")
        {
            Caption = 'Bank Account No.';
        }
        modify("Statement No.")
        {
            Caption = 'Statement No.';
        }
        modify("Statement Ending Balance")
        {
            Caption = 'Statement Ending Balance';
        }
        modify("Statement Date")
        {
            Caption = 'Statement Date';
        }
        modify("Balance Last Statement")
        {
            Caption = 'Balance Last Statement';
        }
        modify("Total Balance on Bank Account")
        {
            Caption = 'Total Balance on Bank Account';
        }
        modify("Total Applied Amount")
        {
            Caption = 'Total Applied Amount';
        }
        modify("Total Transaction Amount")
        {
            Caption = 'Total Transaction Amount';
        }
        modify("Total Unposted Applied Amount")
        {
            Caption = 'Total Unposted Applied Amount';
        }
        modify("Total Difference")
        {
            Caption = 'Total Difference';
        }
        modify("Statement Type")
        {
            Caption = 'Statement Type';
            OptionCaption = 'Bank Reconciliation,Payment Application';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Post Payments Only")
        {
            Caption = 'Post Payments Only';
        }
        modify("Import Posted Transactions")
        {
            Caption = 'Import Posted Transactions';
            OptionCaption = ' ,Yes,No';
        }
        modify("Total Outstd Bank Transactions")
        {
            Caption = 'Total Outstd Bank Transactions';
        }
        modify("Total Outstd Payments")
        {
            Caption = 'Total Outstd Payments';
        }
        // modify("Total Applied Amount Payments")
        // {
        //     Caption = 'Total Applied Amount Payments';
        // }
        //felix
        modify("Bank Account Balance (LCY)")
        {
            Caption = 'Bank Account Balance ($)';
        }
        modify("Total Positive Adjustments")
        {
            Caption = 'Total Positive Adjustments';
        }
        modify("Total Negative Adjustments")
        {
            Caption = 'Total Negative Adjustments';
        }
        // modify("Total Positive Difference")
        // {
        //     Caption = 'Total Positive Difference';
        // }
        //felix
        // modify("Total Negative Difference")
        // {
        //     Caption = 'Total Negative Difference';
        // }
        modify("Copy VAT Setup to Jnl. Line")
        {
            Caption = 'Copy Tax Setup to Jnl. Line';
        }
        modify("Dimension Set ID")
        {
            Caption = 'Dimension Set ID';
        }

        //Unsupported feature: Deletion (FieldCollection) on ""Bank Statement"(Field 6)".


        field(50001; "Notes Line 1"; Text[250]) { }
        field(50002; "Notes Line 2"; Text[250]) { }
        field(50003; "Notes Line 3"; Text[250]) { }
        field(50004; "Notes Line 4"; Text[250]) { }
        field(50005; "Notes Line 5"; Text[250]) { }
        field(50006; "Notes Line 6"; Text[250]) { }
        field(50008; "Reconcile Stat. Lines Based On"; Option)
        {
            Caption = 'Reconcile Statement Lines Based On';
            OptionMembers = " ","Cheque No","Document No";
        }
        field(50009; "Reconciliation Type"; Option)
        {
            Editable = true;
            OptionMembers = " ",Auto,Manual;
        }
        field(35; Status; Option)
        {
            Description = 'Stores the status of the record in the database';
            Editable = false;
            OptionCaption = 'Pending,Pending Approval,Approved,Cancelled,Posted';
            OptionMembers = Pending,"Pending Approval",Approved,Cancelled,Posted;
            trigger OnValidate()

            begin

                CalcFields("Final Approver Status");
                if "Final Approver Status" = "Final Approver Status"::Approved then begin
                    Status := Status::Approved;

                end;
            end;
        }
        field(70134778; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("Statement No.")));
        }
        field(70134779; "User ID"; Code[20]) { }
    }


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ERROR(RenameErr,TABLECAPTION);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //ERROR(RenameErr,TABLECAPTION);
    */
    //end;

    //Unsupported feature: Property Deletion (Attributes) on "CreateDim(PROCEDURE 22)".


    //Unsupported feature: Property Insertion (Local) on "CreateDim(PROCEDURE 22)".



    //Unsupported feature: Code Modification on "MatchSingle(PROCEDURE 5)".

    //procedure MatchSingle();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    MatchBankRecLines.MatchSingle(Rec,DateRange);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    MatchBankRecLines.MatchSingle2(Rec,DateRange);
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "ImportBankStatement(PROCEDURE 6)".


    //Unsupported feature: Property Deletion (Attributes) on "ValidateShortcutDimCode(PROCEDURE 7)".


    //Unsupported feature: Property Insertion (Local) on "ValidateShortcutDimCode(PROCEDURE 7)".


    //Unsupported feature: Property Modification (Attributes) on "ImportAndProcessToNewStatement(PROCEDURE 8)".


    //Unsupported feature: Property Modification (Attributes) on "ImportStatement(PROCEDURE 13)".


    //Unsupported feature: Property Deletion (Attributes) on "SelectBankAccountToUse(PROCEDURE 4)".



    //Unsupported feature: Code Modification on "SelectBankAccountToUse(PROCEDURE 4)".

    //procedure SelectBankAccountToUse();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF OnlyWithImportFormatSet THEN BEGIN
      // copy to temp as we need OR filter
      BankAccount.SETFILTER("Bank Statement Import Format",'<>%1','');
      CopyBankAccountsToTemp(TempBankAccount,BankAccount);

      // clear filters
      BankAccount.SETRANGE("Bank Statement Import Format");
      TempLinkedBankAccount.SETRANGE("Bank Statement Import Format");

      BankAccount.GetLinkedBankAccounts(TempLinkedBankAccount);
      CopyBankAccountsToTemp(TempBankAccount,TempLinkedBankAccount);

      NoOfAccounts := TempBankAccount.COUNT;
    END ELSE
      NoOfAccounts := BankAccount.COUNT;
    #16..42
    END;

    EXIT(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
      BankAccount.GetLinkedBankAccounts(TempLinkedBankAccount);
      TempLinkedBankAccount.SETRANGE("Bank Statement Import Format",'');
      CopyBankAccountsToTemp(TempBankAccount,TempLinkedBankAccount);
    #13..45
    */
    //end;
    procedure MatchSingle2(DateRange: Integer)
    var
        MatchBankRecLines: Codeunit "Match Bank Rec. Lines DSL";
    begin
        //MatchBankRecLines.MatchSingle(Rec,DateRange);//**changes to change matching criteria
        MatchBankRecLines.MatchSingle2(Rec, DateRange);
    end;

    procedure GetTempCopy(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    begin
        if BankAccReconciliation.HasFilter then
            CopyFilters(BankAccReconciliation);

        SetRange("Statement Type", "statement type"::"Bank Reconciliation");
        if not FindSet then
            exit;

        repeat
            BankAccReconciliation := Rec;
            BankAccReconciliation.Insert;
        until Next = 0;
    end;
    /*
       procedure GetTempCopyFromBankRecHeader(var BankAccReconciliation: Record "Bank Acc. Reconciliation")

       var
           BankRecHeader: Record "Bank Rec. Header";
       begin
           if BankAccReconciliation.HasFilter then begin
             BankRecHeader.SetFilter("Bank Account No.",BankAccReconciliation.GetFilter("Bank Account No."));
             BankRecHeader.SetFilter("Statement No.",BankAccReconciliation.GetFilter("Statement No."));
             BankRecHeader.SetFilter("Statement Date",BankAccReconciliation.GetFilter("Statement Date"));
             BankRecHeader.SetFilter("Statement Balance",BankAccReconciliation.GetFilter("Balance Last Statement"));
           end;

           if not BankRecHeader.FindSet then
             exit;

           repeat
             BankAccReconciliation."Statement Type" := BankAccReconciliation."statement type"::"Bank Reconciliation";
             BankAccReconciliation."Bank Account No." := BankRecHeader."Bank Account No.";
             BankAccReconciliation."Statement No." := BankRecHeader."Statement No.";
             BankAccReconciliation."Statement Date" := BankRecHeader."Statement Date";
             BankAccReconciliation."Balance Last Statement" := BankRecHeader."Statement Balance";
             BankAccReconciliation."Statement Ending Balance" := BankRecHeader.CalculateEndingBalance;
             BankAccReconciliation.Insert;
           until BankRecHeader.Next = 0;
       end;
   */
    procedure InsertRec(StatementType: Option; BankAccountNo: Code[20])
    begin
        Init;
        Validate("Statement Type", StatementType);
        Validate("Bank Account No.", BankAccountNo);
        Insert(true);
    end;

    trigger OnAfterInsert()
    begin
        "User ID" := database.UserId;
    end;

    //Unsupported feature: Property Modification (Subtype) on "ImportBankStatement(PROCEDURE 6).ProcessBankAccRecLines(Variable 1000)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).FieldNo(Parameter 1001)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).TableID(Parameter 1003)".


    //Unsupported feature: Property Deletion (AsVar) on "OnAfterCreateDimTableIDs(PROCEDURE 164).No(Parameter 1002)".



    //Unsupported feature: Property Modification (TextConstString) on "DuplicateStatementErr(Variable 1000)".

    //var
    //>>>> ORIGINAL VALUE:
    //DuplicateStatementErr : @@@="%1=Statement No. value";ENU=Statement %1 already exists.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //DuplicateStatementErr : @@@="%1=Statement No. value";ENU=Statement %1 already exists.;ESM=El estado de cta. banco %1 ya existe.;FRC=Le relevé %1 existe déjà.;ENC=Statement %1 already exists.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "RenameErr(Variable 1001)".

    //var
    //>>>> ORIGINAL VALUE:
    //RenameErr : @@@="%1=Table name caption";ENU=You cannot rename a %1.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //RenameErr : @@@="%1=Table name caption";ENU=You cannot rename a %1.;ESM=No se puede cambiar el nombre a %1.;FRC=Vous ne pouvez pas renommer un %1.;ENC=You cannot rename a %1.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "BalanceQst(Variable 1002)".

    //var
    //>>>> ORIGINAL VALUE:
    //BalanceQst : @@@="%1=Balance Last Statement field caption;%2=field caption;%3=table caption";ENU=%1 is different from %2 on the %3. Do you want to change the value?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BalanceQst : @@@="%1=Balance Last Statement field caption;%2=field caption;%3=table caption";ENU=%1 is different from %2 on the %3. Do you want to change the value?;ESM=%1 es diferente del %2 en el %3. ¿Confirma que desea cambiar el valor?;FRC=%1 est différent de %2 sur le %3. Voulez-vous changer la valeur?;ENC=%1 is different from %2 on the %3. Do you want to change the value?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "YouChangedDimQst(Variable 1009)".

    //var
    //>>>> ORIGINAL VALUE:
    //YouChangedDimQst : ENU=You may have changed a dimension.\\Do you want to update the lines?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //YouChangedDimQst : ENU=You may have changed a dimension.\\Do you want to update the lines?;ESM=Puede que haya cambiado una dimensión.\\¿Desea actualizar las líneas?;FRC=Vous avez probablement modifié une dimension.\\Souhaitez-vous mettre à jour les lignes?;ENC=You may have changed a dimension.\\Do you want to update the lines?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "NoBankAccountsMsg(Variable 1010)".

    //var
    //>>>> ORIGINAL VALUE:
    //NoBankAccountsMsg : ENU=You have not set up a bank account.\To use the payments import process, set up a bank account.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //NoBankAccountsMsg : ENU=You have not set up a bank account.\To use the payments import process, set up a bank account.;ESM=No ha configurado ninguna cuenta bancaria.\Para usar el proceso de importación de pagos, configure una cuenta bancaria.;FRC=Vous n'avez paramétré aucun compte bancaire.\Veuillez en paramétrer un pour utiliser le processus d'importation de paiements.;ENC=You have not set up a bank account.\To use the payments import process, set up a bank account.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "NoBankAccWithFileFormatMsg(Variable 1011)".

    //var
    //>>>> ORIGINAL VALUE:
    //NoBankAccWithFileFormatMsg : ENU=No bank account exists that is ready for import of bank statement files.\Fill the Bank Statement Import Format field on the card of the bank account that you want to use.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //NoBankAccWithFileFormatMsg : ENU=No bank account exists that is ready for import of bank statement files.\Fill the Bank Statement Import Format field on the card of the bank account that you want to use.;ESM=No existen cuentas bancarias listas para la importación de los archivos de estado de cuenta bancario.\Rellene el campo Formato de importación de estado de cuenta bancario de la ficha de la cuenta bancaria que desee usar.;FRC=Il n'existe aucun compte bancaire prêt pour l'importation de fichiers de relevé bancaire.\Complétez le champ Format importation relevé bancaire sur la fiche du compte bancaire que vous souhaitez utiliser.;ENC=No bank account exists that is ready for import of bank statement files.\Fill the Bank Statement Import Format field on the card of the bank account that you want to use.;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "PostHighConfidentLinesQst(Variable 1012)".

    //var
    //>>>> ORIGINAL VALUE:
    //PostHighConfidentLinesQst : ENU=All imported bank statement lines were applied with high confidence level.\Do you want to post the payment applications?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //PostHighConfidentLinesQst : ENU=All imported bank statement lines were applied with high confidence level.\Do you want to post the payment applications?;ESM=Todas las líneas del estado de cuenta bancario importado se aplicaron con un nivel de confianza elevado.\¿Desea registrar las liquidaciones de pago?;FRC=Toutes les lignes de relevé bancaire importées ont été lettrées avec un niveau de confiance élevé.\Voulez-vous valider les lettrages paiement ?;ENC=All imported bank statement lines were applied with high confidence level.\Do you want to post the payment applications?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "MustHaveValueQst(Variable 1015)".

    //var
    //>>>> ORIGINAL VALUE:
    //MustHaveValueQst : ENU=The bank account must have a value in %1. Do you want to open the bank account card?;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //MustHaveValueQst : ENU=The bank account must have a value in %1. Do you want to open the bank account card?;ESM=La cuenta bancaria debe tener un valor en %1. ¿Desea abrir la tarjeta de cuenta bancaria?;FRC=Le compte bancaire doit avoir une valeur dans %1. Voulez-vous ouvrir la fiche compte bancaire?;ENC=The bank account must have a value in %1. Do you want to open the bank account card?;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (TextConstString) on "NoTransactionsImportedMsg(Variable 1013)".

    //var
    //>>>> ORIGINAL VALUE:
    //NoTransactionsImportedMsg : ENU=No bank transactions were imported.;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //NoTransactionsImportedMsg : ENU=No bank transactions were imported.;ESM=No se importaron transacciones bancarias.;FRC=Aucune transaction bancaire n'a été importée.;ENC=No bank transactions were imported.;
    //Variable type has not been exported.
}

