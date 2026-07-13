report 50056 "ICT General Requisition"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("ICT General Requisition Header"; "ICT General Requisition Header")
        {
            column(No; No) { }
            column(Date; Date) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Requested_By; "Requested By") { }
            column(Requisition_Category; "Requisition Category") { }
            column(Technical_Information; "Technical Information") { }
            column(General_Description; "General Description") { }
            column(Assignee; Assignee) { }
            column(Resolution_Remarks; "Resolution Remarks") { }
            column(Resolution_Status; "Resolution Status") { }
            column(Urgency_Priority; "Urgency Priority") { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
            end;
        }
    }





    var
        CompInf: Record "Company Information";

}