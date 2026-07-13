Table 50077 Semesters
{
    DrillDownPageID = "Semesters List";
    LookupPageID = "Semesters List";

    fields
    {
        field(1; "Code"; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; From; Date) { }
        field(4; "To"; Date) { }
        field(5; Remarks; Text[150]) { }
        field(6; "Current Semester"; Boolean)
        {
            Editable = true;
        }
        field(7; "Academic Year"; Text[9])
        {
            TableRelation = "Academic Year".Code;
        }
        field(38; "Short Course Semester"; Boolean) { }
        field(8; "SMS Results Semester"; Boolean) { }
        field(9; "Lock Exam Editting"; Boolean) { }
        field(10; "Lock CAT Editting"; Boolean) { }
        field(11; "Registration Deadline"; Date) { }
        field(112; "Lecturers Allocations Deadline"; Date) { }
        field(12; "Registration Closed"; Boolean) { }
        field(13; "BackLog Marks"; Boolean) { }
        field(14; "Allow Online Results"; Boolean) { }
        field(24; "Allow Exam Card Generation"; Boolean) { }
        field(15; "Active Semester"; Boolean) { }
        field(16; "SB Registration Deadline"; Date) { }
        field(17; "Exam Card Semester"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Exam Semester"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Academic Year") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /* CReg.RESET;
         CReg.SETRANGE(CReg.Semester,Code);
         IF CReg.FIND('-') THEN ERROR('Please note that you can not edit used Semester');*/

    end;

    trigger OnRename()
    begin
        /*IF xRec.Code<>Code THEN BEGIN
        CReg.RESET;
        CReg.SETRANGE(CReg.Semester,xRec.Code);
        IF CReg.FIND('-') THEN ERROR('Please note that you can not edit used Semester');
        END; */

    end;
}

