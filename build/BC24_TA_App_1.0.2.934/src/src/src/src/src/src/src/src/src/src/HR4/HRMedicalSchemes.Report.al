Report 50268 "HR Medical Schemes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRMedicalSchemes.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Medical Schemes"; "HR Medical Schemes")
        {
            RequestFilterFields = "Scheme No", "Medical Insurer";
            column(ReportForNavId_1; 1) { }
            column(SchemeNo_HRMedicalSchemes; "HR Medical Schemes"."Scheme No") { }
            column(MedicalInsurer_HRMedicalSchemes; "HR Medical Schemes"."Medical Insurer") { }
            column(SchemeName_HRMedicalSchemes; "HR Medical Schemes"."Scheme Name") { }
            column(Inpatientlimit_HRMedicalSchemes; "HR Medical Schemes"."In-patient limit") { }
            column(Outpatientlimit_HRMedicalSchemes; "HR Medical Schemes"."Out-patient limit") { }
            column(AreaCovered_HRMedicalSchemes; "HR Medical Schemes"."Area Covered") { }
            column(DependantsIncluded_HRMedicalSchemes; "HR Medical Schemes"."Dependants Included") { }
            column(Comments_HRMedicalSchemes; "HR Medical Schemes".Comments) { }
            column(InsurerName_HRMedicalSchemes; "HR Medical Schemes"."Insurer Name") { }
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

