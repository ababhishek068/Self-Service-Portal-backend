Table 50119 "Students Transfer"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Customer Type" = const(Student));

            trigger OnValidate()
            begin
                if Cust.Get("Student No") then
                    Name := Cust.Name;
            end;
        }
        field(3; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Current Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(5; "New Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "New Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;

            trigger OnValidate()
            begin
                /*
                                //TESTFIELD("Campus Code");
                                // TESTFIELD("Settlement Type");

                                AdminSetup.Reset;
                                AdminSetup.SetRange(AdminSetup.Degree, "New Programme");
                                //AdminSetup.SETRANGE(AdminSetup."Settlement Type","Settlement Type");
                                //AdminSetup.SETRANGE(AdminSetup.Campus,"Campus Code");                
                                if AdminSetup.Find('-') then begin
                                    GeneralSetup.Get;
                                    spr := GeneralSetup."Registration Number Seperator";

                                    AdminSetup.Reset;
                                    AdminSetup.SetRange(AdminSetup.Degree, "Current Programme");
                                    if AdminSetup.Find('-') then begin
                                        if AdminSetup."JAB Prefix" = '' then
                                            MinusstrLength := StrLen(AdminSetup."Programme Prefix") + 2
                                        else
                                            MinusstrLength := StrLen(AdminSetup."Programme Prefix") + 1 + StrLen(AdminSetup."JAB Prefix") + 2;
                                    end
                                    else begin
                                        Error('Admission Number Setup For Programme ' + Format("Current Programme") + ' is missing');
                                    end;

                                    AdminSetup.Reset;
                                    AdminSetup.SetRange(AdminSetup.Degree, "New Programme");
                                    if AdminSetup.Find('-') then begin
                                        if AdminSetup."No. Series" = '' then Error('Admission Number Setup For Programme ' + Format("New Programme") + ' is incomplete');
                                        if AdminSetup."JAB Prefix" = '' then
                                            NewAdminCode := AdminSetup."Programme Prefix" + spr + CopyStr("Student No", MinusstrLength, StrLen("Student No") - (MinusstrLength - 1))
                                        else
                                            NewAdminCode := AdminSetup."Programme Prefix" + spr + AdminSetup."JAB Prefix" + spr + CopyStr("Student No", MinusstrLength, StrLen("Student No") - (MinusstrLength - 1));
                                    end
                                    else begin
                                        Error('Admission Number Setup For Programme ' + Format("New Programme") + ' is missing');
                                    end;

                                    //NewAdminCode := AdminSetup."Programme Prefix" + spr + CopyStr("Student No", MinusstrLength, StrLen("Student No") - (MinusstrLength + 1));

                                end;

                                "New Student No" := NewAdminCode;
               
                if Prog.get("New Programme") then begin
                    "New Department Code" := prog."Department Code";
                end;
                AdminSetup.Reset;
                AdminSetup.SetRange(AdminSetup.Degree, "New Programme");
                if AdminSetup.Find('-') then
                    NewPrefix := AdminSetup."Programme Prefix"
                else
                    Error('Admission Number Setup For Programme ' + Format("New Programme") + ' is missing');

                AdminSetup.Reset;
                AdminSetup.SetRange(AdminSetup.Degree, "Current Programme");
                if AdminSetup.Find('-') then
                    OldPrefix := AdminSetup."Programme Prefix"
                else
                    Error('Admission Number Setup For Programme ' + Format("Current Programme") + ' is missing');

                NewAdminCode := NewPrefix + CopyStr("Student No", StrLen(OldPrefix) + 1, 20);
                 */
                "New Student No" := "Student No";

            end;
        }
        field(7; Date; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Creg: Record "Course Registration";
            begin
                creg.reset;
                creg.setrange("Student No.", "Student No");
                if Creg.find('-') then begin
                    creg.calcfields("Campus Code");
                    "Current Programme" := Creg.Programme;
                    Semester := Creg.Semester;
                    "Settlement Type" := Creg."Settlement Type";
                    "Academic Year" := creg."Academic Year";
                    "Campus Code" := creg."Campus Code";

                end
            end;
        }
        field(8; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Semester; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(11; "Settlement Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Settlement Type".Code;
        }
        field(37; "Academic Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the academic year in the database';
            TableRelation = "Academic Year".Code;
        }
        field(38; "Campus Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(39; "New School Code"; Code[20])
        {
            CalcFormula = lookup(Programme."School Code" where(Code = field("New Programme")));
            FieldClass = FlowField;
        }
        field(40; "New Department Code"; Code[20])
        {
            CalcFormula = lookup(Programme."Department Code" where(Code = field("New Programme")));
            FieldClass = FlowField;
        }
        field(41; "Old Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Student No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Posted = true then Error('Please note that you can not modify posted entry!');
    end;

    trigger OnModify()
    begin
        if Posted = true then Error('Please note that you can not modify posted entry!');
    end;

    var
        Cust: Record Customer;
}

