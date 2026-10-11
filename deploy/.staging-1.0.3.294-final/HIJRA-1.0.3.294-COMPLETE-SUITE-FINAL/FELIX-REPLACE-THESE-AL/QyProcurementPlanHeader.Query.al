/// <summary>
/// SSP Facility UAT R59-R61: procurement budget plan headers.
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyProcurementPlanHeader".
/// Column names are read verbatim by the portal — do not rename.
/// </summary>
query 52169 "QyProcurementPlanHeader"
{
    QueryType = Normal;

    elements
    {
        dataitem(Header; "Portal Procurement Plan Hdr.")
        {
            column(BudgetName; "Budget Name") { }
            column(GlobalDimension1; "Global Dimension 1") { }
            column(GlobalDimension2; "Global Dimension 2") { }
            column(ProcurementPlanPeriod; "Plan Period") { }
            column(Status; Status) { }
        }
    }
}
