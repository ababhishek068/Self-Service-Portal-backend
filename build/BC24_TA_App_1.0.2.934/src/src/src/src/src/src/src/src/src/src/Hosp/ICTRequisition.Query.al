Query 50031 "ICT Requisition"
{

    elements
    {
        dataitem(ICT_General_Requisition_Header; "ICT General Requisition Header")
        {
            column(No; No) { }
            column(Date; Date) { }
            column(Requisition_Category; "Requisition Category") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(General_Description; "General Description") { }
            column(Urgency_Priority; "Urgency Priority") { }
            column(Required_Date; "Required Date") { }
            column(Resolution_Status; "Resolution Status") { }
            column(Resolution_Remarks; "Resolution Remarks") { }
            column(Assignee; Assignee) { }
            column(Assignee_Name; "Assignee Name") { }
            column(Requested_By; "Requested By") { }
            column(Requestor_Name; "Requestor Name") { }
        }
    }
}

