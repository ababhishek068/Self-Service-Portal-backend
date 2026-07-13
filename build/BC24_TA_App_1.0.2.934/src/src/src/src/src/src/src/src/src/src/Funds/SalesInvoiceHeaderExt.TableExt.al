tableextension 50028 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(70134678; "Invoice Cleared"; Boolean) { }
        field(50067; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No where("Station Code" = field("Shortcut Dimension 1 Code"));

        }
        field(50121; "Sales Person"; code[20])
        {
            // TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Global Dimension 1 Code"));
            TableRelation = "Shift Allocation Line"."Staff No" where(No = field("Shift No"));
        }
        field(50069; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line"."Amount Including VAT" where("Document No." = field("No.")));
        }
        field(70134680; "Pay Mode"; option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,MPESA,PDQ';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MPESA,PDQ;
        }
        field(70134681; "Bank Account No"; code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(70134682; "Cash Sale"; Boolean) { }
        field(70134683; "Transaction No"; code[20]) { }
        field(50082; "Applied Credit Memo No"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."No." where("Applies-to Doc. No." = field("No.")));
        }
        field(50083; "Prepared By"; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."User ID" where("Document No." = field("No.")));
        }

    }
}





