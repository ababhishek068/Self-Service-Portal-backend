table 50269 "ICT General Requisition Header"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Date; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Global Dimension 1 Code"; code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = filter(1));
            DataClassification = ToBeClassified;

        }
        field(4; "Global Dimension 2 Code"; code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = filter(2));
            DataClassification = ToBeClassified;

        }
        field(5; "Requisition Category"; code[20])
        {
            TableRelation = "ICT Requisition Type".code;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                ReqC: Record "ICT Requisition Type";
            begin
                ReqC.Reset();
                ReqC.SetRange(Code, "Requisition Category");
                if ReqC.Find('-') then begin
                    Assignee := ReqC."Assigned Staff";
                    Validate(Assignee);
                end;
            end;
        }
        field(6; "General Description"; text[250])
        {

            DataClassification = ToBeClassified;

        }
        field(7; "Urgency Priority"; Option)
        {
            OptionMembers = ,Low,"Moderate",High,"Very High";

            DataClassification = ToBeClassified;

        }
        field(8; "Requested By"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Requested By") then "Requestor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(9; "Required Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Resolution Status"; option)
        {
            OptionMembers = Open,Submitted,InProgress,"Resolved Waiting User Confirmation",Closed,Cancelled;
            DataClassification = ToBeClassified;

        }
        field(11; "Resolution Remarks"; text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Assignee"; code[20])
        {
            TableRelation = "HR-Employee"."No." where("ICT Officer" = filter(true), Status = filter(Active));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET(Assignee) then "Assignee Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;

        }
        field(13; "No. Series"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Technical Information"; code[50])
        {
            TableRelation = "ICT Technical Information".code;
            DataClassification = ToBeClassified;
        }
        field(15; "Assignee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "ICT. Dep. Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;
            DataClassification = ToBeClassified;
        }
        field(17; "Requestor Name"; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(19; "Date Resolved"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Cancelled Remarks"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "User Closing Remarks"; text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(22; "Date User Confirmed"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(23; "Date Escalated"; Date)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HREmp: Record "HR-Employee";
    begin
        if "No" = '' then begin
            GenLedgerSetup.Get;

            GenLedgerSetup.TestField(GenLedgerSetup."ICT Requisition Nos");
             "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."ICT Requisition Nos",  0D,true);
        end;
        HRSetup.Get();
        HRSetup.TestField("ICT Dep. Code");
        "ICT. Dep. Code" := HRSetup."ICT Dep. Code";

        if "Requested By" = '' then begin
            HREmp.Reset();
            HREmp.SetRange("User ID", UserId);
            if HREmp.Find('-') then begin
                "Requested By" := HREmp."No.";
                Validate("Requested By");
            end;
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        HRSetup: Record "HR Setup";
}