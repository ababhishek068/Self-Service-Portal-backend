namespace Hijra.Hijra;

query 50123 "Gate Pass"
{
    Caption = 'Gate Pass';
    QueryType = Normal;

    elements
    {
        dataitem(GatePass; "Gate Pass")
        {
            column(AssetNo; "Asset No.")
            {
            }
            column(Comment; Comment)
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(DateCreated; "Date Created")
            {
            }
            column(DateOut; "Date Out")
            {
            }
            column(DepartmentDistrict; "Department/District")
            {
            }
            column(Description; Description)
            {
            }
            column(DistrictDepartmentName; "District/Department Name")
            {
            }
            column(DivisionBranch; "Division/Branch")
            {
            }
            column(DivisionBranchName; "Division/Branch Name")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(EmployeeNo; "Employee No")
            {
            }
            column(ExternalDocumentNo; "External Document No")
            {
            }
            column(FromLocation; "From Location")
            {
            }
            column(GatePassNo; "Gate Pass No.")
            {
            }
            column(Linkto; "Link to")
            {
            }
            column(No; No)
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(ReturnedStatus; "Returned Status")
            {
            }
            column(ReturnDate; "Return Date")
            {
            }
            column(Sector; Sector)
            {
            }
            column(SectorName; "Sector Name")
            {
            }
            column(SerialNo; "Serial No.")
            {
            }
            column(Status; Status)
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
            column(TimeOut; "Time Out")
            {
            }
            column(ToBeReturned; "To Be Returned")
            {
            }
            column(ToLocation; "To Location")
            {
            }
            column(TransferNo; "Transfer No")
            {
            }
            column(WorkStation; "Work Station")
            {
            }
            column(WorkStationName; "Work Station Name")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
