Table 50756 "Registry Files"
{
    DrillDownPageID = "Registry Files View";
    LookupPageID = "Registry Files View";

    fields
    {
        field(1; "File No."; Code[25]) { }
        field(2; "File Subject/Description"; Text[250]) { }
        field(3; "Date Created"; Date) { }
        field(4; "Created By"; Code[50]) { }
        field(5; "Maximum Allowable Files"; Integer) { }
        field(6; "File Type"; Option)
        {
            OptionCaption = ' ,General,Personnel,Outbound,Inbound';
            OptionMembers = " ",General,Personnel,Outbound,Inbound;
        }
        field(7; "Date of Issue"; Date) { }
        field(8; "Issuing Officer"; Text[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                User_Id.Init;
                User_Id.SetRange(User_Id."Employee No.", "Issuing Officer");
                if not (User_Id.Find('-')) then Error('The Issuing officer ' + (Format("Issuing Officer")) + ' is not a valid ERP user.');
                if (rec_Emp.Get("Issuing Officer")) then begin

                end;
                "Issuing Office Name" := rec_Emp."First Name" + ' ' + rec_Emp."Middle Name" + ' ' + rec_Emp."Last Name";
                "Issuing Officer ID" := User_Id."User ID";
                Rename("File No.");
            end;
        }
        field(9; "Circulation Reason"; Option)
        {
            OptionCaption = ' ,Normal Circulation,Bring Up';
            OptionMembers = " ","Normal Circulation","Bring Up";
        }
        field(10; "Expected Return Date"; Date) { }
        field(11; "Receiving Officer"; Text[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                User_Id.Init;
                User_Id.SetRange(User_Id."Employee No.", "Receiving Officer");
                if not (User_Id.Find('-')) then Error('The Receiving Officer ' + (Format("Receiving Officer")) + ' is not a valid ERP user.');
                if (rec_Emp.Get("Receiving Officer")) then begin

                end;
                "Recieving Officer Name" := rec_Emp."First Name" + ' ' + rec_Emp."Middle Name" + ' ' + rec_Emp."Last Name";
                "Receiving Officer ID" := User_Id."User ID";
                Rename("File No.");
            end;
        }
        field(12; "Delivery Officer"; Text[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                User_Id.Init;
                User_Id.SetRange(User_Id."Employee No.", "Delivery Officer");
                if not (User_Id.Find('-')) then Error('The Delivery officer ' + (Format("Delivery Officer")) + ' is not a valid ERP user.');
                if (rec_Emp.Get("Delivery Officer")) then begin

                    "Delivery Officer Name" := rec_Emp."First Name" + ' ' + rec_Emp."Middle Name" + ' ' + rec_Emp."Last Name";
                    "Delivery Officer ID" := User_Id."User ID";
                end;
                Rename("File No.");
            end;
        }
        field(13; "File Status"; Option)
        {
            OptionCaption = ' ,New,Active,Partially Active,Bring_up,Archived,Disposed';
            OptionMembers = " ",New,Active,"Partially Active",Bring_up,Archived,Disposed;
        }
        field(14; "Dispatch Status"; Option)
        {
            OptionCaption = ',Dispatched,In Registry';
            OptionMembers = ,Dispatched,"In Registry";
        }
        field(34; "Disposal Type"; option)
        {
            OptionMembers = "",Shredding,Burning,Chemical;
        }
        field(15; "Care of"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(16; "Issuing Office Name"; Text[250]) { }
        field(17; "Recieving Officer Name"; Text[250]) { }
        field(18; "Delivery Officer Name"; Text[250]) { }
        field(19; "Receiving Officer ID"; Code[50])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.Get("Recieving Officer No") then
                    "Recieving Officer Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(20; "Issuing Officer ID"; Code[50])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.Get("Recieving Officer No") then
                    "Issuing Office Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(21; "Delivery Officer ID"; Code[50]) { }
        field(22; "Care of Name"; Code[100]) { }
        field(23; "Care of ID"; Code[50]) { }
        field(24; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25; "Date Closed"; Date) { }
        field(26; "Folio No"; Code[20]) { }
        field(27; "Receiving Office"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(28; "Requisition No"; Code[20])
        {
            TableRelation = "File Requisition".No;

            trigger OnValidate()
            begin
                if FileReq.Get("Requisition No") then begin
                    "Receiving Officer" := FileReq."Requesting Officer";
                    "Receiving Office" := FileReq."Department Code";
                end;
            end;
        }
        field(29; "No. Series"; Code[20]) { }
        field(30; "File Opening Request"; Boolean) { }
        field(31; "File Return Time"; time) { }
        field(32; "Recieving Officer No"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.Get("Recieving Officer No") then
                    "Recieving Officer Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
    }

    keys
    {
        key(Key1; "File No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    var
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        HRSetup.get;
        if "File No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."File Nos");
            "File No.":=NoSeriesMgt.GetNextNo(HRSetup."File Nos", 0D, true);
        end;
        "Date Created" := Today;
        "Created By" := UserId;
        "Maximum Allowable Files" := 1;
        // IF User_Id.GET(USERID) THEN
        //  IF User_Id."Employee No."<>'' THEN BEGIN
        //  "Issuing Officer":=User_Id."Employee No.";
        // VALIDATE("Issuing Officer");
        //  END;
        "Date of Issue" := Today;
        "File Type" := "file type"::General;
        "File Status" := "file status"::New;
        "Circulation Reason" := "circulation reason"::"Normal Circulation"
    end;

    var
        rec_Emp: Record "HR-Employee";
        User_Id: Record "User Setup";
        FileReq: Record "File Requisition";
}

