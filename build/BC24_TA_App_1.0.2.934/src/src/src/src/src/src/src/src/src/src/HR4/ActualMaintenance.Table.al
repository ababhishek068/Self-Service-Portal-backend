Table 50281 "Actual Maintenance "
{
    DrillDownPageID = "Actual Maintenance List";
    LookupPageID = "Actual Maintenance List";

    fields
    {
        field(1; "Maintenance No."; Code[20])
        {

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "Maintenance No." <> xRec."Maintenance No." then begin
                    FASetup.Get;
                    NoSeriesMgt.TestManual(FASetup."Maintenance Nos.");
                    "No. Series" := ' ';
                end;
            end;
        }
        field(5; Description; Text[100]) { }
        field(10; "Created By"; Code[30]) { }
        field(15; "Planned Date"; Date) { }
        field(20; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(25; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(30; "Plan No."; Code[20])
        {
            TableRelation = "Maintenance Plan"."Plan No.";

            trigger OnValidate()
            begin
                MaintPlanLines.Reset;
                MaintPlanLines.SetRange(MaintPlanLines."Plan No.", "Plan No.");
                if MaintPlanLines.FindSet then begin

                    //Remove Existing Maintenance Lines
                    MaintLines.Reset;
                    MaintLines.SetRange(MaintLines."Maintenance No.", "Maintenance No.");
                    if MaintLines.FindSet then MaintLines.DeleteAll;

                    repeat
                        MaintLines.Reset;
                        MaintLines.Init;
                        MaintLines."Maintenance No." := "Maintenance No.";
                        MaintLines."Line No." := 0;
                        MaintLines."Fixed Asset No." := MaintPlanLines."Fixed Asset No.";
                        MaintLines.Validate(MaintLines."Fixed Asset No.");
                        MaintLines."Dimension 1 Code" := MaintPlanLines."Dimension 1 Code";
                        MaintLines."Dimension 2 Code" := MaintPlanLines."Dimension 2 Code";
                        MaintLines.Insert(true);
                    until MaintPlanLines.Next = 0;

                end
                else
                    Error(Txt0001, "Plan No.");
            end;
        }
        field(35; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(40; Comments; Text[100]) { }
        field(45; "No. Series"; Code[10]) { }
        field(50; "Total Cost"; Decimal)
        {
            CalcFormula = sum("Actual Maintenance Lines".Cost where("Maintenance No." = field("Maintenance No.")));
            FieldClass = FlowField;
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
    }

    keys
    {
        key(Key1; "Maintenance No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Maintenance No." = '' then begin
            FASetup.Get;
            FASetup.TestField("Maintenance Nos.");
            "Maintenance No.":=NoSeriesMgt.GetNextNo(FASetup."Maintenance Nos.",  0D, true);
        end;

        "Created By" := UserId;
    end;

    var
        FASetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        MaintPlanLines: Record "Maintenance Plan Lines";
        MaintLines: Record "Actual Maintenance Lines";
        Txt0001: label 'There are no Maintenance Plan Lines for Plan No. %1';
}

