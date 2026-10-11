/// <summary>
/// Procurement plan header (table 50890). Published as "QyProcurementPlanHeader".
/// </summary>
query 52126 "Portal Procurement Plan Hdr"
{
    Caption = 'Portal Procurement Plan Hdr';
    QueryType = Normal;

    elements
    {
        dataitem(PlanHeader; "Procurement Plan Header")
        {
            column(BudgetName; "Budget Name") { }
            column(GlobalDimension1; "Global Dimension 1") { }
            column(GlobalDimension2; "Global Dimension 2") { }
            column(ProcurementPlanPeriod; "Procurement Plan Period") { }
            column(Status; Status) { }
            column(SystemId; SystemId) { }
        }
    }
}
