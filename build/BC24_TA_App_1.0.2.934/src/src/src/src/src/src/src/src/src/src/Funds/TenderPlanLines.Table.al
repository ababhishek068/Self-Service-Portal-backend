Table 50510 "Tender Plan Lines"
{

    fields
    {
        field(1; "Tender No."; Code[20]) { }
        field(5; "Planned start date"; Date)
        {
            Editable = true;
        }
        field(6; "Planned end date"; Date)
        {
            Editable = true;
        }
        field(7; "Planned duration"; Decimal)
        {
            Editable = true;
        }
        field(8; "Actual start date"; Date)
        {

            trigger OnValidate()
            begin
                if "Actual end date" > "Actual start date" then "Actual Duration" := "Actual end date" - "Actual start date";
                SetNextStart;
            end;
        }
        field(9; "Actual end date"; Date)
        {

            trigger OnValidate()
            begin
                if "Actual end date" > "Actual start date" then "Actual Duration" := "Actual end date" - "Actual start date";
                SetNextStart;
            end;
        }
        field(10; "Actual Duration"; Decimal)
        {
            Editable = true;
        }
        field(11; Stage; Code[20])
        {
            Editable = true;
            NotBlank=true;
            TableRelation="Procurement Method Stages"."Stage Code";
            trigger OnValidate()
            var
            procstage: Record "Procurement Method Stages";
            begin
                procstage.Reset();
                procstage.SetRange(procstage."Stage Code",Stage);
                if procstage.FindFirst() then begin
                    Description:=procstage."Stage Description";
                end;

            end;
        }
        field(12; "Sorting No."; Integer)
        {
            Editable = false;
        }
        field(13; WorkplanCode; Code[20])
        {
            CalcFormula = lookup("Tender Plan Header"."Workplan Code" where("No."=field("Tender No.")));
            FieldClass = FlowField;
        }
        field(14; "WorkPlan Code"; Code[20]) { }
        field(15; "Proc. Method No."; Option)
        {
             OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
            CalcFormula = lookup("Tender Plan Header"."Procurement Method" where("No." = field("Tender No.")));
            FieldClass = FlowField;
        }
        field(16; Description; Text[50]) { }
        field(17;"Stage No";Integer)
        {Editable=false;
        AutoIncrement=true;
        }
    }

    keys
    {
        key(Key1; "Tender No.", Stage)
        {
            Clustered = true;
        }
        key(Key2; "Tender No.", "Sorting No.") { }
    }

    fieldgroups { }

    var
        me: Record "Tender Plan Lines";

    procedure SetNextStart()
    begin
        me.SetFilter("Sorting No.", '%1', "Sorting No." + 1);
        if me.FindFirst then begin
            me."Actual start date" := "Actual end date";
            me.Modify;
        end;
    end;
}

