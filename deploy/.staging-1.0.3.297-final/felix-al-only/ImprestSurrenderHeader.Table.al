Table 50884 "Imprest Surrender Header"
{
    LookupPageId = "Travel Advances Acct. List";
    DrillDownPageId = "Travel Advances Acct. List";

    fields
    {
        field(1; No;
        Code[20])
        {

            trigger OnValidate()
            begin

                if No <> xRec.No then begin
                    GenLedgerSetup.Get;
                    NoSeriesMgt.TestManual(GenLedgerSetup."Imprest Surrender No");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Surrender Date"; Date) { }
        field(3; Type; Code[20])
        {
            // TableRelation = "Clinical Reference".Code where (Recomendations=filter(2));

            trigger OnValidate()
            begin

                "Account No." := '';
                "Account Name" := '';
                Remarks := '';
                RecPayTypes.Reset;
                RecPayTypes.SetRange(RecPayTypes.Code, Type);
                RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Payment);

                if RecPayTypes.Find('-') then begin
                    Grouping := RecPayTypes."Default Grouping";
                end;

                if RecPayTypes.Find('-') then begin
                    "Account Type" := RecPayTypes."Account Type";
                    "Transaction Name" := RecPayTypes.Description;

                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"G/L Account" then begin
                        RecPayTypes.TestField(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."G/L Account";
                        Validate("Account No.");
                    end;

                    //Banks
                    if RecPayTypes."Account Type" = RecPayTypes."account type"::"Bank Account" then begin
                        //RecPayTypes.TESTFIELD(RecPayTypes."G/L Account");
                        "Account No." := RecPayTypes."Bank Account";
                        Validate("Account No.");
                    end;
                end;

                //VALIDATE("Account No.");
            end;
        }
        field(4; "Pay Mode"; Option)
        {
            OptionMembers = " ",Cash,Cheque,EFT,"Custom 1","Custom 2","Custom 3","Custom 4","Custom 5";
        }
        field(5; "Cheque No"; Code[20]) { }
        field(6; "Cheque Date"; Date) { }
        field(7; "Cheque Type"; Code[20])
        {
            TableRelation = Temp;
        }
        field(8; "Bank Code"; Code[20])
        {
            // TableRelation = Shifts;
        }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; Cashier; Code[20]) { }
        field(12; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = Customer."No." where("Customer Posting Group" = filter('IMPREST' | 'SDEBTORS'));

            trigger OnValidate()
            var
                Emp: Record "HR-Employee";
            begin

                "Account Name" := '';
                RecPayTypes.RESET;
                RecPayTypes.SETRANGE(RecPayTypes.Code, Type);
                RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);

                IF "Account Type" IN ["Account Type"::"G/L Account", "Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"IC Partner"]
                THEN
                    CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                                GLAcc.GET("Account No.");
                                "Account Name" := GLAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                "Global Dimension 1 Code" := '';
                            END;
                        "Account Type"::Customer:
                            BEGIN
                                Cust.GET("Account No.");
                                "Account Name" := Cust.Name;
                                //      "VAT Code":=Cust."Default Withholding Tax Code";
                                //      "Withholding Tax Code":=Cust."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := Cust."Global Dimension 1 Code";
                            END;
                        "Account Type"::Vendor:
                            BEGIN
                                Vend.GET("Account No.");
                                "Account Name" := Vend.Name;
                                //      "VAT Code":=Vend."Default VAT Code";
                                //      "Withholding Tax Code":=Vend."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := Vend."Global Dimension 1 Code";
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                                BankAcc.GET("Account No.");
                                "Account Name" := BankAcc.Name;
                                "VAT Code" := RecPayTypes."VAT Code";
                                "Withholding Tax Code" := RecPayTypes."Withholding Tax Code";
                                "Global Dimension 1 Code" := BankAcc."Global Dimension 1 Code";

                            END;

                        "Account Type"::"Fixed Asset":
                            BEGIN
                                FA.GET("Account No.");
                                "Account Name" := FA.Description;
                                // "VAT Code":=FA."Default VAT Code";
                                // "Withholding Tax Code":=FA."Default Withholding Tax Code";
                                "Global Dimension 1 Code" := FA."Global Dimension 1 Code";
                            END;

                    END;

            end;
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; "Account Name"; Text[150]) { }
        field(16; Posted; Boolean) { }
        field(17; "Date Posted"; Date) { }
        field(18; "Time Posted"; Time) { }
        field(19; "Posted By"; Code[20]) { }
        field(20; Amount; Decimal) { }
        field(21; Remarks; Text[250]) { }
        field(22; "Transaction Name"; Text[100]) { }
        field(27; "Net Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(28; "Paying Bank Account"; Code[20]) { }
        field(29; Payee; Text[100]) { }
        field(30; "Global Dimension 1 Code"; Code[30])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;

            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name

            end;
        }
        field(33; "Bank Account No"; Code[20]) { }
        field(34; "Cashier Bank Account"; Code[20]) { }
        field(35; Status; Option)
        {
            OptionMembers = Pending,"1st Approval","2nd Approval","Cheque Printing",Posted,Cancelled,Checking,VoteBook,"Pending Approval",Approved;
            trigger OnValidate()
            begin
                CalcFields("Final Approver Status");
                CalcFields("Open Approver Count");
                if ("Final Approver Status" = "Final Approver Status"::Approved) and ("Open Approver Count" = 0) then
                    Status := Status::Approved;


            end;
        }
        field(70134778; "Final Approver Status"; Enum "Approval Status")
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry".Status where("Document No." = field("No")));
        }
        field(70134779; "Final Approver Seq No"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Approval Entry"."Sequence No." where("Document No." = field("No")));
        }
        field(70134789; "Open Approver Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("No"), Status = filter(Open)));
        }
        field(37; Grouping; Code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }
        field(38; "Payment Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(39; "Bank Type"; Option)
        {
            OptionMembers = Normal,"Petty Cash";
        }
        field(40; "PV Type"; Option)
        {
            OptionMembers = Normal,Other;
        }
        field(42; "Apply to ID"; Code[20]) { }
        field(43; "No. Printed"; Integer) { }
        field(44; "Imprest Issue Date"; Date) { }
        field(45; Surrendered; Boolean) { }
        field(46; "Imprest Issue Doc. No"; Code[20])
        {
            TableRelation = if ("Imprest Surrender Type" = const("Item Cash")) "Imprest Header"."No." where("Account No." = field("Account No."),
            Posted = const(true), "imprest TYpe" = const("Item Cash"), "Surrender Status" = filter(<> Full))
            else
            if ("Imprest Surrender Type" = const(Imprest)) "Imprest Header"."No." where("Account No." = field("Account No."),
            Posted = const(true), "imprest TYpe" = const(Imprest), "Surrender Status" = filter(<> Full));

            trigger OnValidate()
            var
                SurrLine: Record "Imprest Surrender Details";
                LineNo: Integer;
            begin

                /*Copy the details from the payments header tableto the imprest surrender table to enable the user work on the same document*/
                /*Retrieve the header details using the get statement*/
                

       

    // CopyImprestHeader();
    // CopyImprestLines();
    // LoadEmployeeInformation();
    //PrepareSurrender();
   



                
            end;
        }
        field(47; "Vote Book"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(48; "Total Allocation"; Decimal) { }
        field(49; "Total Expenditure"; Decimal) { }
        field(50; "Total Commitments"; Decimal) { }
        field(51; Balance; Decimal) { }
        field(52; "Balance Less this Entry"; Decimal) { }
        field(54; "Petty Cash"; Boolean) { }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", District);
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                departmentsRec.SetRange(departmentsRec."Sector Code", "Global Dimension 1 Code");
                if departmentsRec.FindFirst() then begin
                    "District Name" := CopyStr(departmentsRec."Department Name", 1, MaxStrLen("District Name"));
                end;
            end;
        }
        field(59; "Function Name"; Text[50]) { }
        field(60; "Budget Center Name"; Text[80]) { }
        field(61; "User ID"; Code[20])
        {
            TableRelation = User."User Name";
            trigger OnValidate()
            begin
                Cashier := "User ID";
            end;
        }
        field(62; "Issue Voucher Type"; Option)
        {
            OptionMembers = " ","Cash Voucher","Payment Voucher";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 3);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250]) { }
        field(84; Dim4; Text[250]) { }
        field(85; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(86; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = true;
            TableRelation = Currency;
        }
        field(87; "Responsibility Center"; Code[100])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                //TestField(Status, Status::Pending);
                // if not UserMgt.CheckRespCenter(1, "Shortcut Dimension 3 Code") then
                //    Error(
                //      Text001,
                //      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
            end;
        }
        field(88; "Amount Surrendered LCY"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Amount LCY" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(89; "PV No"; Code[20]) { }
        field(90; "Print No."; Integer) { }
        field(91; "Cash Surrender Amt"; Decimal)
        {
            CalcFormula = lookup("Imprest Surrender Details"."Cash Surrender Amt" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(92; "Financial Period"; Code[20])
        {
            TableRelation = "Financial Periods"."Period Code" where("Current Period" = filter(true));
        }
        field(93; "Actual Spent"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Actual Spent" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(50000; "Difference Owed"; Decimal)
        {
            CalcFormula = sum("Imprest Surrender Details"."Amount LCY" where("Surrender Doc No." = field(No)));
            FieldClass = FlowField;
        }
        field(50001; "Employee No"; Code[40])
        {
            trigger OnValidate()
            var
                Emp: Record "HR-Employee";
            begin
                if Emp.Get("Employee No") then begin
                    "Job Grade" := Emp."Job Group";
                    if "Job Grade" = '' then
                        "Job Grade" := Emp.Grade;
                    "Responsibility Center" := Emp."Responsibility Center";
                    "Global Dimension 1 Code" := Emp.Sector;
                    District := Emp.District;
                    "District Name" := CopyStr(Emp."District Name", 1, MaxStrLen("District Name"));
                    "Shortcut Dimension 2 Code" := Emp."Global Dimension 2 Code";
                    "Branch Name" := CopyStr(Emp."Branch- Name", 1, MaxStrLen("Branch Name"));
                    "Division Name" := CopyStr(Emp."Division Name", 1, MaxStrLen("Division Name"));
                    "Shortcut Dimension 3 Code" := Emp."Global Dimension 3 Code";
                    Division := Emp.Division;
                end
            end;
        }

        field(50002; "Imp Purpose"; Text[250])
        {
            CalcFormula = lookup("Imprest Header".Purpose where("No." = field("Imprest Issue Doc. No")));
            FieldClass = FlowField;
        }
        field(50003; District; Code[20])
        {
            DataClassification = ToBeClassified;

            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            TableRelation = Departments."Department Code" where("Sector Code" = field("Global Dimension 1 Code"), level = const(District));

            trigger OnValidate()
            begin
                TestField("Global Dimension 1 Code");
                Clear(Division);
                Clear("Shortcut Dimension 3 Code");
                //Clear("Branch Grade");
                Clear("Shortcut Dimension 2 Code");
                departmentsRec.Reset();
                departmentsRec.SetRange(departmentsRec."Department Code", District);
                departmentsRec.SetRange(departmentsRec.level, departmentsRec.level::District);
                departmentsRec.SetRange(departmentsRec."Sector Code", "Global Dimension 1 Code");
                if departmentsRec.FindFirst() then begin
                    "District Name" := CopyStr(departmentsRec."Department Name", 1, MaxStrLen("District Name"));
                end;
            end;
        }
        field(50004; "District Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Branch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Division"; Code[20])
        {
            //TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            TableRelation = Branches."Division/Branch Code" where("Department/District Code" = field("Shortcut Dimension 2 Code"), level = const(Division), "Sector Code" = field("Global Dimension 1 Code"));
            trigger OnValidate()
            begin
                TestField("Shortcut Dimension 2 Code");
                TestField("Global Dimension 1 Code");
                branchesdivRec.Reset();
                branchesdivRec.SetRange(branchesdivRec."Division/Branch Code", Division);
                branchesdivRec.SetRange(branchesdivRec.level, branchesdivRec.level::Division);
                if branchesdivRec.FindFirst() then begin
                    branchesdivRec.TestField("Sector Code");
                    branchesdivRec.TestField("Department/District Code");
                    "Division Name" := CopyStr(branchesdivRec."Division/Branch Name", 1, MaxStrLen("Division Name"));
                    Clear("Shortcut Dimension 3 Code");
                    Clear(District);
                    Clear(branchgrade);
                    // Sector := branchesdivRec."Sector Code";
                    // "Global Dimension 2 Code" := branchesdivRec."Department/District Code";

                end else if not branchesdivRec.Find() then begin
                    Error('Division does not exists on the organogram');
                end;
            end;
        }
        field(50007; "Division Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Department Name"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52053;"Actual Return Date"; Date)
{
    Caption = 'Actual Return Date';

    trigger OnValidate()
    var
        SurrenderLine: Record "Imprest Surrender Details";
    begin
        if "Actual Return Date" = 0D then
            exit;

        if "Travel Start Date" <> 0D then
            if "Actual Return Date" < "Travel Start Date" then
                Error(
                    'Actual Return Date %1 cannot be earlier than Travel Start Date %2.',
                    "Actual Return Date",
                    "Travel Start Date");
              Modify(true);
        


        // Recalculate surrender lines
        SurrenderLine.Reset();
        SurrenderLine.SetRange(
            "Surrender Doc No.",
            No);

        if SurrenderLine.FindSet() then
            repeat
                SurrenderLine.CalculateSurrender();
                SurrenderLine.Modify();
            until SurrenderLine.Next() = 0;
    end;
}
field(52054; "Basic Pay"; Decimal)
{
    Caption = 'Basic Pay';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 2 : 2;
}

field(52055; "Actual Travel Days"; Decimal)
{
    Caption = 'Actual Travel Days';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 0 : 1;
}

field(52056; "Taxable Days"; Decimal)
{
    Caption = 'Taxable Days';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 0 : 1;
}

field(52057; "Total Taxable Benefit"; Decimal)
{
    Caption = 'Total Taxable Benefit';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 2 : 2;
}

field(52058; "Total PAYE"; Decimal)
{
    Caption = 'Total PAYE';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 2 : 2;
}

field(52059; "Refund Amount"; Decimal)
{
    Caption = 'Refund Amount';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 2 : 2;
}

field(52060; "Reimbursement Amount"; Decimal)
{
    Caption = 'Reimbursement Amount';
    DataClassification = ToBeClassified;
    Editable = false;
    DecimalPlaces = 2 : 2;
}

field(52061; "Settlement Status"; Enum "Imprest Settlement Status")
{
    Caption = 'Settlement Status';
    DataClassification = ToBeClassified;
   
}

field(52062; "Receipt No."; Code[20])
{
    Caption = 'Receipt No.';
    DataClassification = ToBeClassified;
}

field(52063; "Payroll Transaction No."; Code[20])
{
    Caption = 'Payroll Transaction No.';
    DataClassification = ToBeClassified;
}
        field(52064; "Imprest Surrender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Imprest,Item Cash';
            OptionMembers = Imprest,"Item Cash";
        }
        field(52065; "Is HOD"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52052; "Job Grade"; Code[20])
        { }

        field(52066; "Posted Count"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Document No." = field(No),
                                                   Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(52067; "Imprest Type"; Option)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Imprest Header"."imprest TYpe" where("No." = field("Imprest Issue Doc. No")));
            OptionCaption = 'Imprest,Item Cash';
            OptionMembers = Imprest,"Item Cash";
        }
        field(52068; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 4);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(52069; "Basic Pay As At Date"; Date)
{
    Caption = 'Basic Pay As At Date';
    DataClassification = ToBeClassified;
    Editable = false;
}


field(52070; "Employee No."; Code[20])
{
    Caption = 'Employee No.';
    TableRelation = "HR-Employee"."No.";
    Editable = false;
}

field(52071; "Employee Name"; Text[100])
{
    Caption = 'Employee Name';
    Editable = false;
}

field(52073; "Travel Start Date"; Date)
{
    Caption = 'Travel Start Date';
    Editable = false;
}

field(52074; "Travel End Date"; Date)
{
    Caption = 'Travel End Date';
    Editable = false;
}



field(52076; "Travel Days"; Decimal)
{
    Caption = 'Travel Days';
    Editable = false;
}

field(52077; "Expected Return Date"; Date)
{
    Caption = 'Expected Return Date';
    Editable = false;
}

field(52078; "Total Imprest Issued"; Decimal)
{
    Caption = 'Total Imprest Issued';
    Editable = false;
}

field(50009; "Total Actual Spent"; Decimal)
{
    Caption = 'Total Actual Spent';
    Editable = false;
}

field(50010; "Total Refund Due"; Decimal)
{
    Caption = 'Total Refund Due';
    Editable = false;
}

field(50011; "Total Additional Amount"; Decimal)
{
    Caption = 'Total Additional Amount';
    Editable = false;
}

field(50012; "Total Taxable Amount"; Decimal)
{
    Caption = 'Total Taxable Amount';
    Editable = false;
}

field(50013; "Total Tax"; Decimal)
{
    Caption = 'Total Tax';
    Editable = false;
}

field(50014; "Imprest Settlement Status"; Enum "Imprest Settlement Status")
{
    Caption = 'Imprest Settlement Status';
}
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Status = Status::Posted then
            Error('Cannot Delete Document is already Posted');
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."Imprest Surrender No");
            No := NoSeriesMgt.GetNextNo(GenLedgerSetup."Imprest Surrender No", 0D, true);
        end;

        "Account Type" := "account type"::Customer;
        "Surrender Date" := Today;
        if Cashier = '' then
            Cashier := UserId;
        if "Account No." = '' then
            if UserSetup.Get(Cashier) then begin
                "Account No." := UserSetup."Imprest Account";
            end;

        Validate(Cashier);
    end;

    trigger OnModify()
    begin
        // IF  Status=Status::Posted THEN
        //  ERROR('Cannot Modify Document is already Posted');
    end;

    var
        ImpSurrLine: Record "Imprest Surrender Details";
        PayHeader: Record "Imprest Header";
        PayLine: Record "Imprest Lines";
        "Withholding Tax Code": Code[200];
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Cash Office Setup";
        RecPayTypes: Record "Receipts and Payment Types";
        DimVal: Record "Dimension Value";
        "VAT Code": Code[20];
        PaymentsH: Record "Payments Header";
        UserSetup: Record "User Setup";
        distrctsdepartRec: Record Departments;
        branchesdivRec: Record Branches;

        departmentsRec: Record Departments;

        sectorsRec: Record Sectors;

        branchgrade: Record "Branch Grading";
procedure PrepareSurrender()
begin
    TestField("Imprest Issue Doc. No");

    DeleteSurrenderLines();

    CopyImprestHeader();

    CopyImprestLines();

    LoadPaymentVoucher();

    Modify(true);
end;
local procedure DeleteSurrenderLines()
var
    SurrenderLine: Record "Imprest Surrender Details";
begin
    SurrenderLine.Reset();
    SurrenderLine.SetRange("Surrender Doc No.", "No");

    if not SurrenderLine.IsEmpty() then
        SurrenderLine.DeleteAll();
end;
local procedure LoadHeaderInformation()
var
    ImprestHeader: Record "Imprest Header";
begin
    ImprestHeader.Get("Imprest Issue Doc. No");

    Validate("Account No.", ImprestHeader."Account No.");
    Validate("Account Name", ImprestHeader.Payee);

    Amount := ImprestHeader."Paid Amount";

    "Imprest Issue Date" := ImprestHeader.Date;

    "Currency Code" := ImprestHeader."Currency Code";
    "Currency Factor" := ImprestHeader."Currency Factor";

    "Global Dimension 1 Code" := ImprestHeader."Global Dimension 1 Code";
    "Shortcut Dimension 2 Code" := ImprestHeader."Shortcut Dimension 2 Code";
    "Shortcut Dimension 3 Code" := ImprestHeader."Shortcut Dimension 3 Code";
    "Shortcut Dimension 4 Code" := ImprestHeader."Shortcut Dimension 4 Code";

    "Responsibility Center" := ImprestHeader."Responsibility Center";

    "Received From" := ImprestHeader.Payee;
    "Travel Start Date":=ImprestHeader."Travel Start Date";

    "Imp Purpose" := ImprestHeader.Purpose;

    Modify();
end;
    local procedure CopyImprestHeader()
var
    Employee: Record "HR-Employee";
begin
    PayHeader.Get("Imprest Issue Doc. No");

    Validate("Account No.", PayHeader."Account No.");
    Validate("Account Name", PayHeader.Payee);

    Payee := PayHeader.Payee;

    PayHeader.CalcFields("Total Net Amount");
    Amount := PayHeader."Total Net Amount";

    "Paying Bank Account" := PayHeader."Paying Bank Account";

    "Currency Code" := PayHeader."Currency Code";
    "Currency Factor" := PayHeader."Currency Factor";

    "Global Dimension 1 Code" := PayHeader."Global Dimension 1 Code";
    "Shortcut Dimension 2 Code" := PayHeader."Shortcut Dimension 2 Code";
    "Shortcut Dimension 3 Code" := PayHeader."Shortcut Dimension 3 Code";
    "Shortcut Dimension 4 Code" := PayHeader."Shortcut Dimension 4 Code";
    "Shortcut Dimension 5 Code" := PayHeader."Shortcut Dimension 5 Code";

    "Responsibility Center" := PayHeader."Responsibility Center";

    "Imprest Issue Date" := PayHeader.Date;
    "Date Posted" := PayHeader."Date Posted";

    "Travel Start Date" := PayHeader."Travel Start Date";

    "Received From" := PayHeader.Payee;
    "Imp Purpose" := PayHeader.Purpose;

    "Employee No" := PayHeader."Employee No.";
    "Job Grade" := PayHeader."Job Grade";
    if ("Job Grade" = '') and Employee.Get("Employee No") then begin
        "Job Grade" := Employee."Job Group";
        if "Job Grade" = '' then
            "Job Grade" := Employee.Grade;
    end;

    "Cheque No" := PayHeader."Cheque No.";
    "Is HOD" := PayHeader."Is HOD";
end;
local procedure CopyImprestLines()
var
    ImprestLine: Record "Imprest Lines";
    SurrenderLine: Record "Imprest Surrender Details";
begin
    ImprestLine.SetRange(No, "Imprest Issue Doc. No");

    if ImprestLine.FindSet() then
        repeat
            SurrenderLine.Init();

            CopyImprestLine(
                ImprestLine,
                SurrenderLine);

            SurrenderLine.Insert(true);

        until ImprestLine.Next() = 0;
end;
local procedure CopyImprestLine(
    var ImprestLine: Record "Imprest Lines";
    var SurrenderLine: Record "Imprest Surrender Details")
begin
    SurrenderLine."Surrender Doc No." := "No";

    SurrenderLine."Account No:" := ImprestLine."Account No:";
    SurrenderLine."Account Name" := ImprestLine."Account Name";

    SurrenderLine."Imprest Holder" := ImprestLine."Imprest Holder";

    SurrenderLine."Imprest Type" := ImprestLine."Advance Type";
    SurrenderLine."Imprest Surrender Type" := ImprestLine."Imprest Type";

    SurrenderLine.Amount := ImprestLine.Amount;
    SurrenderLine."Advance Amount" := ImprestLine.Amount;

    SurrenderLine."Currency Code" := ImprestLine."Currency Code";
    SurrenderLine."Currency Factor" := ImprestLine."Currency Factor";

    SurrenderLine."Date Issued" := ImprestLine."Date Issued";
    SurrenderLine."Due Date" := ImprestLine."Due Date";

    SurrenderLine."Duty Area" := ImprestLine."Duty Area";

    SurrenderLine."Shortcut Dimension 1 Code" := ImprestLine."Global Dimension 1 Code";
    SurrenderLine."Shortcut Dimension 2 Code" := ImprestLine."Shortcut Dimension 2 Code";
    SurrenderLine."Shortcut Dimension 3 Code" := ImprestLine."Shortcut Dimension 3 Code";
    SurrenderLine."Shortcut Dimension 4 Code" := ImprestLine."Shortcut Dimension 4 Code";

    // Travel snapshot
    SurrenderLine."Travel Start Date" := "Travel Start Date";
    SurrenderLine."Approved Daily Rate" := ImprestLine."Daily Rate(Amount)";
    SurrenderLine."Taxable Travel Allowance" := ImprestLine."Taxable Travel Allowance";

    // Employee snapshot
    SurrenderLine."Basic Pay At Requisition" := ImprestLine."Basic Pay At Requisition";
    SurrenderLine."Job Group At Requisition" := ImprestLine."Job Group";
    if SurrenderLine."Job Group At Requisition" = '' then
        SurrenderLine."Job Group At Requisition" := ImprestLine."Employee Job Group";
    if SurrenderLine."Job Group At Requisition" = '' then
        SurrenderLine."Job Group At Requisition" := "Job Grade";

    // Initialise calculated fields
    SurrenderLine."Actual Travel Days" := 0;
    SurrenderLine."Tax Free Daily Limit" := 0;
    SurrenderLine."Taxable Rate Difference" := 0;
    SurrenderLine."Taxable Days" := 0;
    SurrenderLine."Taxable Benefit" := 0;
    SurrenderLine."Income Tax" := 0;
    SurrenderLine."Actual Spent" := 0;
    SurrenderLine."Net Allowable Expense" := 0;
    SurrenderLine."Refund Amount" := 0;
    SurrenderLine."Additional Payment" := 0;
    SurrenderLine."Outstanding Amount" := 0;
end;
local procedure LoadPaymentVoucher()
begin
    Clear("PV No");

    PaymentsH.Reset();
    PaymentsH.SetRange("Imprest No.", "Imprest Issue Doc. No");

    if PaymentsH.FindFirst() then
        "PV No" := PaymentsH."No.";
end;
local procedure InitializeSurrender()
begin
   // LoadEmployeeInformation();

    // Future enhancements
    // PrepareSurrenderLines();
    // UpdateHeaderTotals();
end;
        

}

