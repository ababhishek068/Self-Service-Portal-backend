/// <summary>
/// Procurement plan lines (table 50889). Published as "QyProcurementPlanLines".
/// </summary>
query 52127 "Portal Procurement Plan Lines"
{
    Caption = 'Portal Procurement Plan Lines';
    QueryType = Normal;

    elements
    {
        dataitem(PlanLines; "Procurement Plan Lines")
        {
            column(BudgetName; "Budget Name") { }
            column(Department; Department) { }
            column(Type_Field; "Type") { }
            column(TypeNo; "Type No") { }
            column(Description; Description) { }
            column(Category; Category) { }
            column(Quantity; Quantity) { }
            column(UnitCost; "Unit Cost") { }
            column(Amount; Amount) { }
            column(RemainingQty; "Remaining Qty") { }
            column(UnitofMeasure; "Unit of Measure") { }
            column(PlanDate; "Plan Date") { }
            column(ProcurementPlanPeriod; "Procurement Plan Period") { }
            column(GlobalDimension1; "Global Dimension 1") { }
            column(GlobalDimension2; "Global Dimension 2") { }
            column(SystemId; SystemId) { }
        }
    }
}
