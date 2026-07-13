table 50918 "Staff Portal Cues"
{
    Caption = 'Staff Portal Cues';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[30]) { }
        field(2; "Employee No"; Code[30])
        {
            Caption = 'Employee No';
            FieldClass = FlowFilter;
        }
        field(3; "My User Id"; Code[30])
        {
            Caption = 'My User Id';
            FieldClass = FlowFilter;
        }
        field(4; "Staff Claims Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Staff Claims Header" where(Status = const(Pending), "Employee No" = field("Employee No")));
        }
        field(5; "Staff Claims Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Staff Claims Header" where(Status = const("Pending Approval"), "Employee No" = field("Employee No")));
        }
        field(6; "Staff Claims Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Staff Claims Header" where(Status = const(Approved), "Employee No" = field("Employee No")));
        }
        field(7; "Total Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where(Status = const(Open), "Approver ID" = field("My User Id")));
        }
        field(8; "Imprest Requests Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Header" where(Status = const(Pending), "Employee No." = field("Employee No")));
        }
        field(9; "Imprest Requests Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Header" where(Status = const("Pending Approval"), "Employee No." = field("Employee No")));
        }
        field(10; "Imprest Requests Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Header" where(Status = const(Approved), "Employee No." = field("Employee No")));
        }
        field(11; "Imprest Surrenders Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Surrender Header" where(Status = const(Pending), "Employee No" = field("Employee No")));
        }
        field(12; "Imprest Surrenders Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Surrender Header" where(Status = const("Pending Approval"), "Employee No" = field("Employee No")));
        }
        field(13; "Imprest Surrenders Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Imprest Surrender Header" where(Status = const(Approved), "Employee No" = field("Employee No")));
        }
        field(14; "Petty Cash Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Payments Header" where(Status = const(Pending), "Employee No" = field("Employee No")));
        }
        field(15; "Petty Cash Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Payments Header" where(Status = const(Pending), "Employee No" = field("Employee No")));
        }
        field(16; "Petty Cash Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Payments Header" where(Status = const(Approved), "Employee No" = field("Employee No")));
        }
        field(17; "Purchase Requests Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = const(Open), "Employee No." = field("Employee No"), "Document Type" = const(Quote)));
        }
        field(18; "Purchase Requests Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = const("Pending Approval"), "Employee No." = field("Employee No"), "Document Type" = const(Quote)));
        }
        field(19; "Purchase Requests Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where(Status = const(Released), "Employee No." = field("Employee No"), "Document Type" = const(Quote)));
        }
        field(20; "Store Requests Open"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Store Requistion Header" where(Status = const(Open), "Employee No" = field("Employee No")));
        }
        field(21; "Store Requests Pending"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Store Requistion Header" where(Status = const("Pending Approval"), "Employee No" = field("Employee No")));
        }
        field(22; "Store Requests Approved"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Store Requistion Header" where(Status = const(Released), "Employee No" = field("Employee No")));
        }
        field(23; "Claims Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Staff Claims Header")));
        }
        field(24; "Imprests Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Imprest Header")));
        }
        field(25; "Surrenders Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Imprest Surrender Header")));
        }
        field(26; "Leaves App Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"HR Leave Application")));
        }
        field(27; "PurchaseRe Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Purchase Header")));
        }
        field(28; "Petty Cash Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Payments Header"), "Document Type" = const(Quote)));
        }
        field(29; "StoreReq Pending My Approval"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Approver ID" = field("My User Id"), Status = const(Open), "Table ID" = const(Database::"Store Requistion Header")));
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
