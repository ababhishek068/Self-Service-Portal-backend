namespace Hijra.Hijra;

/// <summary>
/// Exposes the per-department petty cash limit to the Self Service Portal.
/// UAT 18/07/2026: "petty cash limit depend on department" failed because table 51043
/// "Petty Cash Limit-Department" was never published, so the portal had no way to read it.
/// Publish this as OData web service QyPettyCashLimitDepartment.
/// </summary>
query 52132 PettyCashLimitDepartment
{
    Caption = 'Petty Cash Limit-Department';
    QueryType = Normal;

    elements
    {
        dataitem(PettyCashLimitDepartment; "Petty Cash Limit-Department")
        {
            column(EntryNo; EntryNo)
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(Limit; Limit)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
