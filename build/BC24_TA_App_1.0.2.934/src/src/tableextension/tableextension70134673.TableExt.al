TableExtension 50005 tableextension70134673 extends "Bank Account Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".


        //Unsupported feature: Property Modification (Data type) on ""Source Code"(Field 28)".


        //Unsupported feature: Property Modification (Data type) on ""Journal Batch Name"(Field 49)".


        //Unsupported feature: Property Modification (Data type) on ""Reason Code"(Field 50)".




        //Unsupported feature: Property Deletion (DataClassification) on ""User ID"(Field 27)".

        field(50000; "External Document No. 2"; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Statement Difference"; Decimal) { }
        field(50002; Test2; Code[20]) { }
        field(50003; Test3; Code[20]) { }
        field(50004; Test; Code[20]) { }
        field(50050; Remarks; Text[50]) { }
        field(53021; "Document Ref. No"; Code[30]) { }
        field(53022; "Source Account Staff No"; Code[20]) { }
        field(53023; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Bal. Account No.")));
            FieldClass = FlowField;
        }
        field(53024; "Payee Name"; Text[100])
        {
            CalcFormula = lookup("Payments Header".Payee where("No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(53025; "Amount Applied"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(54000; "Statement Diffrence 2"; Decimal) { }
    }
}

