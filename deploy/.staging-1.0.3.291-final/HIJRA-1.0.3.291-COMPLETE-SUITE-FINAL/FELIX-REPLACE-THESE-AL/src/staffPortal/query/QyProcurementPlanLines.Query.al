/// <summary>
/// SSP Facility UAT R59-R61: itemised procurement budget plan lines.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyProcurementPlanLines".
/// Column names are read verbatim by the portal — do not rename.
/// </summary>
query 52170 "QyProcurementPlanLines"
{
    QueryType = Normal;

    elements
    {
        dataitem(Line; "Portal Procurement Plan Line")
        {
            column(BudgetName; "Budget Name") { }
            column(Department; Department) { }
            column(Type; Type) { }
            column(TypeNo; "Type No.") { }
            column(GlobalDimension1; "Global Dimension 1") { }
            column(ProcurementPlanPeriod; "Plan Period") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(UnitCost; "Unit Cost") { }
            column(Amount; Amount) { }
            column(PlanDate; "Plan Date") { }
        }
    }
}
