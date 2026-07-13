Table 50141 "HMS Charges"
{
    DataCaptionFields = "Code", Description;
    // DrillDownPageID = UnknownPage70135577;
    // LookupPageID = UnknownPage70135577;

    fields
    {
        field(1; "Code"; Code[150]) { }
        field(2; Description; Text[150]) { }
        field(3; "Income G/L Account No"; Code[20])
        {
            Caption = 'Account No';
            TableRelation = if ("Account type" = filter("G/L Account")) "G/L Account"."No."
            else
            if ("Account type" = filter(Vendor)) Vendor."No.";
        }
        field(4; Amount; Decimal) { }
        field(5; Drugs; Boolean) { }
        field(6; "Applicable Section"; Option)
        {
            OptionCaption = 'Standing Charge,Registration,Triage,Appointment,Observation Room,Consultation Fee,Laboratory,Radiology,Pharmacy,Physiotheraphy';
            OptionMembers = "Standing Charge",Registration,Triage,Appointment,"Observation Room","Consultation Fee",Laboratory,Radiology,Pharmacy,Physiotheraphy;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(9; "Account type"; Option)
        {
            OptionCaption = 'G/L Account,Vendor';
            OptionMembers = "G/L Account",Vendor;
        }
        field(10; "Billing Type"; Option)
        {
            OptionCaption = 'Once,Reccuring';
            OptionMembers = Once,Reccuring;
        }
        field(11; "Reccuring Type"; Option)
        {
            OptionCaption = ' ,Daily,Hourly';
            OptionMembers = " ",Daily,Hourly;
        }
        field(12; "Transaction Type"; Code[50])
        {
            Editable = true;
            TableRelation = "HMS Transactions code"."Transaction Type";
        }
        field(13; "Percentage Rate"; Decimal)
        {
            Description = '% Rate at which the insurance per on top of the (Amount)';
        }
        field(14; "Expense G/L Account No"; Code[20])
        {
            Caption = 'Account No';
            TableRelation = if ("Account type" = filter("G/L Account")) "G/L Account"."No."
            else
            if ("Account type" = filter(Vendor)) Vendor."No.";
        }
        field(15; "Doctor Percentage"; Decimal) { }
        field(16; "Insurance Amount"; Decimal) { }
        field(17; "Branch2 Amount"; Decimal) { }
        field(18; "Branch3 Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description) { }
        key(Key3; Amount) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description) { }
        fieldgroup(Brick; "Code", Description, Amount) { }
    }
}

