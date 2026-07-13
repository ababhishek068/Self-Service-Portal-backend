Report 50148 "Grant budget"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grantbudget.rdlc';
    Caption = 'Grant budget';
    ApplicationArea = All;

    dataset
    {
        dataitem("Job-Task"; "Job-Task")
        {
            column(ReportForNavId_1; 1) { }
            column(GrantPhase_JobTask; "Job-Task"."Grant Phase") { }
            column(GrantNo_JobTask; "Job-Task"."Grant No.") { }
            column(GrantTaskNo_JobTask; "Job-Task"."Grant Task No.") { }
            column(Description_JobTask; "Job-Task".Description) { }
            column(GrantTaskType_JobTask; "Job-Task"."Grant Task Type") { }
            dataitem("Job-Planning Line"; "Job-Planning Line")
            {
                DataItemLink = "Grant No." = field("Grant No."), "Grant Task No." = field("Grant Task No.");
                column(ReportForNavId_7; 7) { }
                column(GrantNo_JobPlanningLine; "Job-Planning Line"."Grant No.") { }
                column(PlanningDate_JobPlanningLine; "Job-Planning Line"."Planning Date") { }
                column(DocumentNo_JobPlanningLine; "Job-Planning Line"."Document No.") { }
                column(Type_JobPlanningLine; "Job-Planning Line".Type) { }
                column(No_JobPlanningLine; "Job-Planning Line"."No.") { }
                column(Description_JobPlanningLine; "Job-Planning Line".Description) { }
                column(Quantity_JobPlanningLine; "Job-Planning Line".Quantity) { }
                column(DirectUnitCostLCY_JobPlanningLine; "Job-Planning Line"."Direct Unit Cost (LCY)") { }
                column(UnitCostLCY_JobPlanningLine; "Job-Planning Line"."Unit Cost (LCY)") { }
                column(TotalCostLCY_JobPlanningLine; "Job-Planning Line"."Total Cost (LCY)") { }
                column(UnitPriceLCY_JobPlanningLine; "Job-Planning Line"."Unit Price (LCY)") { }
                column(TotalPriceLCY_JobPlanningLine; "Job-Planning Line"."Total Price (LCY)") { }
                column(ResourceGroupNo_JobPlanningLine; "Job-Planning Line"."Resource Group No.") { }
                column(LineAmountLCY_JobPlanningLine; "Job-Planning Line"."Line Amount (LCY)") { }
                column(UnitCost_JobPlanningLine; "Job-Planning Line"."Unit Cost") { }
                column(TotalCost_JobPlanningLine; "Job-Planning Line"."Total Cost") { }
                column(UnitPrice_JobPlanningLine; "Job-Planning Line"."Unit Price") { }
                column(TotalPrice_JobPlanningLine; "Job-Planning Line"."Total Price") { }
                column(LineAmount_JobPlanningLine; "Job-Planning Line"."Line Amount") { }
                column(BudgetPeriod_JobPlanningLine; "Job-Planning Line"."Budget Period") { }
                column(TotalYear1_JobPlanningLine; "Job-Planning Line"."Total Year 1") { }
                column(TotalYear2_JobPlanningLine; "Job-Planning Line"."Total Year 2") { }
                column(TotalYear3_JobPlanningLine; "Job-Planning Line"."Total Year 3") { }
                column(DisbursedAmount_JobPlanningLine; "Job-Planning Line"."Disbursed Amount") { }
                column(Restriction_JobPlanningLine; "Job-Planning Line".Restriction) { }
                column(DonorExpenseCode_JobPlanningLine; "Job-Planning Line"."Donor Expense Code") { }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

