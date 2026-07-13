table 50707 "HR Employee Exit Interviews 2"
{
    // version HRMIS 2015 VRS1.0


    fields
    {
        field(1; "Exit Interview No"; Code[10]) { }
        field(2; "Date Of Interview"; Date) { }
        field(3; "Interview Done By"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate();
            var
                HREmp: Record "HR-Employee";
            begin
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", "Interview Done By");
                IF HREmp.FIND('-') THEN BEGIN
                    "Interviewer Name" := HREmp."Full Name";
                END;
            end;
        }
        field(4; "Re Employ In Future"; Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(5; "Reason For Leaving"; Option)
        {
            OptionMembers = " ",Resignation,Dismissal,Retirement,Termination,"Contract Ended","Appointment Revoked",Retrenchment,Personal,Transfer,Secondment;
        }
        field(6; "Reason For Leaving (Other)"; Text[150]) { }
        field(7; "Date Of Leaving"; Date) { }
        field(10; Comment; Text[250])
        {
            Editable = true;
        }
        field(11; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate();
            var
                HREmp: Record "HR-Employee";
            begin
                HREmp.RESET;
                HREmp.SETRANGE(HREmp."No.", "Employee No.");
                IF HREmp.FIND('-') THEN BEGIN
                    "Employee Name" := HREmp."Full Name";
                    Designation := HREmp."Job Title";
                    Division := HREmp."Global Dimension 1 Code";
                    Department := HREmp."Global Dimension 2 Code";
                    "Date of Join" := HREmp."Date of First Appointment";
                    "Terms of service" := FORMAT(HREmp."Contract Type");
                    "Department Code" := HREmp."Global Dimension 1 Code";
                END;
            end;
        }
        field(12; "No Series"; Code[10]) { }
        field(13; "Form Submitted"; Boolean) { }
        field(14; "Global Dimension 2"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; "Employee Name"; Text[50]) { }
        field(16; "Interviewer Name"; Text[50]) { }
        field(17; Closed; Boolean) { }
        field(18; "Reasons for Resignation"; Text[250]) { }
        field(19; Dislikes; Text[250]) { }
        field(20; Likes; Text[250]) { }
        field(21; Improvements; Text[250]) { }
        field(22; Opportunities; Text[250]) { }
        field(23; Designation; Text[50]) { }
        field(24; Division; Text[50]) { }
        field(25; Department; Text[50]) { }
        field(26; "Terms of service"; Text[50]) { }
        field(27; "Date of Join"; Date) { }
        field(28; "Exit status"; Option)
        {
            OptionCaption = 'New,,Submitted,Effected';
            OptionMembers = New,,Submitted,Effected;
        }
        field(29; "Department Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Length of Service"; Text[100]) { }
        field(31; UserID; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(32; MyRecId; RecordID) { }
    }

    keys
    {
        key(Key1; "Exit Interview No") { }
    }

    fieldgroups { }

    trigger OnInsert();
    var
        TheTable: record "HR Employee Exit Interviews 2";
    begin

        //GENERATE NEW NUMBER FOR THE DOCUMENT
        IF "Exit Interview No" = '' THEN BEGIN
            TheTable.RESET;
            IF TheTable.FINDLAST THEN BEGIN
                "Exit Interview No" := INCSTR(TheTable."Exit Interview No")
            END ELSE BEGIN
                "Exit Interview No" := 'EXIT-00001';
            END;
        END;

    END;
}

