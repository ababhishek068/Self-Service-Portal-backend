Report 50149 "Grant  list"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grantlist.rdlc';
    Caption = 'Grant  list';
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            RequestFilterFields = "No.", "Starting Date", "Principal Investigator", Status, "Proposal No", Donors;
            column(ReportForNavId_1; 1) { }
            column(No_Jobs; Jobs."No.") { }
            column(FileName; Jobs."Description 2") { }
            column(Title_Jobs; Jobs.Description) { }
            column(GlobalDimension1Code_Jobs; Jobs."Global Dimension 1 Code") { }
            column(FundingAgencyNo_Jobs; Jobs."Funding Agency No.") { }
            column(Objective_Jobs; Jobs.Objective) { }
            column(PrimeInstitution_Jobs; Jobs."Prime Institution") { }
            column(TypeOfFunding_Jobs; Jobs."Type Of Funding") { }
            column(ContractedTo_Jobs; Jobs."Contracted To") { }
            column(AmountAwarded_Jobs; Jobs."Amount Awarded") { }
            column(PaymentMethods_Jobs; Jobs."Payment Methods") { }
            column(AllowedIndirectCost_Jobs; Jobs."Allowed Indirect Cost") { }
            column(StartingDate_Jobs; Jobs."Starting Date") { }
            column(EndingDate_Jobs; Jobs."Ending Date") { }
            column(PrincipalInvestigator_Jobs; Jobs."Principal Investigator") { }
            column(strEmailPI; strEmailPI) { }
            column(STRAcc; STRAcc) { }
            column(StrProjectManager; StrProjectManager) { }
            column(strEmailPM; strEmailPM) { }
            column(Code_Logos; Logos.Name) { }
            column(Picture; Logos.Picture) { }


            trigger OnAfterGetRecord()
            begin
                Logos.get;
                logos.CalcFields(Picture);


                STRAcc := '';
                strEmailPI := '';
                StrProjectManager := '';

                ProjectPersonnel.Reset;
                ProjectPersonnel.SetRange(ProjectPersonnel.Project, Jobs."No.");
                ProjectPersonnel.SetRange(ProjectPersonnel."Project Role", 'ACCOUNTANT');
                if ProjectPersonnel.Find('-') then begin
                    STRAcc := ProjectPersonnel."Employee Name";
                    ProjectPersonnel.Validate(email);
                    strEmailACC := ProjectPersonnel.email;

                    //UNTIL ProjectPersonnel.NEXT=0;
                end;


                ProjectPersonnel.Reset;
                ProjectPersonnel.SetRange(ProjectPersonnel.Project, Jobs."No.");
                ProjectPersonnel.SetRange(ProjectPersonnel."Project Role", 'PROJECT_MANAGER');
                if ProjectPersonnel.Find('-') then begin
                    StrProjectManager := ProjectPersonnel."Employee Name";
                    strEmailPM := ProjectPersonnel.email;
                    //UNTIL ProjectPersonnel.NEXT=0;
                end;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        ProjectPersonnel: Record "Project Personnel Cost Alloc";
        STRAcc: Text;
        strEmailPI: Text;
        StrProjectManager: Text;
        strEmailPM: Text;
        strEmailACC: Text;
        Logos: Record "Company Information";
}

