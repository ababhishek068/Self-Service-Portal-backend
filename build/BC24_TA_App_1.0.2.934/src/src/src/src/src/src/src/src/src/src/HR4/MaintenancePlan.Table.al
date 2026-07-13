Table 50279 "Maintenance Plan"
{
    DrillDownPageID = "Maintenance Plan List";
    LookupPageID = "Maintenance Plan List";

    fields
    {
        field(1; "Plan No."; Code[20])
        {

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "Plan No." <> xRec."Plan No." then begin
                    FASetup.Get;

                    NoSeriesMgt.TestManual(FASetup."Maintenance Plan Nos.");
                    "No. Series" := ' ';
                end;
            end;
        }
        field(5; Description; Text[100]) { }
        field(10; "Planned Date"; Date) { }
        field(15; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(20; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(25; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(30; Comments; Text[100]) { }
        field(35; "No. Series"; Code[10]) { }
        field(36; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(40; "Total Estimated Cost"; Decimal)
        {
            CalcFormula = sum("Maintenance Plan Lines"."Estimated Cost" where("Plan No." = field("Plan No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Plan No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Plan No." = '' then begin
            FASetup.Get;
            FASetup.TestField("Maintenance Plan Nos.");
            "Plan No.":=NoSeriesMgt.GetNextNo(FASetup."Maintenance Plan Nos.",  0D, true);
        end;

        "Created By" := UserId;
    end;

    var
        FASetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

