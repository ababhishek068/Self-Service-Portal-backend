Table 50786 "Funds Management Cue"
{
    Caption = 'Finance Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Interbank Pending Approval"; Integer)
        {
            CalcFormula = count("InterBank Transfers" where(Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(3; "Interbank Not Posted"; Integer)
        {
            CalcFormula = count("InterBank Transfers" where(Status = filter(Approved),
                                                             Posted = filter(false)));
            FieldClass = FlowField;
        }
        field(4; "PV Pending Approval"; Integer)
        {
            CalcFormula = count("Payments Header" where("Payment Type" = filter(Normal),
                                                         Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(5; "PV Not Posted"; Integer)
        {
            CalcFormula = count("Payments Header" where("Payment Type" = filter(Normal),
                                                         Status = filter(Approved)));
            FieldClass = FlowField;
        }
        field(6; "PCV Pending Approval"; Integer)
        {
            CalcFormula = count("Payments Header" where("Payment Type" = filter("Petty Cash"),
                                                         Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(7; "PCV Not Posted"; Integer)
        {
            CalcFormula = count("Payments Header" where("Payment Type" = filter("Petty Cash"),
                                                         Status = filter(Approved)));
            FieldClass = FlowField;
        }
        field(8; "Staff Travel Pending Approval"; Integer)
        {
            CalcFormula = count("Imprest Header" where(Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(9; "Staff Travel Not Posted"; Integer)
        {
            CalcFormula = count("Imprest Header" where(Status = filter(Approved)));
            FieldClass = FlowField;
        }
        field(10; "Staff TA Pending Approval"; Integer)
        {
            CalcFormula = count("Imprest Surrender Header" where(Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(11; "Staff TA Not Posted"; Integer)
        {
            CalcFormula = count("Imprest Surrender Header" where(Status = filter(Approved)));
            FieldClass = FlowField;
        }
        field(12; "Other Advance Pending Approval"; Integer) { }
        field(13; "Other Advance Not Posted"; Integer) { }
        field(14; "Staff Claim Pending Approval"; Integer)
        {
            CalcFormula = count("Staff Claims Header" where(Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(15; "Staff Claim Not Posted"; Integer)
        {
            CalcFormula = count("Staff Claims Header" where(Status = filter(Approved)));
            FieldClass = FlowField;
        }
        field(16; "Requisitions Pending Approval"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Quote),
                                                         DocApprovalType = filter(Requisition),
                                                         Status = filter('Pending Approval')));
            FieldClass = FlowField;
        }
        field(17; "Requisitions Not Posted"; Integer) { }
        field(18; "Store Req. Pending Approval"; Integer)
        {
            CalcFormula = count("Store Requistion Header" where(Status = filter(Released)));
            FieldClass = FlowField;
        }
        field(19; "Store Req. Not Posted"; Integer)
        {
            CalcFormula = count("Store Requistion Header" where(Status = filter("Pending Approval")));
            FieldClass = FlowField;
        }
        field(29; "Unpaid Invoices"; Integer)
        {
            CalcFormula = count("Purch. Inv. Header" where("Remaining Amount" = filter(<> 0)));
            FieldClass = FlowField;
        }
        field(20; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
        }
        field(50000; "Approval Entries"; Integer) { }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

