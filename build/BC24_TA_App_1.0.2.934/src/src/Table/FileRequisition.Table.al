Table 50759 "File Requisition"
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Requesting Officer"; Code[20])
        {
            TableRelation = "HR-Employee";

            trigger OnValidate()
            begin
                if HREMP.Get("Requesting Officer") then begin
                    Name := HREMP."First Name" + ' ' + HREMP."Middle Name" + ' ' + HREMP."Last Name";
                    Designation := HREMP."Job Title";
                end;
            end;
        }
        field(4; Name; Text[100]) { }
        field(5; Designation; Code[20]) { }
        field(6; "Collecting Officer"; Text[50]) { }
        field(7; Purpose; Code[50])
        {
            TableRelation = "File Request Reasons".Code;
        }
        field(8; "File No"; Code[20])
        {
            TableRelation = "Registry Files"."File No." where("File Status" = const(Active));

            trigger OnValidate()
            begin
                if FileReq.Get("File No") then begin
                    "File Name" := FileReq."File Subject/Description";
                end;
            end;
        }
        field(9; "File Name"; Text[100]) { }
        field(10; "Authorized By"; Code[20]) { }
        field(11; "Served By"; Code[50]) { }
        field(12; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HREMP: Record "HR-Employee";
        FileReq: Record "Registry Files";
}

