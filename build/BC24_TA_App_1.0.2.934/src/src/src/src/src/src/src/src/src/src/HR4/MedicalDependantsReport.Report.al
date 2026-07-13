Report 50269 "Medical Dependants Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MedicalDependantsReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Medical Dependants"; "HR Medical Dependants")
        {
            column(ReportForNavId_1; 1) { }
            column(SchemeNo_HRMedicalDependants; "HR Medical Dependants"."Scheme No") { }
            column(EmployeeNo_HRMedicalDependants; "HR Medical Dependants"."Employee No") { }
            column(FirstName_HRMedicalDependants; "HR Medical Dependants"."Dependant Name") { }
            column(LastName_HRMedicalDependants; "HR Medical Dependants"."Last Name") { }
            column(Designation_HRMedicalDependants; "HR Medical Dependants".Designation) { }
            column(Department_HRMedicalDependants; "HR Medical Dependants".Department) { }
            column(SchemeJoinDate_HRMedicalDependants; "HR Medical Dependants"."Scheme Join Date") { }
            column(SchemeAnniversary_HRMedicalDependants; "HR Medical Dependants"."Scheme Anniversary") { }
            column(DateofBirth_HRMedicalDependants; "HR Medical Dependants"."Date of Birth") { }
            column(Above18Yrs_HRMedicalDependants; "HR Medical Dependants"."Below 25 Yrs") { }
            column(SecondName_HRMedicalDependants; "HR Medical Dependants"."Second Name") { }
            column(Twins_HRMedicalDependants; "HR Medical Dependants".Twins) { }
            column(PolicyNo_HRMedicalDependants; "HR Medical Dependants"."Policy No") { }
            column(Names_HRMedicalDependants; "HR Medical Dependants".Names) { }
            column(Relation_HRMedicalDependants; "HR Medical Dependants".Relation) { }
            column(Contact_HRMedicalDependants; "HR Medical Dependants".Contact) { }
            column(LineNo_HRMedicalDependants; "HR Medical Dependants"."Line No") { }
            column(DependantName_HRMedicalDependants; "HR Medical Dependants"."Dependant Name") { }
            column(Gender_HRMedicalDependants; "HR Medical Dependants".Gender) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        if userSetUp.Get(UserId) then begin
            if userSetUp."Medical Team" = false then
                Error('Permission denied');
        end;
    end;

    var
        userSetUp: Record "User Setup";
}

