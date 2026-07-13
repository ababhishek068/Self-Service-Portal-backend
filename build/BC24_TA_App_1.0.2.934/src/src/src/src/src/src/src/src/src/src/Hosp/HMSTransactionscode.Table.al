Table 50778 "HMS Transactions code"
{

    fields
    {
        field(1; "Transaction Type"; Code[25]) { }
        field(2; Description; Text[200]) { }
        field(3; "Income G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; "Expense G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Calculate Doctor Fee"; Boolean) { }
        field(6; "Calculate Insurance Fee"; Boolean) { }
        field(7; "Patient No Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HMS Patient"."Patient No.";
        }
        field(8; Amount; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Transaction Type" = field("Transaction Type"),
                                                                          "Patient No." = field("Patient No Filter"),
                                                                          Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(9; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(10; "Patient Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ' ,Corporate,Cash';
            OptionMembers = " ",Corporate,Cash;
        }
        field(11; "Receipt Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(12; "Posted Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(13; "Invoice Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Transaction Type" = field("Transaction Type"),
                                                                          "Patient No." = field("Patient No Filter"),
                                                                          Date = field("Date Filter"),
                                                                          Posted = filter(true),
                                                                          "Patient Type Lk" = const(Corporate)));
            FieldClass = FlowField;
        }
        field(14; "Cash Amount"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Transaction Type" = field("Transaction Type"),
                                                                          "Patient No." = field("Patient No Filter"),
                                                                          Date = field("Date Filter"),
                                                                          Posted = filter(true),
                                                                          "Patient Type Lk" = const(Cash)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Transaction Type")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

