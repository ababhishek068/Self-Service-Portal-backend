query 50064 "ICT General Requisition Header"
{
    QueryType = Normal;

    elements
    {
        dataitem(ICTReq; "ICT General Requisition Header")
        {
            column(No; No) { }
            column(Date; Date) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Required_Date; "Required Date") { }
            column(Requisition_Category; "Requisition Category") { }
            column(Requested_By; "Requested By") { }
            column(General_Description; "General Description") { }
            column(Urgency_Priority; "Urgency Priority") { }
            column(Resolution_Status; "Resolution Status") { }
            column(Resolution_Remarks; "Resolution Remarks") { }
            column(Assignee; Assignee) { }
            column(Technical_Information; "Technical Information") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
