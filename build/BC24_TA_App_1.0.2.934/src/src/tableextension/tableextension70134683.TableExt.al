TableExtension 50012 tableextension70134683 extends "Detailed Cust. Ledg. Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Journal Batch Name"(Field 14)".


        //Unsupported feature: Property Modification (Data type) on ""Reason Code"(Field 15)".


        //Unsupported feature: Property Modification (Data type) on ""Tax Jurisdiction Code"(Field 41)".


        //Unsupported feature: Property Deletion (DataClassification) on ""User ID"(Field 11)".

        field(50000; Description; Text[100])
        {
            CalcFormula = lookup("Cust. Ledger Entry".Description where("Customer No." = field("Customer No."),
                                                                         "Entry No." = field("Cust. Ledger Entry No.")));
            FieldClass = FlowField;
        }

        field(50002; Reversed; Boolean)
        {
            CalcFormula = lookup("Cust. Ledger Entry".Reversed where("Customer No." = field("Customer No."),
                                                                      "Entry No." = field("Cust. Ledger Entry No.")));
            FieldClass = FlowField;
        }

        field(50004; "Exist in CL"; Integer)
        {
            CalcFormula = count("Cust. Ledger Entry" where("Entry No." = field("Cust. Ledger Entry No."),
                                                            "Customer No." = field("Customer No.")));
            FieldClass = FlowField;
        }
        field(50005; "Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Trans Exists in GL"; Integer)
        {
            CalcFormula = count("G/L Entry" where("Transaction No." = field("Transaction No."),
                                                   "Posting Date" = field("Posting Date")));
            FieldClass = FlowField;
        }
    }
    keys
    {
        // Unsupported feature: Key containing base fields
        // 
        // //Unsupported feature: Property Modification (SumIndexFields) on ""Cust. Ledger Entry No.","Entry Type","Posting Date"(Key)".
        // 
        // 
        // //Unsupported feature: Property Insertion (MaintainSQLIndex) on ""Cust. Ledger Entry No.","Entry Type","Posting Date"(Key)".
        // 
        // 
        // //Unsupported feature: Property Insertion (MaintainSIFTIndex) on ""Ledger Entry Amount","Cust. Ledger Entry No.","Posting Date"(Key)".
        // 
        // 
        // //Unsupported feature: Property Insertion (MaintainSIFTIndex) on ""Initial Document Type","Entry Type","Customer No.","Currency Code","Initial Entry Global Dim. 1","Initial Entry Global Dim. 2","Posting Date"(Key)".
        // 
        // 
        // //Unsupported feature: Deletion (KeyCollection) on ""Document Type"(Key)".
        // 
        // 
        // //Unsupported feature: Deletion (KeyCollection) on ""Initial Document Type","Initial Entry Due Date"(Key)".
        // 
        // key(Key1;"Customer No.","Posting Date")
        // {
        // }
    }
}

