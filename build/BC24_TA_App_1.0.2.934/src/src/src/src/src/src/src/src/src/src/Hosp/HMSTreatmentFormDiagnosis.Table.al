Table 50587 "HMS Treatment Form Diagnosis"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Diagnosis No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Diagnosis".Code;

            trigger OnValidate()
            begin
                if Diagnosis.Get("Diagnosis No.") then begin
                    "Diagnosis Code" := Diagnosis.Diagnosis;
                    Description := Diagnosis.Description;
                end;

                objPat.Reset;
                objPat.SetRange(objPat."Patient No.", "Patient No");
                if objPat.Find('-') then begin
                    //"Age in Years"  := ((TODAY-objPat."Date Of Birth")/365);
                    Gender := objPat.Gender;
                end;
            end;
        }
        field(3; "Diagnosis Name"; Text[250])
        {
            CalcFormula = lookup("HMS Setup Diagnosis".Description where(Code = field("Diagnosis No.")));
            FieldClass = FlowField;
        }
        field(4; Confirmed; Boolean) { }
        field(5; Remarks; Text[100]) { }
        field(6; "Treatment Date"; Date)
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Treatment Date" where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(7; PatientNoF; Code[20])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Patient No." where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(8; "Patient No"; Code[20])
        {

            trigger OnValidate()
            begin
                /*objPat.RESET;
                objPat.SETRANGE(objPat."Patient No.","Patient No");
                IF objPat.FIND('-') THEN BEGIN
                  IF objPat."Date Of Birth"<>0D THEN
                "Age in Years"  := ((TODAY-objPat."Date Of Birth")/365);
                Gender:=objPat.Gender  ;
                END;*/

            end;
        }
        field(9; Gender; Option)
        {
            OptionMembers = " ",Male,Female;
        }
        field(10; Age; Integer)
        {
            CalcFormula = lookup("HMS Patient"."Age in Years" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(11; "Patient Name"; Text[100])
        {
            CalcFormula = lookup("HMS Patient"."Search Name" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(12; "Diagnosis Date"; Date)
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Treatment Date" where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(13; Treatment; Text[30])
        {
            TableRelation = "HMS Pharmacy Line"."Drug Name" where("Drug Name" = const(''));
        }
        field(14; "Patient Appointments"; Integer) { }
        field(15; Doctor; Code[20])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Doctor ID" where("Treatment No." = field("Treatment No.")));
            FieldClass = FlowField;
        }
        field(16; "Diagnosis Count"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field("Diagnosis No."),
                                                                      "Treatment Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(17; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(18; "Diagnosis Code"; Code[50]) { }
        field(19; Description; Text[200]) { }
        field(20; "Age in Years"; Decimal) { }
        field(21; "Diagnosis Type"; Option)
        {
            OptionCaption = ',Pre-Diagnosis,Post-Diagnosis';
            OptionMembers = ,"Pre-Diagnosis","Post-Diagnosis";
        }
        field(22; Ddate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Date OF Birth"; Date)
        {
            CalcFormula = lookup("HMS Patient"."Date Of Birth" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(24; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.", "Diagnosis No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Diagnosis: Record "HMS Setup Diagnosis";
        objPat: Record "HMS Patient";
}

