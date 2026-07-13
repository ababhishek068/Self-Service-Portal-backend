Table 50116 "Individual Work Plan"
{

    fields
    {
        field(1; Code; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Staff No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HRemp: Record "HR-Employee";
            begin
                if HRemp.Get("Staff No") then begin
                    "Global Dimension 1" := HRemp."Global Dimension 1 Code";
                    Validate("Global Dimension 1");
                    "Global Dimension 2" := HRemp."Global Dimension 2 Code";
                    Validate("Global Dimension 2");
                    "Employee Name" := HRemp."First Name" + ' ' + HRemp."Middle Name" + ' ' + HRemp."Last Name";
                end;
            end;
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Appraisal Periods - UP".Code;
        }
        field(4; "Global Dimension 1"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear(Dim1);

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Global Dimension 1");
                if DimensionValue.FindFirst() then Dim1 := DimensionValue.Name;
            end;
        }
        field(5; "Global Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear(Dim2);

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Global Dimension 2");
                if DimensionValue.FindFirst() then Dim2 := DimensionValue.Name;
            end;
        }
        field(6; Dim1; Text[50]) { }
        field(7; Dim2; Text[50]) { }
        field(8; "No. Series"; Code[20]) { }
        field(9; "Employee Name"; Text[150]) { }
        field(10; "Open To"; Option)
        {
            OptionMembers = Apprisee,Supervisor,HR;
        }
        field(11; Status; Option)
        {
            OptionMembers = Open,"Pending Approval","Approved",Cancelled;
        }
        field(12; "Appraisee Comments"; Text[500]) { }
        field(13; "Supervisor Comments"; Text[500]) { }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        GenLedgerSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Code = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Individual WorkPlan Nos.");
            Code:=NoSeriesMgt.GetNextNo(GenLedgerSetup."Individual WorkPlan Nos.",  0D, true);
        end;
    end;
}

