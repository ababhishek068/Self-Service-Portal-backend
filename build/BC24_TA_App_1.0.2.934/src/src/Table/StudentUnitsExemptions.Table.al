Table 50094 "Student Units Exemptions"
{
    DrillDownPageID = "Student Units - List";
    LookupPageID = "Student Units - List";

    fields
    {
        field(2; "Student No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = Customer."No.";
        }
        field(3; Semester; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field(Programme));
        }
        field(4; Programme; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(5; "Register for"; Option)
        {
            Editable = false;
            NotBlank = false;
            OptionCaption = 'Stage,Unit/Subject';
            OptionMembers = Stage,"Unit/Subject";
        }
        field(6; Stage; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(7; Unit; Code[20])
        {
            Editable = true;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme));
            trigger OnValidate()
            var
                CMaster: record "Courses Master";
            begin
                if Cmaster.get(unit) then begin
                    Description := cmaster.Description;
                    CF := cmaster.units;
                    "Unit Type" := CMaster."Unit Type";
                end;

            end;
        }
        field(8; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(9; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(10; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Filter"),
                                                         "Stage Code" = field("Stage Filter"));
        }
        field(11; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(12; "Unit Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
        }
        field(13; Taken; Boolean) { }
        field(14; "Student Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'FULL TIME,PART TIME';
            OptionMembers = "FULL TIME","PART TIME";
            TableRelation = "Course Registration"."Student Type";
        }
        field(15; "Application Date"; Date) { }
        field(16; Status; Option)
        {
            OptionCaption = 'Being Processed,Approved,Rejected,Canceled';
            OptionMembers = "Being Processed",Approved,Rejected,Canceled;

            trigger OnValidate()
            begin
                if UserSetup.Get(UserId) then begin
                    // if UserSetup."Can Exempt Units"=false then Error('Please note that you dont have the rights to exempt units');
                end else begin
                    Error('Please note that you dont have the rights to exempt units');
                end;
                "Approval Date" := Today;
                /*
                IF Status = Status::Approved THEN BEGIN
                CourseReg.RESET;
                CourseReg.SETRANGE(CourseReg."Student No.","Student No.");
                IF CourseReg.FIND('+') THEN BEGIN
                CourseReg.CALCFIELDS(CourseReg."Units Taken");
                
                FeeStruc.RESET;
                FeeStruc.SETRANGE(FeeStruc."Programme Code",Programme);
                FeeStruc.SETRANGE(FeeStruc."Stage Code",Stage);
                FeeStruc.SETRANGE(FeeStruc.Semester,Semester);
                FeeStruc.SETRANGE(FeeStruc."Student Type",CourseReg."Student Type");
                IF FeeStruc.FIND('-') THEN BEGIN
                FeeStruc.CALCFIELDS(FeeStruc."No Of Units");
                MESSAGE('%1',FeeStruc."Break Down");
                MESSAGE('%1',FeeStruc."No Of Units");
                ExFee:=(FeeStruc."Break Down"/FeeStruc."No Of Units")*1/3;
                //Reduce fee for current units
                StudUnits.RESET;
                StudUnits.SETRANGE(StudUnits.Unit,Unit);
                IF StudUnits.FIND('-') THEN BEGIN
                StudentCharges.RESET;
                StudentCharges.SETRANGE(StudentCharges."Reg. Transacton ID",CourseReg."Reg. Transacton ID");
                StudentCharges.SETRANGE(StudentCharges."Tuition Fee",TRUE);
                IF StudentCharges.FIND('-') THEN BEGIN
                StudentCharges.Amount:=StudentCharges.Amount-(FeeStruc."Break Down"/FeeStruc."No Of Units");
                StudentCharges.MODIFY;
                END;
                
                END;
                END;
                
                StudentCharges.INIT;
                StudentCharges.Programme:=CourseReg.Programme;
                StudentCharges.Stage:=CourseReg.Stage;
                StudentCharges.Semester:=CourseReg.Semester;
                StudentCharges."Student No.":="Student No.";
                StudentCharges."Reg. Transacton ID":=CourseReg."Reg. Transacton ID";
                StudentCharges.Date:=TODAY;
                StudentCharges.Code:='EXEMPT';
                StudentCharges.VALIDATE(StudentCharges.Code);
                StudentCharges.Description:=StudentCharges.Description + ' - ' + Unit;
                StudentCharges."Recovered First":=TRUE;
                StudentCharges."Recovery Priority":=19;
                StudentCharges.Charge:=TRUE;
                StudentCharges.Amount:=ExFee;
                StudentCharges."Transacton ID":='';
                StudentCharges.VALIDATE(StudentCharges."Transacton ID");
                StudentCharges.INSERT;
                
                END;
                
                END;
                */

            end;
        }
        field(17; "Approval Date"; Date) { }
        field(18; "Unit Name"; Text[100]) { }
        field(19; CF; Decimal) { }
        field(20; Description; Text[150])
        {
            CalcFormula = lookup("Units/Subjects".Desription where("Programme Code" = field(Programme),
                                                                    "Stage Code" = field(Stage),
                                                                    Code = field(Unit)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Programme, Stage, Unit, Semester, "Student No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        UserSetup: Record "User Setup";

}

