TableExtension 50013 tableextension70134685 extends "Bank Account"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Name(Field 2)".


        //Unsupported feature: Property Modification (Data type) on ""Search Name"(Field 3)".


        //Unsupported feature: Property Modification (Data type) on "Address(Field 5)".


        //Unsupported feature: Property Modification (Data type) on "Contact(Field 8)".


        //Unsupported feature: Deletion on "City(Field 7).OnLookup".


        //Unsupported feature: Deletion on ""Country/Region Code"(Field 35).OnValidate".


        //Unsupported feature: Property Deletion (ObsoleteState) on "Picture(Field 89)".


        //Unsupported feature: Property Deletion (ObsoleteReason) on "Picture(Field 89)".


        //Unsupported feature: Deletion on ""Post Code"(Field 91).OnLookup".


        //Unsupported feature: Property Deletion (CaptionClass) on "Region(Field 92)".


        //Unsupported feature: Property Deletion (TableRelation) on ""SWIFT Code"(Field 111)".


        //Unsupported feature: Property Deletion (ValidateTableRelation) on ""SWIFT Code"(Field 111)".


        //Unsupported feature: Property Deletion (DataClassification) on ""Bank Stmt. Service Record ID"(Field 121)".

        field(50000; "Cheque Format"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Kalamazoo Format,Plain Format';
            OptionMembers = "Kalamazoo Format","Plain Format";
        }
        field(50001; "Statement Difference"; Decimal) { }
        field(50002; Test2; Code[10]) { }
        field(50003; Test3; Code[10]) { }
        field(50004; Text; Code[10]) { }
        field(53000; test; Option)
        {
            OptionMembers = a,b;
        }
        field(61002; "Credit Agreement?"; Boolean)
        {

            trigger OnValidate()
            begin
                if not "Credit Agreement?" then "Maximum Credit Limit" := 0;
            end;
        }
        field(61003; "Maximum Credit Limit"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Credit Agreement?", true);

                if "Maximum Credit Limit" > 0 then
                    Error('Maximum Credit Limit must be less than zero');
            end;
        }
        field(39005975; "Bank Type"; Option)
        {
            OptionMembers = Normal,Cash,"Fixed Deposit",SMPA,"Chq Collection","Mobile Collection";

            trigger OnValidate()
            begin

                //TestNoEntriesExist(FIELDCAPTION("Bank Type"));
            end;
        }
        field(39005976; "Pending Voucher Amount"; Decimal) { }
        field(39005977; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR".Code;

            trigger OnValidate()
            begin

                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text005,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(39005978; "Bank Branch Name"; Text[250]) { }
        field(50190; "Bank Account Name"; Text[250]) { }
        field(39005979; "Last Pv No."; Code[20]) { }
        field(39005980; "Receipt No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(39005981; "UnIndentified Receipts A/c"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
    }


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;

    IF IsContactUpdateNeeded THEN BEGIN
      MODIFY;
      UpdateContFromBank.OnModify(Rec);
      IF NOT FIND THEN BEGIN
        RESET;
        IF FIND THEN;
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;

    IF (Name <> xRec.Name) OR
       ("Search Name" <> xRec."Search Name") OR
       ("Name 2" <> xRec."Name 2") OR
       (Address <> xRec.Address) OR
       ("Address 2" <> xRec."Address 2") OR
       (City <> xRec.City) OR
       ("Phone No." <> xRec."Phone No.") OR
       ("Telex No." <> xRec."Telex No.") OR
       ("Territory Code" <> xRec."Territory Code") OR
       ("Currency Code" <> xRec."Currency Code") OR
       ("Language Code" <> xRec."Language Code") OR
       ("Our Contact Code" <> xRec."Our Contact Code") OR
       ("Country/Region Code" <> xRec."Country/Region Code") OR
       ("Fax No." <> xRec."Fax No.") OR
       ("Telex Answer Back" <> xRec."Telex Answer Back") OR
       ("Post Code" <> xRec."Post Code") OR
       (Region <> xRec.Region) OR
       ("E-Mail" <> xRec."E-Mail") OR
       ("Home Page" <> xRec."Home Page")
    THEN BEGIN
    #4..10
    */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DimMgt.RenameDefaultDim(DATABASE::"Bank Account",xRec."No.","No.");
    "Last Date Modified" := TODAY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Last Date Modified" := TODAY;
    */
    //end;


    //Unsupported feature: Code Modification on "ShowContact(PROCEDURE 1)".

    //procedure ShowContact();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "No." = '' THEN
      EXIT;

    #4..11
    END;
    COMMIT;

    Cont.FILTERGROUP(2);
    Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
    Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
    PAGE.RUN(PAGE::"Contact List",Cont);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    #16..18
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "DisplayMap(PROCEDURE 7)".


    //Unsupported feature: Parameter Insertion (Parameter: PostExchDef) (ParameterCollection) on "GetPostExchDef(PROCEDURE 47)".


    //Unsupported feature: Variable Insertion (Variable: BankExportImportSetup) (VariableCollection) on "GetPostExchDef(PROCEDURE 47)".


    //Unsupported feature: Property Deletion (Attributes) on "RefreshStatementProvider(PROCEDURE 47)".


    //Unsupported feature: Property Modification (Name) on "RefreshStatementProvider(PROCEDURE 47)".



    //Unsupported feature: Code Modification on "RefreshStatementProvider(PROCEDURE 47)".

    //procedure RefreshStatementProvider();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    StatementProvider := SelectBankLinkingService;

    IF StatementProvider <> '' THEN
      OnRefreshStatementProviderEvent(BankAccount,StatementProvider);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TESTFIELD("Bank Statement Import Format");

    BankExportImportSetup.GET("Bank Statement Import Format");
    BankExportImportSetup.TESTFIELD("Data Exch. Def. Code");

    PostExchDef.GET(BankExportImportSetup."Data Exch. Def. Code");
    PostExchDef.TESTFIELD(Type,PostExchDef.Type::"Bank Statement Import");
    */
    //end;


    //Unsupported feature: Code Modification on "CreateNewAccount(PROCEDURE 42)".

    //procedure CreateNewAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GeneralLedgerSetup.GET;
    INIT;
    VALIDATE("Bank Account No.",OnlineBankAccLink."Bank Account No.");
    VALIDATE(Name,OnlineBankAccLink.Name);
    IF OnlineBankAccLink."Currency Code" <> '' THEN
      CurrencyCode := GeneralLedgerSetup.GetCurrencyCode(OnlineBankAccLink."Currency Code");
    VALIDATE("Currency Code",CurrencyCode);
    VALIDATE(Contact,OnlineBankAccLink.Contact);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #2..4
    VALIDATE("Currency Code",OnlineBankAccLink."Currency Code");
    VALIDATE(Contact,OnlineBankAccLink.Contact);
    */
    //end;

    //Unsupported feature: ReturnValue Insertion (ReturnValue: <Blank>) (ReturnValueCollection) on "GetBankAccountNo(PROCEDURE 45)".


    //Unsupported feature: Property Deletion (Attributes) on "DisableStatementProviders(PROCEDURE 45)".


    //Unsupported feature: Property Modification (Name) on "DisableStatementProviders(PROCEDURE 45)".



    //Unsupported feature: Code Modification on "DisableStatementProviders(PROCEDURE 45)".

    //procedure DisableStatementProviders();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnGetStatementProvidersEvent(TempNameValueBuffer);
    IF TempNameValueBuffer.FINDSET THEN
      REPEAT
        OnDisableStatementProviderEvent(TempNameValueBuffer.Name);
      UNTIL TempNameValueBuffer.NEXT = 0;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF IBAN <> '' THEN
      EXIT(DELCHR(IBAN,'=<>'));

    IF "Bank Account No." <> '' THEN
      EXIT("Bank Account No.");
    */
    //end;

    //Unsupported feature: Property Modification (Attributes) on "OnCheckLinkedToStatementProviderEvent(PROCEDURE 22)".


    //Unsupported feature: Property Modification (Attributes) on "OnCheckAutoLogonPossibleEvent(PROCEDURE 23)".


    //Unsupported feature: Property Modification (Attributes) on "OnUnlinkStatementProviderEvent(PROCEDURE 24)".


    //Unsupported feature: Property Modification (Attributes) on "OnSimpleLinkStatementProviderEvent(PROCEDURE 40)".


    //Unsupported feature: Property Modification (Attributes) on "OnLinkStatementProviderEvent(PROCEDURE 25)".


    //Unsupported feature: Property Modification (Attributes) on "OnGetDataExchangeDefinitionEvent(PROCEDURE 26)".


    //Unsupported feature: Property Modification (Attributes) on "OnUpdateBankAccountLinkingEvent(PROCEDURE 34)".


    //Unsupported feature: Property Modification (Attributes) on "OnGetStatementProvidersEvent(PROCEDURE 36)".


    //Unsupported feature: ReturnValue Insertion (ReturnValue: AccountNo) (ReturnValueCollection) on "GetBankAccountNoWithCheck(PROCEDURE 46)".


    //Unsupported feature: Property Deletion (Attributes) on "OnDisableStatementProviderEvent(PROCEDURE 46)".


    //Unsupported feature: Property Deletion (Local) on "OnDisableStatementProviderEvent(PROCEDURE 46)".


    //Unsupported feature: Property Modification (Name) on "OnDisableStatementProviderEvent(PROCEDURE 46)".



    //Unsupported feature: Code Modification on "OnDisableStatementProviderEvent(PROCEDURE 46)".

    //procedure OnDisableStatementProviderEvent();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    // The subscriber of this event should disable the statement provider with the given name
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    AccountNo := GetBankAccountNo;
    IF AccountNo = '' THEN
      ERROR(BankAccIdentifierIsEmptyErr,FIELDCAPTION("Bank Account No."),FIELDCAPTION(IBAN));
    */
    //end;

    //Unsupported feature: Deletion (ParameterCollection) on "RefreshStatementProvider(PROCEDURE 47).BankAccount(Parameter 1001)".


    //Unsupported feature: Deletion (VariableCollection) on "RefreshStatementProvider(PROCEDURE 47).StatementProvider(Variable 1000)".


    //Unsupported feature: Deletion (VariableCollection) on "CreateNewAccount(PROCEDURE 42).GeneralLedgerSetup(Variable 1001)".


    //Unsupported feature: Deletion (VariableCollection) on "CreateNewAccount(PROCEDURE 42).CurrencyCode(Variable 1002)".


    //Unsupported feature: Deletion (VariableCollection) on "DisableStatementProviders(PROCEDURE 45).TempNameValueBuffer(Variable 1000)".


    //Unsupported feature: Deletion (ParameterCollection) on "OnDisableStatementProviderEvent(PROCEDURE 46).ProviderName(Parameter 1002)".


    var
        UserMgt: Codeunit "User Setup Management";
        RespCenter: Record "Responsibility Center BR";
        Text005: label 'Your identification is set up to process from %1 %2 only.';
}

