table 51450 "HR Attendance Ledger"
{
    Caption = 'HR Attendance Table';
    DrillDownPageId="HR Attendance List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'No.';
        }
        field(2; "Staff No."; Code[30])
        {
            Caption = 'Staff No.';
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            var
                HREmployee: Record "HR-Employee";
            begin
                HREmployee.SetLoadFields("No.", "Full Name", Sector, "Business Unit",Division);
                HREmployee.SetRange("No.", "Staff No.");
                if HREmployee.FindFirst() then begin
                    "Staff Name" := HREmployee."Full Name";
                    "Global Dimension 1 Code" := HREmployee.Sector;
                    "Global Dimension 2 Code" := HREmployee."Business Unit";
                    
                end;
            end;
        }
        field(3; "Staff Name"; Text[150])
        {
            Caption = 'Staff Name';
            Editable = false;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(5; Email; Text[100])
        {
            Caption = 'Email';
        }
        field(6; "Global Dimension 1 Code"; Code[30])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Global Dimension 2 Code"; Code[30])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        // field(8; Market; Code[100])
        // {
        //     Caption = 'Market';
        //     TableRelation = "Project Markets".Name;
        // }
        field(9; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(10; "Time In"; Time)
        {
            Caption = 'Time In';
        }
        field(11; "Time out"; Time)
        {
            Caption = 'Time out';
            trigger OnValidate()
            begin
                if "Time out" <> 0T then
                    "Hours Worked" := (("Time out" - "Time In") / 3600000);
            end;
        }
        field(12; "Hours Worked"; Decimal)
        {
            Caption = 'Hours Worked';
        }
        field(13; "Location Coordinates"; Text[150])
        {
            Caption = 'Location Coordinates';
        }
        field(14; "Location Name"; Text[150])
        {
            Caption = 'Location Name';
        }
        field(15; "Checked In By"; Code[30])
        {
            Caption = 'Checked In By';
        }
        field(16; "Checked Out By"; Code[30])
        {
            Caption = 'Checked Out By';
        }
        field(17; "Checked Out"; Boolean)
        {
            Caption = 'is Checked Out?';
        }
        field(18; "Sign in Comments"; Text[250])
        {
        }
        field(19; "Sign out Comments"; Text[250])
        {
        }
        field(20; "login date time"; DateTime)
        {
        }
        field(21; "Signin Location"; Text[300])
        {
        }
        field(22; "Signout Location"; Text[300])
        {
        }
        field(23; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Absence,Present,On Leave';
            OptionMembers = ,Absence,Present,"On Leave";
        }
        field(24; "Signin Location Coordinates"; Text[150])
        {
            Caption = 'Location Coordinates';
        }
        field(25; "Signout Location Coordinates"; Text[150])
        {
            Caption = 'Location Coordinates';
        }
        field(26; "Swap No"; Code[30])
        {
        }
        field(27; isHQItem; Boolean)
        {
            // FieldClass = FlowField;
            //CalcFormula = lookup("Dimension Value".isHQItem where(Code = field("Global Dimension 1 Code")));
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        NoseriesMgmt: Codeunit NoSeriesManagement;
        HRSetup: Record "HR Setup";

    trigger OnInsert()
    var
        HRAttendanceLedger: Record "HR Attendance Ledger";
    begin
        if "No." = '' then begin
            HRSetup.Get();
            "No." := NoseriesMgmt.GetNextNo(HRSetup."Attendance Nos", 0D, true);
            // HRAttendanceLedger.RESET();
            // if HRAttendanceLedger.FINDLAST() then
            //     "No." := INCSTR(HRAttendanceLedger."No.")
            // else
            //     "No." := 'ATT00001';
        end;
    end;

    procedure GetNextNo(): Code[50]
    var
        HRAttendanceLedger: Record "HR Attendance Ledger";
        NewNo: Code[50];
    begin

        HRSetup.Get();
        NewNo := NoseriesMgmt.GetNextNo(HRSetup."Attendance Nos", 0D, true);
        exit(NewNo);
        
        /*  HRAttendanceLedger.RESET();
         if HRAttendanceLedger.FINDLAST() then
             exit(INCSTR(HRAttendanceLedger."No."))
         else
             exit('ATT_00001'); */
    end;
}
