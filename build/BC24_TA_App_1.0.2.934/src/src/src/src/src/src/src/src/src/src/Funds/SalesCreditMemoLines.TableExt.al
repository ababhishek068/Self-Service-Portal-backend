TableExtension 50035 "Sales Credit Memo Lines" extends "Sales Cr.Memo Line"
{
    fields
    {

        field(50001; "Applies to Doc No"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Applies-to Doc. No." where("No." = field("Document No.")));
        }


    }
}

