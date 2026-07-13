report 50058 "Case Complaint Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Case Complainant"; "Case Complainant")
        {
            RequestFilterFields = "Case No";
            column(Case_No; "Case No") { }
            column(Name; Name) { }

            column(CaseDescription; Cas."Case Description") { }
            column(ID_Number; "ID Number") { }
            column(CaseDate; Cas."Case Date") { }
            column(CaseAmount; Cas."Amount Involved") { }
            column(Source_of_Complaint; "Source of Complaint") { }
            column(Sacco_Name; "Sacco Name") { }
            column(Care_Of; "Care Of") { }
            column(Region; Region) { }
            column(Tribe; Tribe) { }
            trigger OnAfterGetRecord()
            begin
                if cas.get("Case No") then;
            end;
        }
    }

    requestpage
    {


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }
    var
        Cas: record cases;
}