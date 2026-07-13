Table 50193 "HR Medical Scheme Members"
{
    // DrillDownPageID = "Posted Imprest Surrender UP";
    LookupPageID = "HR Medical Scheme Members List";

    fields
    {
        field(1; "Scheme No"; Code[50])
        {

            trigger OnValidate()
            begin

                Medscheme.Reset;
                Medscheme.SetRange(Medscheme."Scheme No", "Scheme No");
                if Medscheme.Find('-') then begin
                    "Out-Patient Limit" := Medscheme."Out-patient limit";
                    "In-patient Limit" := Medscheme."In-patient limit";
                    "Balance In- Patient" := "In-patient Limit" - "Cumm.Amount Spent";
                    "Balance Out- Patient" := "Out-Patient Limit" - "Cumm.Amount Spent Out";
                end;
            end;
        }
        field(2; "Employee No"; Code[50])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            var
                HRMedDependads: Record "HR Medical Dependants";
                EmpDep: Record "HR Employee Kin";
                Ln: Integer;
            begin
                Clear(Emp);
                Emp.SetRange(Emp."No.", "Employee No");
                if Emp.Find('-') then begin
                    "First Name" := Emp."First Name";
                    "Middle Name" := Emp."Middle Name";
                    "Last Name" := Emp."Last Name";
                    Designation := Emp."Job Title";
                    Department := Emp."Department Code";
                    "Scheme Join Date" := Emp."Medical Scheme Join";
                end;
                HRMedDependads.reset;
                HRMedDependads.setrange("Employee No", "Employee No");
                if HRMedDependads.Find('-') then HRMedDependads.DeleteAll();

                EmpDep.Reset();
                EmpDep.SetRange("Employee Code", "Employee No");
                if EmpDep.Find('-') then begin
                    repeat
                        Ln := Ln + 1;
                        HRMedDependads.Init();
                        HRMedDependads."Line No" := Ln;
                        HRMedDependads."Employee No" := "Employee No";
                        HRMedDependads."Scheme No" := "Scheme No";
                        HRMedDependads."Dependant Member No." := EmpDep."Member ID";
                        HRMedDependads.Names := EmpDep.SurName + ' ' + EmpDep."Other Names";
                        HRMedDependads.Relation := EmpDep.Relationship;
                        HRMedDependads.Insert();
                    until EmpDep.Next() = 0;
                end;
            end;
        }
        field(3; "First Name"; Text[100]) { }
        field(4; "Last Name"; Text[30]) { }
        field(5; Designation; Text[100]) { }
        field(6; Department; Text[100]) { }
        field(7; "Scheme Join Date"; Date) { }
        field(8; "Scheme Anniversary"; Date) { }
        field(9; "Cumm.Amount Spent"; Decimal)
        {
            CalcFormula = sum("HR Medical Claims"."Amount Charged" where("Member No" = field("Employee No"),
                                                                          "Claim Type" = const(Inpatient)));
            FieldClass = FlowField;
        }
        field(10; "Out-Patient Limit"; Decimal) { }
        field(11; "In-patient Limit"; Decimal) { }
        field(12; "Maximum Cover"; Decimal) { }
        field(13; "Cumm.Amount Spent Out"; Decimal)
        {
            CalcFormula = sum("HR Medical Claims"."Amount Charged" where("Member No" = field("Employee No"),
                                                                          "Claim Type" = const(Outpatient)));
            FieldClass = FlowField;
        }
        field(14; "Balance Out- Patient"; Decimal) { }
        field(15; "Balance In- Patient"; Decimal) { }
        field(16; "Middle Name"; Text[30]) { }
        field(17; No; Code[50]) { }
        field(18; Type; Code[50]) { }
        field(19; Gender; Option)
        {
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(20; "Join Date"; DateFormula) { }
        field(21; "Family Level"; Code[100]) { }
        field(22; "Member No"; Code[30]) { }
    }

    keys
    {
        key(Key1; "Scheme No", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Medscheme: Record "HR Medical Schemes";
        Emp: Record "HR-Employee";
}

