namespace ABH_UAT.ABH_UAT;

using microsoft;

report 50367 "Individualized Budget"
{
    ApplicationArea = All;
    Caption = 'Individualized Budget';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;    
    RDLCLayout = './Layouts/Individualbudget.rdl';
    dataset
    {
        dataitem(Budgetline; "Budget line")
        {
            column(BudgetNo; "Budget No")
            {
            }
            column(Budgetyear; "Budget year")
            {
            }
            column(CurrentQuantity; "Current Quantity")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(Description; Description)
            {
            }
            column(EntryNo; "Entry No")
            {
            }
            column(EstimatedCost; "Estimated Cost")
            {
            }
            column(Functional; Functional)
            {
            }
            column(GlAccount; "Gl Account")
            {
            }
            column(Justification; Justification)
            {
            }
            column(N; N)
            {
            }
            column(NBirr; "N(Birr)")
            {
            }
            column(No; No)
            {
            }
            column(NonFunctional; "Non Functional")
            {
            }
            column(PartiallyFunctional; "Partially Functional")
            {
            }
            column(R; R)
            {
            }
            column(RBirr; "R(Birr)")
            {
            }
            column(SystemCreatedEntry; "System-Created Entry")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(T; T)
            {
            }
            column(TBirr; "T(Birr)")
            {
            }
            column(Type; "Type")
            {
            }
            column(UoM; UoM)
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
