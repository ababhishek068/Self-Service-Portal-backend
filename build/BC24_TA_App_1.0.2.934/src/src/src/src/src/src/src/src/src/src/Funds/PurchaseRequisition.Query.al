query 50050 "Purchase Requisition"
{
    QueryType = Normal;

    elements
    {
        dataitem(Purchase_Header; "Purchase Header")
        {
            column(No_; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Request_Description; "Request Description") { }
            column(Posting_Description; "Posting Description") { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
            column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
            column(Project_Code; "Project Code") { }
            column(Donor_Name; "Donor Name") { }
            column(Department_Name; "Department Name") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Status; Status) { }
            column(Employee_No_; "Employee No.") { }
            column(Assigned_User_ID; "Assigned User ID") { }
            column(Assigned_Procurement_Officer; "Assigned Procurement Officer") { }
            column(Procurement_Method_Code; "Procurement Method Code") { }
            column(Amount; Amount) { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}