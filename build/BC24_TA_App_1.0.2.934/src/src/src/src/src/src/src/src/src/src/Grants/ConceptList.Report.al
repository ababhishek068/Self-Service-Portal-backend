Report 50132 "Concept List"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    //RDLCLayout = './Layouts/ConceptList.rdlc';

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            DataItemTableView = where(Status = filter("Concept Formulation"));
            column(ReportForNavId_1000000000; 1000000000) { }
            column(No_Jobs; Jobs."No.") { }
            column(Objective_Jobs; Jobs.Objective) { }
            column(PrincipalInvestigator_Jobs; Jobs."Principal Investigator") { }
            column(ContractNo_Jobs; Jobs."Contract No") { }
            column(SearchDescription_Jobs; Jobs."Search Description") { }
            column(Description_Jobs; Jobs.Description) { }
            column(Description2_Jobs; Jobs."Description 2") { }
            column(CreationDate_Jobs; Jobs."Creation Date") { }
            column(StartingDate_Jobs; Jobs."Starting Date") { }
            column(EndingDate_Jobs; Jobs."Ending Date") { }
            column(Status_Jobs; Jobs.Status) { }
            column(TotalCostLCY_Jobs; Jobs."Total Cost(LCY)") { }
            column(ApprovalStatus_Jobs; Jobs."Approval Status") { }
            column(TotalCost_Jobs; Jobs."Total Cost") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

