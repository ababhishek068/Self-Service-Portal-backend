tableextension 50022 "Purch. Receipt Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(51000; "Order Qty Archive"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line Archive".Quantity where("Document No." = field("Document No."), "No." = field("No.")));
        }
        field(51001; "Order VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line Archive"."VAT Base Amount" where("Document No." = field("Document No."), "No." = field("No.")));
        }
        field(51002; "Order Amount Including VAT Archive"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line Archive"."Amount Including VAT" where("Document No." = field("Document No."), "No." = field("No.")));
        }
        field(51102; "Order Archive Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line Archive"."Amount Including VAT" where("Document No." = field("Order No.")));
        }
        field(51112; "Order Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Amount Including VAT" where("Document No." = field("Order No.")));
        }
        field(51003; "Order Received Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line Archive"."Quantity Received" where("Document No." = field("Document No."), "No." = field("No.")));
        }
        field(51004; "Order Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".Quantity where("Document No." = field("Order No."), "No." = field("No.")));
        }
        field(51005; "Line Amount Including VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Amount Including VAT" where("Document No." = field("Order No."), "No." = field("No.")));
        }
        field(51006; "Total Qty Received"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Order No." = field("Order No."), "No." = field("No."), "Document No." = field("Document No.")));
        }
        field(51007; "GRN Qty Received"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Order No." = field("Order No."), "No." = field("No."), "Document No." = field("GRN Filter")));
        }
        field(51008; "GRN Filter"; code[20])
        {
            FieldClass = FlowFilter;
        }

    }


}