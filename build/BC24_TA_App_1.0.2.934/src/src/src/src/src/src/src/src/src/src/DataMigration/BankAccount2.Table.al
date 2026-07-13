Table 50487 "Bank Account2"
{
    Caption = 'Bank Account';
    DataCaptionFields = "No.", Name;

    // Permissions = TableData "Bank Account Ledger Entry"=r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';


        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[100])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';


        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(13; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(14; "Transit No."; Text[20])
        {
            Caption = 'Transit No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));


        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

        }
        field(18; "Chain Name"; Code[10])
        {
            Caption = 'Chain Name';
        }
        field(20; "Min. Balance"; Decimal)
        {
            //AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Min. Balance';
        }
        field(21; "Bank Acc. Posting Group"; Code[10])
        {
            Caption = 'Bank Acc. Posting Group';
            TableRelation = "Bank Account Posting Group";


        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            ////TableRelation = Language;
        }
        field(26; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(29; "Our Contact Code"; Code[10])
        {
            Caption = 'Our Contact Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(37; Amount; Decimal)
        {
            //AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(38; Comment; Boolean)
        {
            // CalcFormula = exist("Comment Line" where ("Table Name"=const(Bank field("No.")")";
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(41; "Last Statement No."; Code[20])
        {
            Caption = 'Last Statement No.';
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(58; Balance; Decimal)
        {
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Bank Account Ledger Entry"."Amount (LCY)" where("Bank Account No." = field("No."),
                                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Net Change"; Decimal)
        {
            // AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Bank Account Ledger Entry".Amount where("Bank Account No." = field("No."),
                                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                        "Posting Date" = field("Date Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Bank Account Ledger Entry"."Amount (LCY)" where("Bank Account No." = field("No."),
                                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Posting Date" = field("Date Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(89; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;


        }
        field(92; Region; Text[30])
        {
            Caption = 'Region';
        }
        field(93; "Last Check No."; Code[20])
        {
            Caption = 'Last Check No.';
        }
        field(94; "Balance Last Statement"; Decimal) { }
        field(95; "Balance at Date"; Decimal) { }
        field(96; "Balance at Date (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Bank Account Ledger Entry"."Amount (LCY)" where("Bank Account No." = field("No."),
                                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Posting Date" = field(upperlimit("Date Filter"))));
            Caption = 'Balance at Date (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(97; "Debit Amount"; Decimal) { }
        field(98; "Credit Amount"; Decimal)
        {
            //AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount" where("Bank Account No." = field("No."),
                                                                                 "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                 "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = field("Date Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Bank Account Ledger Entry"."Debit Amount (LCY)" where("Bank Account No." = field("No."),
                                                                                      "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                      "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                      "Posting Date" = field("Date Filter")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Bank Account Ledger Entry"."Credit Amount (LCY)" where("Bank Account No." = field("No."),
                                                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                       "Posting Date" = field("Date Filter")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Check Report ID"; Integer)
        {
            Caption = 'Check Report ID';
            TableRelation = Object.ID where(Type = const(Report));
        }
        field(109; "Check Report Name"; Text[80])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Report),
                                                                        "Object ID" = field("Check Report ID")));
            Caption = 'Check Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; Iban; Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(Iban);
            end;
        }
        field(111; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
        }
        field(50000; TEXT; Integer) { }
        field(39005975; "Bank Type"; Option)
        {
            OptionMembers = Normal,Cash,"Fixed Deposit",SMPA,"Chq Collection";


        }
        field(39005976; "Pending Voucher Amount"; Decimal)
        {
            //CalcFormula = sum(Table39005995.Field5 where (Field27=field("No.")));
            FieldClass = FlowField;
        }
        field(39005977; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center".Code;


        }
        field(39005978; "Bank Branch Name"; Text[250]) { }
        field(39005979; "UnUsed PettyCash"; Decimal) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name") { }
        key(Key3; "Bank Acc. Posting Group") { }

        key(Key5; "Country/Region Code") { }
    }

    fieldgroups { }

}

