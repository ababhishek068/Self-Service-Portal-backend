Table 50222 "HR Medical Dependants"
{

    fields
    {
        field(1; "Scheme No"; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin

                /*  Medscheme.RESET;
                  Medscheme.SETRANGE(Medscheme."Scheme No","Scheme No");
                   IF Medscheme.FIND('-') THEN BEGIN
                  "Out-Patient Limit":=Medscheme."Out-patient limit";
                  "In-patient Limit":=Medscheme."In-patient limit";
                  "Balance In- Patient":="In-patient Limit"-"Cumm.Amount Spent";
                  "Balance Out- Patient":="Out-Patient Limit"-"Cumm.Amount Spent Out";
                   END; */

            end;
        }
        field(2; "Employee No"; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                /*   Emp.RESET;
                   Emp.SETRANGE(Emp."No.","Employee No");
                   IF Emp.FIND('-') THEN BEGIN
                   "First Name":=Emp."First Name"+' '+Emp."Middle Name";
                   "Last Name":=Emp."Last Name";
                   Designation:=Emp."Job Title";
                   Department:=Emp."Department Code";
                   "Scheme Join Date":=Emp."Medical Scheme Join Date";

                   //"In-patient Limit":=Medscheme."In-patient limit";
                    END;        */

            end;
        }
        field(3; "First Name"; Text[30]) { }
        field(4; "Last Name"; Text[30]) { }
        field(5; Designation; Text[50]) { }
        field(6; Department; Text[100]) { }
        field(7; "Scheme Join Date"; Date) { }
        field(8; "Scheme Anniversary"; Date) { }
        field(9; "Date of Birth"; Date) { }
        field(10; "Below 25 Yrs"; Boolean) { }
        field(50000; "Second Name"; Text[30]) { }
        field(50004; Twins; Boolean) { }
        field(50005; "Policy No"; Code[30]) { }
        field(50006; Names; Text[100]) { }
        field(50007; Relation; Option)
        {
            OptionMembers = "","Spouse","Child",Other;
        }
        field(50008; Contact; Text[50]) { }
        field(50009; Gender; Option)
        {
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(50010; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(50011; "Dependant Name"; Text[30]) { }
        field(50012; "Dependant Member No."; Code[50]) { }
    }

    keys
    {
        key(Key1; "Scheme No", "Line No", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

