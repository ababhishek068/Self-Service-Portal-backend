Table 50490 "Procurement Methods"
{
    LookupPageId = "Procurement Methods List";
    DrillDownPageId = "Procurement Methods List";

    fields
    {
        field(1; "Code"; Option)
        {
            Caption='Procurement Method';
            NotBlank = true;
            OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EO';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
        }
        field(2; Description; Text[30]) { }
        field(3; "Invite/Advertise date"; Date) { }
        field(4; "Invite/Advertise period"; DateFormula) { }
        field(5; "Open tender period"; Integer) { }
        field(6; "Evaluate tender period"; Integer) { }
        field(7; "Committee period"; Integer) { }
        field(8; "Notification period"; Integer) { }
        field(9; "Contract period"; Integer) { }
        field(11; "Planned Date"; Date) { }
        field(12; "Planned Days"; DateFormula) { }
        field(13; "Actual Days"; DateFormula) { }
        field(14; Type; Option)
        {
            OptionMembers = ,Restricted;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        WorkplanActivities.Reset;
        WorkplanActivities.SetRange(WorkplanActivities."Procurement Method",Rec.Code);
        if WorkplanActivities.Find('-') then begin
            Error('You cannot delete this Workplan [ %1 ] because it is in use in Workplan [ %2 ]', Code, WorkplanActivities."Procurement Workplan Code");
        end;

        TenderPlanHeader.Reset;
        TenderPlanHeader.SetRange(TenderPlanHeader."Procurement Method", Rec.Code);
        if TenderPlanHeader.Find('-') then begin
            Error('You cannot delete this Workplan [ %1 ] because it is in use in Tender Card [ %2 ]', Code, TenderPlanHeader."No.");
        end;
    end;

    var
        WorkplanActivities: Record "Workplan Activities";
        TenderPlanHeader: Record "Tender Plan Header";
}

